SELECT Result,
       ROUND(AVG(Shots), 1) AS shots,
       ROUND(AVG(ShotsOnTarget), 1) AS shots_on_target,
       ROUND(AVG(Corners), 1) AS corners,
       ROUND(AVG(Fouls), 1) AS fouls,
       ROUND(AVG(Yellows), 2) AS yellows
FROM team_matches
WHERE Shots IS NOT NULL
GROUP BY Result;