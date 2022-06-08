class agent extends uvm_agent;
  `uvm_component_utils(agent);

  monitor monitor_h;
  driver  driver_h;
  //TODO :: add sequencer instance
  sequencer sequencer_h;


  extern function new(string name="agent", uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern function void connect_phase (uvm_phase phase);

endclass: agent

function agent::new(string name="agent", uvm_component parent);
  super.new(name, parent);
endfunction: new

function void agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  monitor_h   = monitor::type_id::create("monitor", this);
  driver_h    = driver::type_id::create("driver", this);
  sequencer_h = sequencer::type_id::create("sequencer", this);
endfunction: build_phase

function void agent::connect_phase(uvm_phase phase);
  driver_h.seq_item_port.connect(sequencer_h.seq_item_port) 
  //TODO replace sequencer here
endfunction: connect_phase





