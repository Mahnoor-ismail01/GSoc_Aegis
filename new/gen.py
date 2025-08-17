import json
from jinja2 import Template, Environment, FileSystemLoader

def generate_uvm_files(json_file_path, output_dir='.'):
    # Load the JSON file
    with open(json_file_path, 'r') as f:
        data = json.load(f)

    # Set up Jinja environment (assuming templates are strings or in a directory)
    # For simplicity, we'll define templates as strings here
    # In a real scenario, you can use FileSystemLoader for external template files

    # Transaction Template
    transaction_template_str = """
class {{ dut.name }}_transaction extends uvm_object;
  `uvm_object_utils({{ dut.name }}_transaction)
  
  {% for signal in dut.signals %}
  {% if signal.is_queue | default(false) %}
  rand {{ signal.type }} [{{ signal.width-1 }}:0] {{ signal.name }}[$];
  {% else %}
  rand {{ signal.type }} [{{ signal.width-1 }}:0] {{ signal.name }};
  {% endif %}
  {% if signal.constraints %}
  constraint c_{{ signal.name }} { {{ signal.constraints }}; }
  {% endif %}
  {% endfor %}
  
  {% for feature in dut.features | default([]) %}
  {% if feature.name == "burst_support" %}
  constraint data_size { wdata.size() == awlen + 1; }
  {% for func in feature.functions | default([]) %}
  function {{ func.return_type }} {{ func.name }}();
    case (awburst)
      {% for case in func.logic | default([]) %}
      {{ case.case }}: return {{ case.return }};
      {% endfor %}
      default: return awaddr;
    endcase
  endfunction
  {% endfor %}
  {% endif %}
  {% endfor %}
  
  `uvm_object_utils_begin({{ dut.name }}_transaction)
  {% for signal in dut.signals %}
  {% if signal.is_queue | default(false) %}
    `uvm_field_array_int({{ signal.name }}, {{ signal.field_flags | default('UVM_ALL_ON') }})
  {% else %}
    `uvm_field_int({{ signal.name }}, {{ signal.field_flags | default('UVM_ALL_ON') }})
  {% endif %}
  {% endfor %}
  `uvm_object_utils_end
  
  function new(string name = "{{ dut.name }}_transaction");
    super.new(name);
  endfunction
endclass
"""

    # Sequence Template (per testcase)
    sequence_template_str = """
class {{ testcase.name }}_sequence extends uvm_sequence #({{ testcase.protocol }}_transaction);
  `uvm_object_utils({{ testcase.name }}_sequence)
  
  function new(string name = "{{ testcase.name }}_sequence");
    super.new(name);
  endfunction
  
  task body();
    {{ testcase.protocol }}_transaction tx;
    {% if testcase.sequence.type == "burst_write" %}
    repeat({{ testcase.sequence.count | default(1) }}) begin
      tx = {{ testcase.protocol }}_transaction::type_id::create("tx");
      start_item(tx);
      {% for key, value in testcase.sequence.constraints.items() %}
      tx.{{ key }} = {{ value }};
      {% endfor %}
      {% if testcase.sequence.handshaking %}
      tx.awvalid = {{ testcase.sequence.handshaking.awvalid | default(1) }};
      tx.wvalid = {{ testcase.sequence.handshaking.wvalid | default(1) }};
      {% if testcase.sequence.handshaking.wlast %}
      tx.wlast = (tx.wdata.size() == {{ testcase.sequence.constraints.awlen }} + 1);
      {% endif %}
      {% endif %}
      finish_item(tx);
    end
    {% elif testcase.sequence.type == "error" %}
    tx = {{ testcase.protocol }}_transaction::type_id::create("tx");
    start_item(tx);
    {% for key, value in testcase.sequence.constraints.items() %}
    tx.{{ key }} = {{ value }};
    {% endfor %}
    finish_item(tx);
    {% else %}
    tx = {{ testcase.protocol }}_transaction::type_id::create("tx");
    start_item(tx);
    finish_item(tx);
    {% endif %}
  endtask
endclass
"""

    # Test Template (per testcase)
    test_template_str = """
class {{ testcase.name }}_test extends uvm_test;
  `uvm_component_utils({{ testcase.name }}_test)
  
  {{ dut.name }}_env env;
  
  function new(string name = "{{ testcase.name }}_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = {{ dut.name }}_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    {% if testcase.protocol %}
    {{ testcase.name }}_sequence seq;
    phase.raise_objection(this);
    seq = {{ testcase.name }}_sequence::type_id::create("seq");
    seq.start(env.{{ testcase.protocol }}_agent.sequencer);
    phase.drop_objection(this);
    {% elif testcase.virtual_sequence %}
    {{ testcase.virtual_sequence.name }} vseq;
    phase.raise_objection(this);
    vseq = {{ testcase.virtual_sequence.name }}::type_id::create("vseq");
    vseq.start(env.virtual_sequencer);
    phase.drop_objection(this);
    {% endif %}
  endtask
endclass
"""

    # Create Jinja templates
    env = Environment()
    transaction_template = env.from_string(transaction_template_str)
    sequence_template = env.from_string(sequence_template_str)
    test_template = env.from_string(test_template_str)

    # Assume data has 'dut' and 'testcases'
    dut = data.get('dut', {})
    testcases = data.get('testcases', [])

    # Generate transaction file (one per DUT)
    if dut:
        transaction_content = transaction_template.render(dut=dut)
        transaction_file_path = f"{output_dir}/{dut.get('name', 'dut')}_transaction.sv"
        with open(transaction_file_path, 'w') as f:
            f.write(transaction_content)
        print(f"Generated: {transaction_file_path}")

    # Generate sequence and test files per testcase
    for testcase in testcases:
        # Sequence file
        sequence_content = sequence_template.render(testcase=testcase, dut=dut)
        sequence_file_path = f"{output_dir}/{testcase.get('name', 'testcase')}_sequence.sv"
        with open(sequence_file_path, 'w') as f:
            f.write(sequence_content)
        print(f"Generated: {sequence_file_path}")

        # Test file
        test_content = test_template.render(testcase=testcase, dut=dut)
        test_file_path = f"{output_dir}/{testcase.get('name', 'testcase')}_test.sv"
        with open(test_file_path, 'w') as f:
            f.write(test_content)
        print(f"Generated: {test_file_path}")

# Example usage
generate_uvm_files('adder.json', output_dir='output')