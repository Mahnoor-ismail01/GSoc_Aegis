
class basic_addition_test extends uvm_test;
  `uvm_component_utils(basic_addition_test)
  
  adder_env env;
  
  function new(string name = "basic_addition_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = adder_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    
    basic_addition_sequence seq;
    phase.raise_objection(this);
    seq = basic_addition_sequence::type_id::create("seq");
    seq.start(env.adder_agent.sequencer);
    phase.drop_objection(this);
    
  endtask
endclass