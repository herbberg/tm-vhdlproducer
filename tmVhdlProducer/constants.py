"""Constants for resources of Virtex chip.

"""

# resources of Virtex chip (algo_dist.py)
BRAMS_TOTAL = 1470
SLICELUTS_TOTAL = 433200
PROCESSORS_TOTAL = 3600

# Number of objects (algo_dist.py)
NR_CALOS = 12
NR_MUONS = 8

## GTL LUTs generation (vhdlproducer.py)
#corr_types = ['EG-EG', 'EG-MU', 'MU-MU']
#corr_luts = ['deta', 'dphi', 'cosh_deta', 'cos_dphi']
#pt_scales = ['EG-ET', 'JET-ET', 'ETM-ET', 'MU-ET', 'MU-UPT']
#lut_dir = 'vhdl_gtl_pkgs'
#templ_luts = 'gtl_luts.vhd'
#templ_gtl_pkg = 'gtl_pkg.vhd'
#phi_scales = ['EG-PHI', 'MU-PHI']
#sin_cos_phi_luts = ['sin_phi', 'cos_phi']

## GTL pkg generation (vhdlproducer.py)
#CALO_PHI_BINS = 144
#MUON_PHI_BINS = 576

#ETTEM_IN_ETT_LOW = 12
#ASYMX_IN_Y_LOW = 20
#TOWERCOUNT_IN_HTT_LOW = 12
#MBX_IN_Y_LOW = 28

gtl_const = {
    'corr_types': ['EG-EG', 'EG-MU', 'MU-MU'],
    'corr_luts': ['deta', 'dphi', 'cosh_deta', 'cos_dphi'],
    'pt_scales': ['EG-ET', 'JET-ET', 'ETM-ET', 'MU-ET', 'MU-UPT'],
    'lut_dir': 'vhdl_gtl_pkgs',
    'templ_luts': 'gtl_luts.vhd',
    'templ_gtl_pkg': 'gtl_pkg.vhd',
    'phi_scales': ['EG-PHI', 'MU-PHI'],
    'sin_cos_phi_luts': ['sin_phi', 'cos_phi'],
    'CALO_PHI_BINS': 144,
    'MUON_PHI_BINS': 576,
    'ETTEM_IN_ETT_LOW': 12,
    'ASYMX_IN_Y_LOW': 20,
    'TOWERCOUNT_IN_HTT_LOW': 12,
    'MBX_IN_Y_LOW': 28
}
