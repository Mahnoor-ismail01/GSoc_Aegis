
import json
import os
import sys
from jinja2 import Environment, FileSystemLoader

def generate_files(vp_file):
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
    transaction_types = dut.get("transaction_types", [{"name": "default", "inputs": [], "outputs": [], "constraints": []}])
    test_cases = vp.get("test_cases", [])
    sim_time = dut.get("sim_time", 1000)

    # Validate transaction types
    for ttype in transaction_types:
        if "name" not in ttype or "inputs" not in ttype or "outputs" not in ttype:
            raise ValueError(f"Transaction type missing name, inputs, or outputs: {ttype}")
        for sig in ttype["inputs"] + ttype["outputs"]:
            if "name" not in sig or "width" not in sig:
                raise ValueError(f"Signal missing name or width: {sig}")
            if sig["width"] != "dynamic" and (not isinstance(sig["width"], int) or sig["width"] < 1):
                raise ValueError(f"Invalid width for signal {sig.get('name', 'unknown')}: {sig.get('width')}")
            if "type" not in sig:
                sig["type"] = "logic"
            if sig["width"] == "dynamic" and "bit_width" not in sig:
                raise ValueError(f"Dynamic signal {sig.get('name', 'unknown')} must include bit_width")
            if sig["width"] == "dynamic" and (not isinstance(sig.get("bit_width"), int) or sig.get("bit_width") < 1):
                raise ValueError(f"Invalid bit_width for dynamic signal {sig.get('name', 'unknown')}: {sig.get('bit_width')}")
            sig["path"] = sig.get("path", sig["name"])
            sig["description"] = sig.get("description", "")
            sig["constraints"] = sig.get("constraints", [])

    # Set up Jinja2 environment
    template_dir = os.path.dirname(os.path.abspath(__file__))
    env = Environment(loader=FileSystemLoader(template_dir))

    # Generate transaction files
    transaction_template = env.get_template('new_transaction.j2')
    os.makedirs("generated", exist_ok=True)
    for ttype in transaction_types:
        ttype_name = ttype["name"]
        transaction_file = f"generated/{dut_name}_{ttype_name}_packet.sv"
        try:
            with open(transaction_file, "w") as f:
                f.write(transaction_template.render(dut_name=dut_name, ttype_name=ttype_name, inputs=ttype["inputs"], outputs=ttype["outputs"], signals=ttype["inputs"] + ttype["outputs"], test_cases=test_cases, sim_time=sim_time))
            print(f"Generated {transaction_file}")
        except Exception as e:
            print(f"Error writing {transaction_file}: {e}")
            sys.exit(1)

    # Generate sequence files for each test case
    sequence_template = env.get_template('new_sequence.j2')
    for test_case in test_cases:
        sequence_name = f"{dut_name}_{test_case['name']}_seq"
        sequence_file = f"generated/{sequence_name}.sv"
        try:
            with open(sequence_file, "w") as f:
                f.write(sequence_template.render(dut_name=dut_name, sequence_name=sequence_name, transaction_type=transaction_types[0]["name"], test_case=test_case, sim_time=sim_time))
            print(f"Generated {sequence_file}")
        except Exception as e:
            print(f"Error writing {sequence_file}: {e}")
            sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_transaction.py <vp_json_file>")
        sys.exit(1)
    generate_files(sys.argv[1])
