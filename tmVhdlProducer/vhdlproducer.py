import json
import logging
import shutil
import uuid
import os
import math

from binascii import hexlify

from jinja2 import Environment
from jinja2 import FileSystemLoader
from jinja2 import StrictUndefined

import tmEventSetup
import tmTable

from .constants import corr_types, corr_luts, pt_prec, pt_scales, lut_dir, templ_luts, phi_scales, sin_cos_phi_luts

from .vhdlhelper import MenuHelper
from .vhdlhelper import vhdl_bool
from .vhdlhelper import bx_encode

__all__ = ['VhdlProducer']

# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hexstr_filter(s, bytes):
    """Converts a string into hex representation.

    >>> hexstr_filter("Monty Python's Flying Circus", 32)
    '0000000073756372694320676e69796c462073276e6f687479502079746e6f4d'
    """
    chars = bytes * 2
    return "{0:0>{1}}".format(hexlify(s[::-1].encode()).decode(), chars)[-chars:]

def uuid2hex_filter(s):
    """Converts a UUID into hex representation.

    >>> uuid2hex_filter('1d69f777-ade0-4fb7-82f7-2b9afbba4078')
    '1d69f777ade04fb782f72b9afbba4078'
    """
    return uuid.UUID(s).hex.lower()

def sort_by_attribute(items, attribute, reverse=False):
    """Returns list of items sorted by attribute. Provided to overcome lack of
    sort filter in older Jinja2 versions.
    """
    return sorted(items, key=lambda item: getattr(item, attribute), reverse=reverse)

def murmurhash(s):
    """Returns Murmurhash signed integer."""
    return tmEventSetup.getMmHashN(str(s))

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------

CustomFilters = {
    'X21' : lambda x: "%021X" % int(float(x)),
    'X16' : lambda x: "%016X" % int(float(x)),
    'X08' : lambda x: "%08X" % int(float(x)),
    'X04' : lambda x: "%04X" % int(float(x)),
    'X01' : lambda x: "%01X" % int(float(x)),
    'alpha' : lambda s: ''.join(c for c in s if c.isalpha()),
    'sort_by_attribute': sort_by_attribute,
    'hex': lambda d: format(int(d), 'x'), # plain hex format
    'hexstr': hexstr_filter,
    'hexuuid': uuid2hex_filter,
    'mmhashn': murmurhash,
    'vhdl_bool': vhdl_bool
}

ModuleTemplates = [
    'algo_index.vhd',
    'gtl_module_signals.vhd',
    'gtl_module_instances.vhd',
    'ugt_constants.vhd',
]

# -----------------------------------------------------------------------------
# Additional Helpers
# -----------------------------------------------------------------------------

def makedirs(path):
    """Creates a directory recusively, ignores it if the path already exists."""
    logging.debug("creating directory: %s", path)
    if not os.path.exists(path):
        os.makedirs(path)

# -----------------------------------------------------------------------------
#  GtlLutsGenerator.
# -----------------------------------------------------------------------------

def round_halfway(value: float) -> float:
    """Return nearest integral value, with halfway cases rounded away from zero."""
    return math.copysign(math.floor(0.5 + abs(value)), value)

def ptLutsCalc(lut_len, bins, step, prec, pt_bin_min, pt_bin_max):
    lut = [0 for x in range(lut_len)]
    lut_val = [0 for x in range(lut_len)]

    # pt luts
    for i in range(0,lut_len):
        lut[i] = int(round_halfway(((pt_bin_max[i] - pt_bin_min[i])/2+pt_bin_min[i])*10**prec))
        if i < bins:
            lut_val[i] = lut[i]
        else:
            lut_val[i] = 0
    return lut_val

def deltaLutsCalc(lut_type, lut_len, bins, step, prec):
    lut = [0 for x in range(lut_len)]
    lut_val = [0 for x in range(lut_len)]

    # delta eta, cosh deta, delta phi and cos dphi luts
    if lut_type in corr_luts:
        for i in range(0,lut_len):
            if lut_type == "deta" or lut_type == "dphi":
                lut[i] = int(round_halfway(step*i*10**prec))
            elif lut_type == "cosh_deta":
                lut[i] = int(round_halfway(math.cosh(step*i)*10**prec))
            elif lut_type == "cos_dphi":
                lut[i] = int(round_halfway(math.cos(step*i)*10**prec))
            for i in range(0,lut_len):
                if i < bins:
                    lut_val[i] = lut[i]
                else:
                    lut_val[i] = 0

    return lut_val

def phiLutsCalc(lut_type, lut_len, bins, step, prec):
    lut = [0 for x in range(lut_len)]
    lut_val = [0 for x in range(lut_len)]

    # sin and cos phi luts (value based on mid of bin)
    if lut_type in sin_cos_phi_luts:
        for i in range(0,lut_len):
            if lut_type == "sin_phi":
                lut[i] = int(round_halfway(math.sin(step*i+(step/2))*10**prec))
            elif lut_type == "cos_phi":
                lut[i] = int(round_halfway(math.cos(step*i+(step/2))*10**prec))
            for i in range(0,lut_len):
                if i < bins:
                    lut_val[i] = lut[i]
                else:
                    lut_val[i] = 0

    return lut_val

    # TODO
    # eta and phi conv luts
    #if lut_type == "conv":
    # ...
    return lut_val

def gtlLutsGenerator(self, scales, directory):
    # calculate LUT values for pt (definition of "pt_scales" in constants.py)
    pt_param = {}
    for pt_scale in pt_scales:

        pt_bits = scales[pt_scale].getNbits()
        pt_max_value = scales[pt_scale].getMaximum()
        pt_step = scales[pt_scale].getStep()

        lut_size = 2**pt_bits

        pt_bin_min = [0 for x in range(lut_size+1)]
        pt_bin_max = [0 for x in range(lut_size+1)]

        for pt_bin in scales[pt_scale].getBins():
            pt_bin_min[pt_bin.hw_index] = pt_bin.minimum
            pt_bin_max[pt_bin.hw_index] = pt_bin.maximum

        nr_bins = pt_bin.hw_index+1

        lut_val = ptLutsCalc(lut_size, nr_bins, pt_step, pt_prec, pt_bin_min, pt_bin_max)

        pt_param[pt_scale]={'lut_size': lut_size, 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}

    # calculate LUT values for deta and dphi (definition of "corr_types" in constants.py)
    corr_param = {}
    for corr_type in corr_types:

        corr_param[corr_type] = {}

        eta_type = corr_type.split('-')[0]+"-ETA"
        phi_type = corr_type.split('-')[1]+"-PHI"

        eta_bits = scales[eta_type].getNbits()
        eta_max_value = scales[eta_type].getMaximum()
        eta_min_value = scales[eta_type].getMinimum()
        eta_step = scales[eta_type].getStep()

        phi_bits = scales[phi_type].getNbits()
        phi_step = scales[phi_type].getStep()
        phi_bins = int(scales[phi_type].getMaximum()/scales[phi_type].getStep())

        delta_prec = scales['PRECISION-'+corr_type+'-Delta'].getNbits()
        math_prec = scales['PRECISION-'+corr_type+'-Math'].getNbits()

        if corr_type == "EG-MU":
            eta_bits = scales['MU-ETA'].getNbits()+1 # +1 for correct length of calo-muon cosh deta lut
            eta_step = scales['MU-ETA'].getStep()

        eta_bins = int(round_halfway((abs(eta_min_value)+eta_max_value)/eta_step))

        lut_size = {"deta": 2**eta_bits, "dphi": 2**phi_bits, "cosh_deta": 2**eta_bits, "cos_dphi": 2**phi_bits}
        bins = {"deta": eta_bins, "dphi": phi_bins, "cosh_deta": eta_bins, "cos_dphi": phi_bins}
        step = {"deta": eta_step, "dphi": phi_step, "cosh_deta": eta_step, "cos_dphi": phi_step}
        prec = {"deta": delta_prec, "dphi": delta_prec, "cosh_deta": math_prec, "cos_dphi": math_prec}

        for corr_lut in corr_luts:

            corr_param[corr_type][corr_lut] = {}

            lut_val = deltaLutsCalc(corr_lut, lut_size[corr_lut], bins[corr_lut], step[corr_lut], prec[corr_lut])

            param = {'lut_size': lut_size[corr_lut], 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}
            corr_param[corr_type][corr_lut] = param

    # calculate LUT values for sine and cosine phi (definition of "phi_scales" in constants.py)
    sin_cos_phi_param = {}
    for phi_scale in phi_scales:

        obj_type = phi_scale.split('-')[0]
        sin_cos_phi_param[obj_type] = {}

        phi_bits = scales[phi_scale].getNbits()
        phi_step = scales[phi_scale].getStep()
        phi_bins = int(scales[phi_scale].getMaximum()/scales[phi_scale].getStep())
        print(obj_type, phi_bins)
        tbpt_prec = scales['PRECISION-'+obj_type+'-'+obj_type+'-TwoBodyPtMath'].getNbits()

        lut_size = 2**phi_bits

        for lut_type in sin_cos_phi_luts:

            sin_cos_phi_param[obj_type][lut_type] = {}

            lut_val = phiLutsCalc(lut_type, lut_size, phi_bins, phi_step, tbpt_prec)

            sin_cos_phi_param[obj_type][lut_type]={'lut_size': lut_size, 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}

# render template
    os.path.join(directory, lut_dir)
    lut_path = os.path.join(directory, lut_dir)
    if not os.path.exists(lut_path):
        makedirs(lut_path)

    gtl_luts_params = {
        'pt_param': pt_param,
        'corr_param': corr_param,
        'sin_cos_phi_param': sin_cos_phi_param,
    }

    content_luts = self.engine.render(templ_luts, gtl_luts_params)
    filename = os.path.join(directory, lut_dir, templ_luts)
    with open(filename, 'w') as fp:
        fp.write(content_luts)

# -----------------------------------------------------------------------------
#  Template engines with custom loader environment.
# -----------------------------------------------------------------------------

class TemplateEngine(object):
    """Custom tempalte engine class."""

    def __init__(self, searchpath, encoding='utf-8'):
        # Create Jinja environment.
        loader = FileSystemLoader(searchpath, encoding)
        self.environment = Environment(loader=loader, undefined=StrictUndefined)
        self.environment.filters.update(CustomFilters)

    def render(self, template, data={}):
        template = self.environment.get_template(template)
        return template.render(data)


# -----------------------------------------------------------------------------
#  VHDL producer class.
# -----------------------------------------------------------------------------

class VhdlProducer(object):
    """VHDL producer class."""

    def __init__(self, searchpath):
        self.engine = TemplateEngine(searchpath)

    def create_dirs(self, directory, n_modules):
        """Create directory tree for output, return dictionary of created
        directories.
        """
        directories = {
            "vhdl" : os.path.join(directory, "vhdl"),
            "testvectors" : os.path.join(directory, "testvectors"),
            "xml" : os.path.join(directory, "xml"),
            "doc" : os.path.join(directory, "doc"),
        }
        for i in range(n_modules):
            module_id = f"module_{i:d}"
            directories[module_id] = os.path.join(directories["vhdl"], module_id, "src")
        # Check for exisiting directories (TODO obsolete?)
        for path in directories.values():
            if os.path.exists(path):
                logging.warning("directory `%s' already exists. Will be overwritten.", path)
                shutil.rmtree(path)
        # Create directries
        for path in directories.values():
            makedirs(path)
        return directories

    def write(self, collection, directory):
        """Write distributed modules (VHDL templates) to *directory*."""

        # generation of LUTs in gtl_luts.vhd (for gtl_luts_pkg.vhd)
        scales = collection.eventSetup.getScaleMapPtr()
        gtlLutsGenerator(self, scales, directory)

        helper = MenuHelper(collection)
        logging.info("writing %s algorithms to %s module(s)", len(helper.algorithms), len(helper.modules))
        # Create directory tree
        directories = self.create_dirs(directory, len(collection))
        # Populate modules
        for module in helper.modules:
            logging.info("writing output for module: %s", module.id)
            for template in ModuleTemplates:
                params = {
                    'menu': helper,
                    'module': module,
                }
                content = self.engine.render(template, params)
                #print("content", content)
                module_id = f"module_{module.id:d}"
                filename = os.path.join(directories[module_id], template)
                with open(filename, 'w') as fp:
                    fp.write(content)
                logging.info(f"{template:<24}: {filename}")

        # Write JSON dump (TODO obsolete?)
        params = {
            'menu': helper,
        }
        content = self.engine.render('menu.json', params)
        filename = os.path.join(directories['xml'], 'menu.json')
        makedirs(os.path.dirname(filename)) # Create path if required
        with open(filename, 'w') as fp:
            fp.write(content)

    def writeXmlMenu(self, filename, json_dir, dist=1):
        """Updates a XML menu file based on inforamtion from a JSON file (used to apply
        a previously calculated algorithm distribution over multiple modules).
        Returns path and filename of created XML menu.
        """
        # TODO
        # Load mapping from JSON
        with open(os.path.join(json_dir, 'menu.json')) as fp:
            json_data = json.load(fp)

        menu = tmTable.Menu()
        scale = tmTable.Scale()
        ext_signal = tmTable.ExtSignal()

        logging.info("reading source XML menu file %s", filename)

        message = tmTable.xml2menu(filename, menu, scale, ext_signal, False)
        if message:
            logging.error(f"{filename}: {message}")
            raise RuntimeError(message)

        menu_name = menu.menu["name"]


        logging.info("processing menu \"%s\" ... ", menu_name)

        # Update menu information
        logging.info("updating menu information...")
        logging.info("uuid_menu     : %s", json_data["menu_uuid"])
        logging.info("uuid_firmware : %s", json_data["firmware_uuid"])
        logging.info("n_modules     : %s", json_data["n_modules"])

        # Update menu information
        menu.menu["uuid_menu"] = str(json_data["menu_uuid"])
        menu.menu["uuid_firmware"] = str(json_data["firmware_uuid"])
        menu.menu["n_modules"] = str(json_data["n_modules"])
        menu.menu["is_valid"] = "1"

        # Collect algorithm names
        names = [algorithm["name"] for algorithm in menu.algorithms]

        # Update algorithm
        for name, index, module_id, module_index in json_data["algorithms"]:
            algorithm = tmTable.Row()
            id_ = names.index(name)
            # Copy attributes
            for k, v in menu.algorithms[id_].items():
                algorithm[k] = v
            # Update attributes
            algorithm["index"] = str(index)
            algorithm["module_id"] = str(module_id)
            algorithm["module_index"] = str(module_index)
            menu.algorithms[id_] = algorithm

        target = os.path.join(json_dir, f'{menu_name}-d{dist}.xml')

        logging.info("writing target XML menu file %s", target)
        tmTable.menu2xml(menu, scale, ext_signal, target)

        return target


# eof
