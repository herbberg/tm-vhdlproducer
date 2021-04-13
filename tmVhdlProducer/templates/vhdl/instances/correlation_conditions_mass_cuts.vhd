{%- for o1, o2 in module.correlationCombinationsCoshCos %}
{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_cos_dphi_i: entity work.cosh_deta_cos_dphi
    generic map(
    {%- if o1.is_calo_type and o2.is_calo_type %}
        calo_calo_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
    {%- endif %}
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        calo_calo_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_muon_type %}
        calo_muon_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
    {%- endif %}
    {%- if (o1.is_calo_type and o2.is_muon_type) or (o1.is_muon_type and o2.is_esums_type) %}
        calo_muon_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_muon_type %}
        muon_muon_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
        muon_muon_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if not o2.is_esums_type %}
        deta_bins_width => {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH,
        dphi_bins_width => {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH,
    {%- endif %}
        cosh_cos_vector_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE
    )
    port map(
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
    {%- if not o2.is_esums_type %}
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        deta_bin_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector,
        dphi_bin_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector,
        cosh_deta_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
    {%- endif %}
        cos_dphi_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector
    );
--
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsDeltaR %}

-- Instantiations of deltaR calculation

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deltaR_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        dr_cut => true
    )
    port map(
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
        dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr
    );
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsInvMass %}

-- Instantiations of invariant mass pt calculation

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        mass_cut => true,
        mass_type => INVARIANT_MASS_TYPE,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        cosh_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_PRECISION,
        cosh_cos_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH
    )
    port map(
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        inv_mass_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt
    );
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsInvMassDivDr %}

-- Instantiations of invariant mass over deltaR calculation

mass_div_dr_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.mass_div_dr
    generic map(
        NR_{{ o1.type | upper }}_OBJECTS,
        NR_{{ o2.type | upper }}_OBJECTS,
        {{ o1.type | upper }}_{{ o2.type | upper }}_ROM,
        {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH_ROM,
        {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH_ROM,
        {{ o1.type | upper }}_{{ o2.type | upper }}_INV_DR_SQ_VECTOR_WIDTH,
        {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH
    )
    port map(
        lhc_clk,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr
    );
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsInvMassUpt %}

-- Instantiations of invariant mass upt calculation

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_upt_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        mass_cut => true,
        mass_type => INVARIANT_MASS_UPT_TYPE,
        upt1_width => {{ o1.type | upper }}_UPT_VECTOR_WIDTH,
        upt2_width => {{ o2.type | upper }}_UPT_VECTOR_WIDTH,
        cosh_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_PRECISION,
        cosh_cos_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH
    )
    port map(
        upt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_upt_vector,
        upt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_upt_vector,
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        inv_mass_upt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_upt
    );
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsTransMass %}

-- Instantiations of transverse mass calculation

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        mass_cut => true,
        mass_type => TRANSVERSE_MASS_TYPE,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        cosh_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_PRECISION,
        cosh_cos_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH
    )
    port map(
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        trans_mass => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans
    );
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsTbpt %}

-- Instantiations of two-body pt calculation

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        tbpt_cut => true,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
    {%- if o1.is_calo_type and o2.is_calo_type %}
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_esums_type %}
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_esums_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
        pt_sq_sin_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_SIN_COS_PRECISION
    )
    port map(
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- if o1.is_calo_type and o2.is_muon_type %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_conv_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_conv_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- elif o1.is_muon_type %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_conv_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_conv_sin_phi,
    {%- else %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt
    );

{%- endfor %}
