

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "adder_xtn.sv"

class adder_sequence extends uvm_sequence;
  `uvm_object_utils(adder_sequence)
  function new(string name = "adder_sequence");
    super.new(name);
  endfunction
  virtual task body();


    // Test case: reset_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: reset_test", UVM_MEDIUM)
    repeat(5) begin
      adder_xtn item = adder_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rstn == 0;  }) begin
        `uvm_error("SEQ", "Randomization failed for reset_test")
      end
      `uvm_info("SEQ", $sformatf("reset_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #50;
    end

    // Test case: basic_addition_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: basic_addition_test", UVM_MEDIUM)
    repeat(10) begin
      adder_xtn item = adder_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rstn == 1; a < 128; b < 128;  }) begin
        `uvm_error("SEQ", "Randomization failed for basic_addition_test")
      end
      `uvm_info("SEQ", $sformatf("basic_addition_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #100;
    end

    // Test case: max_value_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: max_value_test", UVM_MEDIUM)
    repeat(5) begin
      adder_xtn item = adder_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rstn == 1; a == 255; b == 255;  }) begin
        `uvm_error("SEQ", "Randomization failed for max_value_test")
      end
      `uvm_info("SEQ", $sformatf("max_value_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #50;
    end

    // Test case: random_addition_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: random_addition_test", UVM_MEDIUM)
    repeat(20) begin
      adder_xtn item = adder_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rstn == 1; a dist {0:/25, [1:254]:/50, 255:/25}; b dist {0:/25, [1:254]:/50, 255:/25};  }) begin
        `uvm_error("SEQ", "Randomization failed for random_addition_test")
      end
      `uvm_info("SEQ", $sformatf("random_addition_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #200;
    end

    // Test case: corner_case_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: corner_case_test", UVM_MEDIUM)
    repeat(10) begin
      adder_xtn item = adder_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rstn == 1; a inside {0, 255}; b inside {0, 255};  }) begin
        `uvm_error("SEQ", "Randomization failed for corner_case_test")
      end
      `uvm_info("SEQ", $sformatf("corner_case_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #100;
    end


  endtask
endclass