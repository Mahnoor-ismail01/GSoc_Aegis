
class basic_addition_sequence extends uvm_sequence #(adder_transaction);
  `uvm_object_utils(basic_addition_sequence)
  
  function new(string name = "basic_addition_sequence");
    super.new(name);
  endfunction
  
  task body();
    adder_transaction tx;
    
    tx = adder_transaction::type_id::create("tx");
    start_item(tx);
    finish_item(tx);
    
  endtask
endclass