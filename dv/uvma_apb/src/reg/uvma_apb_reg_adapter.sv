// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_REG_ADAPTER_SV__
`define __UVMA_APB_REG_ADAPTER_SV__


/**
 * Object that converts between abstract register operations (UVM) and
 * Advanced Peripheral Bus operations.
 *
 * Must be overriden by user if there are more than one slave to be selected.
 */
class uvma_apb_reg_adapter_c extends uvml_ral_reg_adapter_c;

   `uvm_object_utils(uvma_apb_reg_adapter_c)


   /**
    * Default constructor
    */
   extern function new(string name="uvma_apb_reg_adapter");

   /**
    * Converts from UVM register operation to Advanced Peripheral Bus.
    */
   extern virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

   /**
    * Converts from Advanced Peripheral Bus to UVM register operation.
    */
   extern virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

   /**
    * Must be overriden by user if slv_sel is to be anything other than '1
    */
   extern function bit [(`UVMA_APB_PSEL_MAX_SIZE-1):0] map_addr_to_slv_sel([(`UVMA_APB_PADDR_MAX_SIZE-1):0] address);

endclass : uvma_apb_reg_adapter_c


function uvma_apb_reg_adapter_c::new(string name="uvma_apb_reg_adapter");

   super.new(name);

endfunction : new


function uvm_sequence_item uvma_apb_reg_adapter_c::reg2bus(const ref uvm_reg_bus_op rw);

   uvma_apb_mstr_seq_item_c  apb_trn = uvma_apb_mstr_seq_item_c::type_id::create("apb_trn");

   apb_trn.access_type = (rw.kind == UVM_READ) ? UVMA_APB_ACCESS_READ : UVMA_APB_ACCESS_WRITE;
   apb_trn.address     = rw.addr;
   apb_trn.slv_sel     = map_addr_to_slv_sel(apb_trn.address);

   if (rw.kind == UVM_WRITE) begin
      apb_trn.wdata = rw.data;
   end

   return apb_trn;

endfunction : reg2bus


function void uvma_apb_reg_adapter_c::bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

   uvma_apb_mstr_seq_item_c  apb_trn;

   if (!$cast(apb_trn, bus_item)) begin
      `uvm_fatal("APB", $sformatf("Could not cast bus_item (%s) into apb_trn (%s)", $typename(bus_item), $typename(apb_trn)))
   end

   rw.kind = (apb_trn.access_type == UVMA_APB_ACCESS_READ) ? UVM_READ : UVM_WRITE;
   rw.addr = apb_trn.address;

   case (apb_trn.access_type)
      UVMA_APB_ACCESS_READ : rw.data = apb_trn.rdata;
      UVMA_APB_ACCESS_WRITE: rw.data = apb_trn.wdata;

      default: `uvm_fatal("APB_MON", $sformatf("Invalid access_type: %0d", apb_trn.access_type))
   endcase

   if (apb_trn.__has_error) begin
      rw.status = UVM_NOT_OK;
   end
   else begin
      rw.status = UVM_IS_OK;
   end

endfunction : bus2reg


function bit [(`UVMA_APB_PSEL_MAX_SIZE-1):0] uvma_apb_reg_adapter_c::map_addr_to_slv_sel([(`UVMA_APB_PADDR_MAX_SIZE-1):0] address);

   // Default behavior
   return 1'b1;

endfunction : map_addr_to_slv_sel


`endif // __UVMA_APB_REG_ADAPTER_SV__
