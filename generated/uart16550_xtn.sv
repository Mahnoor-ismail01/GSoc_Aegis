

import uvm_pkg::*;

class uart16550_xtn extends uvm_sequence_item;
  `uvm_object_utils(uart16550_xtn)

  // Inputs

  
  rand logic [7:0] wb_dat_i; // WISHBONE data input (8-bit mode)
  

  
  rand logic [2:0] wb_addr_i; // WISHBONE address input (3-bit)
  

  
  rand logic  wb_we_i; // WISHBONE write enable
  

  
  rand logic  wb_stb_i; // WISHBONE strobe
  

  
  rand logic  wb_cyc_i; // WISHBONE cycle
  

  
  logic [7:0] {$} THR; // Transmit Holding Register FIFO (8-bit data input)
  


  // Outputs

  
  logic [7:0] {$} RB; // Receive Buffer FIFO (8-bit data output)
  


  function new(string name = "uart16550_xtn");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    uart16550_xtn tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    
    this.wb_dat_i = tmp.wb_dat_i;
    

    
    this.wb_addr_i = tmp.wb_addr_i;
    

    
    this.wb_we_i = tmp.wb_we_i;
    

    
    this.wb_stb_i = tmp.wb_stb_i;
    

    
    this.wb_cyc_i = tmp.wb_cyc_i;
    

    
    foreach (tmp.THR[j]) this.THR[j] = tmp.THR[j];
    

    
    foreach (tmp.RB[j]) this.RB[j] = tmp.RB[j];
    

  endfunction

  virtual function string convert2string();
    string s = "";

    
    s = $sformatf("wb_dat_i=%0h", wb_dat_i));
    

    
    , s = {s, $sformatf("wb_addr_i=%0h", wb_addr_i));
    

    
    , s = {s, $sformatf("wb_we_i=%0h", wb_we_i));
    

    
    , s = {s, $sformatf("wb_stb_i=%0h", wb_stb_i));
    

    
    , s = {s, $sformatf("wb_cyc_i=%0h", wb_cyc_i));
    

    
    foreach (THR[j]) s = {s, $sformatf("THR[%0d]=%0h", j, THR[j])};
    

    
    foreach (RB[j]) s = {s, $sformatf("RB[%0d]=%0h", j, RB[j])};
    

    return s;
  endfunction
endclass