

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "adder_sequence.sv"

class adder_test extends uvm_test;
  `uvm_component_utils(adder_test)
  function new(string name = "adder_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    adder_sequence seq = adder_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting adder_sequence", UVM_MEDIUM)
    seq.start(null);
    #500;
    phase.drop_objection(this);
  endtask
endclass