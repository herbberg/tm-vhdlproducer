"""Constants for resources of Virtex chip.

"""

BRAMS_TOTAL = 1470
SLICELUTS_TOTAL = 433200
PROCESSORS_TOTAL = 3600
NR_CALOS = 12
NR_MUONS = 8

# GTL LUTs generation (vhdlproducer.py)
corr_types = ["EG-EG", "EG-MU", "MU-MU"]
corr_luts = ["deta", "dphi", "cosh_deta", "cos_dphi"]
pt_scales = ['EG-ET', 'JET-ET', 'ETM-ET', 'MU-ET', 'MU-UPT']
lut_dir = "vhdl_gtl_luts"
templ_luts = 'gtl_luts.vhd'

