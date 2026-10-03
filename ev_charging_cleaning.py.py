

import pandas as pd

file_path = r"D:\Data Analytics\EV Charging Station\data\ChargingRecords.csv"

df = pd.read_csv(file_path)

print("Shape:")
print(df.shape)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())


print("\nCompletely empty rows:")
print(df.isnull().all(axis=1).sum())

print("\nRows with missing values:")
print(df[df.isnull().any(axis=1)])


# Remove completely empty rows
df = df.dropna(how="all")

print("\nShape after removing empty rows:")
print(df.shape)

print("\nMissing values after removing empty rows:")
print(df.isnull().sum())



# Check duplicate rows
duplicates = df[df.duplicated(keep=False)]

print("\nNumber of duplicate rows:")
print(len(duplicates))

print("\nDuplicate records:")
print(duplicates)



# Convert date columns
df["Start_day"] = pd.to_datetime(
    df["Start_day"],
    format="%d-%m-%Y"
)

df["End_day"] = pd.to_datetime(
    df["End_day"],
    format="%d-%m-%Y"
)

# Convert time columns
df["Start_time"] = pd.to_datetime(
    df["Start_time"],
    format="%H:%M:%S"
).dt.time

df["End_time"] = pd.to_datetime(
    df["End_time"],
    format="%H:%M:%S"
).dt.time

# Convert datetime columns
df["Start_datetime"] = pd.to_datetime(
    df["Start_datetime"],
    format="%d-%m-%Y %H:%M"
)

df["End_datetime"] = pd.to_datetime(
    df["End_datetime"],
    format="%d-%m-%Y %H:%M"
)

print("\nData types after date/time conversion:")
print(df.dtypes)



print("\nNumeric column summary:")
print(df[
    [
        "User_id",
        "Charger_id",
        "Charger_company",
        "Charger_type",
        "Duration",
        "Demand"
    ]
].describe())


print("\nUnique values:")

print("Charger_company:", df["Charger_company"].unique())
print("Charger_type:", df["Charger_type"].unique())

print("\nMinimum values:")
print("Duration:", df["Duration"].min())
print("Demand:", df["Demand"].min())

print("\nMaximum values:")
print("Duration:", df["Duration"].max())
print("Demand:", df["Demand"].max())



# Find records with negative duration
negative_duration = df[df["Duration"] < 0]

print("\nNegative duration records:")
print(negative_duration)

print("\nNumber of negative duration records:")
print(len(negative_duration))


# Remove records with invalid negative duration
df = df[df["Duration"] >= 0].copy()

print("\nShape after removing negative durations:")
print(df.shape)

print("\nNegative durations remaining:")
print((df["Duration"] < 0).sum())



print("\nDemand <= 0:")
print((df["Demand"] <= 0).sum())

print("\nDuration == 0:")
print((df["Duration"] == 0).sum())


zero_duration = df[df["Duration"] == 0]

print("\nZero-duration records:")
print(zero_duration.head(20))

print("\nNumber of zero-duration records:")
print(len(zero_duration))

print("\nDemand for zero-duration records:")
print(zero_duration["Demand"].describe())

print("\nZero-duration records with positive demand:")
print((zero_duration["Demand"] > 0).sum())



print("\nCharger company values:")
print(df["Charger_company"].value_counts().sort_index())

print("\nCharger type values:")
print(df["Charger_type"].value_counts().sort_index())

print("\nLocation values:")
print(df["Location"].value_counts())


print("\nCharger company:")
print(df["Charger_company"].value_counts())

print("\nCharger type:")
print(df["Charger_type"].value_counts())

print("\nNumber of locations:")
print(df["Location"].nunique())

print("\nCharger company:")
print(df["Charger_company"].value_counts())

print("\nCharger type:")
print(df["Charger_type"].value_counts())

print("\nNumber of locations:")
print(df["Location"].nunique())


# Create readable charger company category
df["Charger_company_label"] = df["Charger_company"].map({
    0: "Other Company",
    1: "Main Company"
})

# Create readable charger type category
df["Charger_type_label"] = df["Charger_type"].map({
    0: "Slow",
    1: "Fast"
})

print("\nCharger company labels:")
print(df["Charger_company_label"].value_counts())

print("\nCharger type labels:")
print(df["Charger_type_label"].value_counts())



# Create time-based analysis columns

df["Start_Hour"] = df["Start_datetime"].dt.hour

df["Day_of_Week"] = df["Start_datetime"].dt.day_name()

df["Month"] = df["Start_datetime"].dt.month_name()

df["Year"] = df["Start_datetime"].dt.year

print("\nNew time-based columns:")
print(df[
    [
        "Start_datetime",
        "Start_Hour",
        "Day_of_Week",
        "Month",
        "Year"
    ]
].head())


# Convert charging duration from minutes to hours
df["Duration_Hours"] = df["Duration"] / 60

print("\nDuration in hours:")
print(df[["Duration", "Duration_Hours"]].head())


# Create peak and off-peak charging category

df["Peak_OffPeak"] = df["Start_Hour"].apply(
    lambda x: "Peak" if 17 <= x <= 21 else "Off-Peak"
)

print("\nPeak vs Off-Peak:")
print(df["Peak_OffPeak"].value_counts())


print("\nFinal dataset shape:")
print(df.shape)

print("\nMissing values:")
print(df.isnull().sum())

print("\nNegative duration:")
print((df["Duration"] < 0).sum())

print("\nNegative demand:")
print((df["Demand"] < 0).sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())




output_path = r"D:\Data Analytics\EV Charging Station\data\EV_Charging_Cleaned.csv"

df.to_csv(output_path, index=False)

print("Cleaned dataset saved successfully.")
print("Rows:", df.shape[0])
print("Columns:", df.shape[1])
print("File:", output_path)












