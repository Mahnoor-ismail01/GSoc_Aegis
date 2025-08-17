
class adder_transaction extends uvm_object;
  `uvm_object_utils(adder_transaction)
  
  
  
  rand bit [0:0] rstn;
  
  
  constraint c_rstn { rstn inside {0, 1}; }
  
  
  
  rand logic [7:0] a;
  
  
  constraint c_a { a inside {[0:255]}; }
  
  
  
  rand logic [7:0] b;
  
  
  constraint c_b { b inside {[0:255]}; }
  
  
  
  rand logic [7:0] sum;
  
  
  
  
  rand bit [0:0] carry;
  
  
  
  
  
  
  `uvm_object_utils_begin(adder_transaction)
  
  
    `uvm_field_int(rstn, UVM_ALL_ON)
  
  
  
    `uvm_field_int(a, UVM_ALL_ON)
  
  
  
    `uvm_field_int(b, UVM_ALL_ON)
  
  
  
    `uvm_field_int(sum, UVM_ALL_ON | UVM_NO_COMPARE)
  
  
  
    `uvm_field_int(carry, UVM_ALL_ON | UVM_NO_COMPARE)
  
  
  `uvm_object_utils_end
  
  function new(string name = "adder_transaction");
    super.new(name);
  endfunction
endclass