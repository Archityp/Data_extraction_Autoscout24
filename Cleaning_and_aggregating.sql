--final query fo one time execution 
--SELECT * INTO [Auto].[dbo].[Cars_Union] FROM [Auto].[dbo].[unicode_backup2];


-- Without the GO statement, the new columns will not be added to the table. Alternatively, you can execute this statement separately with a selection.
-- Add columns to the table to accommodate and aggregate future data.
ALTER TABLE [Auto].[dbo].[Cars_Union]
ADD 
	Power_kw INT,
	State VARCHAR(50),
	CO2_emissions_gr FLOAT,
	Electric_range_km INT,
	Main_Fuel_type VARCHAR(150);
GO

--deleting duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
	Car_url
	  ORDER BY car_url) AS row_num
FROM [Auto].[dbo].[Cars_Union]
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- Delete rows where:
-- 1. The Price field is empty or contains values starting with 'mtl.', which indicates rental information and misplaced data.
-- 2. The car_url field does not contain the valid URL pattern '%www.autoscout24.de%', indicating incorrect or irrelevant URLs.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE 
Price = '' or Price like '%mtl.' or car_url not like '%www.autoscout24.de%';


--Drop unused or incorrect values 
ALTER TABLE [Auto].[dbo].[Cars_Union]
DROP COLUMN
 [Cargo Space Height]
,[Cargo Space Width]
,[Cargo Space Length]
,[Max  Gross Weight]
,[Max  Towing Capacity]
,[Axles]
,[Payload]
,[Cargo Volume]
,[Wheelbase]
,[Car Registration]
,[Fuel_price]
,[Vehicle_tax]
,[Energy_costs_for_15000_km_annual_mileage]
,[Possible_CO2_costs_over_next_10_years_15000_km_per_year]
,[Fuel_consumption_with_discharged_battery]
,[car_url2]
,[0]
,[Electricity_price]
,[Electricity_consumption_in_pure_electric_mode]
,[Paintwork]
,[Cash_price]
,[Environmental_sticker]
,[Non_smoker_vehicle]
,[Emission_class]
,[Full_service_history]
,[Interior_equipment]
,[Curb_weight]
,[Interior_color]
,[CO2_class]
,[Offer_number]
,[Battery_ownership]
,[Processing_fees]
,[CO2_efficiency]
,[Energy_efficiency_class]
,[Color_as_per_manufacturer]
,[Warranty]
,[Total_one_time]
,[Charging_time_from_10_percent_to_80_percent]
,[Country_version]
,[Last_timing_belt_change]
,[Additional_km_cost]
,[Reduced_km_reimbursement]
,[Final_rate]
,[Key_number]
,[Seats]
,[Nominal_Interest_Rate]
,[Special_payment]
,[Taxi_or_rental_car]
,[Available_from]
,[Availability]
,[Contract_type]
,[Registration_costs]
,[Cylinders]
,[Transfer_costs]
,[Annual_mileage]
,[Gears]
,[Doors];



-- Set columns to NULL where the values are empty strings.
-- This includes a wide range of columns to ensure consistency in data representation.
UPDATE [Auto].[dbo].[Cars_Union] 
SET 
	 [Seller_info] = NULLIF([Seller_info], '')
	,[Duration] = NULLIF([Duration], '')
	,[Drive_type] = NULLIF([Drive_type], '')
	,[Vehicle_condition] = NULLIF([Vehicle_condition], '')
	,[Seller_info_1] = NULLIF([Seller_info_1], '')
	,[Electricity_consumption] = NULLIF([Electricity_consumption], '')
	,[Other_energy_source] = NULLIF([Other_energy_source], '')
	,[Electric_range_EAER7] = NULLIF([Electric_range_EAER7], '')
	,[Electric_range_EAER] = NULLIF([Electric_range_EAER], '')
	,[Electric_range7] = NULLIF([Electric_range7], '')
	,[Electric_range] = NULLIF([Electric_range], '')
	,[Exterior_color] = NULLIF([Exterior_color], '')
    ,[Brand] = NULLIF([Brand], '')
    ,[First_registration] = NULLIF([First_registration], '')
    ,[Vehicle_type] = NULLIF([Vehicle_type], '')
    ,[Vehicle_owners] = NULLIF([Vehicle_owners], '')
    ,[Transmission] = NULLIF([Transmission], '')
    ,[Inspection] = NULLIF([Inspection], '')
    ,[Displacement] = NULLIF([Displacement], '')
    ,[Body_type] = NULLIF([Body_type], '')
    ,[Mileage] = NULLIF([Mileage], '')
    ,[Fuel_type] = NULLIF([Fuel_type], '')
    ,[Fuel_consumption] = NULLIF([Fuel_consumption], '')
    ,[Power] = NULLIF([Power], '')
    ,[Location] = NULLIF([Location], '')
    ,[Model] = NULLIF([Model], '')
    ,[Price] = NULLIF([Price], '')
    ,[Scraping_Date] = NULLIF([Scraping_Date], '')
	,[CO2_emissions] = NULLIF([CO2_emissions], '')
	,[Last_inspection] = NULLIF([Last_inspection], '')
	,[Total_lease_amount] = NULLIF([Total_lease_amount], '')
	,[Leasing_factor] = NULLIF([Leasing_factor], '')
	,[Energy_consumption] = NULLIF([Energy_consumption], '')
	,[Year_of_manufacture] = NULLIF([Year_of_manufacture], '')
	,[Gross_loan_amount] = NULLIF([Gross_loan_amount], '')
	,[Model_version] = NULLIF([Model_version], '')
	,[Liability_Insurance] = NULLIF([Liability_Insurance], '')
	,[Partial_Coverage] = NULLIF([Partial_Coverage], '')
	,[Comprehensive_Coverage] = NULLIF([Comprehensive_Coverage], '');

UPDATE [Auto].[dbo].[Cars_Union] 
SET 
	 [Seller_info] = NULLIF([Seller_info], 'nan')
	,[Duration] = NULLIF([Duration], 'nan')
	,[Drive_type] = NULLIF([Drive_type], 'nan')
	,[Vehicle_condition] = NULLIF([Vehicle_condition], 'nan')
	,[Fuel_type] = NULLIF([Fuel_type], 'nan')
	,[Transmission] = NULLIF([Transmission], 'nan')
	,[Exterior_color] = NULLIF([Exterior_color], 'nan')
	,[Other_energy_source] = NULLIF([Other_energy_source], 'nan');

UPDATE [Auto].[dbo].[Cars_Union] 
SET [Seller_info] = NULLIF([Seller_info], '-');
GO



-- Set 'Scraping_Date' to '2024-08-14' where it is null or empty.
UPDATE [Auto].[dbo].[Cars_Union]
SET Scraping_Date = '2024-08-14'
WHERE Scraping_Date is null OR Scraping_Date = '';

-- Delete rows where 'Scraping_Date' is null or does not contain '2024'.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE Scraping_Date is null or Scraping_Date NOT LIKE '%2024%';

-- Delete rows where 'First_registration' does not contain '19' or '20'.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE First_registration NOT LIKE '%20%' AND First_registration NOT LIKE '%19%';
GO

-- Delete rows where 'First_registration' cannot be converted to a date.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE TRY_CONVERT(DATE, 
	RIGHT(CASE 
		WHEN CHARINDEX('.', First_registration) > 0 THEN SUBSTRING(First_registration, 4, LEN(First_registration)) ELSE First_registration END, 4) 
		+ '-' + 
	LEFT(CASE 
		WHEN CHARINDEX('.', First_registration) > 0 THEN SUBSTRING(First_registration, 4, LEN(First_registration)) ELSE First_registration END, 2) + '-01')  IS NULL;
GO

-- Update 'First_registration' to a date format ('YYYY-MM-DD') based on existing data.
UPDATE [Auto].[dbo].[Cars_Union]
SET First_registration = CONVERT(DATE, 
	RIGHT(CASE WHEN CHARINDEX('.', First_registration) > 0 THEN SUBSTRING(First_registration, 4, LEN(First_registration)) ELSE First_registration END, 4) 
	+ '-' + 
	LEFT(CASE WHEN CHARINDEX('.', First_registration) > 0 THEN SUBSTRING(First_registration, 4, LEN(First_registration)) ELSE First_registration END, 2) + '-01');

-- Update 'Inspection' to 'YYYY-MM-DD' format where 'Inspection' is in 'Mon YY' format.
UPDATE [Auto].[dbo].[Cars_Union]
SET Inspection = CASE 
	WHEN charindex(' ',Inspection)=4 THEN CONCAT('20',RIGHT(Inspection,2),'-', CASE 
		WHEN LEFT(Inspection, 3) = 'Jan' THEN '01'
		WHEN LEFT(Inspection, 3) = 'Feb' THEN '02'
		WHEN LEFT(Inspection, 3) = 'Mrz' THEN '03'
		WHEN LEFT(Inspection, 3) = 'Apr' THEN '04'
		WHEN LEFT(Inspection, 3) = 'Mai' THEN '05'
		WHEN LEFT(Inspection, 3) = 'Jun' THEN '06'
		WHEN LEFT(Inspection, 3) = 'Jul' THEN '07'
		WHEN LEFT(Inspection, 3) = 'Aug' THEN '08'
		WHEN LEFT(Inspection, 3) = 'Sep' THEN '09'
		WHEN LEFT(Inspection, 3) = 'Okt' THEN '10'
		WHEN LEFT(Inspection, 3) = 'Nov' THEN '11'
		WHEN LEFT(Inspection, 3) = 'Dez' THEN '12'
		ELSE '01' END, '-01')
	ELSE Inspection END;
GO


-- Update 'Inspection' date to 18 months after 'scraping_date' if 'Inspection' is 'Neu'.
UPDATE [Auto].[dbo].[Cars_Union]
SET Inspection = CONVERT(DATE, DATEADD(MONTH, 18, scraping_date), 120) 
WHERE Inspection = 'Neu';

-- Convert 'Inspection' from 'MM/YY' format to 'YYYY-MM-DD'.
UPDATE [Auto].[dbo].[Cars_Union]
SET Inspection = CONVERT(DATE, RIGHT(Inspection, 4) + '-' + LEFT(Inspection, 2) + '-01')
WHERE Inspection like '%/%';

-- Delete rows where 'Inspection' cannot be converted to a date and is not null.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE try_CONVERT(DATE, Inspection, 120) is null and Inspection is not null
GO

-- Convert 'Last_inspection' from 'MM/YY' format to 'YYYY-MM-DD'.
-- Set 'Inspection' to 24 months after 'Last_inspection' where 'Last_inspection' is not null and 'Inspection' is null.
UPDATE [Auto].[dbo].[Cars_Union]
SET [Last_inspection] = CONVERT(DATE, RIGHT([Last_inspection], 4) + '-' + LEFT([Last_inspection], 2) + '-01') 
WHERE [Last_inspection] like '%/%';

UPDATE [Auto].[dbo].[Cars_Union]
SET Inspection = DATEADD(MONTH, 24, [Last_inspection]) 
WHERE [Last_inspection] is not null and Inspection is null;
GO


-- Set 'Electric_range_km' to NULL if it is '0'.
-- Update 'Electric_range_km' with values from 'Electric_range7' or 'Electric_range' if they are not null and 'Electric_range_km' is still null.
UPDATE [Auto].[dbo].[Cars_Union] 
SET Electric_range_km = NULLIF(Electric_range_km, '0');

UPDATE [Auto].[dbo].[Cars_Union]
SET Electric_range_km = TRIM(REPLACE(LEFT([Electric_range7],CHARINDEX(' ', [Electric_range7]) - 0),',','.'))
WHERE [Electric_range7] is not null AND Electric_range_km is null;
	
UPDATE [Auto].[dbo].[Cars_Union]
SET Electric_range_km = TRIM(REPLACE(LEFT([Electric_range],CHARINDEX(' ', [Electric_range]) - 0),',','.'))
WHERE [Electric_range] is not null AND Electric_range_km is null;
GO



-- Delete rows where 'CO2_emissions' is either in an invalid format or not in the expected 'g/km' format.
-- Ensures that only valid CO2 emission records are retained.
DELETE 
FROM [Auto].[dbo].[Cars_Union]
WHERE [CO2_emissions] NOT LIKE '%g/km%' and [CO2_emissions] not LIKE '' and [CO2_emissions] is not NULL;

DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE [CO2_emissions] IS NOT NULL AND TRY_CONVERT(FLOAT, TRIM(REPLACE(LEFT([CO2_emissions],CHARINDEX(' ', [CO2_emissions]) - 0),',','.'))) IS NULL;
GO


-- Clean and standardize various columns by converting data types and handling different formats.
-- Specifically addresses 'Seller_info', financial amounts, fuel types, and other fields to ensure consistency.
UPDATE [Auto].[dbo].[Cars_Union]
SET 
Effective_annual_interest_rate = CONVERT(FLOAT, TRIM(REPLACE(REPLACE(Effective_annual_interest_rate, '%', '' ),',','.'))),
CO2_emissions_gr = CONVERT(FLOAT, TRIM(REPLACE(LEFT([CO2_emissions],CHARINDEX(' ', [CO2_emissions]) - 0),',','.'))),
Power_kw = CONVERT(INT, TRIM(REPLACE(LEFT(Power, CHARINDEX(' ',Power) - 0),'.',''))),
Seller_info = CASE WHEN Seller_info = 'nan' THEN [seller_info_1] ELSE Seller_info END,
CO2_emissions_gr = CONVERT(FLOAT, TRIM(REPLACE(LEFT([CO2_emissions],CHARINDEX(' ', [CO2_emissions]) - 0),',','.'))),
Power_kw = CONVERT(INT, TRIM(REPLACE(LEFT(Power, CHARINDEX(' ',Power) - 0),'.',''))),
Other_energy_source = CASE WHEN Fuel_type = 'Elektro' THEN 'Strom' ELSE Other_energy_source END,
Gross_loan_amount = CONVERT(INT,REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Gross_loan_amount) > 0 
	THEN LEFT(REPLACE(Gross_loan_amount, '€ ', ''), CHARINDEX(',', Gross_loan_amount) - LEN('€ ') - 1) 
	ELSE REPLACE(Gross_loan_amount, '€ ', '') 
	END, '.', ''), ',', '')),
Price = CONVERT(INT,REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Price) > 0 
	THEN LEFT(REPLACE(Price, '€ ', ''), CHARINDEX(',', Price) - LEN('€ ') - 1) 
	ELSE REPLACE(Price, '€ ', '') 
	END, '.', ''), ',', '')),
Down_payment = CONVERT(INT,REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Down_payment) > 0 
	THEN LEFT(REPLACE(Down_payment, '€ ', ''), CHARINDEX(',', Down_payment) - LEN('€ ') - 1) 
	ELSE REPLACE(Down_payment, '€ ', '') 
	END, '.', ''), ',', '')),
Net_loan_amount = CONVERT(INT,REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Net_loan_amount) > 0 
	THEN LEFT(REPLACE(Net_loan_amount, '€ ', ''), CHARINDEX(',', Net_loan_amount) - LEN('€ ') - 1) 
	ELSE REPLACE(Net_loan_amount, '€ ', '') 
	END, '.', ''), ',', '')),
Monthly_installment = CONVERT(INT,REPLACE(REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Monthly_installment) > 0 
	THEN LEFT(REPLACE(Monthly_installment, '€ ', ''), CHARINDEX(',', Monthly_installment) - LEN('€ ') - 1) 
	ELSE REPLACE(Monthly_installment, '€ ', '') 
	END, '.', ''), ',', ''), 'ab', '')),
Total_lease_amount = CONVERT(INT,REPLACE(REPLACE(CASE WHEN CHARINDEX(',', Total_lease_amount) > 0 
	THEN LEFT(REPLACE(Total_lease_amount, '€ ', ''), CHARINDEX(',', Total_lease_amount) - LEN('€ ') - 1) 
	ELSE REPLACE(Total_lease_amount, '€ ', '') 
	END, '.', ''), ',', '')),
Displacement = CONVERT(INT, TRIM(REPLACE(REPLACE(Displacement, ' cm³', '' ),'.', '' ))),

Mileage = CONVERT(INT, REPLACE(REPLACE(Mileage, ' km', ''),'.', '')),
Effective_annual_interest_rate = CONVERT(FLOAT, TRIM(REPLACE(REPLACE(Effective_annual_interest_rate, '%', '' ),',','.'))),

Main_Fuel_type = CASE 
	WHEN Fuel_type like '%/%' and Fuel_type not like '%Electricity/%' 
	THEN TRIM(LEFT(REPLACE(Fuel_type,' (Particle filter)',''),CHARINDEX('/',REPLACE(Fuel_type,' (Particle filter)','')) - 1))
	ELSE TRIM(REPLACE(Fuel_type,' (Particle filter)','')) 
	END,
--Fuel_consumption = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE()
Model_version = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(Model_version, '"', ''), 'VW', ''), 'Volkswagen', ''), 'Mercedes', '')),
Vehicle_owners = CONVERT(INT,(REPLACE(Vehicle_owners,'.0',''))),
Liability_Insurance = CONVERT(FLOAT, TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Liability_Insurance, 'ab', '' ),'€',''),',-',''),'*',''),',','.'))),
Partial_Coverage = CONVERT(FLOAT, TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Partial_Coverage, 'ab', '' ),',-',''),'€',''),'*',''),',','.'))),
Comprehensive_Coverage = CONVERT(FLOAT, TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Comprehensive_Coverage, 'ab', '' ),'€',''),',-',''),'*',''),',','.')));
GO

-- Standardize 'Main_Fuel_type' by consolidating fuel types from 'other_energy_source' 
-- and applying specific formatting rules for consistency.
UPDATE [Auto].[dbo].[Cars_Union]
SET Main_Fuel_type = TRIM(CASE 
	WHEN other_energy_source = 'Electricity' and Main_Fuel_type NOT LIKE 'Electricity/%' THEN Main_Fuel_type + '/' + other_energy_source 
	WHEN other_energy_source IS NOT NULL and Main_Fuel_type is null THEN other_energy_source
	ELSE Main_Fuel_type END);

UPDATE [Auto].[dbo].[Cars_Union]
SET Main_Fuel_type = TRIM(CASE
	WHEN Main_Fuel_type LIKE 'Super%' AND Main_Fuel_type LIKE '%/%' THEN REPLACE(Main_Fuel_type, LEFT(Main_Fuel_type, CHARINDEX('/',Main_Fuel_type)),'Gasoline/')
	WHEN Main_Fuel_type LIKE 'Super%' AND Main_Fuel_type NOT LIKE '%/%' THEN 'Gasoline'
	WHEN (Main_Fuel_type LIKE '(CNG)%' OR Main_Fuel_type = 'Natural gas (CNG)') AND Main_Fuel_type NOT LIKE '%/%' THEN 'Natural gas'
	ELSE Main_Fuel_type END);

UPDATE [Auto].[dbo].[Cars_Union]
SET Main_Fuel_type = TRIM(CASE
	WHEN Main_Fuel_type = 'Gasoline/Electricity' or Main_Fuel_type = 'Normal/Electricity' THEN 'Electricity/Gasoline'
	WHEN Main_Fuel_type LIKE 'Diesel/Electricity' THEN 'Electricity/Diesel'
	WHEN Main_Fuel_type LIKE 'Normal' THEN 'Gasoline'
	ELSE Main_Fuel_type END);


--Delete unrealistic values
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE Mileage > 999999 or Power_kw > 900 or CO2_emissions_gr > 900 or CO2_emissions_gr > 900


-- Update 'model' based on patterns in 'Model_version'
-- Handling various cases including specific model names and formats. Nullify 'model' for certain patterns and clean up specific format issues.
UPDATE [Auto].[dbo].[Cars_Union]
SET model = CASE
	WHEN Model_version LIKE 'Transporter%' THEN 'Transporter'
	WHEN Model_version LIKE 'Golf%' THEN 'Golf'
	WHEN Model_version LIKE 'Transporter%' THEN 'Transporter'
	WHEN Model_version LIKE 'Golf%' THEN 'Golf'
	WHEN Model_version LIKE 'Vito%' THEN 'Vito'
	WHEN Model_version LIKE 'Sprinter%' THEN 'Sprinter'
	WHEN Model_version LIKE 'Citan%' THEN 'Citan'
	WHEN Model_version LIKE 'Caddy%' THEN 'Caddy'
	WHEN Model_version LIKE 'Vario%' THEN 'Vario'
	WHEN Model_version LIKE 'Viano%' THEN 'Viano'
	WHEN PATINDEX('T[0-9]%', Model_version) > 0  THEN SUBSTRING(Model_version, PATINDEX('T[0-9]%', Model_version), 2)
	WHEN Model_version LIKE 'T %' 
		OR Model_version LIKE 'V %' 
		OR Model_version LIKE 'C %' 
		OR Model_version LIKE 'EQ%' 
		OR Model_version LIKE 'X %' 
		OR Model_version LIKE '[0-9]%' 
		OR Model_version LIKE 'CL%'
		OR Model_version LIKE 'LT %'
			THEN LEFT(Model_version, CHARINDEX(' ', Model_version, CHARINDEX(' ', Model_version) + 1) - 0)
	WHEN Model_version LIKE 'Crafter%' THEN 'Crafter'
	WHEN Model_version LIKE 'California%' THEN 'California'
	WHEN Model_version LIKE 'ID.%' THEN 'ID. Buzz'
	WHEN Model_version LIKE 'Atego%' THEN 'Atego'
	WHEN Model_version LIKE 'e-Crafter 35%' THEN 'E-Crafter'
	ELSE model END
WHERE model is null and Model_version is not null;

UPDATE [Auto].[dbo].[Cars_Union]
SET Model = TRIM(CASE 
	WHEN Model like '%*%' 
		OR MODEL like '[a-z]' 
		OR MODEL like '%TDI%' 
		OR MODEL like '%TSI%' 
		OR MODEL like '%CDI%' 
		OR MODEL like '%2.0%' 
		OR MODEL like '%/%' 
			THEN NULL
	WHEN Model like '%+%' THEN LEFT(MODEL, CHARINDEX('+', MODEL) - 1)
	WHEN Model like '%.0%' OR Model like '%,0%' THEN REPLACE(REPLACE(Model, '.0',''), ',0','')
	WHEN Model like 'ID%' THEN 'ID. Buzz'
	WHEN Model like 'EQE%' AND Model like '%.%' THEN TRIM(LEFT(Model,6))
	ELSE Model END)

-- Update 'Seller_info' based on 'Comprehensive_Coverage' and 'Seller' values when they are not convertible to FLOAT, and fill with 'Seller_info_1' if 'Seller_info' is still NULL.
UPDATE [Auto].[dbo].[Cars_Union]
SET Seller_info = CASE 
	WHEN  (Comprehensive_Coverage ='Dealer' OR Comprehensive_Coverage ='Private') and Seller_info IS NULL THEN Comprehensive_Coverage 
	ELSE Seller_info END
WHERE  TRY_CONVERT(FLOAT, TRIM(REPLACE(REPLACE(REPLACE(REPLACE(Comprehensive_Coverage, 'ab€ ', '' ),',-',''),'*',''),',','.'))) IS NULL;

UPDATE [Auto].[dbo].[Cars_Union]
SET Seller_info = CASE 
	WHEN Seller ='Dealer' OR Seller ='Private' THEN Seller 
	ELSE Seller_info END
WHERE  TRY_CONVERT(FLOAT, TRIM(REPLACE(REPLACE(REPLACE(REPLACE(Comprehensive_Coverage, 'ab€ ', '' ),',-',''),'*',''),',','.'))) IS NULL;

UPDATE [Auto].[dbo].[Cars_Union]
SET Seller_info = Seller_info_1
WHERE Seller_info IS NULL;


-- Update 'Electric_range_km' based on values from related columns, converting them to integers. 
-- The range is extracted from the string and formatted by removing dots and trimming spaces.
UPDATE [Auto].[dbo].[Cars_Union]
SET Electric_range_km = CASE
	WHEN [Electric_range] IS NOT NULL THEN CONVERT(INT,TRIM(REPLACE(left([Electric_range],CHARINDEX(' ', [Electric_range]) - 1),'.','')))
	WHEN [Electric_range7] IS NOT NULL THEN CONVERT(INT,TRIM(REPLACE(left([Electric_range7],CHARINDEX(' ', [Electric_range7]) - 1),'.','')))
	WHEN [Electric_range_EAER] IS NOT NULL THEN CONVERT(INT,TRIM(REPLACE(left([Electric_range_EAER],CHARINDEX(' ', [Electric_range_EAER]) - 1),'.','')))
	WHEN [Electric_range_EAER7] IS NOT NULL THEN CONVERT(INT,TRIM(REPLACE(left([Electric_range_EAER7],CHARINDEX(' ', [Electric_range_EAER7]) - 1),'.','')))
	ELSE Electric_range_km END;


--LOCATION CLEANING
-- Clean up and correct the 'Location' and 'State' fields in 'Cars_Union' by removing invalid entries, normalizing city names, and updating 'State' based on postal code ranges.
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE 
Location not like '%, DE' or 
Location like '%?%' or
location LIKE '%í%' or location LIKE '%ł%' or location LIKE '%Č%' or location = ', DE';

Update [Auto].[dbo].[Cars_Union]
Set State = 
       CASE 
           -- Schleswig-Holstein
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '24' AND '25' THEN 'Schleswig-Holstein'
           -- Hamburg
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '20' AND '22' THEN 'Hamburg'
           -- Bremen
           WHEN SUBSTRING(Location, 1, 2) = '28' THEN 'Bremen'
           -- Lower Saxony (Niedersachsen)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '26' AND '31'
             OR SUBSTRING(Location, 1, 2) = '38' THEN 'Niedersachsen'
           -- Mecklenburg-Vorpommern
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '17' AND '19' THEN 'Mecklenburg-Vorpommern'
           -- Brandenburg
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '14' AND '16' THEN 'Brandenburg'
           -- Berlin
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '10' AND '11' THEN 'Berlin'
           -- Saxony (Sachsen)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '01' AND '04' THEN 'Sachsen'
           -- Saxony-Anhalt (Sachsen-Anhalt)
           WHEN SUBSTRING(Location, 1, 2) = '06'
             OR SUBSTRING(Location, 1, 2) = '39' THEN 'Sachsen-Anhalt'
           -- Thuringia (Thüringen)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '07' AND '09' THEN 'Thüringen'
           -- North Rhine-Westphalia (Nordrhein-Westfalen)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '32' AND '33'
             OR SUBSTRING(Location, 1, 2) BETWEEN '40' AND '53'
             OR SUBSTRING(Location, 1, 2) BETWEEN '57' AND '59' THEN 'Nordrhein-Westfalen'
           -- Hesse (Hessen)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '34' AND '36'
             OR SUBSTRING(Location, 1, 2) BETWEEN '60' AND '65' THEN 'Hessen'
           -- Rhineland-Palatinate (Rheinland-Pfalz)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '54' AND '56'
             OR SUBSTRING(Location, 1, 2) = '66' THEN 'Rheinland-Pfalz'
           -- Saarland
           WHEN SUBSTRING(Location, 1, 2) = '66' THEN 'Saarland'
           -- Baden-Württemberg
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '68' AND '79' THEN 'Baden-Württemberg'
           -- Bavaria (Bayern)
           WHEN SUBSTRING(Location, 1, 2) BETWEEN '80' AND '99' THEN 'Bayern'
           -- Default case for unmapped locations
           ELSE null
       END
FROM [Auto].[dbo].[Cars_Union]
WHERE location LIKE '%[0-9]%' AND State is null;

-- The most popular misspelings
UPDATE [Auto].[dbo].[Cars_Union]
SET Location = CASE 
	WHEN location = 'Loehne, DE' THEN 'löhne, DE'
	WHEN location IN ('Muenchen, DE','Münhe, DE','Munchen, DE','Mūnche, DE','Bayern, DE','Bavaria, DE','Monachuim, DE','Mümchen, DE','Mönchen, DE') THEN 'München, DE'
	WHEN location = 'Muehldorf, DE' THEN 'Mühldorf, DE'
	WHEN location = 'Götschetal, DE' THEN 'Petersberg, DE'
	WHEN location = 'Muenster, DE' THEN 'Münster, DE'
	WHEN location = 'Wupertal, DE' THEN 'Wuppertal, DE'
	WHEN location IN ('Hanover, DE','Hannpver, DE') THEN 'Hannover, DE'
	WHEN location IN ('Berlın, DE','Erlin, DE','Berljn, DE','Betlin, DE') THEN 'Berlin, DE'
	WHEN location IN ('Koeln, DE') THEN 'Köln, DE'
	WHEN location = 'Hambutg, DE' THEN 'Hamburg, DE'
	ELSE location END;


-- Update 'State' in 'Cars_Union' based on matching city names from 'Germany_cities' table.
WITH RankedCities AS (
    SELECT
        Cars_Union.Location AS CarsLocation,
        city.Location AS CityLocation,
        city.State,
        ROW_NUMBER() OVER (PARTITION BY Cars_Union.Location ORDER BY LEN(city.Location) DESC) AS rn
    FROM [Auto].[dbo].[Cars_Union] AS Cars_Union
    LEFT JOIN [Germany].[dbo].[Germany_cities] AS city
        ON CHARINDEX(city.Location, Cars_Union.Location) > 0
)
UPDATE Cars_Union
SET Cars_Union.State = RankedCities.State
FROM [Auto].[dbo].[Cars_Union] AS Cars_Union
INNER JOIN RankedCities ON Cars_Union.Location = RankedCities.CarsLocation
WHERE RankedCities.rn = 1;



-- Rows with NULL 'state' values are misspelled, incorrect, or not located in Germany. Non-German cities/states are marked as "ignore".
DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE [State] is null or [State] like '%ignore%';



-- Normalize and clean up 'Electricity_consumption' and 'Fuel_consumption' columns by converting values to FLOAT
-- Removing unwanted characters, filling nulls, and adjusting outlier values.
Update [Auto].[dbo].[Cars_Union]
SET [Electricity_consumption] = CONVERT(FLOAT, trim(replace(LEFT([Electricity_consumption],4),',','.')))
WHERE [Electricity_consumption] is not null;

UPDATE [Auto].[dbo].[Cars_Union]
SET [Electricity_consumption] = NULLIF([Electricity_consumption], '0');

UPDATE [Auto].[dbo].[Cars_Union]
SET [Fuel_consumption] = CONVERT(FLOAT, trim(replace(LEFT([Fuel_consumption],4),',','.')));

UPDATE [Auto].[dbo].[Cars_Union]
SET [Electricity_consumption] = CONVERT(FLOAT, trim(replace(LEFT([energy_consumption],4),',','.')))
WHERE [energy_consumption] like '%kWh%' and [energy_consumption] not like '%l/%' and [Electricity_consumption] is null;

UPDATE [Auto].[dbo].[Cars_Union]
SET [Fuel_consumption] = CONVERT(FLOAT, trim(replace(LEFT([energy_consumption],4),',','.')))
WHERE [energy_consumption] is not null and [energy_consumption] not like '%kWh%' and [Fuel_consumption] is null;

ALTER TABLE  [Auto].[dbo].[Cars_Union]
ALTER COLUMN [Electricity_consumption] FLOAT;

ALTER TABLE  [Auto].[dbo].[Cars_Union]
ALTER COLUMN [Fuel_consumption] FLOAT;

UPDATE [Auto].[dbo].[Cars_Union]
SET [Electricity_consumption] = CONVERT(FLOAT, CASE 
	WHEN [Electricity_consumption] > 100 THEN [Electricity_consumption]/10
	WHEN [Electricity_consumption] < 4 THEN  [Electricity_consumption]*10
	WHEN [Electricity_consumption] = 0 THEN null
	ELSE [Electricity_consumption] END )
WHERE [Electricity_consumption] is not null;

UPDATE [Auto].[dbo].[Cars_Union]
SET [Fuel_consumption] = CASE
	WHEN [Fuel_consumption] between 15 and 150 THEN CAST([Fuel_consumption] / 10 AS FLOAT)
	WHEN [Fuel_consumption] > 150 THEN CAST([Fuel_consumption] / 100 AS FLOAT)
	ELSE [Fuel_consumption] END
FROM [Auto].[dbo].[Cars_Union];


--Mileage with null values are new according to first registration
SELECT Mileage, first_registration
FROM  [Auto].[dbo].[Cars_Union]
WHERE Mileage IS NULL;

UPDATE [Auto].[dbo].[Cars_Union]
SET Mileage = 0
WHERE Mileage IS NULL;



--final converting
ALTER TABLE [Auto].[dbo].[Cars_Union]
ALTER COLUMN Effective_annual_interest_rate FLOAT;

ALTER TABLE [Auto].[dbo].[Cars_Union]
ALTER COLUMN Vehicle_owners INT;

ALTER TABLE [Auto].[dbo].[Cars_Union]
ALTER COLUMN Liability_Insurance FLOAT;

ALTER TABLE [Auto].[dbo].[Cars_Union]
ALTER COLUMN Partial_Coverage FLOAT;

ALTER TABLE [Auto].[dbo].[Cars_Union]
ALTER COLUMN Comprehensive_Coverage FLOAT;

ALTER TABLE [Auto].[dbo].[Cars_Union]
ADD ID INT IDENTITY(1,1);





-- Fills NULLs in 'MODEL' and 'Main_Fuel_type' columns based on patterns found in 'MODEL_VERSION' and related data.
UPDATE [Auto].[dbo].[Cars_Union]
SET 
    Model = CASE
              WHEN Model IS NULL AND Model_version LIKE '% T 180%' THEN 'T 180'
              WHEN Model IS NULL AND Model_version LIKE '%Actros%' THEN 'Actros'
              WHEN Model IS NULL AND Model_version LIKE '%E-CRAFTER%' THEN 'e-Crafter'
              WHEN Model IS NULL AND Model_version LIKE '%eSprinter%' THEN 'e-Sprinter'
              WHEN Model IS NULL AND Model_version LIKE '%Amarok%' THEN 'Amarok'
              WHEN Model IS NULL AND Model_version LIKE '% Sprinter%' THEN 'Sprinter'
              ELSE Model
            END,
    Main_Fuel_type = CASE
              WHEN Main_Fuel_type IS NULL AND Model_version LIKE '%CDI%' THEN 'Diesel'
              WHEN Main_Fuel_type IS NULL AND (Model_version LIKE '%E-%' OR Model_version LIKE '%ID.%') THEN 'Electricity'
              WHEN Main_Fuel_type IS NULL AND Model_version IS NOT NULL AND (Electric_range_km > 100 OR CO2_emissions_gr = 0 OR Electricity_consumption IS NOT NULL) THEN 'Electricity'
              WHEN Main_Fuel_type IS NULL AND Model_version LIKE '%TDI%' THEN 'Diesel'
              ELSE Main_Fuel_type
            END
WHERE (Model IS NULL AND (
        Model_version LIKE '% T 180%' 
     OR Model_version LIKE '%Actros%'
     OR Model_version LIKE '%E-CRAFTER%' 
     OR Model_version LIKE '%eSprinter%'
     OR Model_version LIKE '%Amarok%' 
     OR Model_version LIKE '% Sprinter%'))
OR (Main_Fuel_type IS NULL AND (
        Model_version LIKE '%CDI%'
     OR Model_version LIKE '%E-%' 
     OR Model_version LIKE '%ID.%' 
     OR (Model_version IS NOT NULL AND (Electric_range_km > 100 OR CO2_emissions_gr = 0 OR Electricity_consumption IS NOT NULL))
     OR Model_version LIKE '%TDI%'));


DELETE
FROM [Auto].[dbo].[Cars_Union]
WHERE model IS NULL or model = '';


ALTER TABLE [Auto].[dbo].[Cars_Union]
DROP COLUMN 
	[Other_energy_source],
	[car_url],
	[CO2_emissions],
	[Power],
	[Electric_range],
	[Electric_range7],
	[Electric_range_EAER],
	[Electric_range_EAER7],
	[Location],
	[Last_inspection],
	[Seller_info_1],
	[Seller],
	[Fuel_type],
	[Year_of_manufacture],
	[Model_version],
	[energy_consumption];
