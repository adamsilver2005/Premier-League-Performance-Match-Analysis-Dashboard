-- Q5: how often does the half-time result hold? (1995-96 onward)
SELECT HTR AS half_time_result,
       COUNT(*) AS matches,
       ROUND(100.0 * SUM(FTR = 'H') / COUNT(*), 1) AS ft_home_win_pct,
       ROUND(100.0 * SUM(FTR = 'D') / COUNT(*), 1) AS ft_draw_pct,
       ROUND(100.0 * SUM(FTR = 'A') / COUNT(*), 1) AS ft_away_win_pct
FROM matches
WHERE HTR IS NOT NULL
GROUP BY HTR;