type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{min}} to {{max}};

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
{{lut}}
);
