SELECT Season, Team,
       COUNT(*) AS games,
       SUM(Points) AS points,
       ROUND(1.0 * SUM(Points) / COUNT(*), 2) AS ppg,
       SUM(GoalsFor) - SUM(GoalsAgainst) AS goal_diff
FROM team_matches
GROUP BY Season, Team
ORDER BY Season, ppg DESC;