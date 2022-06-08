class coverage extends uvm_subscriber #(sequence_item);
  `uvm_component_utils(coverage)

  bit [1:0] src;
  bit [NumTx-1:0] fwd;

  covergroup  CG_Forward;

    coverpoint src {
      bins src[] = {[0:3]};
      option.weight = 0;
    }

    coverpoint fwd {
      bins fwd[] = {[0:15]};    //ignore fwd == 0
      option.weight = 0;
    }

    cross src, fwd;

  endgroup : CG_Forward;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    CG_Forward = new();
  endfunction : new

  function void sample(sequence_item t);
    src = t.src;
    fwd = t.fwd;
    CG_Forward.sample();
  endfunction : sample

endclass : coverage


