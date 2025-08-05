

import uvm_pkg::*;

class adder_xtn extends uvm_sequence_item;
  `uvm_object_utils(adder_xtn)

  // Inputs

  
  rand bit  rstn; // Reset (active low)
  

  
  rand bit [7:0] a; // First operand
  

  
  rand bit [7:0] b; // Second operand
  


  // Outputs

  
  bit [7:0] sum; // Sum output
  

  
  bit  carry; // Carry output
  


  function new(string name = "adder_xtn");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    adder_xtn tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

    
    this.rstn = tmp.rstn;
    

    
    this.a = tmp.a;
    

    
    this.b = tmp.b;
    

    
    this.sum = tmp.sum;
    

    
    this.carry = tmp.carry;
    

  endfunction

  virtual function string convert2string();
    string s = "";

    
    s = $sformatf("rstn=%0h", rstn));
    

    
    , s = {s, $sformatf("a=%0h", a));
    

    
    , s = {s, $sformatf("b=%0h", b));
    

    
    , s = {s, $sformatf("sum=%0h", sum));
    

    
    , s = {s, $sformatf("carry=%0h", carry))
    

    return s;
  endfunction
endclass