CREATE DATABASE covid;

USE covid;

-- before importing the data, we have to create the table first
CREATE TABLE df (
iso_code VARCHAR(60),
continent VARCHAR(60),
location VARCHAR(60),
dates VARCHAR(60),
population INT,
total_cases INT,
new_cases INT ,
new_cases_smoothed VARCHAR(60),
total_deaths INT,
new_deaths INT,
new_deaths_smoothed FLOAT,
total_cases_per_million FLOAT,
new_cases_per_million FLOAT,
new_cases_smoothed_per_million FLOAT,
total_deaths_per_million FLOAT,
new_deaths_per_million FLOAT,
new_deaths_smoothed_per_million FLOAT,
reproduction_rate FLOAT,
icu_patients INT,
icu_patients_per_million FLOAT,
hosp_patients INT,
hosp_patients_per_million FLOAT,
weekly_icu_admissions INT,
weekly_icu_admissions_per_million FLOAT,
weekly_hosp_admissions INT,
weekly_hosp_admissions_per_million FLOAT
);

-- turining off the sql strict mode can prevent error when importing the data from csv to the table
SET sql_mode = "";


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Covid death.csv' 
INTO TABLE df
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from df ;

select  location, year(dates), sum(total_cases), sum(total_deaths) from df
where  year(dates) in ( 2020, 2021)  group by location, year(dates) order by location, dates; 

select location, dates, total_cases, total_deaths from df where location = 'AFGHANISTAN' and year(dates) = '2020';

select distinct location, year(dates) from df;


-- after the data is imported, we need the change the date into the right format
-- first we have to check if we can covert the string into date
select dates from df;
select str_to_date(dates, '%m/%d/%Y') 
from df;

-- after that we can update it into table 
SET SQL_SAFE_UPDATES = 0;
update df set dates = str_to_date(dates,'%m/%d/%Y');

-- from the table that shown, there's 
select location, dates, total_cases, new_cases, total_deaths, population
from df
order by 3 desc;

-- from the table that shown, there's some obsevartion that contain the value from other observation, we can omit them from the table
-- by using the syntax below
delete from df
where location in
('High income',
'Low income',
'Lower middle income',
'Upper middle income',
'World',
'International',
'Europe',
'Asia',
'North America',
'South America',
'European Union');

-- after doing data preprocess, we can start doing data exploration
-- countries's covid mortality rate
select location, dates, total_cases, total_deaths, (total_deaths/ total_cases)*100 as covid_mortality
from df
order by 1,2;

-- percentage of covid
select location, dates, total_cases, population, (total_cases/population)*100 as casespercentage
from df
order by 1,2;


select location, max(total_cases) 
from df
group by location
order by max(total_cases) desc ;

select location, max(total_deaths) 
from df
group by location
order by max(total_deaths) desc ;




