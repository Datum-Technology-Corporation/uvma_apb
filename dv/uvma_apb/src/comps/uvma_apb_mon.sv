// Copyright 2021 Datum Technology Corporation
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_MON_SV__
`define __UVMA_APB_MON_SV__


/**
 * Component sampling transactions from a AMBA Advanced Peripheral Bus virtual interface
 * (uvma_apb_if).
 */
class uvma_apb_mon_c extends uvml_mon_c;
   
   //virtual uvma_apb_if.passive_mp  mp; ///< 
   
   // Objects
   uvma_apb_cfg_c    cfg;
   uvma_apb_cntxt_c  cntxt;
   
   // TLM
   uvm_analysis_port#(uvma_apb_mon_trn_c)  ap;
   uvm_analysis_port#(uvma_apb_mon_trn_c)  drv_rsp_ap;
   
   
   
   
   `uvm_component_utils_begin(uvma_apb_mon_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_mon", uvm_component parent=null);
   
   /**
    * 1. Ensures cfg & cntxt handles are not null.
    * 2. Builds ap.
    */
   extern virtual function void build_phase(uvm_phase phase);
   
   /**
    * Oversees monitoring, depending on the reset state, by calling mon_<pre|in|post>_reset() tasks.
    */
   extern virtual task run_phase(uvm_phase phase);
   
   /**
    * Updates the context's reset state.
    */
   extern task observe_reset();
   
   /**
    * Called by run_phase() while agent is in pre-reset state.
    */
   extern task mon_pre_reset(uvm_phase phase);
   
   /**
    * Called by run_phase() while agent is in reset state.
    */
   extern task mon_in_reset(uvm_phase phase);
   
   /**
    * Called by run_phase() while agent is in post-reset state.
    */
   extern task mon_post_reset(uvm_phase phase);
   
   /**
    * TODO Describe uvma_apb_mon_c::mon_bus()
    */
   extern task mon_bus(output uvma_apb_mon_trn_c trn);
   
   /**
    * TODO Describe uvma_apb_mon_c::process_trn()
    */
   extern function void process_trn(uvma_apb_mon_trn_c trn);
   
endclass : uvma_apb_mon_c


function uvma_apb_mon_c::new(string name="uvma_apb_mon", uvm_component parent=null);
   
   super.new(name, parent);
   
endfunction : new


function void uvma_apb_mon_c::build_phase(uvm_phase phase);
   
   super.build_phase(phase);
   
   void'(uvm_config_db#(uvma_apb_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end
   
   void'(uvm_config_db#(uvma_apb_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (!cntxt) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end
   
   //mp = cntxt.vif.passive_mp;
   
   ap         = new("ap"        , this);
   drv_rsp_ap = new("drv_rsp_ap", this);
  
endfunction : build_phase


task uvma_apb_mon_c::run_phase(uvm_phase phase);
   
   super.run_phase(phase);
   
   if (cfg.enabled) begin
      fork
         observe_reset();
         
         begin
            forever begin
               case (cntxt.reset_state)
                  UVMA_APB_RESET_STATE_PRE_RESET : mon_pre_reset (phase);
                  UVMA_APB_RESET_STATE_IN_RESET  : mon_in_reset  (phase);
                  UVMA_APB_RESET_STATE_POST_RESET: mon_post_reset(phase);
               endcase
            end
         end
      join_none
   end
   
endtask : run_phase


task uvma_apb_mon_c::observe_reset();
   
   forever begin
      wait (cntxt.vif.reset_n === 0);
      cntxt.reset_state = UVMA_APB_RESET_STATE_IN_RESET;
      wait (cntxt.vif.reset_n === 1);
      cntxt.reset_state = UVMA_APB_RESET_STATE_POST_RESET;
   end
   
endtask : observe_reset


task uvma_apb_mon_c::mon_pre_reset(uvm_phase phase);
   
   @(cntxt.vif.mon_cb); //@(mp.mon_cb);
   
endtask : mon_pre_reset


task uvma_apb_mon_c::mon_in_reset(uvm_phase phase);
   
   @(cntxt.vif.mon_cb); //@(mp.mon_cb);
   
endtask : mon_in_reset


task uvma_apb_mon_c::mon_post_reset(uvm_phase phase);
   
   uvma_apb_mon_trn_c  trn;
   
   mon_bus(trn);
   process_trn(trn);
   ap.write   (trn);
   `uvml_hrtbt()
   
endtask : mon_post_reset


task uvma_apb_mon_c::mon_bus(output uvma_apb_mon_trn_c trn);
   
   do begin
      @(cntxt.vif.mon_cb);
   end while ((cntxt.vif.mon_cb.penable !== 1'b1) || (cntxt.vif.mon_cb.psel[0] !== 1'b1));
   
   trn = uvma_apb_mon_trn_c::type_id::create("trn");
   trn.set_initiator(this);
   trn.set_timestamp_start($realtime());
   
   if (cntxt.vif.mon_cb.pwrite === 1'b1) begin
      trn.access_type = UVMA_APB_ACCESS_WRITE;
      //for (int unsigned ii=0; ii<cfg.data_bus_width; ii++) begin
         trn.data/*[ii]*/ = cntxt.vif.mon_cb.pwdata/*[ii]*/;
      //end
   end
   else if (cntxt.vif.mon_cb.pwrite === 1'b0) begin 
      trn.access_type = UVMA_APB_ACCESS_READ;
   end
   else begin
      `uvm_error("APB_MON", $sformatf("Invalid pwrite value: %h", cntxt.vif.mon_cb.pwrite))
      //`uvm_error("APB_MON", $sformatf("Invalid pwrite value: %h", mp.mon_cb.pwrite))
   end
   
   //for (int unsigned ii=0; ii<cfg.addr_bus_width; ii++) begin
      trn.address/*[ii]*/ = cntxt.vif.mon_cb.paddr/*[ii]*/;
   //end
   //for (int unsigned ii=0; ii<cfg.sel_width; ii++) begin
    //  trn.slv_sel/*[ii]*/ = cntxt.vif.mon_cb.psel/*[ii]*/;
   //end
   
   do begin
      @(cntxt.vif.mon_cb);
   end while ((cntxt.vif.mon_cb.penable !== 1'b1) || (cntxt.vif.mon_cb.pready !== 1'b1));
   
   if (trn.access_type === UVMA_APB_ACCESS_READ) begin 
      trn.data = cntxt.vif.mon_cb.prdata;
   end
   trn.slv_err = cntxt.vif.mon_cb.pslverr;
   trn.set_error(trn.slv_err);
   trn.set_timestamp_end($realtime());
   
endtask : mon_bus


function void uvma_apb_mon_c::process_trn(uvma_apb_mon_trn_c trn);
   
   // TODO Implement uvma_apb_mon_c::process_trn()
   
endfunction : process_trn


`endif // __UVMA_APB_MON_SV__
