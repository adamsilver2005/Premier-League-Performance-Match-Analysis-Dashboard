import pandas as pd

tm = pd.read_csv("data/clean/team_matches.csv").dropna(subset=["Shots"])

cols = ["Points", "Shots", "ShotsOnTarget", "Corners", "Fouls", "Yellows"]

corr = tm[cols].corr()["Points"].drop("Points").round(3).reset_index()
corr.columns = ["Stat", "Correlation"]
corr.to_csv("data/clean/stat_correlations.csv", index=False)
print(tm[cols].corr()["Points"].round(3))