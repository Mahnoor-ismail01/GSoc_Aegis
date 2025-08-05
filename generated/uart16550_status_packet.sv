

import uvm_pkg::*;

class uart16550_status_packet extends uvm_sequence_item;
  `uvm_object_utils(uart16550_status_packet)


  
  logic CTS_PAD_I; // Input (Clear To Send)
  
  

  
  logic DSR_PAD_I; // Input (Data Set Ready)
  
  

  
  logic RI_PAD_I; // Input (Ring Indicator)
  
  

  
  logic DCD_PAD_I; // Input (Data Carrier Detect)
  
  



  
  logic [7:0] LSR; // Output (Line Status Register)
  

  
  logic [7:0] MSR; // Output (Modem Status Register)
  

  function new(string name = "uart16550_status_packet");
    super.new(name);
  endfunction
  virtual function void do_copy(uvm_object rhs);
    uart16550_status_packet tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    
    this.CTS_PAD_I = tmp.CTS_PAD_I;
    

    
    this.DSR_PAD_I = tmp.DSR_PAD_I;
    

    
    this.RI_PAD_I = tmp.RI_PAD_I;
    

    
    this.DCD_PAD_I = tmp.DCD_PAD_I;
    

    
    this.LSR = tmp.LSR;
    

    
    this.MSR = tmp.MSR;
    

  endfunction
  virtual function string convert2string();
    string s = $sformatf("CTS_PAD_I=%0b DSR_PAD_I=%0b RI_PAD_I=%0b DCD_PAD_I=%0b LSR=%0h MSR=%0h", CTS_PAD_I, DSR_PAD_I, RI_PAD_I, DCD_PAD_I, LSR, MSR);
    
    
    
    
    
    
    
    
    
    
    
    
    
    return s;
  endfunction
endclass