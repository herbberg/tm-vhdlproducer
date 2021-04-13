{%- block signal_correlation_conditions_differences %}
  {%- for o1, o2 in module.correlationCombinations %}

    {%- if o2.is_esums_type %}
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer: dim2_max_phi_range_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => 0));
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector: deta_dphi_vector_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- else %}
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer: dim2_max_eta_range_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => 0));
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector: deta_dphi_vector_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer: dim2_max_phi_range_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => 0));
    signal {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector: deta_dphi_vector_array(0 to NR_{{ o1.type|upper }}_OBJECTS-1, 0 to NR_{{ o2.type|upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- endif %}

    {%- if o1.is_calo_type and o2.is_calo_type %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector : common_deta_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector : common_dphi_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- elif o1.is_calo_type and o2.is_esums_type %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- elif o1.is_calo_type and o2.is_muon_type %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector : common_deta_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector : common_dphi_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- elif o1.is_muon_type and o2.is_muon_type %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector : common_deta_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector : common_dphi_bin_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- elif o1.is_muon_type and o2.is_esums_type %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector : common_cosh_cos_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
    {%- endif %}

  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsDeltaR %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr : dr_dim2_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsInvMass %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt : mass_dim2_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsInvMassUpt %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_upt : mass_dim2_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsInvMassDivDr %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr : mass_div_dr_vector_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsTransMass %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans : mass_dim2_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsTbpt %}
    signal {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt : tbpt_dim2_array(0 to NR_{{ o1.type | upper }}_OBJECTS-1, 0 to NR_{{ o2.type | upper }}_OBJECTS-1) := (others => (others => (others => '0')));
  {%- endfor %}

{%- endblock signal_correlation_conditions_differences %}
{# eof #}
