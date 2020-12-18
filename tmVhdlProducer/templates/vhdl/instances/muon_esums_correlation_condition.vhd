{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.muon_esums_correlation_condition{% endblock %}

{%- block generic_map_beg %}
    {%- if condition.hasDeltaPhi %}
        dphi_cut => {{ condition.deltaPhi.enabled }}, 
    {%- endif %}        
    {%- if condition.hasMass %}
        mass_cut => {{ condition.mass.enabled }}, 
        mass_type => condition.mass.type, 
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
    {%- endif %}        
{% endblock %}

{%- block correlation_cuts %}
-- correlation cuts
    {%- if condition.hasDeltaPhi %}
        diff_phi_upper_limit_vector => X"{{ condition.deltaPhi.upper|X08 }}", 
        diff_phi_lower_limit_vector => X"{{ condition.deltaPhi.lower|X08 }}",
    {%- endif %}        
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
    {%- endif %}        
    {%- if condition.hasMass %}
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
    {%- endif %}
{% endblock %}

{%- block generic_map_end %}
-- type of esums object
        obj_type_esums => {{ o2.type|upper }}_TYPE
{%- endblock %}

{%- block port_map %}
        {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        {{ o2.type|lower }}_bx_{{ o2.bx }},
    {%- if condition.hasDeltaPhi %}
        diff_phi => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
    {%- endif %}        
    {%- if condition.hasMass or condition.hasTwoBodyPt %}
        pt1 => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }}, 
        pt2 => {{ o2.type|lower }}_pt_vector_bx_{{ o2.bx }},
    {%- endif %}        
    {%- if condition.hasMass %}
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }}, 
        cos_phi_2_integer => {{ o2.type|lower }}_cos_phi_bx_{{ o2.bx }}, 
        sin_phi_1_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }}, 
        sin_phi_2_integer => {{ o2.type|lower }}_sin_phi_bx_{{ o2.bx }},
    {%- endif %}        
{%- endblock %}
