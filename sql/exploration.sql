

-- 1. How has home advantage changed over 30 seasons (home win %, home vs away goals)?
-- 6. How has goals per game changed over time?

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


-- 2. Which in-match stats (shots on target, corners, fouls) correlate most with winning? (2000-01+)

SELECT Result,
       ROUND(AVG(Shots), 1) AS shots,
       ROUND(AVG(ShotsOnTarget), 1) AS shots_on_target,
       ROUND(AVG(Corners), 1) AS corners,
       ROUND(AVG(Fouls), 1) AS fouls,
       ROUND(AVG(Yellows), 2) AS yellows
FROM team_matches
WHERE Shots IS NOT NULL
GROUP BY Result;



-- 3. Which teams have been the most dominant, by points per game per season?

SELECT Season, Team,
       COUNT(*) AS games,
       SUM(Points) AS points,
       ROUND(1.0 * SUM(Points) / COUNT(*), 2) AS ppg,
       SUM(GoalsFor) - SUM(GoalsAgainst) AS goal_diff
FROM team_matches
GROUP BY Season, Team
ORDER BY Season, ppg DESC;


-- 4. Do referees differ in home win rate or cards per game? (2000-01+, minimum match count)

SELECT Referee,
       COUNT(*) AS matches,
       ROUND(100.0 * SUM(FTR = 'H') / COUNT(*), 1) AS home_win_pct,
       ROUND(1.0 * SUM(HY + AY) / COUNT(*), 2) AS yellows_per_game,
       ROUND(1.0 * SUM(HR + AR) / COUNT(*), 3) AS reds_per_game
FROM matches
WHERE HasMatchStats = 1
GROUP BY Referee
HAVING COUNT(*) >= 100
ORDER BY matches DESC;




-- 5. How much does leading at half time predict the result? (1995-96+)

SELECT HTR AS half_time_result,
       COUNT(*) AS matches,
       ROUND(100.0 * SUM(FTR = 'H') / COUNT(*), 1) AS ft_home_win_pct,
       ROUND(100.0 * SUM(FTR = 'D') / COUNT(*), 1) AS ft_draw_pct,
       ROUND(100.0 * SUM(FTR = 'A') / COUNT(*), 1) AS ft_away_win_pct
FROM matches
WHERE HTR IS NOT NULL
GROUP BY HTR;




