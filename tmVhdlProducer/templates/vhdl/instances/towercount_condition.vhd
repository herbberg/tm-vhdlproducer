{% extends "instances/base/condition.vhd" %}

{% set o = condition.objects[0] %}

{% block entity %}work.towercount_condition{% endblock entity %}

{% block generic_map %}
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator | vhdl_bool }},
    {%- endif %}
        count_threshold => X"{{ o.count.threshold | X04 }}"
{%- endblock %}

{% block port_map %}
        {{ o.type | lower }}({{ o.bx_arr }}),
{%- endblock %}
