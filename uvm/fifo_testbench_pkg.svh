package fifo_testbench_pkg;
  import uvm_pkg::*;
  //Timescale
  timeunit 10ns; timeprecision 100ps;
  
  // The UVM sequence, transaction item, and driver are in these files:
  `include "fifo_sequence.svh"
  `include "fifo_driver.svh"
  `include "fifo_monitor.svh"
  `include "fifo_agent.svh"
  `include "fifo_env.svh"
  `include "fifo_test.svh"
endpackage