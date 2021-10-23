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


`ifndef __UVMA_APB_MON_TRN_LOGGER_SV__
`define __UVMA_APB_MON_TRN_LOGGER_SV__


/**
 * Component writing AMBA Advanced Peripheral Bus monitor transactions debug data to disk as plain text.
 */
class uvma_apb_mon_trn_logger_c extends uvml_logs_mon_trn_logger_c#(
   .T_TRN  (uvma_apb_mon_trn_c),
   .T_CFG  (uvma_apb_cfg_c    ),
   .T_CNTXT(uvma_apb_cntxt_c  )
);
   
   `uvm_component_utils(uvma_apb_mon_trn_logger_c)
   
   
   /**
    * Default constructor.
    */
   function new(string name="uvma_apb_mon_trn_logger", uvm_component parent=null);
      
      super.new(name, parent);
      
   endfunction : new
   
   /**
    * Writes contents of t to disk
    */
   virtual function void write(uvma_apb_mon_trn_c t);
      
      string access_type = "";
      string data;
      
      case (t.access_type)
         UVMA_APB_ACCESS_READ : access_type = "READ ";
         UVMA_APB_ACCESS_WRITE: access_type = "WRITE";
      endcase
      fwrite($sformatf(" %t | %s | %h | %b | %b | %h |", $realtime(), access_type, t.address, t.slv_sel, t.slv_err, t.data));
      
   endfunction : write
   
   /**
    * Writes log header to disk
    */
   virtual function void print_header();
      
      fwrite("---------------------------------------------------");
      fwrite("     TIME     |  ACC  | ADDRESS | SLV_SEL | SLV_ERR | DATA ");
      fwrite("---------------------------------------------------");
      
   endfunction : print_header
   
endclass : uvma_apb_mon_trn_logger_c


`endif // __UVMA_APB_MON_TRN_LOGGER_SV__
