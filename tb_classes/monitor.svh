class monitor extends uvm_monitor;
  `uvm_component_utils(monitor);

  virtual Utopia vUtopia;
  int PortID;

  uvm_active_passive_enum is_active;

  uvm_analysis_port #() 

  //TOOD::
  // 1. add uvm analysis port
  // 2. events for trigerring covergroups

  extern function new(string name="monitor", uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task receive(output NNI_cell c);

endclass: monitor

function monitor::new(string name="monitor", uvm_component parent);
  super.new(name, parent);
  is_active = UVM_ACTIVE;
endfunction: new

function void driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(virtual vUtopiaTx)::get (this, "", "vUtopia", vUtopia)) begin
    `uvm_fatal("MONITOR", "Failed to get BFM fom vUtopiaTx");
  end
  
  if (!uvm_config_db #(bit)::get (this, "", "is_active", is_active)) begin
    `uvm_fatal("MONITOR", "Failed to get BFM fom vUtopiaTx");
  end



endfunction: build_phase

task monitor::run_phase(uvm_phase phase);
  NNI_cell c;

  forever begin
    receive(c);
    //TODO :: finish this
  end
endtask:  run_phase

task monitor::receive(output NNI_cell c);
  ATMCellType Pkt;

  Tx.cbt.clav <= 1;
  while (Tx.cbt.soc !== 1'b1 && Tx.cbt.en !== 1'b0)
    @(Tx.cbt);
  for (int i=0; i<=52; i++) begin
    // If not enabled, loop
    while (Tx.cbt.en !== 1'b0) @(Tx.cbt);
    Pkt.Mem[i] = Tx.cbt.data;
    @(Tx.cbt);
  end

  Tx.cbt.clav <= 0;

  c = new();
  c.unpack(Pkt);
  c.display($sformatf("@%0t: Mon%0d: ", $time, PortID));
  
endtask : receive


