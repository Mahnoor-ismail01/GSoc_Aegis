
import uvm_pkg::*;
`include "adder_add_operation_packet.sv"

class adder_addition_test_seq extends uvm_sequence;
  `uvm_object_utils(adder_addition_test_seq)

  // Reference to the transaction packet
  rand adder_add_operation_packet pkt;

  // Constructor
  function new(string name = "adder_addition_test_seq");
    super.new(name);
  endfunction

  // Body task to generate and randomize transactions
  virtual task body();
    repeat (10) begin
      `uvm_info("SEQUENCE", $sformatf("Starting iteration %0d for %s", this.get_sequence_id(), "addition_test"), UVM_LOW)
      pkt = adder_add_operation_packet::type_id::create("pkt");
      if (!pkt.randomize() with {
        
        rstn == 1;
        
        a inside {[0:255]};
        
        b inside {[0:255]};
        
      }) begin
        `uvm_error("RANDOMIZE", "Randomization failed")
      end

      // Apply delay
      #100;

      // Start item and finish item
      start_item(pkt);
      finish_item(pkt);

  
  endtask
endclass