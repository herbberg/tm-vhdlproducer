-- Description:
-- Mapping of algo indexes for ROP

-- ========================================================
-- from VHDL producer:
      
-- Unique ID of L1 Trigger Menu:
-- X"{{menu.info.uuid_hex}}"
    
-- Name of L1 Trigger Menu:
-- {{menu.info.name}}
    
-- Scale set:
-- {{menu.info.scale_set}}
    
-- VHDL producer version
-- v{{menu.info.sw_version_major}}.{{menu.info.sw_version_minor}}.{{menu.info.sw_version_patch}}

-- ========================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.ALL;
use work.gt_mp7_core_pkg.all;

entity algo_mapping_rop is
    port(
        lhc_clk : in std_logic;
-- HB 2016-03-02: inserted with fdl version (v0.0.21) for global index. Types definition in gtl_pkg.
	algo_bx_masks_global :  in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
	algo_bx_masks_local :  out std_logic_vector(NR_ALGOS-1 downto 0);
	rate_cnt_before_prescaler_local :  in rate_counter_array;
	rate_cnt_before_prescaler_global :  out rate_counter_global_array; -- to be defined in gt_mp7_core_pkg
	prescale_factor_global :  in prescale_factor_global_array; -- to be defined in gt_mp7_core_pkg
	prescale_factor_local :  out prescale_factor_array;
	rate_cnt_after_prescaler_local :  in rate_counter_array;
	rate_cnt_after_prescaler_global :  out rate_counter_global_array; -- to be defined in gt_mp7_core_pkg
	rate_cnt_post_dead_time_local :  in rate_counter_array;
	rate_cnt_post_dead_time_global :  out rate_counter_global_array; -- to be defined in gt_mp7_core_pkg
	finor_masks_global :  in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
	finor_masks_local :  out std_logic_vector(NR_ALGOS-1 downto 0);
	veto_masks_global :  in std_logic_vector(MAX_NR_ALGOS-1 downto 0);
	veto_masks_local :  out std_logic_vector(NR_ALGOS-1 downto 0);
        algo_before_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_finor_mask : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_before_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0)
    );
end algo_mapping_rop;

architecture rtl of algo_mapping_rop is
    type global_index_array is array (0 to NR_ALGOS-1) of integer;

-- HB 2016-03-02: inserted for global index
    constant global_index: global_index_array := (
-- ==== Inserted by TME - begin
{% for algoName in menu.reporter['index_sorted'] %}
  {%- set algorithm = menu.reporter['algoDict'][algoName] %}
  {%- if algorithm.index in menu.reporter['m2a'][iMod].values() -%}
    {{algorithm.index}}, {% if loop.index0 % 20 == 19 %}
    {% endif %}
  {%- endif %}
{%- endfor %}
-- ==== Inserted by TME - end
	others => 0
    );	    

-- HB 2016-03-02: inserted for global index
    signal rate_cnt_before_prescaler_global_int: rate_counter_global_array := (others => (others => '0'));
    signal rate_cnt_after_prescaler_global_int: rate_counter_global_array := (others => (others => '0'));
    signal rate_cnt_post_dead_time_global_int: rate_counter_global_array := (others => (others => '0'));

    signal algo_before_prescaler_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_after_prescaler_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '0');
    signal algo_after_finor_mask_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0) := (others => '0');

begin

nr_algos_l: for i in 0 to NR_ALGOS-1 generate
-- HB 2016-03-02: inserted for global index
    algo_bx_masks_local(i) <= algo_bx_masks_global(global_index(i));
    rate_cnt_before_prescaler_global_int(global_index(i)) <= rate_cnt_before_prescaler_local(i);
    prescale_factor_local(i) <= prescale_factor_global(global_index(i));
    rate_cnt_after_prescaler_global_int(global_index(i)) <= rate_cnt_after_prescaler_local(i);
    rate_cnt_post_dead_time_global_int(global_index(i)) <= rate_cnt_post_dead_time_local(i);
    finor_masks_local(i) <= finor_masks_global(global_index(i));
    veto_masks_local(i) <= veto_masks_global(global_index(i));
    algo_before_prescaler_rop_int(global_index(i)) <= algo_before_prescaler(i);
    algo_after_prescaler_rop_int(global_index(i)) <= algo_after_prescaler(i);
    algo_after_finor_mask_rop_int(global_index(i)) <= algo_after_finor_mask(i);
end generate;

-- HB 2016-03-02: inserted for global index
rate_cnt_before_prescaler_global <= rate_cnt_before_prescaler_global_int;
rate_cnt_after_prescaler_global <= rate_cnt_after_prescaler_global_int;
rate_cnt_post_dead_time_global <= rate_cnt_post_dead_time_global_int;

algo_2_rop_p: process(lhc_clk, algo_before_prescaler_rop_int, algo_after_prescaler_rop_int, algo_after_finor_mask_rop_int)
    begin
    if lhc_clk'event and lhc_clk = '1' then
        algo_before_prescaler_rop <= algo_before_prescaler_rop_int;
        algo_after_prescaler_rop <= algo_after_prescaler_rop_int;
        algo_after_finor_mask_rop <= algo_after_finor_mask_rop_int;
    end if;
end process;

end architecture rtl;
