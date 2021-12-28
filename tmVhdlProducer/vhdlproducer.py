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

from .constants import gtl_const

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

def ptLutsCalc(lut_len, bins, prec, pt_bin_min, pt_bin_max):
    lut = [0 for x in range(lut_len)]
    lut_val = [0 for x in range(lut_len)]

    # pt luts
    for i in range(0,lut_len):
        lut[i] = int(round_halfway((pt_bin_min[i]+(pt_bin_max[i]-pt_bin_min[i])/2)*10**prec))
        if i < bins:
            lut_val[i] = lut[i]
        else:
            lut_val[i] = 0
    return lut_val

def deltaLutsCalc(lut_type, lut_len, bins, step, prec):
    lut = [0 for x in range(lut_len)]
    lut_val = [0 for x in range(lut_len)]

    # delta eta, cosh deta, delta phi and cos dphi luts
    if lut_type in gtl_const['corr_luts']:
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
    if lut_type in gtl_const['sin_cos_phi_luts']:
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
    """
    VHDL constant names of pt and unconstrained pt LUTs:
        EG_PT_LUT (used also for TAU)
        JET_PT_LUT
        ETM_PT_LUT (used also for HTM and ETMHF)
        MU_PT_LUT
        MU_UPT_LUT
    """
    pt_param = {}
    for pt_scale in gtl_const['pt_scales']:

        pt_bits = scales[pt_scale].getNbits()
        pt_max_value = scales[pt_scale].getMaximum()

        obj_type_2 = pt_scale.split('-')[0]
        # "MassPt" precision for pt LUTs (used in mass and two-body pt calculations)
        mass_pt_prec = scales['PRECISION-EG-'+obj_type_2+'-MassPt'].getNbits()

        lut_size = 2**pt_bits

        pt_bin_min = [0 for x in range(lut_size+1)]
        pt_bin_max = [0 for x in range(lut_size+1)]

        for pt_bin in scales[pt_scale].getBins():
            pt_bin_min[pt_bin.hw_index] = pt_bin.minimum
            pt_bin_max[pt_bin.hw_index] = pt_bin.maximum

        nr_bins = pt_bin.hw_index+1

        lut_val = ptLutsCalc(lut_size, nr_bins, mass_pt_prec, pt_bin_min, pt_bin_max)

        pt_param[pt_scale]={'lut_size': lut_size, 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}

    # calculate LUT values for deta and dphi (definition of "corr_types" in constants.py)
    """
    VHDL constant names of deta and dphi LUTs:
        CALO_CALO_DIFF_ETA_LUT
        CALO_MU_DIFF_ETA_LUT
        MU_MU_DIFF_ETA_LUT
        CALO_CALO_COSH_DETA_LUT
        CALO_MUON_COSH_DETA_LUT
        MU_MU_COSH_DETA_LUT
        CALO_CALO_DIFF_PHI_LUT
        CALO_MU_DIFF_PHI_LUT
        MU_MU_DIFF_PHI_LUT
        CALO_CALO_COS_DPHI_LUT
        CALO_MUON_COS_DPHI_LUT
        MU_MU_COS_DPHI_LUT
    """
    corr_param = {}
    for corr_type in gtl_const['corr_types']:

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

        for corr_lut in gtl_const['corr_luts']:

            corr_param[corr_type][corr_lut] = {}

            lut_val = deltaLutsCalc(corr_lut, lut_size[corr_lut], bins[corr_lut], step[corr_lut], prec[corr_lut])

            param = {'lut_size': lut_size[corr_lut], 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}
            corr_param[corr_type][corr_lut] = param

    # calculate LUT values for sine and cosine phi (definition of "phi_scales" in constants.py)
    """
    VHDL constant names of deta and dphi LUTs:
        CALO_COS_PHI_LUT
        MUON_COS_PHI_LUT
    """
    sin_cos_phi_param = {}
    for phi_scale in gtl_const['phi_scales']:

        obj_type = phi_scale.split('-')[0]
        sin_cos_phi_param[obj_type] = {}

        phi_bits = scales[phi_scale].getNbits()
        phi_step = scales[phi_scale].getStep()
        phi_bins = int(scales[phi_scale].getMaximum()/scales[phi_scale].getStep())
        tbpt_prec = scales['PRECISION-'+obj_type+'-'+obj_type+'-TwoBodyPtMath'].getNbits()

        lut_size = 2**phi_bits

        for lut_type in gtl_const['sin_cos_phi_luts']:
            sin_cos_phi_param[obj_type][lut_type] = {}
            lut_val = phiLutsCalc(lut_type, lut_size, phi_bins, phi_step, tbpt_prec)
            sin_cos_phi_param[obj_type][lut_type]={'lut_size': lut_size, 'min': min(lut_val), 'max': max(lut_val), 'lut': lut_val}

# render template
    os.path.join(directory, gtl_const['lut_dir'])
    lut_path = os.path.join(directory, gtl_const['lut_dir'])
    if not os.path.exists(lut_path):
        makedirs(lut_path)

    gtl_luts_params = {
        'pt_param': pt_param,
        'corr_param': corr_param,
        'sin_cos_phi_param': sin_cos_phi_param,
    }

    content_luts = self.engine.render(gtl_const['templ_luts'], gtl_luts_params)
    filename = os.path.join(directory, gtl_const['lut_dir'], gtl_const['templ_luts'])
    with open(filename, 'w') as fp:
        fp.write(content_luts)

def gtlPkgGenerator(self, scales, directory):
    # calculate constant values for gtl_pkg.vhd (definition of "pt_scales" in constants.py)
    gtl_pkg_param = {}

    calo_eta_max_value = scales['EG-ETA'].getMaximum()
    calo_eta_min_value = scales['EG-ETA'].getMinimum()
    calo_eta_step = scales['EG-ETA'].getStep()
    muon_eta_max_value = scales['MU-ETA'].getMaximum()
    muon_eta_min_value = scales['MU-ETA'].getMinimum()
    muon_eta_step = scales['MU-ETA'].getStep()

    calo_calo_eta_bins = int((abs(calo_eta_min_value)+calo_eta_max_value)/calo_eta_step)
    calo_calo_cosh_deta = math.cosh(calo_calo_eta_bins * calo_eta_step)
    calo_calo_cosh_deta_int = int(round_halfway(calo_calo_cosh_deta * 10**scales['PRECISION-EG-EG-Math'].getNbits()))

    muon_muon_eta_bins = int((abs(muon_eta_min_value)+muon_eta_max_value)/muon_eta_step)
    muon_muon_cosh_deta = math.cosh(muon_muon_eta_bins * muon_eta_step)
    muon_muon_cosh_deta_int = int(round_halfway(muon_muon_cosh_deta * 10**scales['PRECISION-MU-MU-Math'].getNbits()))

    # Delta eta range for calo used in LUT. Delta eta range of calo_eta_max_value and muon_eta_min_value (or vice versa) would be enough.
    calo_muon_eta_bins = int((abs(calo_eta_min_value)+calo_eta_max_value)/muon_eta_step)
    calo_muon_cosh_deta = math.cosh(calo_muon_eta_bins * muon_eta_step)
    calo_muon_cosh_deta_int = int(round_halfway(calo_muon_cosh_deta * 10**scales['PRECISION-EG-MU-Math'].getNbits()))

    cos_dphi_min = -1

    calo_calo_cos_dphi_int = cos_dphi_min*10**scales['PRECISION-EG-EG-Math'].getNbits()
    muon_muon_cos_dphi_int = cos_dphi_min*10**scales['PRECISION-MU-MU-Math'].getNbits()
    calo_muon_cos_dphi_int = cos_dphi_min*10**scales['PRECISION-EG-MU-Math'].getNbits()

    gtl_pkg_param = {
        'phi_min': scales['EG-PHI'].getMinimum(),
        'phi_max': scales['EG-PHI'].getMaximum(),
        'eta_min': scales['EG-ETA'].getMinimum(),
        'eta_max': scales['EG-ETA'].getMaximum(),
        'calo_phi_bins': gtl_const['CALO_PHI_BINS'],
        'muon_phi_bins': gtl_const['MUON_PHI_BINS'],
        'mu_pt_bits': scales['MU-ET'].getNbits(),
        'mu_upt_bits': scales['MU-UPT'].getNbits(),
        'mu_eta_bits': scales['MU-ETA'].getNbits(),
        'mu_eta_step': muon_eta_step,
        'mu_phi_bits': scales['MU-PHI'].getNbits(),
        'eg_et_bits': scales['EG-ET'].getNbits(),
        'eg_eta_bits': scales['EG-ETA'].getNbits(),
        'eg_phi_bits': scales['EG-PHI'].getNbits(),
        'jet_et_bits': scales['JET-ET'].getNbits(),
        'jet_eta_bits': scales['JET-ETA'].getNbits(),
        'jet_phi_bits': scales['JET-PHI'].getNbits(),
        'tau_et_bits': scales['TAU-ET'].getNbits(),
        'tau_eta_bits': scales['TAU-ETA'].getNbits(),
        'tau_phi_bits': scales['TAU-PHI'].getNbits(),
        'ett_et_bits': scales['ETT-ET'].getNbits(),
        'etm_et_bits': scales['ETM-ET'].getNbits(),
        'htt_et_bits': scales['HTT-ET'].getNbits(),
        'htm_et_bits': scales['HTM-ET'].getNbits(),
        'etmhf_et_bits': scales['ETMHF-ET'].getNbits(),
        #'htmhf_et_bits': scales['HTMHF-ET'].getNbits(), # actually not in scales
        'ettem_in_low': gtl_const['ETTEM_IN_ETT_LOW'],
        'ettem_et_bits': scales['ETTEM-ET'].getNbits(),
        'etm_phi_bits': scales['ETM-PHI'].getNbits(),
        'htm_phi_bits': scales['HTM-PHI'].getNbits(),
        'etmhf_phi_bits': scales['ETMHF-PHI'].getNbits(),
        #'htmhf_phi_bits': scales['HTMHF-PHI'].getNbits(), # actually not in scales
        'asym_in_low': gtl_const['ASYMX_IN_Y_LOW'],
        'asymet_bits': scales['ASYMET-COUNT'].getNbits(),
        'asymht_bits': scales['ASYMHT-COUNT'].getNbits(),
        'asymethf_bits': scales['ASYMETHF-COUNT'].getNbits(),
        'asymhthf_bits': scales['ASYMHTHF-COUNT'].getNbits(),
        'towercount_in_low': gtl_const['TOWERCOUNT_IN_HTT_LOW'],
        'towercount_bits': scales['TOWERCOUNT-COUNT'].getNbits(),
        'mb_in_low': gtl_const['MBX_IN_Y_LOW'],
        'mbt0hfm_bits': scales['MBT0HFM-COUNT'].getNbits(),
        'mbt0hfp_bits': scales['MBT0HFP-COUNT'].getNbits(),
        'mbt1hfm_bits': scales['MBT1HFM-COUNT'].getNbits(),
        'mbt1hfp_bits': scales['MBT1HFP-COUNT'].getNbits(),
        'delta_prec': scales['PRECISION-EG-EG-Delta'].getNbits(),
        'calo_pt_prec': scales['PRECISION-EG-EG-MassPt'].getNbits(),
        'muon_pt_prec': scales['PRECISION-MU-MU-MassPt'].getNbits(),
        'calo_calo_cosh_cos_prec': scales['PRECISION-EG-EG-Math'].getNbits(),
        'calo_muon_cosh_cos_prec': scales['PRECISION-EG-MU-Math'].getNbits(),
        'muon_muon_cosh_cos_prec': scales['PRECISION-MU-MU-Math'].getNbits(),
        'calo_sin_cos_prec': scales['PRECISION-EG-EG-TwoBodyPtMath'].getNbits(),
        'muon_sin_cos_prec': scales['PRECISION-MU-MU-TwoBodyPtMath'].getNbits(),
        'calo_calo_cosh_cos_vec_width': calo_calo_cosh_deta_int-(calo_calo_cos_dphi_int),
        'muon_muon_cosh_cos_vec_width': muon_muon_cosh_deta_int-(muon_muon_cos_dphi_int),
        'calo_muon_cosh_cos_vec_width': calo_muon_cosh_deta_int-(calo_muon_cos_dphi_int),
        'calo_sin_cos_vec_width': 10**scales['PRECISION-EG-EG-TwoBodyPtMath'].getNbits(),
        'muon_sin_cos_vec_width': 10**scales['PRECISION-MU-MU-TwoBodyPtMath'].getNbits(),
    }

    content_gtl_pkg = self.engine.render(gtl_const['templ_gtl_pkg'], gtl_pkg_param)
    filename = os.path.join(directory, gtl_const['lut_dir'], gtl_const['templ_gtl_pkg'])
    with open(filename, 'w') as fp:
        fp.write(content_gtl_pkg)

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

    def render(self, template, data=None):
        template = self.environment.get_template(template)
        return template.render(data or {})


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
        gtlPkgGenerator(self, scales, directory)

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
