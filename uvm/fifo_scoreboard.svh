class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  uvm_analysis_imp #(fifo_transaction, fifo_scoreboard) sb_imp;
  
  bit [31:0] write_que [$];
  bit [31:0] read_que [$];
  
  bit [31:0] write_que_popd;
  bit [31:0] read_que_popd;
  
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
    
    if (txn.op == FIFO_WRITE) begin
      write_que.push_back(txn.wdata);
    end else if (txn.op == FIFO_READ) begin
      if (write_que.size() == 0) begin
        `uvm_error("SB", "Read when FIFO model empty")
      end
      else begin
        bit [31:0] exp = write_que.pop_front();
        if (exp == txn.rdata)
          `uvm_info("SB", $sformatf("[PASS] Expected = %0h Received = %0h", exp, txn.rdata),UVM_LOW)
        else
          `uvm_error("SB", $sformatf("[FAIL] Expected = %0h Received = %0h", exp, txn.rdata))
      end
    end
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SB", $sformatf("Total transactions = %0h", total_txns), UVM_LOW)
  endfunction
  
endclass