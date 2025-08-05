

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "miniuart_xtn.sv"

class miniuart_sequence extends uvm_sequence;
  `uvm_object_utils(miniuart_sequence)
  function new(string name = "miniuart_sequence");
    super.new(name);
  endfunction
  virtual task body();


    // Test case: reset_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: reset_test", UVM_MEDIUM)
    repeat(5) begin
      miniuart_xtn item = miniuart_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { WB_RST_I == 1;  }) begin
        `uvm_error("SEQ", "Randomization failed for reset_test")
      end
      `uvm_info("SEQ", $sformatf("reset_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #50;
    end

    // Test case: transmit_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: transmit_test", UVM_MEDIUM)
    repeat(10) begin
      miniuart_xtn item = miniuart_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { WB_WE_I == 1; WB_ADDR_I == 0; WB_DAT_I inside {[0:255]};  }) begin
        `uvm_error("SEQ", "Randomization failed for transmit_test")
      end
      `uvm_info("SEQ", $sformatf("transmit_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #100;
    end

    // Test case: receive_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: receive_test", UVM_MEDIUM)
    repeat(10) begin
      miniuart_xtn item = miniuart_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { WB_WE_I == 0; WB_ADDR_I == 0;  }) begin
        `uvm_error("SEQ", "Randomization failed for receive_test")
      end
      `uvm_info("SEQ", $sformatf("receive_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #100;
    end

    // Test case: baudrate_variation_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: baudrate_variation_test", UVM_MEDIUM)
    repeat(5) begin
      miniuart_xtn item = miniuart_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { WB_RST_I == 0; WB_DAT_I dist {0:/10, [1:255]:/90};  }) begin
        `uvm_error("SEQ", "Randomization failed for baudrate_variation_test")
      end
      `uvm_info("SEQ", $sformatf("baudrate_variation_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #200;
    end


  endtask
endclass