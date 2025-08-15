

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dut_sequence.sv"

class dut_test extends uvm_test;
  `uvm_component_utils(dut_test)
  function new(string name = "dut_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    dut_sequence seq = dut_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting dut_sequence", UVM_MEDIUM)
    seq.start(null);
    #1000;
    phase.drop_objection(this);
  endtask
endclass