# German Cars Data Analysis

This is my data analysis project that scrapes, translates, aggregates, and cleans data from the German website [Autoscout24.de](https://www.autoscout24.de).
## Final result 
  [Tableau visualisations](https://public.tableau.com/views/Cars_17253617283710/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
  Or in a folder dashboards
## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Additional Information](#additional-information)

## Installation

### Prerequisites
- [Python 3.x](https://www.python.org/)

### Steps to Install
1.	Clone the repository:
```bash
    git clone https://github.com/Archityp/Webscraping_Autoscout24.git
```
2.	Navigate to the project directory:
  ```bash
    cd yourproject
```
3.	Install dependencies:
  ```bash
    pip install -r requirements.txt
```
## Usage

### Project Overview
This project consists of several components:

- **Convert txt to JSON:** Converts a list of proxies from a `.txt` format to `.json`.
- **Web Scraper:** Scrapes data from a car listings website.
- **Union:** Merges collected CSV files into one.
- **Translation and Aggregation:** Translates and aggregates the scraped data for further analysis.

## Setup Instructions

1. **Download Proxy List**  
   Go to  [ProxyScrape](https://proxyscrape.com/free-proxy-list) and download a proxy list in the format `protocol://ip:port` as a `.txt` file.  
   Save this file in the `data` folder and run the `Convert txt to JSON` script to convert the proxy list into a `proxies.json` file that the web scraper will use.

2. **Configure the Web Scraper**  
   Before running the web scraper, set the following variables in the script:
   - `brand_name = 'audi'` — specify the brand name exactly as it appears on the website.
   - `price_ranges = [(0, 10000), (10000, 20000)]` — define the price ranges for scraping.
   - `price_step = 1000` — set the step to increment the search prices.
   - `year_ranges = [(1999, 1990)]` — set the range of years you want to scrape.

   **Example Configuration:**
   ```python
   brand_name = 'audi'
   price_ranges = [(0, 10000), (10000, 20000)]
   year_ranges = [(1999, 1990)]
   ```

   The scraper will collect all car listings for Audi cars within those price and year ranges. # German Cars Data Analysis.
   Each `year_range` and `price_range` combination runs as a separate process, so:
   
• 2 ranges = 2 processes  
• 8 ranges = 8 processes

4. **Run the Web Scraper**  
   After setting up the scraper, run the script. After collecting the first 50 offers, a new folder with CSV files will be created.

5. **Union CSV Files**  
   Once you have the scraped data, use the Union_all_files script to merge all CSV files into a single file.

6. **Translation and Aggregation**  
   Finally, run the Translation_and_precleaning script to translate the German data into English and aggregate the data for further analysis.

7. **SQL Cleaning**  
   After generating the final CSV file, upload it to your database management system (e.g., SQL Server), create a backup using the first row and run Cleaning_and_aggregating SQL query for final data cleaning.

## Examples

### Scraping for Audi (1999–1990) in the price range 0–18,000:
```python
brand_name = 'audi'
price_ranges = [
    (0, 2000), (2000, 4000), (4000, 6000), 
    (6000, 8000), (8000, 10000), (10000, 14000), 
    (14000, 18000)
]
price_step = 1000
year_ranges = [
    (1999, 1990), (1999, 1990), (1999, 1990), 
    (1999, 1990), (1999, 1990), (1999, 1990), 
    (1999, 1990)
]
```

### Scraping for BMW (2024–2020) in the price range 0–100,000:
```python
brand_name = 'BMW'
price_ranges = [
    (0, 100000), (0, 100000), (0, 100000), 
    (0, 100000), (0, 100000)
]
price_step = 1000
year_ranges = [
    (2024, 2024), (2023, 2023), (2022, 2022), 
    (2021, 2021), (2020, 2020)
]
```

## Additional Information

### Known Limitations
• The script does not currently scrape information on brand-new 2024 cars without mileage. This will be addressed in future updates.

### Proxies
• For better performance, set the proxy filter to elite proxies when downloading the list.

### Why Translation?
1. To introduce a layer of complexity that solves additional challenges.
2. The German version of the website is better optimized and contains more detailed data, such as insurance costs and potential loan amounts.

### Potential problems 
1. When importing into SQL Server, there may be encoding issues. Try saving the final CSV file with Unicode encoding using Excel.
2. The query handles all potential problems with the dataset. If an error occurs at any step, try deleting the file, restoring it from backup, and running the commands one by one. If you are using a data management system other than SQL Server, you may need to run the commands from the beginning, as the GO statement is specific to T-SQL 

________________________________________

## Note from the Author
Thank you for taking the time to explore this project! It took a lot of time and effort to build, and I thoroughly enjoyed working on it. I plan to update and optimize it in the future for better analysis.
I hope you enjoy the visualizations in Tableau, and I look forward to your feedback!
