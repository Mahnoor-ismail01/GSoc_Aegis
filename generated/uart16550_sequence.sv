

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "uart16550_xtn.sv"

class uart16550_sequence extends uvm_sequence;
  `uvm_object_utils(uart16550_sequence)
  function new(string name = "uart16550_sequence");
    super.new(name);
  endfunction
  virtual task body();

    `uvm_info("SEQ", "Running default test case", UVM_MEDIUM)
    repeat(10) begin
      uart16550_xtn item = uart16550_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize()) `uvm_error("SEQ", "Randomization failed for default_test")
      `uvm_info("SEQ", $sformatf("default_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #10;
    end

  endtask
endclass