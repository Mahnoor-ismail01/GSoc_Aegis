
import json
import os
import sys
from jinja2 import Template

def generate_testcase_template(vp_file):
    # Read VP JSON
    try:
        with open(vp_file, 'r') as f:
            vp = json.load(f)
    except Exception as e:
        print(f"Error reading VP file: {e}")
        sys.exit(1)

    # Extract DUT info
    dut = vp.get("dut", {"name": "dut"})
    dut_name = dut.get("name", "dut")
    transaction_types = dut.get("transaction_types", [{"name": "default", "inputs": [], "outputs": []}])
    test_cases = vp.get("test_cases", [])
    sim_time = dut.get("sim_time", 1000)

    # Validate transaction types
    for ttype in transaction_types:
        if "name" not in ttype or "inputs" not in ttype or "outputs" not in ttype:
            raise ValueError(f"Transaction type missing name, inputs, or outputs: {ttype}")
        for sig in ttype["inputs"] + ttype["outputs"]:
            if "name" not in sig or "width" not in sig:
                raise ValueError(f"Signal missing name or width: {sig}")
            print(f"Debug: Signal {sig.get('name', 'unknown')} has width {sig.get('width')}")
            if sig["width"] != "dynamic" and (not isinstance(sig["width"], int) or sig["width"] < 1):
                raise ValueError(f"Invalid width for signal {sig.get('name', 'unknown')}: {sig.get('width')}")
            if "type" not in sig:
                sig["type"] = "logic"  # Default to logic
            if not isinstance(sig["type"], str):
                raise ValueError(f"Invalid type for signal {sig.get('name', 'unknown')}: {sig.get('type')}")
            # Parse enum and struct types
            if sig["width"] == "dynamic" and "bit_width" not in sig:
                raise ValueError(f"Dynamic signal {sig.get('name', 'unknown')} must include bit_width")
            if sig["width"] == "dynamic" and (not isinstance(sig.get("bit_width"), int) or sig.get("bit_width") < 1):
                raise ValueError(f"Invalid bit_width for dynamic signal {sig.get('name', 'unknown')}: {sig.get('bit_width')}")
            if sig["type"].startswith("enum"):
                if "{" not in sig["type"] or "}" not in sig["type"]:
                    raise ValueError(f"Enum type for {sig.get('name', 'unknown')} must include values, e.g., 'enum {{IDLE, ACTIVE}}'")
                sig["enum_values"] = [v.strip() for v in sig["type"].split("{")[1].split("}")[0].split(",")]
            elif sig["type"].startswith("struct"):
                if "{" not in sig["type"] or "}" not in sig["type"]:
                    raise ValueError(f"Struct type for {sig.get('name', 'unknown')} must include fields, e.g., 'struct {{logic a; logic b;}}'")
                sig["struct_fields"] = sig["type"].split("{")[1].split("}")[0].strip()
            sig["path"] = sig.get("path", sig["name"])  # Default path to name
            sig["description"] = sig.get("description", "")  # Optional description
            sig["constraints"] = sig.get("constraints", [])  # Optional signal constraints

    # Validate test cases and set default trans_type
    default_trans_type = transaction_types[0]["name"] if transaction_types else "default"
    valid_trans_types = [ttype["name"] for ttype in transaction_types]
    for tc in test_cases:
        if "name" not in tc or "loops" not in tc or "constraints" not in tc:
            raise ValueError(f"Test case missing name, loops, or constraints: {tc}")
        if not isinstance(tc["loops"], int) or tc["loops"] < 1:
            raise ValueError(f"Invalid loops for test case {tc.get('name', 'unknown')}: {tc.get('loops')}")
        if not isinstance(tc["constraints"], list):
            raise ValueError(f"Constraints must be a list for test case {tc.get('name', 'unknown')}: {tc.get('constraints')}")
        tc["trans_type"] = tc.get("trans_type", default_trans_type)
        if tc["trans_type"] not in valid_trans_types:
            raise ValueError(f"Invalid trans_type {tc['trans_type']} in test case {tc.get('name', 'unknown')}")

    # Identify handshake signals per transaction type
    handshake_info = {}
    for ttype in transaction_types:
        handshake_inputs = [sig["name"] for sig in ttype["inputs"] if "valid" in sig["name"].lower() or "req" in sig["name"].lower()]
        handshake_outputs = [sig["name"] for sig in ttype["outputs"] if "ready" in sig["name"].lower() or "ack" in sig["name"].lower()]
        handshake_info[ttype["name"]] = {"inputs": handshake_inputs, "outputs": handshake_outputs}
        ttype["signals"] = ttype["inputs"] + ttype["outputs"]

    # Jinja2 templates
    templates = {}
    
    # Transaction file template for each transaction type
    for ttype in transaction_types:
        ttype_name = ttype["name"]
        templates[f"{dut_name}_{ttype_name}_packet.sv"] = """

import uvm_pkg::*;

class {{ dut_name }}_{{ ttype_name }}_packet extends uvm_sequence_item;
  `uvm_object_utils({{ dut_name }}_{{ ttype_name }}_packet)

{% for i in inputs %}
  {% if i.type.startswith('rand') %}
  {{ i.type }} {% if i.width == "dynamic" %}[{{ i.bit_width - 1 }}:0] {$} {% elif i.width > 1 and not i.type.startswith('enum') and not i.type.startswith('struct') %}[{{ i.width - 1 }}:0] {% endif %}{{ i.name }}; // {{ 'Handshake input' if i.name in handshake_inputs else 'Input' }}{% if i.description %} ({{ i.description }}){% endif %}
  {% else %}
  {{ i.type }} {% if i.width == "dynamic" %}[{{ i.bit_width - 1 }}:0] {$} {% elif i.width > 1 and not i.type.startswith('enum') and not i.type.startswith('struct') %}[{{ i.width - 1 }}:0] {% endif %}{{ i.name }}; // {{ 'Handshake input' if i.name in handshake_inputs else 'Input' }}{% if i.description %} ({{ i.description }}){% endif %}
  {% endif %}
  {% if i.constraints %}
  constraint {{ i.name }}_c { {% for c in i.constraints %}{{ c }}; {% endfor %} }
  {% endif %}
{% endfor %}

{% for o in outputs %}
  {% if o.type.startswith('rand') %}
  {{ o.type }} {% if o.width == "dynamic" %}[{{ o.bit_width - 1 }}:0] {$} {% elif o.width > 1 and not o.type.startswith('enum') and not o.type.startswith('struct') %}[{{ o.width - 1 }}:0] {% endif %}{{ o.name }}; // {{ 'Handshake output' if o.name in handshake_outputs else 'Output' }}{% if o.description %} ({{ o.description }}){% endif %}
  {% else %}
  {{ o.type }} {% if o.width == "dynamic" %}[{{ o.bit_width - 1 }}:0] {$} {% elif o.width > 1 and not o.type.startswith('enum') and not o.type.startswith('struct') %}[{{ o.width - 1 }}:0] {% endif %}{{ o.name }}; // {{ 'Handshake output' if o.name in handshake_outputs else 'Output' }}{% if o.description %} ({{ o.description }}){% endif %}
  {% endif %}
{% endfor %}
  function new(string name = "{{ dut_name }}_{{ ttype_name }}_packet");
    super.new(name);
  endfunction
  virtual function void do_copy(uvm_object rhs);
    {{ dut_name }}_{{ ttype_name }}_packet tmp;
    super.do_copy(rhs);
    if (!$cast(tmp, rhs)) `uvm_fatal("COPY", "Cast failed in do_copy")
{% for i in signals %}
    {% if i.width == "dynamic" %}
    foreach (tmp.{{ i.name }}[j]) this.{{ i.name }}[j] = tmp.{{ i.name }}[j];
    {% elif i.type.startswith('struct') or i.type.startswith('enum') %}
    this.{{ i.name }} = tmp.{{ i.name }};
    {% else %}
    this.{{ i.name }} = tmp.{{ i.name }};
    {% endif %}
{% endfor %}
  endfunction
  virtual function string convert2string();
    string s = $sformatf("{% for i in signals %}{% if i.width != 'dynamic' and not i.type.startswith('enum') and not i.type.startswith('struct') %}{{ i.path }}=%0{{ 'h' if i.width > 1 or i.type.startswith('enum') else 'b' }}{% if not loop.last %} {% endif %}{% endif %}{% endfor %}", {% for i in signals %}{% if i.width != 'dynamic' and not i.type.startswith('enum') and not i.type.startswith('struct') %}{{ i.name }}{% if not loop.last %}, {% endif %}{% endif %}{% endfor %});
    {% for i in signals %}
    {% if i.width == "dynamic" %}
    foreach ({{ i.name }}[j]) s = {s, $sformatf(" {{ i.path }}[%0d]=%0h", j, {{ i.name }}[j])};
    {% elif i.type.startswith('enum') %}
    s = {s, $sformatf(" {{ i.path }}=%s", {{ i.name }}.name())};
    {% elif i.type.startswith('struct') %}
    s = {s, $sformatf(" {{ i.path }}={enable=%0b, priority=%0h}", {{ i.name }}.enable, {{ i.name }}.priority)};
    {% endif %}
    {% endfor %}
    return s;
  endfunction
endclass
"""

    templates[f"{dut_name}_sequence.sv"] = """

`include "uvm_macros.svh"
import uvm_pkg::*;
{% for ttype in transaction_types %}
`include "{{ dut_name }}_{{ ttype.name }}_packet.sv"
{% endfor %}

class {{ dut_name }}_sequence extends uvm_sequence;
  `uvm_object_utils({{ dut_name }}_sequence)
  function new(string name = "{{ dut_name }}_sequence");
    super.new(name);
  endfunction
  virtual task body();
{% if test_cases %}
{% for tc in test_cases %}
    // Test case: {{ tc.name }} (uses {{ tc.trans_type }}_packet)
    `uvm_info("SEQ", "Starting test case: {{ tc.name }}", UVM_MEDIUM)
    repeat({{ tc.loops }}) begin
      {{ dut_name }}_{{ tc.trans_type }}_packet item = {{ dut_name }}_{{ tc.trans_type }}_packet::type_id::create("item");
      start_item(item);
      if (!item.randomize() with { {% for c in tc.constraints %}{{ c }}; {% endfor %} }) begin
        `uvm_error("SEQ", "Randomization failed for {{ tc.name }}")
      end
      `uvm_info("SEQ", $sformatf("{{ tc.name }}: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #{{ tc.delay|default(10) }};
    end
{% endfor %}
{% else %}
    `uvm_info("SEQ", "Running default test case", UVM_MEDIUM)
    repeat(10) begin
      {{ dut_name }}_{{ default_trans_type }}_packet item = {{ dut_name }}_{{ default_trans_type }}_packet::type_id::create("item");
      start_item(item);
      if (!item.randomize()) `uvm_error("SEQ", "Randomization failed for default_test")
      `uvm_info("SEQ", $sformatf("default_test: %s", item.convert2string()), UVM_MEDIUM)
      finish_item(item);
      #10;
    end
{% endif %}
  endtask
endclass
"""

    templates[f"{dut_name}_test.sv"] = """

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "{{ dut_name }}_sequence.sv"

class {{ dut_name }}_test extends uvm_test;
  `uvm_component_utils({{ dut_name }}_test)
  function new(string name = "{{ dut_name }}_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    {{ dut_name }}_sequence seq = {{ dut_name }}_sequence::type_id::create("seq");
    `uvm_info("TEST", "Starting {{ dut_name }}_sequence", UVM_MEDIUM)
    seq.start(null);
    #{{ sim_time }};
    phase.drop_objection(this);
  endtask
endclass
"""

    # Generate files
    os.makedirs("generated", exist_ok=True)
    for filename, template_str in templates.items():
        template = Template(template_str)
        content = template.render(
            dut_name=dut_name,
            transaction_types=transaction_types,
            test_cases=test_cases,
            sim_time=sim_time,
            default_trans_type=default_trans_type,
            ttype_name=filename.split('_')[1] if filename.endswith('_packet.sv') else None,
            inputs=next((ttype["inputs"] for ttype in transaction_types if ttype["name"] == filename.split('_')[1]), []) if filename.endswith('_packet.sv') else [],
            outputs=next((ttype["outputs"] for ttype in transaction_types if ttype["name"] == filename.split('_')[1]), []) if filename.endswith('_packet.sv') else [],
            signals=next((ttype["signals"] for ttype in transaction_types if ttype["name"] == filename.split('_')[1]), []) if filename.endswith('_packet.sv') else [],
            handshake_inputs=next((handshake_info[ttype["name"]]["inputs"] for ttype in transaction_types if ttype["name"] == filename.split('_')[1]), []) if filename.endswith('_packet.sv') else [],
            handshake_outputs=next((handshake_info[ttype["name"]]["outputs"] for ttype in transaction_types if ttype["name"] == filename.split('_')[1]), []) if filename.endswith('_packet.sv') else []
        )
        output_file = f"generated/{filename}"
        try:
            with open(output_file, "w") as f:
                f.write(content)
            print(f"Generated {output_file}")
        except Exception as e:
            print(f"Error writing {output_file}: {e}")
            sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_testcase_template_uvm_jinja.py <vp_json_file>")
        sys.exit(1)
    generate_testcase_template(sys.argv[1])