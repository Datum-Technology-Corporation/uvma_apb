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


`ifndef __UVMT_APB_ST_READS_TEST_SV__
`define __UVMT_APB_ST_READS_TEST_SV__


/**
 * TODO Describe uvmt_apb_st_reads_test_c
 */
class uvmt_apb_st_reads_test_c extends uvmt_apb_st_base_test_c;
   
   rand uvme_apb_st_reads_vseq_c  reads_vseq;
   
   
   `uvm_component_utils(uvmt_apb_st_reads_test_c)
   
   /**
    * Creates reads_vseq.
    */
   extern function new(string name="uvmt_apb_st_reads_test", uvm_component parent=null);
   
   /**
    * Runs reads_vseq on vsequencer.
    */
   extern virtual task main_phase(uvm_phase phase);
   
endclass : uvmt_apb_st_reads_test_c


function uvmt_apb_st_reads_test_c::new(string name="uvmt_apb_st_reads_test", uvm_component parent=null);
   
   super.new(name, parent);
   
   reads_vseq = uvme_apb_st_reads_vseq_c::type_id::create("reads_vseq");
   
endfunction : new


task uvmt_apb_st_reads_test_c::main_phase(uvm_phase phase);
   
   super.main_phase(phase);
   
   phase.raise_objection(this);
   `uvm_info("TEST", $sformatf("Starting reads virtual sequence:\n%s", reads_vseq.sprint()), UVM_NONE)
   reads_vseq.start(vsequencer);
   `uvm_info("TEST", $sformatf("Finished reads virtual sequence:\n%s", reads_vseq.sprint()), UVM_NONE)
   phase.drop_objection(this);
   
endtask : main_phase


`endif // __UVMT_APB_ST_READS_TEST_SV__
