class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) sb_imp;
  
  int total_txns = 0;
  
  function new (string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp", this);
  endfunction
  
  function void write(fifo_transaction txn);
    total_txns++;
    `uvm_info("SB", $sformatf("Scoreboard sees- wdata = %0h rdata = %0h", txn.wdata, txn.rdata), UVM_LOW)
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SB", $sformatf("Total transactions = %0h", total_txns), UVM_LOW)
  endfunction
  
endclass