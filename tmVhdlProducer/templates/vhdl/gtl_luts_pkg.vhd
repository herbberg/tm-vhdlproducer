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

-- conversion LUTs
type calo_eta_conv_2_muon_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of integer range -510 to 510;

constant CALO_ETA_CONV_2_MUON_ETA_LUT : calo_eta_conv_2_muon_eta_lut_array := (
2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62,
66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126,
130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186, 190,
194, 198, 202, 206, 210, 214, 218, 222, 226, 230, 234, 238, 242, 246, 250, 254,
258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318,
322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 362, 366, 370, 374, 378, 382,
386, 390, 394, 398, 402, 406, 410, 414, 418, 422, 426, 430, 434, 438, 442, 446,
450, 454, 458, 462, 466, 470, 474, 478, 482, 486, 490, 494, 498, 502, 506, 510,
-510, -506, -502, -498, -494, -490, -486, -482, -478, -474, -470, -466, -462, -458, -454, -450,
-446, -442, -438, -434, -430, -426, -422, -418, -414, -410, -406, -402, -398, -394, -390, -386,
-382, -378, -374, -370, -366, -362, -358, -354, -350, -346, -342, -338, -334, -330, -326, -322,
-318, -314, -310, -306, -302, -298, -294, -290, -286, -282, -278, -274, -270, -266, -262, -258,
-254, -250, -246, -242, -238, -234, -230, -226, -222, -218, -214, -210, -206, -202, -198, -194,
-190, -186, -182, -178, -174, -170, -166, -162, -158, -154, -150, -146, -142, -138, -134, -130,
-126, -122, -118, -114, -110, -106, -102, -98, -94, -90, -86, -82, -78, -74, -70, -66,
-62, -58, -54, -50, -46, -42, -38, -34, -30, -26, -22, -18, -14, -10, -6, -2
);

type calo_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;

constant CALO_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := (
2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62,
66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126,
130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186, 190,
194, 198, 202, 206, 210, 214, 218, 222, 226, 230, 234, 238, 242, 246, 250, 254,
258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318,
322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 362, 366, 370, 374, 378, 382,
386, 390, 394, 398, 402, 406, 410, 414, 418, 422, 426, 430, 434, 438, 442, 446,
450, 454, 458, 462, 466, 470, 474, 478, 482, 486, 490, 494, 498, 502, 506, 510,
514, 518, 522, 526, 530, 534, 538, 542, 546, 550, 554, 558, 562, 566, 570, 574,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

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

constant CALO_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['EG']['sin_phi']['lut_size'], sin_cos_phi_param['EG']['sin_phi']['lut'])|trim }}
);

constant CALO_COS_PHI_LUT : calo_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['EG']['cos_phi']['lut_size'], sin_cos_phi_param['EG']['cos_phi']['lut'])|trim }}
);

-- Center of phi bins for calculation of cosine and sine with 4 digits after decimal point
type muon_sin_cos_phi_lut_array is array (0 to 2**MUON_PHI_BITS-1) of integer range {{sin_cos_phi_param['MU']['sin_phi']['min']}} to {{sin_cos_phi_param['MU']['sin_phi']['max']}};

constant MUON_SIN_PHI_LUT : muon_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['MU']['sin_phi']['lut_size'], sin_cos_phi_param['MU']['sin_phi']['lut'])|trim }}
);

constant MUON_COS_PHI_LUT : muon_sin_cos_phi_lut_array := (
{{ dump_lut(sin_cos_phi_param['MU']['cos_phi']['lut_size'], sin_cos_phi_param['MU']['cos_phi']['lut'])|trim }}
);

