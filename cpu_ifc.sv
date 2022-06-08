interface cpu_ifc;
  
  `import utopia_pkg::*
  
  interface cpu_ifc;
  logic        BusMode;
  logic [11:0] Addr;
  logic        Sel;
  CellCfgType  DataIn;
  CellCfgType  DataOut;
  logic        Rd_DS;
  logic        Wr_RW;
  logic        Rdy_Dtack;

  modport Peripheral (input  BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW, 
                      output DataOut, Rdy_Dtack);

  modport Test (output BusMode, Addr, Sel, DataIn, Rd_DS, Wr_RW,
                input  DataOut, Rdy_Dtack);

endinterface : cpu_ifc

typedef virtual cpu_ifc vCPU;
typedef virtual cpu_ifc.Test vCPU_T;
