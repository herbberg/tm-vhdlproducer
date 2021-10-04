-- calo-calo differences LUTs
type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{cc_deta_min}} to {{cc_deta_max}};

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
{%- for i in range(0,256,16) %}
    {%- if i < 256-16 %}
{{cc_deta_lut[i]}}, {{cc_deta_lut[i+1]}}, {{cc_deta_lut[i+2]}}, {{cc_deta_lut[i+3]}}, {{cc_deta_lut[i+4]}}, {{cc_deta_lut[i+5]}}, {{cc_deta_lut[i+6]}}, {{cc_deta_lut[i+7]}}, {{cc_deta_lut[i+8]}}, {{cc_deta_lut[i+9]}}, {{cc_deta_lut[i+10]}}, {{cc_deta_lut[i+11]}}, {{cc_deta_lut[i+12]}}, {{cc_deta_lut[i+13]}}, {{cc_deta_lut[i+14]}}, {{cc_deta_lut[i+15]}},
    {%- else %}
{{cc_deta_lut[i]}}, {{cc_deta_lut[i+1]}}, {{cc_deta_lut[i+2]}}, {{cc_deta_lut[i+3]}}, {{cc_deta_lut[i+4]}}, {{cc_deta_lut[i+5]}}, {{cc_deta_lut[i+6]}}, {{cc_deta_lut[i+7]}}, {{cc_deta_lut[i+8]}}, {{cc_deta_lut[i+9]}}, {{cc_deta_lut[i+10]}}, {{cc_deta_lut[i+11]}}, {{cc_deta_lut[i+12]}}, {{cc_deta_lut[i+13]}}, {{cc_deta_lut[i+14]}}, {{cc_deta_lut[i+15]}}
    {%- endif %}
{%- endfor %}
);

type calo_calo_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range {{cc_dphi_min}} to {{cc_dphi_max}};

constant CALO_CALO_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := (
{%- for i in range(0,256,16) %}
    {%- if i < 256-16 %}
{{cc_dphi_lut[i]}}, {{cc_dphi_lut[i+1]}}, {{cc_dphi_lut[i+2]}}, {{cc_dphi_lut[i+3]}}, {{cc_dphi_lut[i+4]}}, {{cc_dphi_lut[i+5]}}, {{cc_dphi_lut[i+6]}}, {{cc_dphi_lut[i+7]}}, {{cc_dphi_lut[i+8]}}, {{cc_dphi_lut[i+9]}}, {{cc_dphi_lut[i+10]}}, {{cc_dphi_lut[i+11]}}, {{cc_dphi_lut[i+12]}}, {{cc_dphi_lut[i+13]}}, {{cc_dphi_lut[i+14]}}, {{cc_dphi_lut[i+15]}},
    {%- else %}
{{cc_dphi_lut[i]}}, {{cc_dphi_lut[i+1]}}, {{cc_dphi_lut[i+2]}}, {{cc_dphi_lut[i+3]}}, {{cc_dphi_lut[i+4]}}, {{cc_dphi_lut[i+5]}}, {{cc_dphi_lut[i+6]}}, {{cc_dphi_lut[i+7]}}, {{cc_dphi_lut[i+8]}}, {{cc_dphi_lut[i+9]}}, {{cc_dphi_lut[i+10]}}, {{cc_dphi_lut[i+11]}}, {{cc_dphi_lut[i+12]}}, {{cc_dphi_lut[i+13]}}, {{cc_dphi_lut[i+14]}}, {{cc_dphi_lut[i+15]}}
    {%- endif %}
{%- endfor %}
);

-- muon-muon differences LUTs
type muon_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{mm_deta_min}} to {{mm_deta_max}};

constant MU_MU_DIFF_ETA_LUT : muon_muon_diff_eta_lut_array := (
{%- for i in range(0,512,16) %}
    {%- if i < 512-16 %}
{{mm_deta_lut[i]}}, {{mm_deta_lut[i+1]}}, {{mm_deta_lut[i+2]}}, {{mm_deta_lut[i+3]}}, {{mm_deta_lut[i+4]}}, {{mm_deta_lut[i+5]}}, {{mm_deta_lut[i+6]}}, {{mm_deta_lut[i+7]}}, {{mm_deta_lut[i+8]}}, {{mm_deta_lut[i+9]}}, {{mm_deta_lut[i+10]}}, {{mm_deta_lut[i+11]}}, {{mm_deta_lut[i+12]}}, {{mm_deta_lut[i+13]}}, {{mm_deta_lut[i+14]}}, {{mm_deta_lut[i+15]}},
    {%- else %}
{{mm_deta_lut[i]}}, {{mm_deta_lut[i+1]}}, {{mm_deta_lut[i+2]}}, {{mm_deta_lut[i+3]}}, {{mm_deta_lut[i+4]}}, {{mm_deta_lut[i+5]}}, {{mm_deta_lut[i+6]}}, {{mm_deta_lut[i+7]}}, {{mm_deta_lut[i+8]}}, {{mm_deta_lut[i+9]}}, {{mm_deta_lut[i+10]}}, {{mm_deta_lut[i+11]}}, {{mm_deta_lut[i+12]}}, {{mm_deta_lut[i+13]}}, {{mm_deta_lut[i+14]}}, {{mm_deta_lut[i+15]}}
    {%- endif %}
{%- endfor %}
);

type muon_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{mm_dphi_min}} to {{mm_dphi_max}};

constant MU_MU_DIFF_PHI_LUT : muon_muon_diff_phi_lut_array := (
{%- for i in range(0,1024,16) %}
    {%- if i < 1024-16 %}
{{mm_dphi_lut[i]}}, {{mm_dphi_lut[i+1]}}, {{mm_dphi_lut[i+2]}}, {{mm_dphi_lut[i+3]}}, {{mm_dphi_lut[i+4]}}, {{mm_dphi_lut[i+5]}}, {{mm_dphi_lut[i+6]}}, {{mm_dphi_lut[i+7]}}, {{mm_dphi_lut[i+8]}}, {{mm_dphi_lut[i+9]}}, {{mm_dphi_lut[i+10]}}, {{mm_dphi_lut[i+11]}}, {{mm_dphi_lut[i+12]}}, {{mm_dphi_lut[i+13]}}, {{mm_dphi_lut[i+14]}}, {{mm_dphi_lut[i+15]}},
    {%- else %}
{{mm_dphi_lut[i]}}, {{mm_dphi_lut[i+1]}}, {{mm_dphi_lut[i+2]}}, {{mm_dphi_lut[i+3]}}, {{mm_dphi_lut[i+4]}}, {{mm_dphi_lut[i+5]}}, {{mm_dphi_lut[i+6]}}, {{mm_dphi_lut[i+7]}}, {{mm_dphi_lut[i+8]}}, {{mm_dphi_lut[i+9]}}, {{mm_dphi_lut[i+10]}}, {{mm_dphi_lut[i+11]}}, {{mm_dphi_lut[i+12]}}, {{mm_dphi_lut[i+13]}}, {{mm_dphi_lut[i+14]}}, {{mm_dphi_lut[i+15]}}
    {%- endif %}
{%- endfor %}
);
