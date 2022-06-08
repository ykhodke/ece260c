class monitor extends uvm_monitor;
  `uvm_component_utils(monitor);

  virtual Utopia.TB_Tx vUtopiaTx;
  int PortID;

  //TOOD::
  // 1. add uvm analysis port
  // 2. events for trigerring covergroups

  extern function new(string name="monitor", uvm_component parent, input Utopia.TB_Tx vUtopiaTx, input int PortID);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase();
  extern task receive(output NNI_cell c);

endclass: monitor

function monitor::new(string name="monitor", uvm_component parent, input Utopia.TB_Tx vUtopiaTx, input int PortID);
  super.new(name, parent);
  this.vUtopiaTx = vUtopiaTx;
  this.PortID = PortID;
endfunction: new

//test

function void driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual vUtopiaTx)::get (this, "", "vUtopiaTx", vUtopiaTx)) begin
    `uvm_fatal("MONITOR", "Failed to get BFM fom vUtopiaTx");
  end
endfunction: build_phase

task monitor::run_phase();
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


