

import uvm_pkg::*;

class miniuart_xtn extends uvm_sequence_item;
  `uvm_object_utils(miniuart_xtn)

  // Inputs

  
  rand bit  WB_CLK_I; // Wishbone clock input
  

  
  rand bit  WB_RST_I; // Asynchronous reset
  

  
  rand bit [1:0] WB_ADDR_I; // Register selection address
  

  
  rand bit [7:0] WB_DAT_I; // Data input
  

  
  rand bit  WB_WE_I; // Write or read cycle selection
  

  
  rand bit  WB_STB_I; // Transfer cycle specification
  

  
  rand bit  RxD_PAD_I; // Serial input signal
  


  // Outputs

  
  bit [7:0] WB_DAT_O; // Data output
  

  
  bit  WB_ACK_O; // Acknowledge of a transfer
  

  
  bit  IntTx_O; // Transmit interrupt
  

  
  bit  IntRx_O; // Receive interrupt
  

  
  bit  TxD_PAD_O; // Serial output signal
  


  function new(string name = "miniuart_xtn");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    miniuart_xtn tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    
    this.WB_CLK_I = tmp.WB_CLK_I;
    

    
    this.WB_RST_I = tmp.WB_RST_I;
    

    
    this.WB_ADDR_I = tmp.WB_ADDR_I;
    

    
    this.WB_DAT_I = tmp.WB_DAT_I;
    

    
    this.WB_WE_I = tmp.WB_WE_I;
    

    
    this.WB_STB_I = tmp.WB_STB_I;
    

    
    this.RxD_PAD_I = tmp.RxD_PAD_I;
    

    
    this.WB_DAT_O = tmp.WB_DAT_O;
    

    
    this.WB_ACK_O = tmp.WB_ACK_O;
    

    
    this.IntTx_O = tmp.IntTx_O;
    

    
    this.IntRx_O = tmp.IntRx_O;
    

    
    this.TxD_PAD_O = tmp.TxD_PAD_O;
    

  endfunction

  virtual function string convert2string();
    string s = "";

    
    s = $sformatf("WB_CLK_I=%0h", WB_CLK_I));
    

    
    , s = {s, $sformatf("WB_RST_I=%0h", WB_RST_I));
    

    
    , s = {s, $sformatf("WB_ADDR_I=%0h", WB_ADDR_I));
    

    
    , s = {s, $sformatf("WB_DAT_I=%0h", WB_DAT_I));
    

    
    , s = {s, $sformatf("WB_WE_I=%0h", WB_WE_I));
    

    
    , s = {s, $sformatf("WB_STB_I=%0h", WB_STB_I));
    

    
    , s = {s, $sformatf("RxD_PAD_I=%0h", RxD_PAD_I));
    

    
    , s = {s, $sformatf("WB_DAT_O=%0h", WB_DAT_O));
    

    
    , s = {s, $sformatf("WB_ACK_O=%0h", WB_ACK_O));
    

    
    , s = {s, $sformatf("IntTx_O=%0h", IntTx_O));
    

    
    , s = {s, $sformatf("IntRx_O=%0h", IntRx_O));
    

    
    , s = {s, $sformatf("TxD_PAD_O=%0h", TxD_PAD_O))
    

    return s;
  endfunction
endclass