{%- if condition.objects[1].is_esums_type %}
  {%- set nr_o = 1 %}
-- slices for esums
        slice_low_obj2 => 0,
        slice_high_obj2 => 0,
{%- else %}
  {%- set nr_o = condition.nr_objects %}
{%- endif %}
-- obj cuts
{%- for i in range(0,nr_o) %}
  {%- set o = condition.objects[i] %}
  {%- if o.slice %}
        slice_low_obj{{i+1}} => {{ o.slice.lower }},
        slice_high_obj{{i+1}} => {{ o.slice.upper }},
  {%- endif %}
  {%- if not o.operator %}
        pt_ge_mode_obj{{i+1}} => {{ o.operator | vhdl_bool }},
  {%- endif %}
        pt_threshold_obj{{i+1}} => X"{{ o.threshold | X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_obj{{i+1}} => {{ o.etaNrCuts }},
  {%- endif %}
  {%- if o.etaNrCuts == 1 %}
        eta_upper_limits_obj{{i+1}} => (1 => X"{{ o.etaUpperLimit[0] | X04 }}", others => X"0000"),
        eta_lower_limits_obj{{i+1}} => (1 => X"{{ o.etaLowerLimit[0] | X04 }}", others => X"0000"),
  {%- elif o.etaNrCuts == 2 %}
        eta_upper_limits_obj{{i+1}} => (1 => X"{{ o.etaUpperLimit[0] | X04 }}", 2 => X"{{ o.etaUpperLimit[1] | X04 }}", others => X"0000"),
        eta_lower_limits_obj{{i+1}} => (1 => X"{{ o.etaLowerLimit[0] | X04 }}", 2 => X"{{ o.etaLowerLimit[1] | X04 }}", others => X"0000"),
  {%- elif o.etaNrCuts == 3 %}
        eta_upper_limits_obj{{i+1}} => (1 => X"{{ o.etaUpperLimit[0] | X04 }}", 2 => X"{{ o.etaUpperLimit[1] | X04 }}", 3 => X"{{ o.etaUpperLimit[2] | X04 }}", others => X"0000"),
        eta_lower_limits_obj{{i+1}} => (1 => X"{{ o.etaLowerLimit[0] | X04 }}", 2 => X"{{ o.etaLowerLimit[1] | X04 }}", 3 => X"{{ o.etaLowerLimit[2] | X04 }}", others => X"0000"),
  {%- endif %}
  {%- if o.phiNrCuts > 0 %}
        nr_phi_windows_obj{{i+1}} => {{ o.phiNrCuts }},
  {%- endif %}
  {%- if o.phiNrCuts == 1 %}
        phi_upper_limits_obj{{i+1}} => (1 => X"{{ o.phiUpperLimit[0] | X04 }}", others => X"0000"),
        phi_lower_limits_obj{{i+1}} => (1 => X"{{ o.phiLowerLimit[0] | X04 }}", others => X"0000"),
  {%- elif o.phiNrCuts == 2 %}
        phi_upper_limits_obj{{i+1}} => (1 => X"{{ o.phiUpperLimit[0] | X04 }}", 2 => X"{{ o.phiUpperLimit[1] | X04 }}", others => X"0000"),
        phi_lower_limits_obj{{i+1}} => (1 => X"{{ o.phiLowerLimit[0] | X04 }}", 2 => X"{{ o.phiLowerLimit[1] | X04 }}", others => X"0000"),
  {%- endif %}
  {%- if o.charge %}
        requested_charge_obj{{i+1}} => "{{ o.charge.value }}",
  {%- endif %}
  {%- if o.quality %}
        qual_lut_obj{{i+1}} => X"{{ o.quality.value | X04 }}",
  {%- endif %}
  {%- if o.isolation %}
        iso_lut_obj{{i+1}} => X"{{ o.isolation.value | X01 }}",
  {%- endif %}
  {%- if o.displaced %}
        disp_cut_obj{{i+1}} => {{ o.displaced | vhdl_bool }},
        disp_requ_obj{{i+1}} => {{ o.displaced.state | vhdl_bool }},
  {% endif %}
  {%- if o.upt %}
        upt_cut_obj{{i+1}} => {{ o.upt | vhdl_bool }},
        upt_upper_limit_obj{{i+1}} => X"{{ o.upt.upper | X04 }}",
        upt_lower_limit_obj{{i+1}} => X"{{ o.upt.lower | X04 }}",
  {%- endif %}
  {%- if o.impactParameter %}
        ip_lut_obj{{i+1}} => X"{{ o.impactParameter.value | X01 }}",
  {%- endif %}
{%- endfor %}
