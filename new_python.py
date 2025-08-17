
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

    # Validate transaction types and signals
    for ttype in transaction_types:
        if not all(key in ttype for key in ["name", "inputs", "outputs"]):
            raise ValueError(f"Transaction type missing required fields: {ttype}")
        for sig in ttype["inputs"] + ttype["outputs"]:
            if not all(key in sig for key in ["name", "width"]):
                raise ValueError(f"Signal missing required fields: {sig}")
            if sig["width"] != "dynamic" and (not isinstance(sig["width"], int) or sig["width"] < 1):
                raise ValueError(f"Invalid width for signal {sig.get('name', 'unknown')}: {sig.get('width')}")
            # Ensure adder inputs a and b are 8-bit
            if sig["name"] in ["a", "b"] and sig["width"] != 8:
                raise ValueError(f"Signal {sig.get('name', 'unknown')} must have width 8 for adder")
            sig["type"] = sig.get("type", "logic")
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
        trans_type = test_case.get("trans_type", transaction_types[0]["name"])
        matching_ttype = next((t for t in transaction_types if t["name"] == trans_type), transaction_types[0])
        sequence_file = f"generated/{sequence_name}.sv"
        try:
            with open(sequence_file, "w") as f:
                f.write(sequence_template.render(dut_name=dut_name, sequence_name=sequence_name, transaction_type=matching_ttype["name"], test_case=test_case, sim_time=sim_time))
            print(f"Generated {sequence_file}")
        except Exception as e:
            print(f"Error writing {sequence_file}: {e}")
            sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python new_python.py <vp_json_file>")
        sys.exit(1)
    generate_files(sys.argv[1])