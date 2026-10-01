import sqlite3
import numpy as np
import pandas as pd

df = pd.read_csv("data/raw/dataset.csv", encoding="latin-1")

# Strip stray spaces / non-breaking spaces from text columns
for col in df.select_dtypes(include="object").columns:
    df[col] = df[col].str.replace("\xa0", " ").str.strip()

# Dataset ends partway through 2021-22, so exclude the incomplete season
df = df[df["Season"] != "2021-22"].copy()

# Dates, ordering, and a match ID
df["MatchDate"] = pd.to_datetime(df["DateTime"], utc=True).dt.tz_localize(None).dt.normalize()
df = df.drop(columns="DateTime").sort_values(["MatchDate", "HomeTeam"]).reset_index(drop=True)
df["MatchID"] = df.index + 1

df["TotalGoals"] = df["FTHG"] + df["FTAG"]
df["HasMatchStats"] = df["HS"].notna().astype(int)  # nulls are left as NaN on purpose

# Long format: one row per team per match
home_map = {"HomeTeam": "Team", "AwayTeam": "Opponent", "FTHG": "GoalsFor", "FTAG": "GoalsAgainst",
            "HS": "Shots", "AS": "ShotsAgainst", "HST": "ShotsOnTarget", "AST": "ShotsOnTargetAgainst",
            "HC": "Corners", "AC": "CornersAgainst", "HF": "Fouls", "AF": "FoulsAgainst",
            "HY": "Yellows", "HR": "Reds"}
away_map = {"AwayTeam": "Team", "HomeTeam": "Opponent", "FTAG": "GoalsFor", "FTHG": "GoalsAgainst",
            "AS": "Shots", "HS": "ShotsAgainst", "AST": "ShotsOnTarget", "HST": "ShotsOnTargetAgainst",
            "AC": "Corners", "HC": "CornersAgainst", "AF": "Fouls", "HF": "FoulsAgainst",
            "AY": "Yellows", "AR": "Reds"}

keep = ["MatchID", "Season", "MatchDate", "Referee"] + list(home_map.values())
home = df.rename(columns=home_map)[keep].assign(Venue="Home")
away = df.rename(columns=away_map)[keep].assign(Venue="Away")
tm = pd.concat([home, away]).sort_values(["Team", "MatchDate", "MatchID"]).reset_index(drop=True)

# Result, points, and rolling form (points from the previous 5 games)
tm["Result"] = np.select([tm.GoalsFor > tm.GoalsAgainst, tm.GoalsFor == tm.GoalsAgainst], ["W", "D"], "L")
tm["Points"] = tm["Result"].map({"W": 3, "D": 1, "L": 0})
tm["Form5"] = tm.groupby("Team")["Points"].transform(lambda s: s.shift().rolling(5).sum())


# Season table: one row per team per season, with final league position
st = (tm.groupby(["Season", "Team"])
        .agg(Games=("Points", "size"),
             Points=("Points", "sum"),
             GoalsFor=("GoalsFor", "sum"),
             GoalsAgainst=("GoalsAgainst", "sum"))
        .reset_index())
st["GoalDiff"] = st["GoalsFor"] - st["GoalsAgainst"]
st["PPG"] = (st["Points"] / st["Games"]).round(2)
st = st.sort_values(["Season", "Points", "GoalDiff", "GoalsFor"],
                    ascending=[True, False, False, False])
st["SeasonRank"] = st.groupby("Season").cumcount() + 1


# Save to SQLite and CSV (Power BI reads the CSVs easily)
conn = sqlite3.connect("data/epl.db")
df.to_sql("matches", conn, if_exists="replace", index=False)
tm.to_sql("team_matches", conn, if_exists="replace", index=False)
conn.close()

df.to_csv("data/clean/matches.csv", index=False)
tm.to_csv("data/clean/team_matches.csv", index=False)

print(df.shape, tm.shape)
print(tm.groupby("Season").size().tail())