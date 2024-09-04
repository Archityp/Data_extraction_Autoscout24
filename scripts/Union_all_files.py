import pandas as pd
import os
import numpy as np

# Usage
folder_path = r'Folder with your csv files'
columns_to_remove = ['Komfort', 'Unterhaltung/Media', 'Sicherheit', 'Extras']

def clean_and_remove_columns(df, columns_to_remove):
    # Drop specified columns
    df = df.drop(columns=[col for col in columns_to_remove if col in df.columns], errors='ignore')
    df = df.loc[:, ~df.columns.str.contains('^Unnamed')]
    df.replace('', np.nan, inplace=True)
    return df

def read_and_clean_csv(file, columns_to_remove):
    try:
        # Read the CSV file
        df = pd.read_csv(file, on_bad_lines='skip', delimiter=',', quoting=1, low_memory=False)
        
        # Clean the DataFrame by removing specified columns
        df = clean_and_remove_columns(df, columns_to_remove)
        
        # Print the number of rows in the file
        print(f"File: {file} - Rows: {len(df)}")
        
        return df
    except Exception as e:
        print(f"Error reading {file}: {e}")
        return pd.DataFrame()

def union_csv_files(folder, columns_to_remove):
    all_dfs = []
    files = [os.path.join(folder, f) for f in os.listdir(folder) if f.endswith('.csv')]
    
    print("Starting the concatenation process...")
    
    for file in files:
        df = read_and_clean_csv(file, columns_to_remove)
        if not df.empty:
            all_dfs.append(df)

    if not all_dfs:
        print("No valid data found.")
        return

    # Concatenate all DataFrames
    df_union = pd.concat(all_dfs, ignore_index=True, sort=False)
    
    print(f"Total rows after concatenation: {len(df_union)}")

    # Save the concatenated DataFrame
    output_file = os.path.join(folder, 'unioned_data.csv')
    df_union.to_csv(output_file, index=False)
    print(f"Concatenated data saved to {output_file}")

# Execute the function
union_csv_files(folder_path, columns_to_remove)