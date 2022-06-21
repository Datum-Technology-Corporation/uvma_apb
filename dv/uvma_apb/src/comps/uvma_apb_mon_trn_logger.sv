// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
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
         UVMA_APB_ACCESS_READ : access_type = "READ  ";
         UVMA_APB_ACCESS_WRITE: access_type = "WRITE ";
      endcase
      fwrite($sformatf(" %t |    %b    |    %b    | %s | %h | %h ", $realtime(), t.slv_sel, t.slv_err, access_type, t.address, t.data));

   endfunction : write

   /**
    * Writes log header to disk
    */
   virtual function void print_header();

      fwrite("-------------------------------------------------------------");
      fwrite("        TIME        | SLV_SEL | SLV_ERR | ACCESS | ADDRESS  | DATA ");
      fwrite("-------------------------------------------------------------");

   endfunction : print_header

endclass : uvma_apb_mon_trn_logger_c


`endif // __UVMA_APB_MON_TRN_LOGGER_SV__
