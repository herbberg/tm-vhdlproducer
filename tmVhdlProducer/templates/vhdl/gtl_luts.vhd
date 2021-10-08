{%- macro dump_lut(ll, v_p_r, lut) -%}
  {% for i in range(0,ll,v_p_r) -%}
    {% if i <= ll-v_p_r -%}
      {% for j in range(0,v_p_r) -%}
        {%- if i+j == ll-1 -%}
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
{{ dump_lut(pt_param['EG-ET']['ll'], v_p_r, pt_param['EG-ET']['lut'])|trim }}
);

-- jet pt LUT
type jet_pt_lut_array is array (0 to 2**(JET_ET_HIGH-JET_ET_LOW+1)-1) of natural range {{pt_param['JET-ET']['min']}} to {{pt_param['JET-ET']['max']}};

constant JET_PT_LUT : jet_pt_lut_array := (
{{ dump_lut(pt_param['JET-ET']['ll'], v_p_r, pt_param['JET-ET']['lut'])|trim }}
);

-- esums pt LUTs
type etm_pt_lut_array is array (0 to 2**(ETM_ET_HIGH-ETM_ET_LOW+1)-1) of natural range {{pt_param['ETM-ET']['min']}} to {{pt_param['ETM-ET']['max']}};

constant ETM_PT_LUT : etm_pt_lut_array := (
{{ dump_lut(pt_param['ETM-ET']['ll'], v_p_r, pt_param['ETM-ET']['lut'])|trim }}
);

-- muon pt LUT
type muon_pt_lut_array is array (0 to 2**(MUON_PT_HIGH-MUON_PT_LOW+1)-1) of natural range {{pt_param['MU-ET']['min']}} to {{pt_param['MU-ET']['max']}};

constant MU_PT_LUT : muon_pt_lut_array := (
{{ dump_lut(pt_param['MU-ET']['ll'], v_p_r, pt_param['MU-ET']['lut'])|trim }}
);

-- muon unconstraint pt LUT
type muon_upt_lut_array is array (0 to 2**(MUON_UPT_HIGH-MUON_UPT_LOW+1)-1) of natural range {{pt_param['MU-UPT']['min']}} to {{pt_param['MU-UPT']['max']}};

constant MU_UPT_LUT : muon_upt_lut_array := (
{{ dump_lut(pt_param['MU-UPT']['ll'], v_p_r, pt_param['MU-UPT']['lut'])|trim }}
);

-- calo-calo differences LUTs
type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{corr_param['EG-EG']['deta']['min']}} to {{corr_param['EG-EG']['deta']['max']}};

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
{{ dump_lut(corr_param['EG-EG']['deta']['ll'], v_p_r, corr_param['EG-EG']['deta']['lut'])|trim }}
);

type calo_calo_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range {{corr_param['EG-EG']['dphi']['min']}} to {{corr_param['EG-EG']['dphi']['max']}};

constant CALO_CALO_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := (
{{ dump_lut(corr_param['EG-EG']['dphi']['ll'], v_p_r, corr_param['EG-EG']['dphi']['lut'])|trim }}
);

-- muon-muon differences LUTs
type muon_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{corr_param['MU-MU']['deta']['min']}} to {{corr_param['MU-MU']['deta']['max']}};

constant MU_MU_DIFF_ETA_LUT : muon_muon_diff_eta_lut_array := (
{{ dump_lut(corr_param['MU-MU']['deta']['ll'], v_p_r, corr_param['MU-MU']['deta']['lut'])|trim }}
);

type muon_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{corr_param['MU-MU']['dphi']['min']}} to {{corr_param['MU-MU']['dphi']['max']}};

constant MU_MU_DIFF_PHI_LUT : muon_muon_diff_phi_lut_array := (
{{ dump_lut(corr_param['MU-MU']['dphi']['ll'], v_p_r, corr_param['MU-MU']['dphi']['lut'])|trim }}
);

-- calo-muon differences LUTs
type calo_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range {{corr_param['EG-MU']['deta']['min']}} to {{corr_param['EG-MU']['deta']['max']}};

constant CALO_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := (
{{ dump_lut(corr_param['EG-MU']['deta']['ll'], v_p_r, corr_param['EG-MU']['deta']['lut'])|trim }}
);

type calo_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{corr_param['EG-MU']['dphi']['min']}} to {{corr_param['EG-MU']['dphi']['max']}};

constant CALO_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := (
{{ dump_lut(corr_param['EG-MU']['dphi']['ll'], v_p_r, corr_param['EG-MU']['dphi']['lut'])|trim }}
);

-- calo-calo cosh deta LUTs
type calo_calo_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{corr_param['EG-EG']['cosh_deta']['min']}} to {{corr_param['EG-EG']['cosh_deta']['max']}};

constant CALO_CALO_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := (
{{ dump_lut(corr_param['EG-EG']['cosh_deta']['ll'], v_p_r, corr_param['EG-EG']['cosh_deta']['lut'])|trim }}
);

-- calo-calo cos dphi LUTs
type calo_calo_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range {{corr_param['EG-EG']['cos_dphi']['min']}} to {{corr_param['EG-EG']['cos_dphi']['max']}};

constant CALO_CALO_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := (
{{ dump_lut(corr_param['EG-EG']['cos_dphi']['ll'], v_p_r, corr_param['EG-EG']['cos_dphi']['lut'])|trim }}
);

-- muon-muon cosh deta LUTs
type calo_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range {{corr_param['EG-MU']['cosh_deta']['min']}} to {{corr_param['EG-MU']['cosh_deta']['max']}};

constant CALO_MUON_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := (
{{ dump_lut(corr_param['EG-MU']['cosh_deta']['ll'], v_p_r, corr_param['EG-MU']['cosh_deta']['lut'])|trim }}
);

-- calo-muon cos dphi LUTs
type calo_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range {{corr_param['EG-MU']['cos_dphi']['min']}} to {{corr_param['EG-MU']['cos_dphi']['max']}};

constant CALO_MUON_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := (
{{ dump_lut(corr_param['EG-MU']['cos_dphi']['ll'], v_p_r, corr_param['EG-MU']['cos_dphi']['lut'])|trim }});

-- muon-muon cosh deta LUTs
type muon_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{corr_param['MU-MU']['cosh_deta']['min']}} to {{corr_param['MU-MU']['cosh_deta']['max']}};

constant MU_MU_COSH_DETA_LUT : muon_muon_cosh_deta_lut_array := (
{{ dump_lut(corr_param['MU-MU']['cosh_deta']['ll'], v_p_r, corr_param['MU-MU']['cosh_deta']['lut'])|trim }}
);

-- muon-muon cos dphi LUTs
type muon_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range {{corr_param['MU-MU']['cos_dphi']['min']}} to {{corr_param['MU-MU']['cos_dphi']['max']}};

constant MU_MU_COS_DPHI_LUT : muon_muon_cos_dphi_lut_array := (
{{ dump_lut(corr_param['MU-MU']['cos_dphi']['ll'], v_p_r, corr_param['MU-MU']['cos_dphi']['lut'])|trim }}
);
