import json
import jinja2


try:
    with open('miniuartTem.json', 'r') as file:
        config = json.load(file)
except FileNotFoundError:
    print("Error: uart16550_uvm_test.json not found.")
    exit(1)
except json.JSONDecodeError as e:
    print(f"Error: Invalid JSON format - {e}")
    exit(1)

template_loader = jinja2.FileSystemLoader(searchpath="./")
template_env = jinja2.Environment(loader=template_loader)
template = template_env.get_template('transaction.j2')

try:
    name = config.get("name", "xtn")  
    signals = config.get("signals", [])  
    default_constraints = config.get("default_constraints", [])  
    registers = config.get("registers", []) 
except KeyError as e:
    print(f"Error: Missing required JSON field - {e}")
    exit(1)


try:
    output = template.render(
        name=name,
        signals=signals,
        default_constraints=default_constraints,  
        registers=registers
    )
except jinja2.exceptions.TemplateError as e:
    print(f"Error: Template rendering failed - {e}")
    exit(1)


try:
    with open(f'{name}_transaction.sv', 'w') as file:
        file.write(output)
except IOError as e:
    print(f"Error: Failed to write {name}_transaction.sv - {e}")
    exit(1)

print(f"Generated {name}_transaction.sv successfully.")