// The agent contains sequencer, driver, and monitor (yet to be included)
class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_driver driver;
  fifo_monitor monitor;
  uvm_sequencer#(fifo_transaction) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = fifo_monitor ::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin //active by default
      driver = fifo_driver ::type_id::create("driver", this);
      sequencer = uvm_sequencer#(fifo_transaction)::type_id::create("sequencer", this);
    end
  endfunction    

  // In UVM connect phase, we connect the sequencer to the driver.
  function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info("AGENT", "Raise objection in agent", UVM_FULL)
    // We raise objection to keep the test from completing
    phase.raise_objection(this);
    begin
      fifo_sequence seq;
      seq = fifo_sequence::type_id::create("seq");
      seq.start(sequencer);
    end
    // We drop objection to allow the test to complete
    phase.drop_objection(this);
    `uvm_info("AGENT", "Drop objection in agent", UVM_FULL)
  endtask

endclass