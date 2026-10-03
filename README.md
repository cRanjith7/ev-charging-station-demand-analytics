EV Charging Station Demand & Utilization Analytics

Why I built this project

I wanted to work on a project where the data could answer practical questions instead of only creating a dashboard for the sake of having a dashboard.

For this project, I analyzed EV charging activity to understand:

when charging activity is highest

which locations generate more charging demand

how Fast and Slow chargers are used

which chargers are used more frequently

how charging demand changes over time

how demand differs between Peak and Off-Peak periods

where EV charging stations are located in India

The project started with raw charging transaction data and was taken through Python, SQL Server and Power BI.

Project at a glance

Project: EV Charging Station Demand & Utilization Analytics
Type: Data Analytics / Business Intelligence
Main tools: Python, Pandas, SQL Server, Power BI, Excel
Dataset: IEEE Task Force – Electric Vehicle Charging Transactions
Transaction records analyzed: 72,826
Unique users: 2,337
Unique chargers: 2,118

The project focuses on analysis and reporting rather than machine learning.

What I worked on

1. Data preparation with Python

I first inspected the raw charging records to understand the columns, missing values, duplicate rows and unusual records.

Using Pandas, I:

removed completely empty rows

checked duplicate records

converted date and time fields into usable datetime values

identified and removed negative-duration records

checked negative demand values

created useful analysis columns such as:

Start Hour

Day of Week

Month

Year

Duration in Hours

Peak / Off-Peak

created readable labels for charger type and charger company

saved the cleaned dataset for further analysis

One important point I kept in mind during cleaning was not to create information that was not present in the original dataset.

2. SQL Server analysis

After cleaning, I loaded the data into SQL Server and used SQL to answer business questions.

Some of the analysis includes:

busiest charging locations

average demand by location

high-value locations

underperforming locations

high-demand and low-usage chargers

busiest charger in each location

top 3 chargers within each location

high-value repeat users

users with above-average demand

user demand ranking

peak charging hours

high-demand location and hour combinations

demand classification

month-over-month demand changes

peak-hour demand contribution

charger-type contribution

location contribution to total demand

day and hour charging activity

I also used SQL concepts such as:

GROUP BY, HAVING, subqueries, CASE, CTEs, window functions, RANK() and ROW_NUMBER().

3. Power BI dashboard

I built the dashboard as three pages instead of putting everything into one page.

Page 1 — Executive Overview

This page gives a quick view of the overall charging activity.

It includes:

Total Charging Sessions

Unique Users

Unique Chargers

Total Demand

Average Demand

Average Charging Duration

Monthly Charging Demand

Charging Sessions by Hour

Sessions by Charger Type

Total Demand by Location

Peak vs Off-Peak Demand

Page 2 — Charger Location & Performance

This page focuses more on charger and location performance.

It includes:

Total Chargers

Sessions per Charger

Average Demand

Average Duration

Top Chargers by Sessions

Average Demand by Charger Type

Location performance table

Sessions by Charger Company

Page 3 — Usage Patterns, Demand Categories & Location Insights

This page is designed for deeper exploration.

It includes:

Charging Sessions by Hour

Sessions by Demand Category

Monthly Demand Trend

EV Charging Station Locations map

Top 10 Locations by Total Demand

The map uses a separate India charging-station dataset containing location information. It is used for geographic context rather than pretending that the transaction dataset contains latitude and longitude.

Some numbers from the analysis

After cleaning the transaction data:

Metric

Result

Charging sessions

72,826

Unique users

2,337

Unique chargers

2,118

Total demand

1,270,112.10

Average demand

17.44

Average charging duration

151.22 minutes

A few observations from the analysis:

Apartment and Public Area locations account for a large share of total charging demand.

Slow charging sessions make up most of the recorded sessions, while Fast charging has a higher average demand per session.

Charging activity is concentrated in the evening, with 18:00 having the highest number of sessions.

Off-Peak sessions contribute more total demand than Peak sessions under the project's Peak/Off-Peak definition.

Charging activity generally increases across the dataset period, with some month-to-month variation.

These are observations from this dataset and should not be treated as universal EV charging behavior.

Peak / Off-Peak definition

For this project, I used the following working definition:

Peak: 17:00 to 21:00

Off-Peak: all other hours

This is a project analysis assumption, not an official electricity tariff definition.

Demand categories

For the dashboard, charging sessions are grouped into three simple categories:

High Demand: Demand >= 40

Medium Demand: Demand >= 20 and < 40

Low Demand: Demand < 20

These categories are created for analysis and visualization.

Important data limitations

This project also taught me that good analysis is not only about finding numbers.

The transaction dataset does not provide all the information that would be needed for a complete business or revenue analysis.

For example, the dataset does not directly provide:

actual charging price

actual revenue

charger availability or downtime

vehicle model

battery capacity

payment method

charger latitude/longitude in the transaction file

charger capacity in the downloaded transaction CSV

Because of this, I did not treat unavailable information as if it existed.

If an estimated revenue calculation is used, it is clearly labelled as an estimate based on an assumed rate rather than actual revenue.

Project structure

EV Charging Station/
│
├── data/
│   ├── charging_stations_india
│   ├── ChargingRecords_Rawdata
│   ├── ChargingRecords
│   └── EV_Charging_Cleaned
│
├── Images/
│   ├── page 1/
│   └── page 2/
│
├── powerbi/
│   └── Power BI dashboard files
│
├── python/
│   ├── basic comments
│   └── realworld_problems
│
├── sql/
│   ├── realworldproblems.sql
│   └── SQLQuery1.sql
│
└── README.md

My workflow

Raw Charging Data
        ↓
Data Understanding
        ↓
Python / Pandas
Cleaning + EDA
        ↓
Cleaned Dataset
        ↓
SQL Server
Business Analysis
        ↓
Power BI
Data Model + Measures + Dashboard
        ↓
Insights
        ↓
Recommendations / Reporting

Dataset sources

EV charging transaction data

The main transaction dataset is from the IEEE Power & Energy Society Data Sharing platform:

IEEE Task Force – Electric Vehicle Charging Transactions

Dataset page:
https://ieee-pes-data-sharing.org/datasets/detail/c903145b-3ba7-4fd3-ac1b-7727abf79e73

The dataset is published under a Creative Commons Attribution 4.0 license according to the dataset page.

India charging station location data

A separate India charging-station dataset was used for the map visual to provide geographic context.

The map dataset contains fields such as location, state/city information and geographic coordinates.

What I learned from this project

The main thing I learned was that a good analytics project is not just about making charts.

I had to decide:

what the raw data actually tells me

what needs to be cleaned

which business questions are worth answering

which SQL approach is appropriate

how to turn query results into useful Power BI visuals

where assumptions should be clearly mentioned

where the data is simply not enough to make a conclusion

That process was more useful to me than just building a dashboard.

Tools used

Python

Pandas

NumPy

Matplotlib

SQL

Microsoft SQL Server

CTEs

Subqueries

Window Functions

Aggregations

Power BI

Power Query

Data Modeling

DAX Measures

Interactive Slicers

KPI Cards

Charts

Map Visualization

Other

Excel

GitHub

Project status

Completed

The project covers the complete analytics workflow from raw data preparation to SQL analysis and an interactive three-page Power BI dashboard.

