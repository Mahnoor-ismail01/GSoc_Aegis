

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dut_xtn.sv"

class dut_sequence extends uvm_sequence;
  `uvm_object_utils(dut_sequence)
  function new(string name = "dut_sequence");
    super.new(name);
  endfunction
  virtual task body();


    // Test case: transmit_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: transmit_test", UVM_MEDIUM)
    repeat(5) begin
      dut_xtn item = dut_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { {'variable': 'wb_we_i', 'value': '1'}; {'variable': 'wb_addr_i', 'value': '0'}; {'variable': 'wb_dat_i', 'range': [0, 255]}; {'variable': 'wb_stb_i', 'value': '1'}; {'variable': 'wb_cyc_i', 'value': '1'};  }) begin
        `uvm_error("SEQ", "Randomization failed for transmit_test")
      end
      `uvm_info("SEQ", $sformatf("transmit_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #10;
    end

    // Test case: receive_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: receive_test", UVM_MEDIUM)
    repeat(3) begin
      dut_xtn item = dut_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { {'variable': 'wb_we_i', 'value': '0'}; {'variable': 'wb_addr_i', 'value': '0'}; {'variable': 'wb_stb_i', 'value': '1'}; {'variable': 'wb_cyc_i', 'value': '1'};  }) begin
        `uvm_error("SEQ", "Randomization failed for receive_test")
      end
      `uvm_info("SEQ", $sformatf("receive_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #10;
    end

    // Test case: divisor_latch_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: divisor_latch_test", UVM_MEDIUM)
    repeat(2) begin
      dut_xtn item = dut_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { {'variable': 'wb_we_i', 'value': '1'}; {'variable': 'wb_addr_i', 'value': '0'}; {'variable': 'wb_dat_i', 'range': [0, 255]}; {'variable': 'wb_stb_i', 'value': '1'}; {'variable': 'wb_cyc_i', 'value': '1'};  }) begin
        `uvm_error("SEQ", "Randomization failed for divisor_latch_test")
      end
      `uvm_info("SEQ", $sformatf("divisor_latch_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #10;
    end


  endtask
endclass