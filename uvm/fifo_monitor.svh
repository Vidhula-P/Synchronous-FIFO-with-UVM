class fifo_monitor extends uvm_monitor;

  `uvm_component_utils(fifo_monitor)

  virtual fifo_if dut_vif;
  uvm_analysis_port  #(fifo_transaction) mon_analysis_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_analysis_port = new ("mon_analysis_port", this);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual fifo_if)::get(this, "", "dut_vif", dut_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction 

  task run_phase(uvm_phase phase);
    fifo_transaction txn;
    `uvm_info("MONITOR","Start Monitor", UVM_MEDIUM)
    forever begin
      @(negedge dut_vif.clk);   
      if(dut_vif.tb.wr_en) begin
        txn = fifo_transaction::type_id::create("txn", this);
        txn.op = FIFO_WRITE;
        txn.wdata = dut_vif.tb.wdata;
      	`uvm_info("MONITOR",$sformatf("Writing %h", txn.wdata), UVM_MEDIUM)
        mon_analysis_port.write(txn);
      end
      if(dut_vif.tb.rd_en) begin
        txn = fifo_transaction::type_id::create("txn", this);
        txn.op = FIFO_READ;
        txn.rdata = dut_vif.tb.rdata;
        `uvm_info("MONITOR",$sformatf("Reading %h", txn.rdata), UVM_MEDIUM)
        mon_analysis_port.write(txn);
      end
    end
  endtask

endclass