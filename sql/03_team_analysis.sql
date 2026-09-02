/* ============================================================
   NBA LEAGUE TEAM ANALYSIS
   SEASON: 2025-26
   Focus: Regular Season Performance
   ============================================================ */

/* ============================================================
   TEAM RECORD
   Calculates each team's overall, home, and away records
   ============================================================ */

WITH TeamRecords AS (
    SELECT
        team_name AS [Team],
        SUM(CASE WHEN wl = 1 THEN 1 ELSE 0 END) AS [Wins],
        COUNT(DISTINCT game_id) AS [Games Played],
        SUM(CASE WHEN wl = 1 AND is_home = 1 THEN 1 ELSE 0 END) AS [Home Wins],
        SUM(CASE WHEN is_home = 1 THEN 1 ELSE 0 END) AS [Home Games],
        SUM(CASE WHEN wl = 1 AND is_home = 0 THEN 1 ELSE 0 END) AS [Away Wins],
        SUM(CASE WHEN is_home = 0 THEN 1 ELSE 0 END) AS [Away Games]
    FROM TeamStatistics
    WHERE season_year = '2025-26'
        AND game_id LIKE '2%'
    GROUP BY team_id, team_name
)

SELECT
    [Team],
    [Wins],
    [Games Played] - [Wins] AS [Losses],
    CAST(ROUND([Wins] * 100.0 / [Games Played], 1) AS DECIMAL(4,1)) AS [Win Percentage],
    [Home Wins],
    [Home Games] - [Home Wins] AS [Home Losses],
    [Away Wins],
    [Away Games] - [Away Wins] AS [Away Losses]
FROM TeamRecords
ORDER BY [Wins] DESC;

/* ============================================================
   TEAM PROGRESSION
   Shows the Lakers' regular-season performance by season
   ============================================================ */

WITH AllTeamRecords AS (
    SELECT
        team_id AS [Team ID],
        team_name AS [Team],
        season_year AS [Season],
        SUM(CASE WHEN wl = 1 THEN 1 ELSE 0 END) AS [Wins],
        COUNT(DISTINCT game_id) AS [Games Played],
        CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
        ROUND(AVG(off_rating), 1) AS [Off. Rating],
        ROUND(AVG(def_rating), 1) AS [Def. Rating]     
    FROM TeamStatistics
    WHERE team_id = 1610612747
        AND game_id LIKE '2%'
    GROUP BY team_id, team_name, season_year
)

SELECT
    [Team ID],
    [Team],
    [Season],
    [Wins],
    [Games Played] - [Wins] AS [Losses],
    [PPG],
    [Off. Rating],
    [Def. Rating]
FROM AllTeamRecords
ORDER BY [Season] DESC;

/* ============================================================
   HOME VS. AWAY PERFORMANCE
   Compares the Lakers' performance at home and on the road
   ============================================================ */

SELECT
    CASE
        WHEN is_home = 0 THEN 'Away'
        ELSE 'Home'
    END AS [Location],
    team_name AS [Team],
    season_year AS [Season],
    SUM(CASE WHEN wl = 1 THEN 1 ELSE 0 END) AS [Wins],
    COUNT(DISTINCT game_id) - SUM(CASE WHEN wl = 1 THEN 1 ELSE 0 END) AS [Losses],
    CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
    CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
    CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%]
FROM TeamStatistics
WHERE season_year = '2025-26'
    AND team_id = 1610612747
    AND game_id LIKE '2%'
GROUP BY is_home, team_name, season_year
ORDER BY is_home DESC;

/* ============================================================
   TEAM IMPROVEMENT
   Finds the teams with the largest year-to-year improvement
   in win percentage
   ============================================================ */

WITH TeamRecords AS (
    SELECT 
        team_id AS [Team ID],
        team_name AS [Team],
        season_year AS [Season],
        SUM(CASE WHEN wl = 1 THEN 1 ELSE 0 END) AS [Wins],
        COUNT(DISTINCT game_id) AS [Games Played]
    FROM TeamStatistics
    WHERE season_year IN ('2024-25', '2025-26')
        AND game_id LIKE '2%'
    GROUP BY team_id, team_name, season_year
),

TeamWins AS (
    SELECT
        [Team ID],
        [Team],
        [Season],
        [Wins],
        [Games Played] - [Wins] AS [Losses],
        CAST([Wins] AS DECIMAL(4,1)) / [Games Played] AS [Win Percentage]
    FROM TeamRecords
),

PreviousSeason AS (
    SELECT
        [Team ID],
        [Team],
        [Season],
        [Wins],
        LAG([Wins]) OVER (
            PARTITION BY [Team ID]
            ORDER BY [Season]
        ) AS [Previous Wins],
        [Win Percentage],
        LAG([Win Percentage]) OVER (
            PARTITION BY [Team ID]
            ORDER BY [Season]
        ) AS [Previous Win Percentage]
    FROM TeamWins
)

SELECT
    [Team],
    [Season],
    [Wins],
    [Previous Wins],
    CAST([Win Percentage] * 100 AS DECIMAL(4,1)) AS [Win Percentage],
    CAST([Previous Win Percentage] * 100 AS DECIMAL(4,1)) AS [Previous Win Percentage],
    CAST(([Win Percentage] - [Previous Win Percentage]) * 100 AS DECIMAL(4,1)) AS [Improvement]
FROM PreviousSeason
WHERE [Previous Win Percentage] IS NOT NULL
ORDER BY [Improvement] DESC;

