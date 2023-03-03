  {%- for i in range(1, nr_requirements) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_requirements > i and o.slice %}
        slice_{{ i }}_low_obj1 => {{ o.slice.lower }},
        slice_{{ i }}_high_obj1 => {{ o.slice.upper }},
    {%- endif %}
  {%- endfor %}
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator | vhdl_bool }},
  {%- endif %}
        pt_thresholds_obj1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.threshold | X04 }}"{% endfor %}),
  {%- set max_eta_cuts = [o1.etaNrCuts, o2.etaNrCuts, o3.etaNrCuts, o4.etaNrCuts] | max %}
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows_obj1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}{{ o.etaNrCuts }}{% endfor %}),
  {%- endif %}
  {%- if max_eta_cuts == 1 %}
        eta_upper_limits_obj1 => ((1 => X"{{ o1.etaUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaUpperLimit[0] | X04 }}", others => X"0000")),
        eta_lower_limits_obj1 => ((1 => X"{{ o1.etaLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaLowerLimit[0] | X04 }}", others => X"0000")),
  {%- elif max_eta_cuts == 2 %}
        eta_upper_limits_obj1 => ((1 => X"{{ o1.etaUpperLimit[0] | X04 }}", 2 => X"{{ o1.etaUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaUpperLimit[0] | X04 }}", 2 => X"{{ o2.etaUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaUpperLimit[0] | X04 }}", 2 => X"{{ o3.etaUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaUpperLimit[0] | X04 }}", 2 => X"{{ o4.etaUpperLimit[1] | X04 }}", others => X"0000")),
        eta_lower_limits_obj1 => ((1 => X"{{ o1.etaLowerLimit[0] | X04 }}", 2 => X"{{ o1.etaLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaLowerLimit[0] | X04 }}", 2 => X"{{ o2.etaLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaLowerLimit[0] | X04 }}", 2 => X"{{ o3.etaLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaLowerLimit[0] | X04 }}", 2 => X"{{ o4.etaLowerLimit[1] | X04 }}", others => X"0000")),
  {%- elif max_eta_cuts == 3 %}
        eta_upper_limits_obj1 => ((1 => X"{{ o1.etaUpperLimit[0] | X04 }}", 2 => X"{{ o1.etaUpperLimit[1] | X04 }}", 3 => X"{{ o1.etaUpperLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaUpperLimit[0] | X04 }}", 2 => X"{{ o2.etaUpperLimit[1] | X04 }}", 3 => X"{{ o2.etaUpperLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaUpperLimit[0] | X04 }}", 2 => X"{{ o3.etaUpperLimit[1] | X04 }}", 3 => X"{{ o3.etaUpperLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaUpperLimit[0] | X04 }}", 2 => X"{{ o4.etaUpperLimit[1] | X04 }}", 3 => X"{{ o4.etaUpperLimit[2] | X04 }}", others => X"0000")),
        eta_lower_limits_obj1 => ((1 => X"{{ o1.etaLowerLimit[0] | X04 }}", 2 => X"{{ o1.etaLowerLimit[1] | X04 }}", 3 => X"{{ o1.etaLowerLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o2.etaLowerLimit[0] | X04 }}", 2 => X"{{ o2.etaLowerLimit[1] | X04 }}", 3 => X"{{ o2.etaLowerLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o3.etaLowerLimit[0] | X04 }}", 2 => X"{{ o3.etaLowerLimit[1] | X04 }}", 3 => X"{{ o3.etaLowerLimit[2] | X04 }}", others => X"0000"), (1 => X"{{ o4.etaLowerLimit[0] | X04 }}", 2 => X"{{ o4.etaLowerLimit[1] | X04 }}", 3 => X"{{ o4.etaLowerLimit[2] | X04 }}", others => X"0000")),
  {%- endif %}
  {%- set max_phi_cuts = [o1.phiNrCuts, o2.phiNrCuts, o3.phiNrCuts, o4.phiNrCuts] | max %}
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        nr_phi_windows_obj1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}{{ o.phiNrCuts }}{% endfor %}),
  {%- endif %}
  {%- if max_phi_cuts == 1 %}
        phi_upper_limits_obj1 => ((1 => X"{{ o1.phiUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o2.phiUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o3.phiUpperLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o4.phiUpperLimit[0] | X04 }}", others => X"0000")),
        phi_lower_limits_obj1 => ((1 => X"{{ o1.phiLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o2.phiLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o3.phiLowerLimit[0] | X04 }}", others => X"0000"), (1 => X"{{ o4.phiLowerLimit[0] | X04 }}", others => X"0000")),
  {%- elif max_phi_cuts == 2 %}
        phi_upper_limits_obj1 => ((1 => X"{{ o1.phiUpperLimit[0] | X04 }}", 2 => X"{{ o1.phiUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o2.phiUpperLimit[0] | X04 }}", 2 => X"{{ o2.phiUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o3.phiUpperLimit[0] | X04 }}", 2 => X"{{ o3.phiUpperLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o4.phiUpperLimit[0] | X04 }}", 2 => X"{{ o4.phiUpperLimit[1] | X04 }}", others => X"0000")),
        phi_lower_limits_obj1 => ((1 => X"{{ o1.phiLowerLimit[0] | X04 }}", 2 => X"{{ o1.phiLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o2.phiLowerLimit[0] | X04 }}", 2 => X"{{ o2.phiLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o3.phiLowerLimit[0] | X04 }}", 2 => X"{{ o3.phiLowerLimit[1] | X04 }}", others => X"0000"), (1 => X"{{ o4.phiLowerLimit[0] | X04 }}", 2 => X"{{ o4.phiLowerLimit[1] | X04 }}", others => X"0000")),
  {%- endif %}
  {%- if o1.isolation or o2.isolation or o3.isolation or o4.isolation %}
        iso_luts_obj1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.isolation.value | X01 }}"{% endfor %}),
  {%- endif %}
  {%- if orm_obj.slice %}
        slice_low_obj2 => {{ orm_obj.slice.lower }},
        slice_high_obj2 => {{ orm_obj.slice.upper }},
  {%- endif %}
  {%- if not orm_obj.operator %}
        pt_ge_mode_obj2 => {{ orm_obj.operator | vhdl_bool }},
  {%- endif %}
        pt_threshold_obj2 => X"{{ orm_obj.threshold | X04 }}",
  {%- if orm_obj.etaNrCuts > 0 %}
        nr_eta_windows_obj2 => {{ orm_obj.etaNrCuts }},
  {%- endif %}
  {%- if orm_obj.etaNrCuts == 1 %}
        eta_upper_limits_obj2 => (1 => X"{{ orm_obj.etaUpperLimit[0] | X04 }}", others => X"0000"),
        eta_lower_limits_obj2 => (1 => X"{{ orm_obj.etaLowerLimit[0] | X04 }}", others => X"0000"),
  {%- elif orm_obj.etaNrCuts == 2 %}
        eta_upper_limits_obj2 => (1 => X"{{ orm_obj.etaUpperLimit[0] | X04 }}", 2 => X"{{ orm_obj.etaUpperLimit[1] | X04 }}", others => X"0000"),
        eta_lower_limits_obj2 => (1 => X"{{ orm_obj.etaLowerLimit[0] | X04 }}", 2 => X"{{ orm_obj.etaLowerLimit[1] | X04 }}", others => X"0000"),
  {%- elif orm_obj.etaNrCuts == 3 %}
        eta_upper_limits_obj2 => (1 => X"{{ orm_obj.etaUpperLimit[0] | X04 }}", 2 => X"{{ orm_obj.etaUpperLimit[1] | X04 }}", 3 => X"{{ orm_obj.etaUpperLimit[2] | X04 }}", others => X"0000"),
        eta_lower_limits_obj2 => (1 => X"{{ orm_obj.etaLowerLimit[0] | X04 }}", 2 => X"{{ orm_obj.etaLowerLimit[1] | X04 }}", 3 => X"{{ orm_obj.etaLowerLimit[2] | X04 }}", others => X"0000"),
  {%- endif %}
  {%- if orm_obj.phiNrCuts > 0 %}
        nr_phi_windows_obj2 => {{ orm_obj.phiNrCuts }},
  {%- endif %}
  {%- if orm_obj.phiNrCuts == 1 %}
        phi_upper_limits_obj2 => (1 => X"{{ orm_obj.phiUpperLimit[0] | X04 }}", others => X"0000"),
        phi_lower_limits_obj2 => (1 => X"{{ orm_obj.phiLowerLimit[0] | X04 }}", others => X"0000"),
  {%- elif orm_obj.phiNrCuts == 2 %}
        phi_upper_limits_obj2 => (1 => X"{{ orm_obj.phiUpperLimit[0] | X04 }}", 2 => X"{{ orm_obj.phiUpperLimit[1] | X04 }}", others => X"0000"),
        phi_lower_limits_obj2 => (1 => X"{{ orm_obj.phiLowerLimit[0] | X04 }}", 2 => X"{{ orm_obj.phiLowerLimit[1] | X04 }}", others => X"0000"),
  {%- endif %}
  {%- if orm_obj.isolation %}
        iso_lut_obj2 => X"{{ orm_obj.isolation.value | X01 }}",
  {%- endif %}
