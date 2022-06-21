// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_CFG_SV__
`define __UVMA_APB_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running all
 * AMBA Advanced Peripheral Bus agent (uvma_apb_agent_c) components.
 */
class uvma_apb_cfg_c extends uvml_cfg_c;

   // Generic options
   rand bit                      enabled;
   rand uvm_active_passive_enum  is_active;
   rand uvm_sequencer_arb_mode   sqr_arb_mode;
   rand bit                      cov_model_enabled;
   rand bit                      trn_log_enabled;

   // Protocol parameters
   rand uvma_apb_mode_enum      drv_mode;
   rand int unsigned            addr_bus_width ; // Measured in bytes (B)
   rand int unsigned            data_bus_width ; // Measured in bytes (B)
   rand int unsigned            sel_width      ; // Measured in bits  (b)
   rand uvma_apb_drv_idle_enum  drv_idle       ;
   rand int unsigned            mon_slv_list[$];


   `uvm_object_utils_begin(uvma_apb_cfg_c)
      `uvm_field_int (                         enabled          , UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active        , UVM_DEFAULT)
      `uvm_field_enum(uvm_sequencer_arb_mode , sqr_arb_mode     , UVM_DEFAULT)
      `uvm_field_int (                         cov_model_enabled, UVM_DEFAULT)
      `uvm_field_int (                         trn_log_enabled  , UVM_DEFAULT)

      `uvm_field_enum     (uvma_apb_mode_enum    , drv_mode      , UVM_DEFAULT          )
      `uvm_field_int      (                        addr_bus_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int      (                        data_bus_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int      (                        sel_width     , UVM_DEFAULT + UVM_DEC)
      `uvm_field_enum     (uvma_apb_drv_idle_enum, drv_idle      , UVM_DEFAULT          )
      `uvm_field_queue_int(                        mon_slv_list  , UVM_DEFAULT          )
   `uvm_object_utils_end


   constraint defaults_cons {
      soft enabled           == 1;
      soft is_active         == UVM_PASSIVE;
      soft sqr_arb_mode      == UVM_SEQ_ARB_FIFO;
      soft cov_model_enabled == 0;
      soft trn_log_enabled   == 1;

      soft drv_mode        == UVMA_APB_MODE_MSTR;
      soft addr_bus_width  == uvma_apb_default_paddr_width;
      soft data_bus_width  == uvma_apb_default_data_width ;
      soft sel_width       == uvma_apb_default_psel_width ;
      soft drv_idle        == UVMA_APB_DRV_IDLE_ZEROS;
      soft mon_slv_list[0] == 1;
   }

   /*constraint limits_cons {
      //unique {mon_slv_list};
      foreach (mon_slv_list[ii]) {
         foreach (mon_slv_list[jj]) {
            if (ii != jj) {
               mon_slv_list[ii] != mon_slv_list[jj];
            }
         }
      }
   }*/


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_cfg");

endclass : uvma_apb_cfg_c


function uvma_apb_cfg_c::new(string name="uvma_apb_cfg");

   super.new(name);

endfunction : new


`endif // __UVMA_APB_CFG_SV__
