import os
import json

def convert_txt_to_json(txt_file, json_file):
    # Define the folder path where the files are located
    folder_path = "data"
    
    # Create the full paths for the input TXT file and output JSON file
    txt_file_path = os.path.join(folder_path, txt_file)
    json_file_path = os.path.join(folder_path, json_file)
    
    # Read the text file and strip any whitespace or newlines
    with open(txt_file_path, 'r') as file:
        proxies = [line.strip() for line in file]

    # Write the list of proxies to a JSON file
    with open(json_file_path, 'w') as file:
        json.dump(proxies, file, indent=4)

# Example usage
convert_txt_to_json('Proxies.txt', 'Proxies.json')