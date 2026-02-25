class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_agent agent;
  fifo_scoreboard sb;

  function new(string name="fifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = fifo_agent::type_id::create("agent", this);
    sb = fifo_scoreboard::type_id::create("sb", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agent.monitor.mon_analysis_port.connect(sb.sb_imp);
  endfunction

endclass