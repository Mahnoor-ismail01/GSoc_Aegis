

import uvm_pkg::*;

class dut_xtn extends uvm_sequence_item;
  `uvm_object_utils(dut_xtn)

  // Inputs


  // Outputs


  function new(string name = "dut_xtn");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    dut_xtn tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

  endfunction

  virtual function string convert2string();
    string s = "";

    return s;
  endfunction
endclass