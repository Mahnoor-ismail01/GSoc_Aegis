

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "miniuart_sequence.sv"

class miniuart_test extends uvm_test;
  `uvm_component_utils(miniuart_test)
  function new(string name = "miniuart_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    miniuart_sequence seq = miniuart_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting miniuart_sequence", UVM_MEDIUM)
    seq.start(null);
    #1000;
    phase.drop_objection(this);
  endtask
endclass