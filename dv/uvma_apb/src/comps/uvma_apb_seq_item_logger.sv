// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_SEQ_ITEM_LOGGER_SV__
`define __UVMA_APB_SEQ_ITEM_LOGGER_SV__


/**
 * Component writing AMBA Advanced Peripheral Bus sequence items debug data to disk as plain text.
 */
class uvma_apb_seq_item_logger_c extends uvml_logs_seq_item_logger_c#(
   .T_TRN  (uvma_apb_base_seq_item_c),
   .T_CFG  (uvma_apb_cfg_c          ),
   .T_CNTXT(uvma_apb_cntxt_c        )
);

   `uvm_component_utils(uvma_apb_seq_item_logger_c)


   /**
    * Default constructor.
    */
   function new(string name="uvma_apb_seq_item_logger", uvm_component parent=null);
      super.new(name, parent);
   endfunction : new

   /**
    * Writes contents of t to disk.
    */
   virtual function void write(uvma_apb_base_seq_item_c t);

      uvma_apb_mstr_seq_item_c  t_mstr;
      uvma_apb_slv_seq_item_c   t_slv ;

      string access_type;
      string data;

      if (cfg.drv_mode == UVMA_APB_MODE_MSTR) begin
         if (!$cast(t_mstr, t)) begin
            `uvm_fatal("APB_SEQ_ITEM_LOGGER", $sformatf("Could not cast 't' (%s) to 't_mstr' (%s)", $typename(t), $typename(t_mstr)))
         end
         case (t_mstr.access_type)
            UVMA_APB_ACCESS_READ : access_type = "READ  ";
            UVMA_APB_ACCESS_WRITE: access_type = "WRITE ";
         endcase
         if (t_mstr.access_type == UVMA_APB_ACCESS_WRITE) begin
            data = $sformatf("%h", t_mstr.wdata);
         end
         else begin
            data = $sformatf("%h", t_mstr.rdata);
         end
         fwrite($sformatf(" %t |    %b    | %s | %h  | %s ", $realtime(), t_mstr.slv_sel, access_type, t_mstr.address, data));
      end
      else begin
         if (!$cast(t_slv, t)) begin
            `uvm_fatal("APB_SEQ_ITEM_LOGGER", $sformatf("Could not cast 't' (%s) to 't_slv' (%s)", $typename(t), $typename(t_slv)))
         end
         data = $sformatf("%h", t_slv.rdata);
         fwrite($sformatf(" %t |    %b    | %h", $realtime(), t_slv.slverr, t_slv.rdata));
      end

   endfunction : write

   /**
    * Writes log header to disk.
    */
   virtual function void print_header();

      if (cfg.drv_mode == UVMA_APB_MODE_MSTR) begin
         fwrite("--------------------------------------------------");
         fwrite("        TIME        | SLV_SEL | ACCESS | ADDRESS  | DATA ");
         fwrite("--------------------------------------------------");
      end
      else begin
         fwrite("-------------------------------");
         fwrite("        TIME        | SLV_ERR | RDATA ");
         fwrite("-------------------------------");
      end

   endfunction : print_header

endclass : uvma_apb_seq_item_logger_c


`endif // __UVMA_APB_SEQ_ITEM_LOGGER_SV__
