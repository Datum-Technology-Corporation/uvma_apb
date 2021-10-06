// Copyright 2021 Datum Technology Corporation
// 
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.


`ifndef __UVMA_APB_MON_TRN_SV__
`define __UVMA_APB_MON_TRN_SV__


/**
 * Object rebuilt from the AMBA Advanced Peripheral Bus monitor Analog of
 * uvma_apb_base_seq_item_c.
 */
class uvma_apb_mon_trn_c extends uvml_trn_mon_trn_c;
   
   // Data
   uvma_apb_access_type_enum               access_type;
   logic [(`UVMA_APB_PADDR_MAX_SIZE-1):0]  address    ;
   logic [(`UVMA_APB_DATA_MAX_SIZE -1):0]  data       ;
   logic [(`UVMA_APB_PSEL_MAX_SIZE -1):0]  slv_sel    ;
   logic                                   slv_err    ;
   
   // Metadata
   int unsigned  addr_bus_width; // Measured in bytes (B)
   int unsigned  data_bus_width; // Measured in bytes (B)
   int unsigned  sel_width     ; // Measured in bits  (b)
   int unsigned  latency       ; // Measured in clock cycles
   
   
   `uvm_object_utils_begin(uvma_apb_mon_trn_c)
      `uvm_field_enum(uvma_apb_access_type_enum, access_type, UVM_DEFAULT          )
      `uvm_field_int (                           address    , UVM_DEFAULT          )
      `uvm_field_int (                           data       , UVM_DEFAULT          )
      `uvm_field_int (                           slv_sel    , UVM_DEFAULT + UVM_BIN)
      `uvm_field_int (                           slv_err    , UVM_DEFAULT + UVM_BIN)
   `uvm_object_utils_end
   
   
   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_mon_trn");
   
endclass : uvma_apb_mon_trn_c


function uvma_apb_mon_trn_c::new(string name="uvma_apb_mon_trn");
   
   super.new(name);
   
endfunction : new


`endif // __UVMA_APB_MON_TRN_SV__
