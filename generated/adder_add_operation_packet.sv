```
import uvm_pkg::*;

class adder_add_operation_packet extends uvm_sequence_item;
  `uvm_object_utils(adder_add_operation_packet)


  
  logic [0:0] rstn; // Input (Active-low reset input)
  
  

  
  rand logic [7:0] a; // Input (First 8-bit input operand)
  
  

  
  rand logic [7:0] b; // Input (Second 8-bit input operand)
  
  



  
  logic [7:0] sum; // Output (8-bit sum output)
  

  
  logic [0:0] carry; // Output (Carry-out output)
  


  function new(string name = "adder_add_operation_packet");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    adder_add_operation_packet tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")
    
    this.rstn = tmp.rstn;
    
    this.a = tmp.a;
    
    this.b = tmp.b;
    
    this.sum = tmp.sum;
    
    this.carry = tmp.carry;
    
  endfunction

  virtual function string convert2string();
    string s = $sformatf("=%0h =%0h =%0h =%0h =%0h", rstn, a, b, sum, carry);
    return s;
  endfunction
endclass
```