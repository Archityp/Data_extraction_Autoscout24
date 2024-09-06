# Importing all needed libraries 
import requests
from bs4 import BeautifulSoup
import pandas as pd
from fake_useragent import UserAgent
import time
import random
import re
import os
from datetime import datetime
from multiprocessing import Pool, cpu_count, Lock
import json

# List of free proxy IP addresses
# Function to get a random proxy
def get_random_proxy():
    try:
        with open(r'data', 'r') as file:
            proxies = json.load(file)
        if proxies:
            return random.choice(proxies)
        else:
            raise ValueError("Proxy list is empty.")
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading proxies: {e}")
        return None
    
# Initialize a session
url_prefix = 'https://www.autoscout24.de/'
ua = UserAgent()
session = requests.Session()
# Set a random User-Agent for the session
session.headers.update({'User-Agent': ua.random})
session.proxies.update({'http': get_random_proxy()})

# Scraping  settings
# before scraping would be better to take a look on listing manualy to chose most preferable settings 
#big ranges causes data loss up to 10% and possible encoding problems
brand_name = 'audi'
price_ranges = [(0, 2000),(2000, 4000),(4000, 6000),(6000, 8000),(8000, 10000),(10000, 14000),(14000, 18000)]
price_step = 1000
year_ranges = [(1999, 1990),(1999, 1990),(1999, 1990),(1999, 1990),(1999, 1990),(1999, 1990),(1999, 1990)]

# Define variable for file naming
max_year = max([year for year_range in year_ranges for year in year_range])
min_year = min([year for year_range in year_ranges for year in year_range])
max_price = max([price_end for _, price_end in price_ranges])
min_price = min([price_start for price_start,_ in price_ranges])

# Pauses the program for a random amount of time between min_time and max_time seconds.
def random_sleep(min_time=1, max_time=5):
    time_to_sleep = random.uniform(min_time, max_time)
    time.sleep(time_to_sleep)

# Function to read existing CSV and concatenate new data
def update_csv(df, csv_path):
    # Check if the CSV file already exists
    if os.path.exists(csv_path):
        df_existing = pd.read_csv(csv_path)
        # Concatenate existing data with the new data
        df_existing = pd.concat([df_existing, df], ignore_index=True)
        df_existing = df_existing.loc[:, ~df_existing.columns.str.contains('^Unnamed')]
        df_existing.to_csv(csv_path, index=False)
    else:
        df.to_csv(csv_path, index=False)

def standardize_columns(df, all_columns):
    return df.reindex(columns=all_columns)

# Function to scrape the main page
def scrape_autoscout(year_range, price_range, price_step, csv_path, chunk_size=20):
    session.proxies.update({'http': get_random_proxy()})
    session.headers.update({'User-Agent': ua.random})

    year_start, year_end = year_range
    price_start, price_end = price_range

    # List to store the scraped data
    data_chunk = []
    all_columns = []  # To store all columns in order

    # Add a delay of 1-5 seconds between setting filters
    random_sleep()
    for year in range(year_start, year_end -1,-1):
        print('Scraping for year:', year)
        random_sleep()
        for price in range(price_start, price_end + 1, price_step):
            print(f'Scraping for price: {price} to {price + price_step - 1}')
            random_sleep()
            try:
                # Loop over page numbers 1 to 20
                for i in range(1, 21):
                    print(f'Reading page, {i} for price range {price} to {price + price_step - 1}')
                    try:
                        session.headers.update({'User-Agent': ua.random})
                        session.proxies.update({'http': get_random_proxy()})
                        # Construct the URL for the current page            
                        page_url = f'https://www.autoscout24.de/lst/{brand_name}?atype=C&cy=D&damaged_listing=exclude&desc=0&fregfrom={year}&fregto={year}&ocs_listing=include&page={i}&powertype=kw&pricefrom={price}&priceto={price + price_step - 1}&search_id=1eooq1r6owb&sort=standard&source=listpage_pagination&ustate=N%2CU'

                        # Get the webpage content
                        response = session.get(page_url, timeout=200)
                        response.raise_for_status()
                        soup = BeautifulSoup(response.content, 'html.parser')

                        # Find links to individual car listings ( empty pages still offers some car listings we do not need)
                        offer_list = [link.get('href') for link in soup.find_all('a', href=True) if '/angebote/' in link['href'] and '/leasing/' not in link['href'] and '/recommendation/' not in link['href']]
                        if not offer_list:
                            print('No listings found on page', i)
                            break

                        # Visit each car listing page and extract information
                        for item in offer_list:
                            # Construct the URL for the current car listing
                            car_url = url_prefix + item
                        
                            # Get the webpage content for the car listing
                            page = session.get(car_url)
                            soup = BeautifulSoup(page.text, 'html.parser')

                            # Find all elements with the specified classes
                            titles_elements = soup.find_all(class_="VehicleOverview_itemTitle__S2_lb")
                            info_elements = soup.find_all(class_="VehicleOverview_itemText__AI4dA")

                            # Find dt and dd elements
                            dt_elements = soup.find_all('dt')
                            dd_elements = soup.find_all('dd')

                            # Create a dictionary to store the data
                            table_data = {}

                            table_data['car_url'] = car_url

                            # Scraping for specific elements like price, location, brand, model
                            price_element = soup.find(class_="PriceInfo_price__XU0aF")
                            if price_element:
                                price_text = price_element.text.strip()
                                # Check if the price contains "mtl." (indicating a monthly rate)
                                if "mtl." not in price_text:
                                    table_data['Price'] = price_text
                                else:
                                    table_data['Price'] = None  # or skip adding this entry if desired
                            else:
                                table_data['Price'] = None

                            location_element = soup.find(class_="scr-link LocationWithPin_locationItem__tK1m5")
                            if location_element:
                                location = location_element.text.strip()
                            else:
                                location = None
                            table_data['Location'] = location

                            brand_element = soup.find(class_="StageTitle_boldClassifiedInfo__sQb0l")
                            if brand_element:
                                brand = brand_element.text.strip()
                            else:
                                brand = None
                            table_data['Brand'] = brand

                            model_element = soup.find(class_="StageTitle_model__EbfjC StageTitle_boldClassifiedInfo__sQb0l")
                            if model_element:
                                model = model_element.text.strip()
                            else:
                                model = None
                            table_data['Model'] = model

                            modelversion_element = soup.find(class_='StageTitle_modelVersion__Yof2Z')
                            if modelversion_element:
                                model_version = modelversion_element.text.strip()
                            else:
                                model_version = None
                            table_data['Model_version'] = model_version

                            # Find the title tag "Verkäufer"(seller)
                            seller_title_element = soup.find('div', class_="VehicleOverview_itemTitle__S2_lb", string=lambda text: "verkäufer" in text.lower())
                            if seller_title_element:
                                seller_info_element = seller_title_element.find_next('div').find_next('div')
                                if seller_info_element:
                                    seller_info = seller_info_element.get_text(strip=True)
                                else:
                                    seller_info = None
                            else:
                                seller_info = None
                            table_data['Seller_info'] = seller_info

                            # Define the scraping date
                            table_data['Scraping_Date'] = datetime.now().strftime('%Y-%m-%d')

                            # Dictionary to store the insurance information
                            insurance_info = {'Haftpflicht': None, 'Teilkasko': None, 'Vollkasko': None}

                            # Find all divs that contain insurance information
                            insurance_divs = soup.find_all('div', class_='InsuranceInfoGrid_insuranceVariationCardStyle__VGuJY')

                            for div in insurance_divs:
                                # Find the label (Haftpflicht, Teilkasko, or Vollkasko)
                                label_div = div.find('div', class_='InsuranceInfoGrid_insuranceTileLabelWrapper__7AE8t')
                                if label_div:
                                    label_p = label_div.find('p', class_='InsuranceInfoGrid_insuranceVariantLabel__AUhbM')
                                    if label_p:
                                        label = label_p.get_text(strip=True)

                                        # Find the corresponding rate
                                        rate_div = div.find('div', class_='InsuranceInfoGrid_insuranceTileRateWrapper__J8TIt')
                                        if rate_div:
                                            rate_p = rate_div.find('p', class_='InsuranceInfoGrid_insuranceVariantLabel__AUhbM')
                                            if rate_p:
                                                rate = rate_p.get_text(strip=True)

                                                # Update the dictionary with the found rate
                                                if label in insurance_info:
                                                    insurance_info[label] = rate

                            # Update table_data with insurance info
                            table_data.update(insurance_info)

                            # Populate the dictionary with dt and dd elements
                            for key, value in zip(dt_elements, dd_elements):
                                table_data[key.text.replace('\n','')] = value.text.replace('\n','')

                            # Function to add space before camel case words
                            def add_space_to_camel_case(s):
                                return re.sub(r'(?<!^)(?=[A-Z])', ' ', s)
                                    
                            # Apply the function to specific fields in the dictionary
                            for key in ['Komfort', 'Unterhaltung/Media', 'Sicherheit', 'Extras']:
                                if key in table_data:
                                    table_data[key] = add_space_to_camel_case(table_data[key])

                            # Introduce a random delay between 1 to 3 seconds before the next request
                            random_sleep()

                            # Create DataFrame
                            df = pd.DataFrame(table_data, index=[0])
                            all_columns.extend([col for col in df.columns if col not in all_columns])


                            for title, info in zip(titles_elements, info_elements):
                            # Update the set of all columns encountered so far
                                # Extract and clean the text from title and info elements
                                title_text = title.get_text(strip=True)
                                info_text = info.get_text(strip=True)
                                
                                # Check if the column already exists in the DataFrame
                                if title_text not in df.columns:
                                    # Add the new column to the DataFrame
                                    df[title_text] = info_text
                                    if title_text not in all_columns:
                                        all_columns.append(title_text)

                            # Create DataFrame for this car listing
                            if table_data:
                                df = pd.DataFrame(table_data, index=[0]).reindex(columns=all_columns)
                                if not df.empty:
                                    df = df.replace('�', '?')
                                    if not df.apply(lambda row: row.astype(str).str.contains('�').any(), axis=1).any():
                                        data_chunk.append(df)
                                        print(f"Appended data for {year_range} - {price + price_step - 1} with proxy {get_random_proxy()}")

                            if len(data_chunk) >= chunk_size:
                                all_data_df = pd.concat(data_chunk, ignore_index=True).reindex(columns=all_columns, fill_value=None)
                                all_data_df = all_data_df.drop_duplicates()
                                update_csv(all_data_df, csv_path)
                                data_chunk.clear()

                        random_sleep()

                    except requests.RequestException as e:
                        print(f"Error scraping {car_url} with proxy {get_random_proxy()}: {e}")
                        continue     
                    
                if data_chunk:
                    all_data_df = pd.concat(data_chunk, ignore_index=True).reindex(columns=all_columns, fill_value=None)
                    all_data_df = all_data_df.drop_duplicates()
                    update_csv(all_data_df, csv_path)
                    data_chunk.clear()

            except requests.RequestException as e:
                print(f"Error scraping {car_url} with proxy {get_random_proxy()}: {e}")
                continue    

if __name__ == "__main__":
    lock = Lock()

    folder_path = rf'Your\folder\name\{brand_name}'
    os.makedirs(folder_path, exist_ok=True)
    tasks = [(yr, pr, price_step, os.path.join(folder_path, f'{brand_name}-year-{yr[1]}-{yr[0]}-price-{pr[0]}-{pr[1]}.csv'))
            for yr, pr in zip(year_ranges, price_ranges)]
    # Use multiprocessing to scrape in parallel
    with Pool(cpu_count() - 1) as pool:
        pool.starmap(scrape_autoscout, tasks)
    print(f"Scraping completed - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


