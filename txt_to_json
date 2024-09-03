import json

def convert_txt_to_json(txt_file, json_file):
    # Read the text file and strip any whitespace or newlines
    with open(txt_file, 'r') as file:
        proxies = [line.strip() for line in file]

    # Write the list of proxies to a JSON file
    with open(json_file, 'w') as file:
        json.dump(proxies, file, indent=4)

# Example usage
convert_txt_to_json('Proxies.txt', 'Proxies.json')