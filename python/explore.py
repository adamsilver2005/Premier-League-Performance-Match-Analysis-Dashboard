# exploratory analysis of the dataset
# want to see how many rows and seasons there are, which columns exist, if there are any missing values, team name discrepancies etc.


import pandas as pd

data = pd.read_csv("data/raw/dataset.csv", encoding = "latin-1")  

print(data.shape)
print(data.columns.tolist())
print(data.head())
print(data.tail())
print(data.dtypes)
print(data.isna().sum())
print(data["HomeTeam"].nunique(), sorted(data["HomeTeam"].unique()))