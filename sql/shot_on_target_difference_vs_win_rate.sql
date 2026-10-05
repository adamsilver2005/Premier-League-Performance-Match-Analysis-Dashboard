SELECT bucket,
       COUNT(*) AS team_games,
       ROUND(100.0 * SUM(Result = 'W') / COUNT(*), 1) AS win_pct,
       ROUND(100.0 * SUM(Result = 'D') / COUNT(*), 1) AS draw_pct,
       ROUND(100.0 * SUM(Result = 'L') / COUNT(*), 1) AS loss_pct,	
       ROUND(AVG(Points), 2) AS avg_points
FROM (
    SELECT Result, Points,
           CASE
               WHEN ShotsOnTarget - ShotsOnTargetAgainst <= -4 THEN '1: -4 or fewer'
               WHEN ShotsOnTarget - ShotsOnTargetAgainst <= -2 THEN '2: -3 to -2'
               WHEN ShotsOnTarget - ShotsOnTargetAgainst <= 1  THEN '3: -1 to +1'
               WHEN ShotsOnTarget - ShotsOnTargetAgainst <= 3  THEN '4: +2 to +3'
               ELSE '5: +4 or more'
           END AS bucket
    FROM team_matches
    WHERE ShotsOnTarget IS NOT NULL
)
GROUP BY bucket
ORDER BY bucket;