// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_IF_SV__
`define __UVMA_APB_IF_SV__


/**
 * Encapsulates all signals and clocking of AMBA Advanced Peripheral Bus interface. Used by
 * monitor (uvma_apb_mon_c) and driver (uvma_apb_drv_c).
 */
interface uvma_apb_if (
   input logic clk    ,
   input logic reset_n
);

   // 'mstr' signals
   wire [(`UVMA_APB_PADDR_MAX_SIZE-1):0]  paddr  ;
   wire [(`UVMA_APB_PSEL_MAX_SIZE -1):0]  psel   ;
   wire                                   penable;
   wire                                   pwrite ;
   wire [(`UVMA_APB_DATA_MAX_SIZE -1):0]  pwdata ;

   // 'slv' signals
   wire                                   pready ;
   wire [(`UVMA_APB_DATA_MAX_SIZE -1):0]  prdata ;
   wire                                   pslverr;


   /**
    * Used by DUT in 'mstr' mode.
    */
   clocking dut_mstr_cb @(posedge clk);
      input   pready ,
              prdata ,
              pslverr;
      output  paddr  ,
              psel   ,
              penable,
              pwrite ,
              pwdata ;
   endclocking : dut_mstr_cb

   /**
    * Used by DUT in 'slv' mode.
    */
   clocking dut_slv_cb @(posedge clk);
      output  pready ,
              prdata ,
              pslverr;
      input   paddr  ,
              psel   ,
              penable,
              pwrite ,
              pwdata ;
   endclocking : dut_slv_cb

   /**
    * Used by uvma_apb_drv_c.
    */
   clocking drv_mstr_cb @(posedge clk);
      output  paddr  ,
              psel   ,
              penable,
              pwrite ,
              pwdata ;
      input   pready ,
              prdata ,
              pslverr;
   endclocking : drv_mstr_cb

   /**
    * Used by uvma_apb_drv_c.
    */
   clocking drv_slv_cb @(posedge clk);
      output  pready ,
              prdata ,
              pslverr;
      input   paddr  ,
              psel   ,
              penable,
              pwrite ,
              pwdata ;
   endclocking : drv_slv_cb

   /**
    * Used by uvma_apb_mon_c.
    */
   clocking mon_cb @(posedge clk);
      input  paddr  ,
             psel   ,
             penable,
             pwrite ,
             pwdata ,
             pready ,
             prdata ,
             pslverr;
   endclocking : mon_cb


   modport dut_mstr_mp   (clocking dut_mstr_cb);
   modport dut_slv_mp    (clocking dut_slv_cb );
   modport active_mstr_mp(clocking drv_mstr_cb);
   modport active_slv_mp (clocking drv_slv_cb );
   modport passive_mp    (clocking mon_cb     );

endinterface : uvma_apb_if


`endif // __UVMA_APB_IF_SV__
