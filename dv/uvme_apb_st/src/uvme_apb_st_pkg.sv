// Copyright 2021 Datum Technology Corporation
// 
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.


`ifndef __UVME_APB_ST_PKG_SV__
`define __UVME_APB_ST_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_macros.sv"
`include "uvml_logs_macros.sv"
`include "uvml_sb_macros.sv"
`include "uvma_apb_macros.sv"
`include "uvme_apb_st_macros.sv"


// Interface(s) / Module(s) / Checker(s)
`ifdef UVME_APB_ST_INC_CHKR
`include "uvme_apb_st_chkr.sv"
`endif


 /**
 * Encapsulates all the types needed for the Moore.io UVM environment capable of self-testing the Moore.io Advanced
 * Peripheral Bus (APB) UVM Agent.
 */
package uvme_apb_st_pkg;
   
   import uvm_pkg      ::*;
   import uvml_pkg     ::*;
   import uvml_logs_pkg::*;
   import uvml_sb_pkg  ::*;
   import uvma_apb_pkg ::*;
   
   // Constants / Structs / Enums
   `include "uvme_apb_st_tdefs.sv"
   `include "uvme_apb_st_constants.sv"
   
   // Objects
   `include "uvme_apb_st_cfg.sv"
   `include "uvme_apb_st_cntxt.sv"
   
   // Environment components
   `include "uvme_apb_st_cov_model.sv"
   `include "uvme_apb_st_prd.sv"
   `include "uvme_apb_st_vsqr.sv"
   `include "uvme_apb_st_env.sv"
   
   // Virtual sequences
   `include "uvme_apb_st_seq_lib.sv"
   
endpackage : uvme_apb_st_pkg


`endif // __UVME_APB_ST_PKG_SV__
