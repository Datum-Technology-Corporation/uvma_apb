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


`ifndef __UVMA_APB_STORAGE_SLV_SEQ_SV__
`define __UVMA_APB_STORAGE_SLV_SEQ_SV__


/**
 * 'slv' sequence that reads back '0' as data, unless the address has been
 * written to.
 */
class uvma_apb_storage_slv_seq_c extends uvma_apb_slv_base_seq_c;
   
   // Fields
   bit [(`UVMA_APB_DATA_MAX_SIZE-1):0]  mem[int unsigned];
   
   
   `uvm_object_utils_begin(uvma_apb_storage_slv_seq_c)
      //`uvm_field_aa_int_int_unsigned(mem, UVM_DEFAULT)
   `uvm_object_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_storage_slv_seq");
   
   /**
    * TODO Describe uvma_apb_storage_slv_seq_c::body()
    */
   extern virtual task body();
   
endclass : uvma_apb_storage_slv_seq_c


function uvma_apb_storage_slv_seq_c::new(string name="uvma_apb_storage_slv_seq");
   
   super.new(name);
   
endfunction : new


task uvma_apb_storage_slv_seq_c::body();
   
   bit [(`UVMA_APB_PADDR_MAX_SIZE-1):0]  addr = 0;
   uvma_apb_slv_seq_item_c               _req;
   
   forever begin
      while ((cntxt.vif.penable !== 1'b1) || (cntxt.vif.psel[0] !== 1'b1)) begin
         @(cntxt.vif.drv_slv_cb);
      end
      addr = cntxt.vif.drv_slv_cb.paddr;
      `uvm_info("APB_STORAGE_SEQ", $sformatf("Request from mstr: address (x%h) , write (%b), wdata (%h)", addr, cntxt.vif.drv_slv_cb.pwrite, cntxt.vif.pwdata), UVM_MEDIUM)
      case (cntxt.vif.drv_slv_cb.pwrite)
         1'b0 : begin
            if (mem.exists(addr)) begin
               `uvm_create(_req)
               _req.rdata = mem[addr];
               `uvm_send(_req)
            end
            else begin
               `uvm_create(_req)
               _req.rdata = 0;
               `uvm_send(_req)
            end
         end
         
         1'b1 : begin
            mem[addr] = cntxt.vif.pwdata;
            `uvm_do(_req)
         end
         
         default: `uvm_error("APB_STORAGE_SLV_SEQ", $sformatf("Invalid access_type (%0d):\n%s", rsp.access_type, rsp.sprint()))
      endcase
      
      
      while ((cntxt.vif.penable === 1'b1) && (cntxt.vif.psel[0] === 1'b1)) begin
         @(cntxt.vif.drv_slv_cb);
      end
   end
   
endtask : body


`endif // __UVMA_APB_STORAGE_SLV_SEQ_SV__
