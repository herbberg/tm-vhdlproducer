constant PHI_MIN : real := {{phi_min}};
constant PHI_MAX : real := {{phi_max}};
constant ETA_MIN : real := {{eta_min}};
constant ETA_MAX : real := {{eta_max}};

constant MUON_ETA_STEP : real := {{mu_eta_step}};
constant CALO_PHI_BINS : positive := {{calo_phi_bins}};
constant MUON_PHI_BINS : positive := {{muon_phi_bins}};

-- MUON objects bits
constant MUON_PHI_BITS : natural := {{mu_phi_bits}};
constant MUON_PT_BITS : natural := {{mu_pt_bits}};
constant MUON_QUAL_BITS : natural := 4;
constant MUON_ETA_BITS : natural := {{mu_eta_bits}};
constant MUON_ISO_BITS : natural := 2;
constant MUON_CHARGE_BITS : natural := 2;
constant MUON_IDX_BITS : natural := 7;
constant MUON_PHI_RAW_BITS : natural := {{mu_phi_bits}};
constant MUON_UPT_BITS : natural := {{mu_upt_bits}};
constant MUON_IP_BITS : natural := 2;

-- EG objects bits
constant EG_ET_BITS : natural := {{eg_et_bits}};
constant EG_ETA_BITS : natural := {{eg_eta_bits}};
constant EG_PHI_BITS : natural := {{eg_phi_bits}};
constant EG_ISO_BITS : natural := 2;

-- JET objects bits
constant JET_ET_BITS : natural := {{jet_et_bits}};
constant JET_ETA_BITS : natural := {{jet_eta_bits}};
constant JET_PHI_BITS : natural := {{jet_phi_bits}};

-- TAU objects bits
constant TAU_ET_BITS : natural := {{tau_et_bits}};
constant TAU_ETA_BITS : natural := {{tau_eta_bits}};
constant TAU_PHI_BITS : natural := {{tau_phi_bits}};
constant TAU_ISO_BITS : natural := 2;

-- ESUM objects bits
constant ETT_ET_BITS : natural := {{ett_et_bits}};
constant HTT_ET_BITS : natural := {{htt_et_bits}};
constant ETM_ET_BITS : natural := {{etm_et_bits}};
constant ETM_PHI_BITS : natural := {{etm_phi_bits}};
constant HTM_ET_BITS : natural := {{htm_et_bits}};
constant HTM_PHI_BITS : natural := {{htm_phi_bits}};
constant ETTEM_ET_BITS : natural := {{ettem_et_bits}};
constant ETTEM_IN_ETT_LOW : natural := {{ettem_in_low}};
constant ETTEM_IN_ETT_HIGH : natural := {{ettem_in_low+ettem_et_bits-1}};
constant ETMHF_ET_BITS : natural := {{etmhf_et_bits}};
constant ETMHF_PHI_BITS : natural := {{etmhf_phi_bits}};
constant HTMHF_ET_BITS : natural := {{etmhf_et_bits}};
constant HTMHF_PHI_BITS : natural := {{etmhf_phi_bits}};

constant ASYMET_IN_ETM_LOW : natural := {{asym_in_low}};
constant ASYMET_IN_ETM_HIGH : natural := {{asym_in_low+asymet_bits-1}};
constant ASYMHT_IN_HTM_LOW : natural := {{asym_in_low}};
constant ASYMHT_IN_HTM_HIGH : natural := {{asym_in_low+asymht_bits-1}};
constant ASYMETHF_IN_ETMHF_LOW : natural := {{asym_in_low}};
constant ASYMETHF_IN_ETMHF_HIGH : natural := {{asym_in_low+asymethf_bits-1}};
constant ASYMHTHF_IN_HTMHF_LOW : natural := {{asym_in_low}};
constant ASYMHTHF_IN_HTMHF_HIGH : natural := {{asym_in_low+asymhthf_bits-1}};

constant ASYMET_LOW : natural := 0;
constant ASYMET_HIGH : natural := {{asymet_bits-1}};
constant ASYMHT_LOW : natural := 0;
constant ASYMHT_HIGH : natural := {{asymht_bits-1}};
constant ASYMETHF_LOW : natural := 0;
constant ASYMETHF_HIGH : natural := {{asymethf_bits-1}};
constant ASYMHTHF_LOW : natural := 0;
constant ASYMHTHF_HIGH : natural := {{asymhthf_bits-1}};

-- TOWERCOUNT
constant TOWERCOUNT_IN_HTT_LOW : natural := {{towercount_in_low}};
constant TOWERCOUNT_IN_HTT_HIGH : natural := {{towercount_in_low+towercount_bits-1}};
constant TOWERCOUNT_COUNT_LOW : natural := 0;
constant TOWERCOUNT_COUNT_HIGH : natural := {{towercount_bits-1}};

-- Hadronic shower trigger bits (muon shower [mus]) - preliminary definition
-- MUS0 => muon obj 0, bit 61
-- MUS1 => muon obj 2, bit 61
-- MUSOOT0 => muon obj 4, bit 61
-- MUSOOT1 => muon obj 6, bit 61
constant MUS_BIT : natural := 61;
constant NR_MUS_BITS: natural := 4;
constant MUON_OBJ_MUS0 : natural := 0;
constant MUON_OBJ_MUS1 : natural := 2;
constant MUON_OBJ_MUSOOT0 : natural := 4;
constant MUON_OBJ_MUSOOT1 : natural := 6;

-- MINIMUM BIAS TRIGGER objects
constant MBT0HFP_IN_ETT_LOW : natural := {{mb_in_low}};
constant MBT0HFP_IN_ETT_HIGH : natural := {{mb_in_low+mbt0hfp_bits-1}};
constant MBT0HFM_IN_HTT_LOW : natural := {{mb_in_low}};
constant MBT0HFM_IN_HTT_HIGH : natural := {{mb_in_low+mbt0hfm_bits-1}};
constant MBT1HFP_IN_ETM_LOW : natural := {{mb_in_low}};
constant MBT1HFP_IN_ETM_HIGH : natural := {{mb_in_low+mbt1hfp_bits-1}};
constant MBT1HFM_IN_HTM_LOW : natural := {{mb_in_low}};
constant MBT1HFM_IN_HTM_HIGH : natural := {{mb_in_low+mbt1hfm_bits-1}};

constant MBT0HFP_COUNT_LOW : natural := 0;
constant MBT0HFP_COUNT_HIGH : natural := {{mbt0hfp_bits-1}};
constant MBT0HFM_COUNT_LOW : natural := 0;
constant MBT0HFM_COUNT_HIGH : natural := {{mbt0hfm_bits-1}};
constant MBT1HFP_COUNT_LOW : natural := 0;
constant MBT1HFP_COUNT_HIGH : natural := {{mbt1hfp_bits-1}};
constant MBT1HFM_COUNT_LOW : natural := 0;
constant MBT1HFM_COUNT_HIGH : natural := {{mbt1hfm_bits-1}};

-- CENTRALITY
constant CENT_IN_ETMHF_LOW : natural := 28;
constant CENT_IN_ETMHF_HIGH : natural := 31;
constant CENT_IN_HTMHF_LOW : natural := 28;
constant CENT_IN_HTMHF_HIGH : natural := 31;

constant CENT_LBITS_LOW : natural := 0;
constant CENT_LBITS_HIGH: natural := 3;
constant CENT_UBITS_LOW : natural := 4;
constant CENT_UBITS_HIGH: natural := 7;

-- PRECISION
constant DETA_DPHI_PRECISION_ALL: positive := {{delta_prec}};
constant CALO_PT_PRECISION : positive := {{calo_pt_prec}};
constant MUON_PT_PRECISION : positive := {{muon_pt_prec}};
constant MUON_UPT_PRECISION : positive := {{muon_pt_prec}};
constant CALO_CALO_COSH_COS_PRECISION : positive := {{calo_calo_cosh_cos_prec}};
constant CALO_MUON_COSH_COS_PRECISION : positive := {{calo_muon_cosh_cos_prec}};
constant MUON_MUON_COSH_COS_PRECISION : positive := {{muon_muon_cosh_cos_prec}};
constant CALO_SIN_COS_PRECISION : positive := {{calo_sin_cos_prec}};
constant MUON_SIN_COS_PRECISION : positive := {{muon_sin_cos_prec}};

-- VECTOR_WIDTHs
constant CALO_CALO_COSH_COS_VECTOR_WIDTH: positive := log2c({{calo_calo_cosh_cos_vec_width}}); -- max. value cosh_deta-cos_dphi => [10597282-(-1000)] - highest value in LUT
constant MUON_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c({{muon_muon_cosh_cos_vec_width}}); -- max. value cosh_deta-cos_dphi => [667303-(-10000)]=677303 => 0xA55B7 - highest value in LUT
constant CALO_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c({{calo_muon_cosh_cos_vec_width}}); -- max. value cosh_deta-cos_dphi => [109487199-(-10000)] - highest value in LUT
constant CALO_SIN_COS_VECTOR_WIDTH: positive := log2c(2*{{calo_sin_cos_vec_width}}); -- max. value sin/cos(phi) => 1000. 2x max. value, because of sin/cos(phi1)xsin/cos(phi2) in tbpt formular
constant MUON_SIN_COS_VECTOR_WIDTH: positive := log2c(2*{{muon_sin_cos_vec_width}}); -- max. value sin/cos(phi) => 10000. 2x max. value, because of sin/cos(phi1)xsin/cos(phi2) in tbpt formular
