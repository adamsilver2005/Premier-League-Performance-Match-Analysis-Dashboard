-- Q4: referee summary (2000-01 onward, minimum 100 matches)
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

-- Q4b: yellow cards per game by season (checks whether the spread is an era effect)
SELECT Season,
       ROUND(1.0 * SUM(HY + AY) / COUNT(*), 2) AS yellows_per_game
FROM matches
WHERE HasMatchStats = 1
GROUP BY Season
ORDER BY Season;

-- Q4c: league averages for reference lines
SELECT COUNT(*) AS matches,
       ROUND(100.0 * SUM(FTR = 'H') / COUNT(*), 1) AS home_win_pct,
       ROUND(1.0 * SUM(HY + AY) / COUNT(*), 2) AS yellows_per_game,
       ROUND(1.0 * SUM(HR + AR) / COUNT(*), 3) AS reds_per_game
FROM matches
WHERE HasMatchStats = 1;


-- Q4d: referee summary with era-adjusted yellows (2000-01 onward, min 100 matches)
WITH season_avg AS (
    SELECT Season, 1.0 * SUM(HY + AY) / COUNT(*) AS lg_yellows
    FROM matches
    WHERE HasMatchStats = 1
    GROUP BY Season
)
SELECT m.Referee,
       COUNT(*) AS matches,
       ROUND(100.0 * SUM(m.FTR = 'H') / COUNT(*), 1) AS home_win_pct,
       ROUND(1.0 * SUM(m.HY + m.AY) / COUNT(*), 2) AS yellows_per_game,
       ROUND(AVG(s.lg_yellows), 2) AS league_avg_same_seasons,
       ROUND(1.0 * SUM(m.HY + m.AY) / COUNT(*) - AVG(s.lg_yellows), 2) AS yellows_diff,
       ROUND(1.0 * SUM(m.HR + m.AR) / COUNT(*), 3) AS reds_per_game
FROM matches m
JOIN season_avg s ON m.Season = s.Season
WHERE m.HasMatchStats = 1
GROUP BY m.Referee
HAVING COUNT(*) >= 100
ORDER BY yellows_diff DESC;