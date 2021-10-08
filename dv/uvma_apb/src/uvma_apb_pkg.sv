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


`ifndef __UVMA_APB_PKG_SV__
`define __UVMA_APB_PKG_SV__


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvml_macros.sv"
`include "uvml_logs_macros.sv"
`include "uvma_apb_macros.sv"

// Interfaces / Modules / Checkers
`include "uvma_apb_if.sv"
`ifdef UVMA_APB_INC_IF_CHKR
`include "uvma_apb_if_chkr.sv"
`endif


/**
 * Encapsulates all the types needed for an UVM agent capable of driving and/or monitoring AMBA Advanced Peripheral Bus.
 */
package uvma_apb_pkg;
   
   import uvm_pkg      ::*;
   import uvml_pkg     ::*;
   import uvml_logs_pkg::*;
   import uvml_ral_pkg ::*;
   
   // Constants / Structs / Enums
   `include "uvma_apb_tdefs.sv"
   `include "uvma_apb_constants.sv"
   
   // Objects
   `include "uvma_apb_cfg.sv"
   `include "uvma_apb_cntxt.sv"
   
   // High-level transactions
   `include "uvma_apb_mon_trn.sv"
   `include "uvma_apb_base_seq_item.sv"
   `include "uvma_apb_mstr_seq_item.sv"
   `include "uvma_apb_slv_seq_item.sv"
   
   // Agent components
   `include "uvma_apb_cov_model.sv"
   `include "uvma_apb_drv.sv"
   `include "uvma_apb_mon.sv"
   `include "uvma_apb_sqr.sv"
   `include "uvma_apb_mon_trn_logger.sv"
   `include "uvma_apb_seq_item_logger.sv"
   `include "uvma_apb_agent.sv"
   
   // Sequences
   `include "uvma_apb_seq_lib.sv"
   
   // Misc.
   `include "uvma_apb_reg_adapter.sv"
   
endpackage : uvma_apb_pkg


`endif // __UVMA_APB_PKG_SV__
