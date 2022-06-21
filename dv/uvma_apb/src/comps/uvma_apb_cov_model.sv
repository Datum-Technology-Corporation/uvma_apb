// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_COV_MODEL_SV__
`define __UVMA_APB_COV_MODEL_SV__


/**
 * Component encapsulating AMBA Advanced Peripheral Bus functional coverage model.
 */
class uvma_apb_cov_model_c extends uvm_component;

   // Objects
   uvma_apb_cfg_c            cfg;
   uvma_apb_cntxt_c          cntxt;
   uvma_apb_mon_trn_c        mon_trn;
   uvma_apb_mstr_seq_item_c  mstr_seq_item;
   uvma_apb_slv_seq_item_c   slv_seq_item;

   // TLM
   uvm_tlm_analysis_fifo#(uvma_apb_mon_trn_c      )  mon_trn_fifo      ;
   uvm_tlm_analysis_fifo#(uvma_apb_mstr_seq_item_c)  mstr_seq_item_fifo;
   uvm_tlm_analysis_fifo#(uvma_apb_slv_seq_item_c )  slv_seq_item_fifo ;


   `uvm_component_utils_begin(uvma_apb_cov_model_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   // TODO Add covergroup(s) to uvma_apb_cov_model_c
   //      Ex: covergroup apb_cfg_cg;
   //             abc_cp : coverpoint cfg.abc;
   //             xyz_cp : coverpoint cfg.xyz;
   //          endgroup : apb_cfg_cg
   //
   //          covergroup apb_cntxt_cg;
   //             abc_cp : coverpoint cntxt.abc;
   //             xyz_cp : coverpoint cntxt.xyz;
   //          endgroup : apb_cntxt_cg
   //
   //          covergroup apb_mon_trn_cg;
   //             address_cp : coverpoint mon_trn.address {
   //                bins low   = {16'h0000_0000, 16'h4FFF_FFFF};
   //                bins med   = {16'h5000_0000, 16'h9FFF_FFFF};
   //                bins high  = {16'hA000_0000, 16'hFFFF_FFFF};
   //             }
   //          endgroup : apb_mon_trn_cg
   //
   //          covergroup apb_mstr_seq_item_cg;
   //             address_cp : coverpoint mstr_seq_item.address {
   //                bins low   = {16'h0000_0000, 16'h5FFF_FFFF};
   //                bins med   = {16'h6000_0000, 16'hAFFF_FFFF};
   //                bins high  = {16'hB000_0000, 16'hFFFF_FFFF};
   //             }
   //          endgroup : apb_mstr_seq_item_trn_cg
   //
   //          covergroup apb_slv_seq_item_cg;
   //             address_cp : coverpoint slv_seq_item.address {
   //                bins low   = {16'h0000_0000, 16'h5FFF_FFFF};
   //                bins med   = {16'h6000_0000, 16'hAFFF_FFFF};
   //                bins high  = {16'hB000_0000, 16'hFFFF_FFFF};
   //             }
   //          endgroup : apb_slv_seq_item_trn_cg


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_cov_model", uvm_component parent=null);

   /**
    * 1. Ensures cfg & cntxt handles are not null.
    * 2. Builds fifos.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Forks all sampling loops
    */
   extern virtual task run_phase(uvm_phase phase);

   /**
    * TODO Describe uvma_apb_cov_model_c::sample_cfg()
    */
   extern function void sample_cfg();

   /**
    * TODO Describe uvma_apb_cov_model_c::sample_cntxt()
    */
   extern function void sample_cntxt();

   /**
    * TODO Describe uvma_apb_cov_model_c::sample_mon_trn()
    */
   extern function void sample_mon_trn();

   /**
    * TODO Describe uvma_apb_cov_model_c::sample_mstr_seq_item()
    */
   extern function void sample_mstr_seq_item();

   /**
    * TODO Describe uvma_apb_cov_model_c::sample_slv_seq_item()
    */
   extern function void sample_slv_seq_item();

endclass : uvma_apb_cov_model_c


function uvma_apb_cov_model_c::new(string name="uvma_apb_cov_model", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_apb_cov_model_c::build_phase(uvm_phase phase);

   super.build_phase(phase);

   void'(uvm_config_db#(uvma_apb_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end

   void'(uvm_config_db#(uvma_apb_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (!cntxt) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end

   mon_trn_fifo       = new("mon_trn_fifo"      , this);
   mstr_seq_item_fifo = new("mstr_seq_item_fifo", this);
   slv_seq_item_fifo  = new("slv_seq_item_fifo" , this);

endfunction : build_phase


task uvma_apb_cov_model_c::run_phase(uvm_phase phase);

   super.run_phase(phase);

   if (cfg.enabled && cfg.cov_model_enabled) begin
      fork
         // Configuration
         forever begin
            cntxt.sample_cfg_e.wait_trigger();
            sample_cfg();
         end

         // Context
         forever begin
            cntxt.sample_cntxt_e.wait_trigger();
            sample_cntxt();
         end

         // Monitor transactions
         forever begin
            mon_trn_fifo.get(mon_trn);
            sample_mon_trn();
         end

         // 'mstr' sequence items
         forever begin
            mstr_seq_item_fifo.get(mstr_seq_item);
            sample_mstr_seq_item();
         end

         // 'slv' sequence items
         forever begin
            slv_seq_item_fifo.get(slv_seq_item);
            sample_slv_seq_item();
         end
      join_none
   end

endtask : run_phase


function void uvma_apb_cov_model_c::sample_cfg();

   // TODO Implement uvma_apb_cov_model_c::sample_cfg();

endfunction : sample_cfg


function void uvma_apb_cov_model_c::sample_cntxt();

   // TODO Implement uvma_apb_cov_model_c::sample_cntxt();

endfunction : sample_cntxt


function void uvma_apb_cov_model_c::sample_mon_trn();

   // TODO Implement uvma_apb_cov_model_c::sample_mon_trn();

endfunction : sample_mon_trn


function void uvma_apb_cov_model_c::sample_mstr_seq_item();

   // TODO Implement uvma_apb_cov_model_c::sample_mstr_seq_item();

endfunction : sample_mstr_seq_item


function void uvma_apb_cov_model_c::sample_slv_seq_item();

   // TODO Implement uvma_apb_cov_model_c::sample_slv_seq_item();

endfunction : sample_slv_seq_item


`endif // __UVMA_APB_COV_MODEL_SV__
