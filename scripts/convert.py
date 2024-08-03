import re,sys,os

# Function to convert print statements
def convert_print_statement(statement):
    # Define the regex patterns to match both forms of print statements
    pattern_parentheses = r'\bprint\s*\((.*?)\)'
    pattern_no_parentheses = r'\bprint\s+(\w+)'
    
    # Function to process matched groups for parentheses style
    def replacement_parentheses(match):
        # Split the variables by comma and strip whitespace
        variables = [var.strip() for var in match.group(1).split(',')]
        # Create the new print statement with variable names and values
        new_print = ', '.join([f'"{var}:", {var}' for var in variables])
        return f'print({new_print})'
    
    # Function to process matched groups for no parentheses style
    def replacement_no_parentheses(match):
        var = match.group(1).strip()
        return f'print("{var}:", {var})'

    # First, handle the parentheses style
    statement = re.sub(pattern_parentheses, replacement_parentheses, statement)
    # Then, handle the no parentheses style
    statement = re.sub(pattern_no_parentheses, replacement_no_parentheses, statement)
    
    return statement



if len(sys.argv) <= 1:
    print("python preprocessor requires file input",flush=True)
    sys.exit(1)
with open(sys.argv[1],"r") as gfg_file:
    file_content = gfg_file.read().split('\n')
    converted_statements = [convert_print_statement(stmt) for stmt in file_content]
    for row in converted_statements:
        print(row)