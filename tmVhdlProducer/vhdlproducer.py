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

def GtlLutsGeneratorCalc(params):
    # delta eta and delta phi luts
    if params['lut'] == "deta" or params['lut'] == "dphi":
        lut_len = 2**params['bits']
        lut = [0 for x in range(lut_len)]
        lut_val = [0 for x in range(lut_len)]
        for i in range(0,lut_len):
            lut[i] = math.floor(params['step']*i*10**params['prec']+0.5)
            for i in range(0,lut_len):
                if i < params['bins']:
                    lut_val[i] = lut[i]
                else:
                    lut_val[i] = 0
    # TODO
    # pt luts
    #if params['lut'] == "pt":
    # ...
    # cosh deta and cos dphi luts
    #if params['lut'] == "cosh_cos":
    # ...
    # sin phi and cos phi luts
    #if params['lut'] == "sin_cos_phi":
    # ...
    # eta and phi conv luts
    #if params['lut'] == "conv":
    # ...
    return lut_val

def GtlLutsGenerator(self, scales, directory):
# calculate LUT values
    for corr_type in ["calo_calo", "muon_muon"]:
        if corr_type == "calo_calo":
            eta_type = 'EG-ETA'
            phi_type = 'EG-PHI'
            delta_prec = scales['PRECISION-EG-EG-Delta'].getNbits()
        if corr_type == "muon_muon":
            eta_type = 'MU-ETA'
            phi_type = 'MU-PHI'
            delta_prec = scales['PRECISION-MU-MU-Delta'].getNbits()

        eta_bits = scales[eta_type].getNbits()
        eta_max_value = scales[eta_type].getMaximum()
        eta_min_value = scales[eta_type].getMinimum()
        eta_step = scales[eta_type].getStep()
        eta_bins = int((abs(scales[eta_type].getMinimum())+scales[eta_type].getMaximum())/scales[eta_type].getStep())+1
        phi_bits = scales[phi_type].getNbits()
        phi_step = scales[phi_type].getStep()
        phi_bins = int(scales[phi_type].getMaximum()/scales[phi_type].getStep())
        for lut_type in ["deta", "dphi"]:
            if lut_type == "deta":
                params = {'lut': lut_type, 'bits': eta_bits, 'bins': eta_bins, 'step': eta_step, 'prec': delta_prec}
            elif lut_type == "dphi":
                params = {'lut': lut_type, 'bits': phi_bits, 'bins': phi_bins, 'step': phi_step, 'prec': delta_prec}

            lut_val = GtlLutsGeneratorCalc(params)
            max_val = max(lut_val)
            min_val = min(lut_val)

            if corr_type == "calo_calo" and lut_type == "deta":
                cc_deta_lut_val = lut_val
                cc_deta_max = max_val
                cc_deta_min = min_val
            elif corr_type == "calo_calo" and lut_type == "dphi":
                cc_dphi_lut_val = lut_val
                cc_dphi_max = max_val
                cc_dphi_min = min_val
            elif corr_type == "muon_muon" and lut_type == "deta":
                mm_deta_lut_val = lut_val
                mm_deta_max = max_val
                mm_deta_min = min_val
            elif corr_type == "muon_muon" and lut_type == "dphi":
                mm_dphi_lut_val = lut_val
                mm_dphi_max = max_val
                mm_dphi_min = min_val
# render template
    lut_dir = "vhdl_gtl_luts"
    os.path.join(directory, lut_dir)
    lut_path = os.path.join(directory, lut_dir)
    if not os.path.exists(lut_path):
        makedirs(lut_path)
    templ_luts = 'gtl_luts.vhd'

    gtl_luts_params = {
        'cc_deta_min': cc_deta_min,
        'cc_deta_max': cc_deta_max,
        'cc_deta_lut': cc_deta_lut_val,
        'cc_dphi_min': cc_dphi_min,
        'cc_dphi_max': cc_dphi_max,
        'cc_dphi_lut': cc_dphi_lut_val,
        'mm_deta_min': mm_deta_min,
        'mm_deta_max': mm_deta_max,
        'mm_deta_lut': mm_deta_lut_val,
        'mm_dphi_min': mm_dphi_min,
        'mm_dphi_max': mm_dphi_max,
        'mm_dphi_lut': mm_dphi_lut_val,
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

# inserted generation of constants for LUTs in gtl_luts_pkg.vhd
## begin
        scales = collection.eventSetup.getScaleMapPtr()
        GtlLutsGenerator(self, scales, directory)
## end

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
