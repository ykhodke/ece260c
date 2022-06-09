class Environment extends uvm_env;
  `uvm_component_utils(Environment);

  sequencer sequencer_h;
  coverage coverage_h;
  scoreboard scoreboard_h;
  
  // TODOs
  driver driver_h;
  command_monitor command_monitor_h;
  result_monitor result_monitor_h;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase 


