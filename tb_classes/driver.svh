class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)

  virtual Utopia.TB_Rx vUtopiaRx;

  extern function new (string name ="driver", uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase (uvm_phase phase);
  extern task send (input UNI_cell c);

endclass: driver

function driver::new(string new="driver", uvm_component phase);
  super.new(name, parent);
endfunction

function void driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual Utopia.TB_Rx)::get (this, "", "vUtopiaRX", vUtopiaRx)) begin
    `uvm_fatal("DRIVER", "Failed to get BFM fom vUtopiaRx");
  end
endfunction: build_phase

task driver::run_phase(uvm_phase phase);
  UNI_cell c;
  forever begin
    seq_item_port.get_next_item(c);
    send(c);
    seq_item_port.item_done();
  end
endtask: run_phase

task driver::send(input UNI_cell c);
  ATMCellType Pkt;

  c.pack(Pkt);
  $write("Sending cell: "); foreach (Pkt.Mem[i]) $write("%x ", Pkt.Mem[i]); $display;

  @(vUtopiaRX.cbr);
  vUtopiaRX.cbr.clav <= 1;
  for (int i = 0; i <= 52; i++) begin
    while (vUtopiaRX.cbr.en === 1'b1) @(vUtopiaRX.cbr);
    vUtopiaRX.cbr.soc  <= (i == 0);
    vUtopiaRX.cbr.data <= Pkt.Mem[i];
    @(vUtopiaRX.cbr);
  endv
  vUtopiaRX.cbr.soc  <=  'z;
  vUtopiaRX.cbr.data <= 8'bx;
  vUtopiaRX.cbr.clav <= 0;
endtask: send


