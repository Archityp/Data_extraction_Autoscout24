import pandas as pd
import json
import os
import time
import random
import re
from googletrans import Translator


# Define the input file name
input_filename = 'unioned_data.csv'

def clean_csv(input_file, output_file):
    try:
        columns_to_remove = ['column1']  # Replace with your actual column names
        df = pd.read_csv(input_file, encoding='utf-8')
        df_cleaned = df.dropna(subset=['Price', 'car_url'])
        df_cleaned = df_cleaned[(df_cleaned['Price'] != '') & (df_cleaned['car_url'] != '')]
        # Delete columns that contain 'Unnamed' in their names
        df_cleaned = df_cleaned.loc[:, ~df_cleaned.columns.str.contains('^Unnamed')]
        # Delete specific columns defined in the function
        df_cleaned = df_cleaned.drop(columns=columns_to_remove, errors='ignore')
        df_cleaned.to_csv(output_file, index=False, encoding='utf-8')
        print(f"Data cleaning complete. Cleaned data saved to '{output_file}'.")
    except Exception as e:
        print(f"An error occurred in cleaning: {e}")

def translate_columns(input_file, output_file, translation_file="columns_translation.json"):
    
    try:
        # Load the translation dictionary from the JSON file
        if os.path.exists(translation_file):
            with open(translation_file, 'r') as f:
                translation_dict = json.load(f)
        else:
            raise FileNotFoundError(f"Translation file {translation_file} not found.")

        df = pd.read_csv(input_file)
        df.rename(columns=lambda x: translation_dict.get(x, x), inplace=True)
        df.to_csv(output_file, index=False)
        print(f"Translation complete. Translated data saved to '{output_file}'.")
    except pd.errors.ParserError as e:
        print(f"Error reading CSV file: {e}")
    except Exception as e:
        print(f"An error occurred in translation: {e}")

def translate_data(input_file, output_file, cache_file):
    # Initialize the translator
    translator = Translator()

    # Define columns for word-by-word and whole text translation
    columns_word_by_word = ['Duration', 'Environmental_sticker', 'Fuel_type']
    columns_as_whole = ['Body_type','Other_energy_source', 'Vehicle_type', 'Transmission', 'Exterior_color', 'Paintwork', 'Interior_color', 'Seller_info', 'Seller', 'Drive_type', 'Vehicle_condition', 'Interior_equipment']

    # Load translation cache if it exists
    if os.path.exists(cache_file):
        with open(cache_file, 'r') as f:
            translation_cache = json.load(f)
    else:
        translation_cache = {}

    REQUEST_DELAY = 3

    def is_non_translatable(text):
        """Check if the text contains numbers, special characters, or format strings."""
        # Regex to match dates, currency formats, or other non-words
        return re.fullmatch(r'\d+[\.,\d]*|\s*[\u20ac]|[^\w\s]', text) is not None

    def translate_word(word, retries=3):
        """Translate a single word with retry mechanism and caching."""
        if is_non_translatable(word):
            return word
    
        if word in translation_cache:
            return translation_cache[word]
        
        if re.fullmatch(r'\d+|[^\w\s]', word):
            return word
        attempt = 0
        while attempt < retries:
            try:
                translated_word = translator.translate(word, src='de', dest='en').text
                if translated_word is None:
                    return word
                translation_cache[word] = translated_word
                time.sleep(REQUEST_DELAY)
                return translated_word
            except Exception as e:
                attempt += 1
                time.sleep(random.uniform(2, 5))
        return word

    def translate_text_word_by_word(text, delimiter=' '):
        """Translate text by translating each word separately."""
        if len(text) > 50:
            return text
        words = text.split(delimiter)
        return delimiter.join(translate_word(word.strip()) for word in words if word.strip())

    def translate_text_as_whole(text):
        """Translate the entire text as a whole."""
        if len(text) > 50:
            return text
        return translate_word(text)

    try:
        df = pd.read_csv(input_file)
        # Apply translation to columns
        for col in columns_word_by_word:
            if col in df.columns:
                df[col] = df[col].astype(str).apply(lambda x: translate_text_word_by_word(x, delimiter=' '))

        for col in columns_as_whole:
            if col in df.columns:
                df[col] = df[col].astype(str).apply(translate_text_as_whole)

        # Save the updated cache
        with open(cache_file, 'w') as f:
            json.dump(translation_cache, f, indent=4)

        # Save the translated DataFrame to a new CSV file
        df.to_csv(output_file, index=False)
        print(f"Translation complete. Data saved to '{output_file}'.")

    except Exception as e:
        print(f"An error occurred in final translation: {e}")

def run_all_tasks(input_filename):
    # Define file names for intermediate and final outputs
    cleaned_filename = f'cleaned_{input_filename}'
    translated_filename = f'translated_{input_filename}'
    final_output_filename = f'translated_all_{input_filename}'
    cache_file = 'translation_cache.json'

    # Task 1: Clean the CSV file
    clean_csv(input_filename, cleaned_filename)

    # Task 2: Translate column names
    translate_columns(cleaned_filename, translated_filename)

    # Task 3: Translate data within the CSV file
    translate_data(translated_filename, final_output_filename, cache_file)

# Run all tasks
run_all_tasks(input_filename)
