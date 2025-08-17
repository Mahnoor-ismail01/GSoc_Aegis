
class reset_test_sequence extends uvm_sequence #(adder_transaction);
  `uvm_object_utils(reset_test_sequence)
  
  function new(string name = "reset_test_sequence");
    super.new(name);
  endfunction
  
  task body();
    adder_transaction tx;
    
    tx = adder_transaction::type_id::create("tx");
    start_item(tx);
    finish_item(tx);
    
  endtask
endclass