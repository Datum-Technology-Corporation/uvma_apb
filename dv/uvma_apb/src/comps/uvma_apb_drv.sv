// Copyright 2021 Datum Technology Corporation
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_APB_DRV_SV__
`define __UVMA_APB_DRV_SV__


/**
 * Component driving a AMBA Advanced Peripheral Bus virtual interface (uvma_apb_if).
 * @note The req & rsp's roles are switched when this driver is in 'slv' mode.
 */
class uvma_apb_drv_c extends uvml_drv_c #(
   .REQ(uvma_apb_base_seq_item_c)
);

   //virtual uvma_apb_if.active_mstr_mp  mstr_mp; ///<
   //virtual uvma_apb_if.active_slv_mp   slv_mp ; ///<

   // Objects
   uvma_apb_cfg_c    cfg  ;
   uvma_apb_cntxt_c  cntxt;

   // TLM
   uvm_analysis_port     #(uvma_apb_mstr_seq_item_c)  mstr_ap;
   uvm_analysis_port     #(uvma_apb_slv_seq_item_c )  slv_ap ;
   uvm_tlm_analysis_fifo #(uvma_apb_mon_trn_c      )  mon_trn_fifo;


   `uvm_component_utils_begin(uvma_apb_drv_c)
      `uvm_field_object(cfg  , UVM_DEFAULT)
      `uvm_field_object(cntxt, UVM_DEFAULT)
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   extern function new(string name="uvma_apb_drv", uvm_component parent=null);

   /**
    * 1. Ensures cfg & cntxt handles are not null.
    * 2. Builds ap.
    */
   extern virtual function void build_phase(uvm_phase phase);

   /**
    * Oversees driving, depending on the reset state, by calling drv_<pre|in|post>_reset() tasks.
    */
   extern virtual task run_phase(uvm_phase phase);

   /**
    * Called by run_phase() while agent is in pre-reset state.
    */
   extern task drv_pre_reset();

   /**
    * Called by run_phase() while agent is in reset state.
    */
   extern task drv_in_reset();

   /**
    * Called by run_phase() while agent is in post-reset state.
    */
   extern task drv_post_reset();

   /**
    * TODO Describe uvma_apb_drv::get_next_req()
    */
   extern task get_next_req(ref uvma_apb_base_seq_item_c req);

   /**
    * Drives the virtual interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_mstr_req(uvma_apb_mstr_seq_item_c req);

   /**
    * Drives the virtual interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_slv_req(uvma_apb_slv_seq_item_c req);

   /**
    * TODO Describe uvma_apb_drv_c::wait_for_rsp()
    */
   extern task wait_for_rsp(uvma_apb_mon_trn_c rsp);

   /**
    * TODO Describe uvma_apb_drv_c::process_mstr_rsp()
    */
   extern task process_mstr_rsp(uvma_apb_mstr_seq_item_c req, uvma_apb_mon_trn_c rsp);

   /**
    * Drives the virtual interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_mstr_read_req(uvma_apb_mstr_seq_item_c req);

   /**
    * Drives the virtual interface's (cntxt.vif) signals using req's contents.
    */
   extern task drv_mstr_write_req(uvma_apb_mstr_seq_item_c req);

   /**
    * TODO Describe uvma_apb_drv_c::drv_mstr_idle()
    */
   extern task drv_mstr_idle();

   /**
    * TODO Describe uvma_apb_drv_c::drv_slv_idle()
    */
   extern task drv_slv_idle();

endclass : uvma_apb_drv_c


function uvma_apb_drv_c::new(string name="uvma_apb_drv", uvm_component parent=null);

   super.new(name, parent);

endfunction : new


function void uvma_apb_drv_c::build_phase(uvm_phase phase);

   super.build_phase(phase);

   void'(uvm_config_db#(uvma_apb_cfg_c)::get(this, "", "cfg", cfg));
   if (!cfg) begin
      `uvm_fatal("CFG", "Configuration handle is null")
   end
   uvm_config_db#(uvma_apb_cfg_c)::set(this, "*", "cfg", cfg);

   void'(uvm_config_db#(uvma_apb_cntxt_c)::get(this, "", "cntxt", cntxt));
   if (!cntxt) begin
      `uvm_fatal("CNTXT", "Context handle is null")
   end
   uvm_config_db#(uvma_apb_cntxt_c)::set(this, "*", "cntxt", cntxt);

   //mstr_mp = cntxt.vif.active_mstr_mp;
   //slv_mp  = cntxt.vif.active_slv_mp ;

   mstr_ap      = new("mstr_ap"     , this);
   slv_ap       = new("slv_ap"      , this);
   mon_trn_fifo = new("mon_trn_fifo", this);

endfunction : build_phase


task uvma_apb_drv_c::run_phase(uvm_phase phase);

   super.run_phase(phase);

   if (cfg.enabled) begin
      forever begin
         case (cntxt.reset_state)
            UVMA_APB_RESET_STATE_PRE_RESET : drv_pre_reset ();
            UVMA_APB_RESET_STATE_IN_RESET  : drv_in_reset  ();
            UVMA_APB_RESET_STATE_POST_RESET: drv_post_reset();

            default: `uvm_fatal("APB_DRV", $sformatf("Invalid reset_state: %0d", cntxt.reset_state))
         endcase
      end
   end

endtask : run_phase


task uvma_apb_drv_c::drv_pre_reset();

   case (cfg.drv_mode)
      UVMA_APB_MODE_MSTR: @(cntxt.vif.drv_mstr_cb); //@(mstr_mp.drv_mstr_cb);
      UVMA_APB_MODE_SLV : @(cntxt.vif.drv_slv_cb ); //@(slv_mp .drv_slv_cb );

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase

endtask : drv_pre_reset


task uvma_apb_drv_c::drv_in_reset();

   case (cfg.drv_mode)
      UVMA_APB_MODE_MSTR: begin
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.paddr   <= '0;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.psel    <= '0;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.penable <= '0;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwrite  <= '0;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwdata  <= '0;
         @(cntxt.vif.drv_mstr_cb); //@(mstr_mp.drv_mstr_cb);
      end
      UVMA_APB_MODE_SLV: begin
         /*slv_mp*/cntxt.vif.drv_slv_cb.pready  <= '0;
         /*slv_mp*/cntxt.vif.drv_slv_cb.prdata  <= '0;
         /*slv_mp*/cntxt.vif.drv_slv_cb.pslverr <= '0;
         @(cntxt.vif.drv_slv_cb ); //@(slv_mp .drv_slv_cb );
      end

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase

endtask : drv_in_reset


task uvma_apb_drv_c::drv_post_reset();

   uvma_apb_mstr_seq_item_c  mstr_req;
   uvma_apb_slv_seq_item_c   slv_req;
   uvma_apb_mon_trn_c        mstr_rsp;
   uvma_apb_mon_trn_c        slv_rsp;

   case (cfg.drv_mode)
      UVMA_APB_MODE_MSTR: begin
         get_next_req(req);
         if (!$cast(mstr_req, req)) begin
            `uvm_fatal("APB_DRV", $sformatf("Could not cast 'req' (%s) to 'mstr_req' (%s)", $typename(req), $typename(mstr_req)))
         end
         drv_mstr_req(mstr_req);

         mstr_ap.write(mstr_req);
         seq_item_port.item_done();
      end

      UVMA_APB_MODE_SLV: begin
         get_next_req(req);
         if (!$cast(slv_req, req)) begin
            `uvm_fatal("APB_DRV", $sformatf("Could not cast 'req' (%s) to 'slv_req' (%s)", $typename(req), $typename(slv_req)))
         end
         drv_slv_req (slv_req);

         slv_ap.write(slv_req);
         seq_item_port.item_done();
      end

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid drv_mode: %0d", cfg.drv_mode))
   endcase

endtask : drv_post_reset


task uvma_apb_drv_c::get_next_req(ref uvma_apb_base_seq_item_c req);

   seq_item_port.get_next_item(req);
   `uvml_hrtbt()
   `uvm_info("APB_DRV", $sformatf("Got new req:\n%s", req.sprint()), UVM_HIGH)

   // Copy cfg fields
   req.mode           = cfg.drv_mode;
   req.addr_bus_width = cfg.addr_bus_width;
   req.data_bus_width = cfg.data_bus_width;
   req.sel_width      = cfg.sel_width;

endtask : get_next_req


task uvma_apb_drv_c::drv_mstr_req(uvma_apb_mstr_seq_item_c req);

   case (req.access_type)
      UVMA_APB_ACCESS_READ: begin
         drv_mstr_read_req(req);
      end

      UVMA_APB_ACCESS_WRITE: begin
         drv_mstr_write_req(req);
      end

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid access_type: %0d", req.access_type))
   endcase

endtask : drv_mstr_req


task uvma_apb_drv_c::drv_slv_req(uvma_apb_slv_seq_item_c req);

   // Latency cycles
   @(cntxt.vif.drv_slv_cb);
   repeat (req.latency) begin
      @(cntxt.vif.drv_slv_cb);
   end

   // Req data
   cntxt.vif.drv_slv_cb.pready  = 1'b1;
   cntxt.vif.drv_slv_cb.pslverr = req.slverr;
   cntxt.vif.drv_slv_cb.prdata  = req.rdata;

   // Hold cycles
   repeat (req.hold_duration) begin
      @(cntxt.vif.drv_slv_cb);
   end

   // Idle
   @(cntxt.vif.drv_slv_cb);
   drv_slv_idle();

endtask : drv_slv_req


task uvma_apb_drv_c::wait_for_rsp(uvma_apb_mon_trn_c rsp);

   mon_trn_fifo.get(rsp);

endtask : wait_for_rsp


task uvma_apb_drv_c::process_mstr_rsp(uvma_apb_mstr_seq_item_c req, uvma_apb_mon_trn_c rsp);

   req.rdata       = rsp.data   ;
   req.__has_error = rsp.slv_err;

endtask : process_mstr_rsp


task uvma_apb_drv_c::drv_mstr_read_req(uvma_apb_mstr_seq_item_c req);

   bit  waited_for_rdy = 0;

   `uvm_info("APB_DRV", $sformatf("Driving read on MSTR for address %h. cfg.addr_bus_width=%0d, cfg.data_bus_width=%0d", req.address, cfg.addr_bus_width, cfg.data_bus_width), UVM_HIGH)

   @(cntxt.vif.drv_mstr_cb);
   cntxt.vif.drv_mstr_cb.pwrite = 0;
   cntxt.vif.drv_mstr_cb.paddr = req.address;
   cntxt.vif.drv_mstr_cb.psel[0] = 1;

   @(cntxt.vif.drv_mstr_cb);
   cntxt.vif.drv_mstr_cb.penable = 1;
   while (cntxt.vif./*drv_mstr_cb.*/pready !== 1'b1) begin
      @(cntxt.vif.drv_mstr_cb);
      waited_for_rdy = 1;
   end
   req.rdata = cntxt.vif.prdata;
   req.__has_error = cntxt.vif.pslverr;

   if (!waited_for_rdy) @(cntxt.vif.drv_mstr_cb);
   drv_mstr_idle();
   cntxt.vif.drv_mstr_cb.penable = 0;
   cntxt.vif.drv_mstr_cb.psel[0] = 0;
   @(cntxt.vif.drv_mstr_cb);

endtask : drv_mstr_read_req


task uvma_apb_drv_c::drv_mstr_write_req(uvma_apb_mstr_seq_item_c req);

   bit  waited_for_rdy = 0;

   `uvm_info("APB_DRV", $sformatf("Driving write on MSTR for address %h and data %h. cfg.addr_bus_width=%0d, cfg.data_bus_width=%0d", req.address, req.wdata, cfg.addr_bus_width, cfg.data_bus_width), UVM_HIGH)

   @(cntxt.vif.drv_mstr_cb);
   cntxt.vif.drv_mstr_cb.pwrite  = 1;
   cntxt.vif.drv_mstr_cb.paddr   = req.address;
   cntxt.vif.drv_mstr_cb.pwdata  = req.wdata;
   cntxt.vif.drv_mstr_cb.psel[0] = 1;

   @(cntxt.vif.drv_mstr_cb);
   cntxt.vif.drv_mstr_cb.penable = 1;
   while (cntxt.vif./*drv_mstr_cb.*/pready !== 1'b1) begin
      @(cntxt.vif.drv_mstr_cb);
      waited_for_rdy = 1;
   end
   req.__has_error = cntxt.vif.pslverr;

   if (!waited_for_rdy) @(cntxt.vif.drv_mstr_cb);
   drv_mstr_idle();
   cntxt.vif.drv_mstr_cb.penable = 0;
   cntxt.vif.drv_mstr_cb.psel[0] = 0;
   @(cntxt.vif.drv_mstr_cb);

endtask : drv_mstr_write_req


task uvma_apb_drv_c::drv_mstr_idle();

   /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwrite <= '0;

   case (cfg.drv_idle)
      UVMA_APB_DRV_IDLE_SAME: ;// Do nothing;

      UVMA_APB_DRV_IDLE_ZEROS: begin
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.paddr  <= '0;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwdata <= '0;
      end

      UVMA_APB_DRV_IDLE_RANDOM: begin
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.paddr  <= $urandom();
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwdata <= $urandom();
      end

      UVMA_APB_DRV_IDLE_X: begin
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.paddr  <= 'X;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwdata <= 'X;
      end

      UVMA_APB_DRV_IDLE_Z: begin
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.paddr  <= 'Z;
         /*mstr_mp*/cntxt.vif.drv_mstr_cb.pwdata <= 'Z;
      end

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
   endcase

endtask : drv_mstr_idle


task uvma_apb_drv_c::drv_slv_idle();

   case (cfg.drv_idle)
      UVMA_APB_DRV_IDLE_SAME: ;// Do nothing;

      UVMA_APB_DRV_IDLE_ZEROS: begin
         /*slv_mp*/cntxt.vif.drv_slv_cb.prdata  <= '0;
      end

      UVMA_APB_DRV_IDLE_RANDOM: begin
         /*slv_mp*/cntxt.vif.drv_slv_cb.prdata  <= $urandom();
      end

      UVMA_APB_DRV_IDLE_X: begin
         /*slv_mp*/cntxt.vif.drv_slv_cb.prdata  <= 'X;
      end

      UVMA_APB_DRV_IDLE_Z: begin
         /*slv_mp*/cntxt.vif.drv_slv_cb.prdata  <= 'Z;
      end

      default: `uvm_fatal("APB_DRV", $sformatf("Invalid drv_idle: %0d", cfg.drv_idle))
   endcase

endtask : drv_slv_idle


`endif // __UVMA_APB_DRV_SV__
