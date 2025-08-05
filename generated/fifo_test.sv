

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "fifo_sequence.sv"

class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)
  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    fifo_sequence seq = fifo_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting fifo_sequence", UVM_MEDIUM)
    seq.start(null);
    #1000;
    phase.drop_objection(this);
  endtask
endclass