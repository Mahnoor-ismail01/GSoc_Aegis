

import uvm_pkg::*;

class uart16550_control_packet extends uvm_sequence_item;
  `uvm_object_utils(uart16550_control_packet)


  
  logic [7:0] {$} THR; // Input (Transmit Holding Register FIFO (8-bit data input))
  
  

  
  logic [31:0] WB_DAT_I; // Input (WISHBONE data input (32-bit mode))
  
  

  
  logic [4:0] WB_ADDR_I; // Input (WISHBONE address input (5-bit in 32-bit mode))
  
  

  
  logic WB_WE_I; // Input (WISHBONE write enable)
  
  

  
  logic WB_STB_I; // Input (WISHBONE strobe)
  
  

  
  logic WB_CYC_I; // Input (WISHBONE cycle)
  
  

  
  logic SRX_PAD_I; // Input (Serial input signal)
  
  



  
  logic [7:0] {$} RB; // Output (Receive Buffer FIFO (8-bit data output))
  

  
  logic [31:0] WB_DAT_O; // Output (WISHBONE data output (32-bit mode))
  

  
  logic WB_ACK_O; // Handshake output (WISHBONE acknowledge)
  

  
  logic INT_O; // Output (Interrupt output)
  

  
  logic STX_PAD_O; // Output (Serial output signal)
  

  
  logic RTS_PAD_O; // Output (Request To Send)
  

  
  logic DTR_PAD_O; // Output (Data Terminal Ready)
  

  function new(string name = "uart16550_control_packet");
    super.new(name);
  endfunction
  virtual function void do_copy(uvm_object rhs);
    uart16550_control_packet tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    
    foreach (tmp.THR[j]) this.THR[j] = tmp.THR[j];
    

    
    this.WB_DAT_I = tmp.WB_DAT_I;
    

    
    this.WB_ADDR_I = tmp.WB_ADDR_I;
    

    
    this.WB_WE_I = tmp.WB_WE_I;
    

    
    this.WB_STB_I = tmp.WB_STB_I;
    

    
    this.WB_CYC_I = tmp.WB_CYC_I;
    

    
    this.SRX_PAD_I = tmp.SRX_PAD_I;
    

    
    foreach (tmp.RB[j]) this.RB[j] = tmp.RB[j];
    

    
    this.WB_DAT_O = tmp.WB_DAT_O;
    

    
    this.WB_ACK_O = tmp.WB_ACK_O;
    

    
    this.INT_O = tmp.INT_O;
    

    
    this.STX_PAD_O = tmp.STX_PAD_O;
    

    
    this.RTS_PAD_O = tmp.RTS_PAD_O;
    

    
    this.DTR_PAD_O = tmp.DTR_PAD_O;
    

  endfunction
  virtual function string convert2string();
    string s = $sformatf("WB_DAT_I=%0h WB_ADDR_I=%0h WB_WE_I=%0b WB_STB_I=%0b WB_CYC_I=%0b SRX_PAD_I=%0b WB_DAT_O=%0h WB_ACK_O=%0b INT_O=%0b STX_PAD_O=%0b RTS_PAD_O=%0b DTR_PAD_O=%0b", WB_DAT_I, WB_ADDR_I, WB_WE_I, WB_STB_I, WB_CYC_I, SRX_PAD_I, WB_DAT_O, WB_ACK_O, INT_O, STX_PAD_O, RTS_PAD_O, DTR_PAD_O);
    
    
    foreach (THR[j]) s = {s, $sformatf(" THR[%0d]=%0h", j, THR[j])};
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    foreach (RB[j]) s = {s, $sformatf(" RB[%0d]=%0h", j, RB[j])};
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    return s;
  endfunction
endclass