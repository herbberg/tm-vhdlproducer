"""Constants for resources of Virtex chip.

"""

# resources of Virtex chip (algo_dist.py)
virtex_resources = {
    'BRAMS_TOTAL': 1470,
    'SLICELUTS_TOTAL': 433200,
    'PROCESSORS_TOTAL': 3600,
}

# Number of objects (algo_dist.py)
nr_obj = {
    'NR_CALOS': 12,
    'NR_MUONS': 8,
}

# Constants for gtl (vhdlproducer.py)
gtl_const = {
    'corr_types': ['EG-EG', 'EG-MU', 'MU-MU'],
    'corr_luts': ['deta', 'dphi', 'cosh_deta', 'cos_dphi'],
    'pt_scales': ['EG-ET', 'JET-ET', 'ETM-ET', 'MU-ET', 'MU-UPT'],
    'lut_dir': 'vhdl_gtl_pkgs',
    'templ_luts': 'gtl_luts_pkg.vhd',
    'templ_gtl_pkg': 'gtl_pkg.vhd',
    'phi_scales': ['EG-PHI', 'MU-PHI'],
    'sin_cos_phi_luts': ['sin_phi', 'cos_phi'],
    'CALO_PHI_BINS': 144,
    'MUON_PHI_BINS': 576,
    'ETTEM_IN_ETT_LOW': 12,
    'ASYMX_IN_Y_LOW': 20,
    'TOWERCOUNT_IN_HTT_LOW': 12,
    'MBX_IN_Y_LOW': 28,
    'MUON_QUAL_BITS': 4,
    'MUON_ISO_BITS': 2,
    'MUON_CHARGE_BITS': 2,
    'MUON_IDX_BITS': 7,
    'MUON_IP_BITS': 2,
    'EG_ISO_BITS': 2,
    'TAU_ISO_BITS': 2,
    'MUS_BIT': 61,
    'NR_MUS_BITS': 4,
    'MUON_OBJ_MUS0': 0,
    'MUON_OBJ_MUS1': 2,
    'MUON_OBJ_MUSOOT0': 4,
    'MUON_OBJ_MUSOOT1': 6,
    'CENT_IN_ETMHF_LOW': 28,
    'CENT_IN_ETMHF_HIGH': 31,
    'CENT_IN_HTMHF_LOW': 28,
    'CENT_IN_HTMHF_HIGH': 31,
    'CENT_LBITS_LOW': 0,
    'CENT_LBITS_HIGH': 3,
    'CENT_UBITS_LOW': 4,
    'CENT_UBITS_HIGH': 7,
    'ASYMET_LOW': 0,
    'ASYMHT_LOW': 0,
    'ASYMETHF_LOW': 0,
    'ASYMHTHF_LOW': 0,
    'TOWERCOUNT_COUNT_LOW': 0,
    'MBT0HFP_COUNT_LOW': 0,
    'MBT0HFM_COUNT_LOW': 0,
    'MBT1HFP_COUNT_LOW': 0,
    'MBT1HFM_COUNT_LOW': 0,
}
