// Copyright 2021 Datum Technology Corporation
// 
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.


`ifndef __UVMA_APB_MSTR_SEQ_ITEM_SV__
`define __UVMA_APB_MSTR_SEQ_ITEM_SV__


/**
 * Object created by AMBA Advanced Peripheral Bus agent sequences extending uvma_apb_seq_base_c.
 */
class uvma_apb_mstr_seq_item_c extends uvma_apb_base_seq_item_c;
   
   // Data
   rand uvma_apb_access_type_enum             access_type;
   rand bit [(`UVMA_APB_PADDR_MAX_SIZE-1):0]  address    ;
   rand bit [(`UVMA_APB_DATA_MAX_SIZE -1):0]  wdata      ;
        bit [(`UVMA_APB_DATA_MAX_SIZE -1):0]  rdata      ;
   rand bit [(`UVMA_APB_PSEL_MAX_SIZE -1):0]  slv_sel    ;
   
   
   `uvm_object_utils_begin(uvma_apb_mstr_seq_item_c)
      `uvm_field_enum(uvma_apb_access_type_enum, access_type, UVM_DEFAULT          )
      `uvm_field_int (                           address    , UVM_DEFAULT          )
      `uvm_field_int (                           wdata      , UVM_DEFAULT          )
      `uvm_field_int (                           rdata      , UVM_DEFAULT          )
      `uvm_field_int (                           slv_sel    , UVM_DEFAULT + UVM_BIN)
   `uvm_object_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_mstr_seq_item");
   
endclass : uvma_apb_mstr_seq_item_c


function uvma_apb_mstr_seq_item_c::new(string name="uvma_apb_mstr_seq_item");
   
   super.new(name);
   
endfunction : new


`endif // __UVMA_APB_MSTR_SEQ_ITEM_SV__
