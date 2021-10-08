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


`ifndef __UVMA_APB_BASE_SEQ_SV__
`define __UVMA_APB_BASE_SEQ_SV__


/**
 * Abstract object from which all other AMBA Advanced Peripheral Bus agent
 * sequences must extend. Subclasses must be run on AMBA Advanced Peripheral Bus
 * sequencer (uvma_apb_sqr_c) instance.
 */
class uvma_apb_base_seq_c extends uvm_sequence#(
   .REQ(uvma_apb_base_seq_item_c),
   .RSP(uvma_apb_mon_trn_c      )
);
   
   // Agent handles
   uvma_apb_cfg_c    cfg;
   uvma_apb_cntxt_c  cntxt;
   
   
   `uvm_object_utils(uvma_apb_base_seq_c)
   `uvm_declare_p_sequencer(uvma_apb_sqr_c)
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_base_seq");
   
   /**
    * Assigns cfg and cntxt handles from p_sequencer.
    */
   extern virtual task pre_start();
   
endclass : uvma_apb_base_seq_c


function uvma_apb_base_seq_c::new(string name="uvma_apb_base_seq");
   
   super.new(name);
   
endfunction : new


task uvma_apb_base_seq_c::pre_start();
   
   cfg   = p_sequencer.cfg;
   cntxt = p_sequencer.cntxt;
   
endtask : pre_start


`endif // __UVMA_APB_BASE_SEQ_SV__
