
SELECT Season,
       COUNT(*) AS matches,
       ROUND(100.0 * SUM(FTR = 'H') / COUNT(*), 1) AS home_win_pct,
       ROUND(100.0 * SUM(FTR = 'D') / COUNT(*), 1) AS draw_pct,
       ROUND(100.0 * SUM(FTR = 'A') / COUNT(*), 1) AS away_win_pct,
       ROUND(AVG(FTHG), 2) AS avg_home_goals,
       ROUND(AVG(FTAG), 2) AS avg_away_goals,
       ROUND(AVG(TotalGoals), 2) AS goals_per_game
FROM matches
GROUP BY Season
ORDER BY Season;