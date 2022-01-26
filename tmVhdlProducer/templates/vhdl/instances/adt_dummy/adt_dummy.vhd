{%- set adt_0_ext_cond_id = 250 %}
{%- set adt_1_ext_cond_id = 251 %}
{%- set adt_2_ext_cond_id = 252 %}
{%- set adt_3_ext_cond_id = 253 %}
{%- set adt_4_ext_cond_id = 254 %}
{%- set adt_5_ext_cond_id = 255 %}
{%- if condition.objects[0].externalChannelId == adt_0_ext_cond_id %}
cond_adt_0_i: entity work.adt_0_dummy
{%- elif condition.objects[0].externalChannelId == adt_1_ext_cond_id %}
cond_adt_1_i: entity work.adt_1_dummy
{%- elif condition.objects[0].externalChannelId == adt_2_ext_cond_id %}
cond_adt_2_i: entity work.adt_2_dummy
{%- elif condition.objects[0].externalChannelId == adt_3_ext_cond_id %}
cond_adt_3_i: entity work.adt_3_dummy
{%- elif condition.objects[0].externalChannelId == adt_4_ext_cond_id %}
cond_adt_4_i: entity work.adt_4_dummy
{%- elif condition.objects[0].externalChannelId == adt_5_ext_cond_id %}
cond_adt_5_i: entity work.adt_5_dummy
{%- endif %}
    port map(
        lhc_clk,
--         clk240: in std_logic;
        bx_data.mu,
        bx_data.eg,
        bx_data.jet,
        bx_data.tau,
        bx_data.ett,
        bx_data.htt,
        bx_data.etm,
        bx_data.htm,
        bx_data.ettem,
        bx_data.etmhf,
        {{ condition.vhdl_signal }}
    );
