

import uvm_pkg::*;

class adder_default_packet extends uvm_sequence_item;
  `uvm_object_utils(adder_default_packet)




  function new(string name = "adder_default_packet");
    super.new(name);
  endfunction
  virtual function void do_copy(uvm_object rhs);
    adder_default_packet tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")

  endfunction
  virtual function string convert2string();
    string s = $sformatf("", );
    
    return s;
  endfunction
endclass