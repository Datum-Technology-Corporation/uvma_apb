// Copyright 2021 Datum Technology Corporation
// 
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
// Licensed under the Solderpad Hardware License v 2.1 (the "License"); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0.  You may obtain a copy of the License at
//                                        https://solderpad.org/licenses/SHL-2.1/
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.


`ifndef __UVMT_APB_ST_DUT_WRAP_SV__
`define __UVMT_APB_ST_DUT_WRAP_SV__


/**
 * Module wrapper for Advanced Peripheral Bus RTL DUT. All ports are SV interfaces.
 */
module uvmt_apb_st_dut_wrap(
   uvma_apb_if  mstr_if,
   uvma_apb_if  slv_if
);
   
   assign slv_if.paddr   = mstr_if.paddr  ;
   assign slv_if.psel    = mstr_if.psel   ;
   assign slv_if.penable = mstr_if.penable;
   assign slv_if.pwrite  = mstr_if.pwrite ;
   assign slv_if.pwdata  = mstr_if.pwdata ;
   
   assign mstr_if.pready  = slv_if.pready ;
   assign mstr_if.prdata  = slv_if.prdata ;
   assign mstr_if.pslverr = slv_if.pslverr;
   
endmodule : uvmt_apb_st_dut_wrap


`endif // __UVMT_APB_ST_DUT_WRAP_SV__
