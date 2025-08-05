

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "uart16550_sequence.sv"

class uart16550_test extends uvm_test;
  `uvm_component_utils(uart16550_test)
  function new(string name = "uart16550_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    uart16550_sequence seq = uart16550_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting uart16550_sequence", UVM_MEDIUM)
    seq.start(null);
    #2000;
    phase.drop_objection(this);
  endtask
endclass