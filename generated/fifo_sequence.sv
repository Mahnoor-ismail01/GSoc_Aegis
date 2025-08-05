

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "fifo_xtn.sv"

class fifo_sequence extends uvm_sequence;
  `uvm_object_utils(fifo_sequence)
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  virtual task body();


    // Test case: reset_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: reset_test", UVM_MEDIUM)
    repeat(5) begin
      fifo_xtn item = fifo_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rst_n == 0;  }) begin
        `uvm_error("SEQ", "Randomization failed for reset_test")
      end
      `uvm_info("SEQ", $sformatf("reset_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #50;
    end

    // Test case: write_handshake_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: write_handshake_test", UVM_MEDIUM)
    repeat(16) begin
      fifo_xtn item = fifo_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rst_n == 1; wr_valid == 1; wr_ready == 1; rd_valid == 0;  }) begin
        `uvm_error("SEQ", "Randomization failed for write_handshake_test")
      end
      `uvm_info("SEQ", $sformatf("write_handshake_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #20;
    end

    // Test case: overflow_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: overflow_test", UVM_MEDIUM)
    repeat(17) begin
      fifo_xtn item = fifo_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rst_n == 1; wr_valid == 1; wr_ready == 1; rd_valid == 0;  }) begin
        `uvm_error("SEQ", "Randomization failed for overflow_test")
      end
      `uvm_info("SEQ", $sformatf("overflow_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #20;
    end

    // Test case: read_handshake_test (uses control_xtn)
    `uvm_info("SEQ", "Starting test case: read_handshake_test", UVM_MEDIUM)
    repeat(16) begin
      fifo_xtn item = fifo_xtn::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { rst_n == 1; wr_valid == 0; rd_valid == 1; rd_ready == 1;  }) begin
        `uvm_error("SEQ", "Randomization failed for read_handshake_test")
      end
      `uvm_info("SEQ", $sformatf("read_handshake_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #20;
    end


  endtask
endclass