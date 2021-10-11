{%- set items_row = 16 -%}
{%- macro dump_lut(lut_size, lut) -%}
  {% for i in range(0,lut_size,items_row) -%}
    {% if i <= lut_size-items_row -%}
      {% for j in range(0,items_row) -%}
        {%- if i+j == lut_size-1 -%}
{{lut[i+j]}}
        {%- else -%}
{{lut[i+j]}}{{", "}}
        {%- endif -%}
      {%- endfor %}
    {%- endif %}
  {% endfor -%}
{%- endmacro -%}

-- eg and tau pt LUTs
type eg_pt_lut_array is array (0 to 2**(EG_ET_HIGH-EG_ET_LOW+1)-1) of natural range {{pt_param['EG-ET']['min']}} to {{pt_param['EG-ET']['max']}};

constant EG_PT_LUT : eg_pt_lut_array := (
{{ dump_lut(pt_param['EG-ET']['lut_size'], pt_param['EG-ET']['lut'])|trim }}
);

-- jet pt LUT
type jet_pt_lut_array is array (0 to 2**(JET_ET_HIGH-JET_ET_LOW+1)-1) of natural range {{pt_param['JET-ET']['min']}} to {{pt_param['JET-ET']['max']}};

constant JET_PT_LUT : jet_pt_lut_array := (
{{ dump_lut(pt_param['JET-ET']['lut_size'], pt_param['JET-ET']['lut'])|trim }}
);

-- esums pt LUTs
type etm_pt_lut_array is array (0 to 2**(ETM_ET_HIGH-ETM_ET_LOW+1)-1) of natural range {{pt_param['ETM-ET']['min']}} to {{pt_param['ETM-ET']['max']}};

constant ETM_PT_LUT : etm_pt_lut_array := (
{{ dump_lut(pt_param['ETM-ET']['lut_size'], pt_param['ETM-ET']['lut'])|trim }}
);

-- muon pt LUT
type muon_pt_lut_array is array (0 to 2**(MUON_PT_HIGH-MUON_PT_LOW+1)-1) of natural range {{pt_param['MU-ET']['min']}} to {{pt_param['MU-ET']['max']}};

constant MU_PT_LUT : muon_pt_lut_array := (
{{ dump_lut(pt_param['MU-ET']['lut_size'], pt_param['MU-ET']['lut'])|trim }}
);

-- muon unconstraint pt LUT
type muon_upt_lut_array is array (0 to 2**(MUON_UPT_HIGH-MUON_UPT_LOW+1)-1) of natural range {{pt_param['MU-UPT']['min']}} to {{pt_param['MU-UPT']['max']}};

constant MU_UPT_LUT : muon_upt_lut_array := (
{{ dump_lut(pt_param['MU-UPT']['lut_size'], pt_param['MU-UPT']['lut'])|trim }}
);

-- calo-calo differences LUTs
type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{corr_param['EG-EG']['deta']['min']}} to {{corr_param['EG-EG']['deta']['max']}};

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
{{ dump_lut(corr_param['EG-EG']['deta']['lut_size'], corr_param['EG-EG']['deta']['lut'])|trim }}
);

type calo_calo_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range {{corr_param['EG-EG']['dphi']['min']}} to {{corr_param['EG-EG']['dphi']['max']}};

constant CALO_CALO_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := (
{{ dump_lut(corr_param['EG-EG']['dphi']['lut_size'], corr_param['EG-EG']['dphi']['lut'])|trim }}
);

-- muon-muon differences LUTs
type muon_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{corr_param['MU-MU']['deta']['min']}} to {{corr_param['MU-MU']['deta']['max']}};

constant MU_MU_DIFF_ETA_LUT : muon_muon_diff_eta_lut_array := (
{{ dump_lut(corr_param['MU-MU']['deta']['lut_size'], corr_param['MU-MU']['deta']['lut'])|trim }}
);

type muon_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{corr_param['MU-MU']['dphi']['min']}} to {{corr_param['MU-MU']['dphi']['max']}};

constant MU_MU_DIFF_PHI_LUT : muon_muon_diff_phi_lut_array := (
{{ dump_lut(corr_param['MU-MU']['dphi']['lut_size'], corr_param['MU-MU']['dphi']['lut'])|trim }}
);

-- calo-muon differences LUTs
type calo_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range {{corr_param['EG-MU']['deta']['min']}} to {{corr_param['EG-MU']['deta']['max']}};

constant CALO_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := (
{{ dump_lut(corr_param['EG-MU']['deta']['lut_size'], corr_param['EG-MU']['deta']['lut'])|trim }}
);

type calo_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{corr_param['EG-MU']['dphi']['min']}} to {{corr_param['EG-MU']['dphi']['max']}};

constant CALO_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := (
{{ dump_lut(corr_param['EG-MU']['dphi']['lut_size'], corr_param['EG-MU']['dphi']['lut'])|trim }}
);

-- calo-calo cosh deta LUTs
type calo_calo_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{corr_param['EG-EG']['cosh_deta']['min']}} to {{corr_param['EG-EG']['cosh_deta']['max']}};

constant CALO_CALO_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := (
{{ dump_lut(corr_param['EG-EG']['cosh_deta']['lut_size'], corr_param['EG-EG']['cosh_deta']['lut'])|trim }}
);

-- calo-calo cos dphi LUTs
type calo_calo_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range {{corr_param['EG-EG']['cos_dphi']['min']}} to {{corr_param['EG-EG']['cos_dphi']['max']}};

constant CALO_CALO_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := (
{{ dump_lut(corr_param['EG-EG']['cos_dphi']['lut_size'], corr_param['EG-EG']['cos_dphi']['lut'])|trim }}
);

-- muon-muon cosh deta LUTs
type calo_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range {{corr_param['EG-MU']['cosh_deta']['min']}} to {{corr_param['EG-MU']['cosh_deta']['max']}};

constant CALO_MUON_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := (
{{ dump_lut(corr_param['EG-MU']['cosh_deta']['lut_size'], corr_param['EG-MU']['cosh_deta']['lut'])|trim }}
);

-- calo-muon cos dphi LUTs
type calo_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range {{corr_param['EG-MU']['cos_dphi']['min']}} to {{corr_param['EG-MU']['cos_dphi']['max']}};

constant CALO_MUON_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := (
{{ dump_lut(corr_param['EG-MU']['cos_dphi']['lut_size'], corr_param['EG-MU']['cos_dphi']['lut'])|trim }});

-- muon-muon cosh deta LUTs
type muon_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{corr_param['MU-MU']['cosh_deta']['min']}} to {{corr_param['MU-MU']['cosh_deta']['max']}};

constant MU_MU_COSH_DETA_LUT : muon_muon_cosh_deta_lut_array := (
{{ dump_lut(corr_param['MU-MU']['cosh_deta']['lut_size'], corr_param['MU-MU']['cosh_deta']['lut'])|trim }}
);

-- muon-muon cos dphi LUTs
type muon_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range {{corr_param['MU-MU']['cos_dphi']['min']}} to {{corr_param['MU-MU']['cos_dphi']['max']}};

constant MU_MU_COS_DPHI_LUT : muon_muon_cos_dphi_lut_array := (
{{ dump_lut(corr_param['MU-MU']['cos_dphi']['lut_size'], corr_param['MU-MU']['cos_dphi']['lut'])|trim }}
);

-- sin and cos phi LUTs for (twobody-pt)

-- Center of phi bins for calculation of cosine and sine with 3 digits after decimal point
type calo_sin_cos_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range {{sin_cos_phi_param['EG']['sin_phi']['min']}} to {{sin_cos_phi_param['EG']['sin_phi']['max']}};

constant CALO_COS_PHI_LUT : calo_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['EG']['sin_phi']['lut_size'], sin_cos_phi_param['EG']['sin_phi']['lut'])|trim }}
);

constant CALO_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['EG']['cos_phi']['lut_size'], sin_cos_phi_param['EG']['cos_phi']['lut'])|trim }}
);

-- HB 2017-03-29: LUTs for cosine(phi) and sine(phi) for twobody-pt calculation of muon objects and converted phi values for correlations with muon.
-- Center of phi bins for calculation of cosine and sine with 4 digits after decimal point
type muon_sin_cos_phi_lut_array is array (0 to 2**MUON_PHI_BITS-1) of integer range -10000 to 10000;

-- HB 2019-10-08: changed some values according to LUT from emulator (given by Len)
constant MUON_COS_PHI_LUT : muon_sin_cos_phi_lut_array := (
10000, 9999, 9996, 9993, 9988, 9982, 9975, 9967, 9957, 9946, 9934, 9921, 9907, 9892, 9875, 9857,
9838, 9818, 9797, 9775, 9751, 9726, 9700, 9673, 9645, 9616, 9585, 9553, 9521, 9487, 9452, 9415,
9378, 9340, 9300, 9260, 9218, 9175, 9131, 9086, 9040, 8993, 8944, 8895, 8845, 8793, 8741, 8687,
8633, 8577, 8521, 8463, 8404, 8345, 8284, 8223, 8160, 8097, 8032, 7967, 7900, 7833, 7765, 7695,
7625, 7554, 7482, 7410, 7336, 7261, 7186, 7110, 7032, 6954, 6876, 6796, 6716, 6634, 6552, 6470,
6386, 6302, 6217, 6131, 6044, 5957, 5869, 5780, 5691, 5601, 5510, 5419, 5327, 5234, 5141, 5047,
4953, 4858, 4762, 4666, 4569, 4472, 4374, 4276, 4177, 4077, 3977, 3877, 3776, 3675, 3573, 3471,
3369, 3266, 3163, 3059, 2955, 2851, 2746, 2641, 2535, 2430, 2324, 2218, 2111, 2004, 1897, 1790,
1683, 1575, 1467, 1359, 1251, 1143, 1034, 926, 817, 708, 600, 491, 382, 273, 164, 55,
-55, -164, -273, -382, -491, -600, -708, -817, -926, -1034, -1143, -1251, -1359, -1467, -1575, -1683,
-1790, -1897, -2004, -2111, -2218, -2324, -2430, -2535, -2641, -2746, -2851, -2955, -3059, -3163, -3266, -3369,
-3471, -3573, -3675, -3776, -3877, -3977, -4077, -4177, -4276, -4374, -4472, -4569, -4666, -4762, -4858, -4953,
-5047, -5141, -5234, -5327, -5419, -5510, -5601, -5691, -5780, -5869, -5957, -6044, -6131, -6217, -6302, -6386,
-6470, -6552, -6634, -6716, -6796, -6876, -6954, -7032, -7110, -7186, -7261, -7336, -7410, -7482, -7554, -7625,
-7695, -7765, -7833, -7900, -7967, -8032, -8097, -8160, -8223, -8284, -8345, -8404, -8463, -8521, -8577, -8633,
-8687, -8741, -8793, -8845, -8895, -8944, -8993, -9040, -9086, -9131, -9175, -9218, -9260, -9300, -9340, -9378,
-9415, -9452, -9487, -9521, -9553, -9585, -9616, -9645, -9673, -9700, -9726, -9751, -9775, -9797, -9818, -9838,
-9857, -9875, -9892, -9907, -9921, -9934, -9946, -9957, -9967, -9975, -9982, -9988, -9993, -9996, -9999, -10000,
-10000, -9999, -9996, -9993, -9988, -9982, -9975, -9967, -9957, -9946, -9934, -9921, -9907, -9892, -9875, -9857,
-9838, -9818, -9797, -9775, -9751, -9726, -9700, -9673, -9645, -9616, -9585, -9553, -9521, -9487, -9452, -9415,
-9378, -9340, -9300, -9260, -9218, -9175, -9131, -9086, -9040, -8993, -8944, -8895, -8845, -8793, -8741, -8687,
-8633, -8577, -8521, -8463, -8404, -8345, -8284, -8223, -8160, -8097, -8032, -7967, -7900, -7833, -7765, -7695,
-7625, -7554, -7482, -7410, -7336, -7261, -7186, -7110, -7032, -6954, -6876, -6796, -6716, -6634, -6552, -6470,
-6386, -6302, -6217, -6131, -6044, -5957, -5869, -5780, -5691, -5601, -5510, -5419, -5327, -5234, -5141, -5047,
-4953, -4858, -4762, -4666, -4569, -4472, -4374, -4276, -4177, -4077, -3977, -3877, -3776, -3675, -3573, -3471,
-3369, -3266, -3163, -3059, -2955, -2851, -2746, -2641, -2535, -2430, -2324, -2218, -2111, -2004, -1897, -1790,
-1683, -1575, -1467, -1359, -1251, -1143, -1034, -926, -817, -708, -600, -491, -382, -273, -164, -55,
55, 164, 273, 382, 491, 600, 708, 817, 926, 1034, 1143, 1251, 1359, 1467, 1575, 1683,
1790, 1897, 2004, 2111, 2218, 2324, 2430, 2535, 2641, 2746, 2851, 2955, 3059, 3163, 3266, 3369,
3471, 3573, 3675, 3776, 3877, 3977, 4077, 4177, 4276, 4374, 4472, 4569, 4666, 4762, 4858, 4953,
5047, 5141, 5234, 5327, 5419, 5510, 5601, 5691, 5780, 5869, 5957, 6044, 6131, 6217, 6302, 6386,
6470, 6552, 6634, 6716, 6796, 6876, 6954, 7032, 7110, 7186, 7261, 7336, 7410, 7482, 7554, 7625,
7695, 7765, 7833, 7900, 7967, 8032, 8097, 8160, 8223, 8284, 8345, 8404, 8463, 8521, 8577, 8633,
8687, 8741, 8793, 8845, 8895, 8944, 8993, 9040, 9086, 9131, 9175, 9218, 9260, 9300, 9340, 9378,
9415, 9452, 9487, 9521, 9553, 9585, 9616, 9645, 9673, 9700, 9726, 9751, 9775, 9797, 9818, 9838,
9857, 9875, 9892, 9907, 9921, 9934, 9946, 9957, 9967, 9975, 9982, 9988, 9993, 9996, 9999, 10000,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

-- HB 2019-10-08: changed some values according to LUT from emulator (given by Len)
constant MUON_SIN_PHI_LUT : muon_sin_cos_phi_lut_array := (
55, 164, 273, 382, 491, 600, 708, 817, 926, 1034, 1143, 1251, 1359, 1467, 1575, 1683,
1790, 1897, 2004, 2111, 2218, 2324, 2430, 2535, 2641, 2746, 2851, 2955, 3059, 3163, 3266, 3369,
3471, 3573, 3675, 3776, 3877, 3977, 4077, 4177, 4276, 4374, 4472, 4569, 4666, 4762, 4858, 4953,
5047, 5141, 5234, 5327, 5419, 5510, 5601, 5691, 5780, 5869, 5957, 6044, 6131, 6217, 6302, 6386,
6470, 6552, 6634, 6716, 6796, 6876, 6954, 7032, 7110, 7186, 7261, 7336, 7410, 7482, 7554, 7625,
7695, 7765, 7833, 7900, 7967, 8032, 8097, 8160, 8223, 8284, 8345, 8404, 8463, 8521, 8577, 8633,
8687, 8741, 8793, 8845, 8895, 8944, 8993, 9040, 9086, 9131, 9175, 9218, 9260, 9300, 9340, 9378,
9415, 9452, 9487, 9521, 9553, 9585, 9616, 9645, 9673, 9700, 9726, 9751, 9775, 9797, 9818, 9838,
9857, 9875, 9892, 9907, 9921, 9934, 9946, 9957, 9967, 9975, 9982, 9988, 9993, 9996, 9999, 10000,
10000, 9999, 9996, 9993, 9988, 9982, 9975, 9967, 9957, 9946, 9934, 9921, 9907, 9892, 9875, 9857,
9838, 9818, 9797, 9775, 9751, 9726, 9700, 9673, 9645, 9616, 9585, 9553, 9521, 9487, 9452, 9415,
9378, 9340, 9300, 9260, 9218, 9175, 9131, 9086, 9040, 8993, 8944, 8895, 8845, 8793, 8741, 8687,
8633, 8577, 8521, 8463, 8404, 8345, 8284, 8223, 8160, 8097, 8032, 7967, 7900, 7833, 7765, 7695,
7625, 7554, 7482, 7410, 7336, 7261, 7186, 7110, 7032, 6954, 6876, 6796, 6716, 6634, 6552, 6470,
6386, 6302, 6217, 6131, 6044, 5957, 5869, 5780, 5691, 5601, 5510, 5419, 5327, 5234, 5141, 5047,
4953, 4858, 4762, 4666, 4569, 4472, 4374, 4276, 4177, 4077, 3977, 3877, 3776, 3675, 3573, 3471,
3369, 3266, 3163, 3059, 2955, 2851, 2746, 2641, 2535, 2430, 2324, 2218, 2111, 2004, 1897, 1790,
1683, 1575, 1467, 1359, 1251, 1143, 1034, 926, 817, 708, 600, 491, 382, 273, 164, 55,
-55, -164, -273, -382, -491, -600, -708, -817, -926, -1034, -1143, -1251, -1359, -1467, -1575, -1683,
-1790, -1897, -2004, -2111, -2218, -2324, -2430, -2535, -2641, -2746, -2851, -2955, -3059, -3163, -3266, -3369,
-3471, -3573, -3675, -3776, -3877, -3977, -4077, -4177, -4276, -4374, -4472, -4569, -4666, -4762, -4858, -4953,
-5047, -5141, -5234, -5327, -5419, -5510, -5601, -5691, -5780, -5869, -5957, -6044, -6131, -6217, -6302, -6386,
-6470, -6552, -6634, -6716, -6796, -6876, -6954, -7032, -7110, -7186, -7261, -7336, -7410, -7482, -7554, -7625,
-7695, -7765, -7833, -7900, -7967, -8032, -8097, -8160, -8223, -8284, -8345, -8404, -8463, -8521, -8577, -8633,
-8687, -8741, -8793, -8845, -8895, -8944, -8993, -9040, -9086, -9131, -9175, -9218, -9260, -9300, -9340, -9378,
-9415, -9452, -9487, -9521, -9553, -9585, -9616, -9645, -9673, -9700, -9726, -9751, -9775, -9797, -9818, -9838,
-9857, -9875, -9892, -9907, -9921, -9934, -9946, -9957, -9967, -9975, -9982, -9988, -9993, -9996, -9999, -10000,
-10000, -9999, -9996, -9993, -9988, -9982, -9975, -9967, -9957, -9946, -9934, -9921, -9907, -9892, -9875, -9857,
-9838, -9818, -9797, -9775, -9751, -9726, -9700, -9673, -9645, -9616, -9585, -9553, -9521, -9487, -9452, -9415,
-9378, -9340, -9300, -9260, -9218, -9175, -9131, -9086, -9040, -8993, -8944, -8895, -8845, -8793, -8741, -8687,
-8633, -8577, -8521, -8463, -8404, -8345, -8284, -8223, -8160, -8097, -8032, -7967, -7900, -7833, -7765, -7695,
-7625, -7554, -7482, -7410, -7336, -7261, -7186, -7110, -7032, -6954, -6876, -6796, -6716, -6634, -6552, -6470,
-6386, -6302, -6217, -6131, -6044, -5957, -5869, -5780, -5691, -5601, -5510, -5419, -5327, -5234, -5141, -5047,
-4953, -4858, -4762, -4666, -4569, -4472, -4374, -4276, -4177, -4077, -3977, -3877, -3776, -3675, -3573, -3471,
-3369, -3266, -3163, -3059, -2955, -2851, -2746, -2641, -2535, -2430, -2324, -2218, -2111, -2004, -1897, -1790,
-1683, -1575, -1467, -1359, -1251, -1143, -1034, -926, -817, -708, -600, -491, -382, -273, -164, -55,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);
