/* ============================================================
   NBA LEAGUE STATISTICS ANALYSIS
   SEASON: 2025-26
   Focus: Regular Season Performance
   ============================================================ */

/* ============================================================
   SCORING LEADERBOARD
   Ranks the top ten players by points per game
   and displays their shooting and scoring statistics
   ============================================================ */

SELECT TOP 10
    player_name AS [Player],
    CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
    CAST(ROUND(AVG(CAST(fga AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [FGA],
    CAST(ROUND(AVG(CAST(fgm AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [FGM],
    CAST(ROUND(AVG(CAST(fta AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [FTA],
    CAST(ROUND(AVG(CAST(ftm AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [FTM],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
    COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE season_year = '2025-26'
    AND min > 0
    AND game_id LIKE '2%'
GROUP BY player_id, player_name
HAVING COUNT(DISTINCT game_id) >= 20
ORDER BY PPG DESC;

/* ============================================================
   TRIPLE-DOUBLE LEADERBOARD
   Ranks the top ten players by number of triple-doubles
   ============================================================ */

SELECT TOP 10
    player_name AS [Player],
    COUNT(DISTINCT game_id) AS [Triple Doubles]
FROM PlayerStatistics
WHERE season_year = '2025-26'
    AND (CASE WHEN pts >= 10 THEN 1 ELSE 0 END +
     CASE WHEN ast >= 10 THEN 1 ELSE 0 END +
     CASE WHEN reb >= 10 THEN 1 ELSE 0 END +
     CASE WHEN stl >= 10 THEN 1 ELSE 0 END +
     CASE WHEN blk >= 10 THEN 1 ELSE 0 END) >= 3
    AND min > 0
    AND game_id LIKE '2%'
GROUP BY player_id, player_name
ORDER BY [Triple Doubles] DESC;

/* ============================================================
   YEAR-TO-YEAR IMPROVEMENT
   Ranks the top ten players by improvement in PPG
   from the 2024-25 season to the 2025-26 season
   ============================================================ */
   
WITH SeasonAverages AS (
    SELECT
        player_id AS [Player ID],
        player_name AS [Player],
        season_year AS [Season],
        AVG(CAST(pts AS DECIMAL(10,2))) AS [PPG],
        COUNT(DISTINCT game_id) AS [Games Played]
    FROM PlayerStatistics
    WHERE min > 0
        AND game_id LIKE '2%'
        AND season_year IN ('2024-25', '2025-26')
    GROUP BY player_id, player_name, season_year
),

PreviousSeason AS (
    SELECT
        [Player ID],
        [Player],
        [Season],
        [PPG],
        [Games Played],
        LAG([PPG]) OVER (
            PARTITION BY [Player ID]
            ORDER BY [Season] 
            ) AS [Prev. PPG],
        LAG([Games Played]) OVER (
            PARTITION BY [Player ID]
            ORDER BY [Season]
            ) AS [Prev. Games Played]
    FROM SeasonAverages
)	

SELECT TOP 10
    [Player],
    CAST([Prev. PPG] AS DECIMAL(5,1)) AS [Prev. PPG],
    CAST([PPG] AS DECIMAL(5,1)) AS [PPG],
    CAST([PPG] - [Prev. PPG] AS DECIMAL(5,1)) AS [PPG Improvement],
    [Games Played],
    [Prev. Games Played]
FROM PreviousSeason	
WHERE [Season] = '2025-26'
    AND [Prev. PPG] IS NOT NULL
    AND [Games Played] >= 20
    AND [Prev. Games Played] >= 20
ORDER BY [PPG Improvement] DESC;

/* ============================================================
   STATISTICAL LEADERS
   Identifies the league leader in total points, assists,
   rebounds, blocks, steals, and turnovers
   ============================================================ */
    
WITH PlayerTotals AS (
    SELECT
        player_name AS [Player],
        SUM(pts) AS [Total Points],
        SUM(ast) AS [Total Assists],
        SUM(reb) AS [Total Rebounds],
        SUM(blk) AS [Total Blocks],
        SUM(stl) AS [Total Steals],
        SUM(tov) AS [Total Turnovers]
    FROM PlayerStatistics
    WHERE season_year = '2025-26'
        AND game_id LIKE '2%'
    GROUP BY player_id, player_name
),

Leaders AS (
    SELECT
        'Points' AS [Statistic],
        [Player],
        [Total Points] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Points] DESC) AS [Rank]
    FROM PlayerTotals

    UNION ALL
    SELECT
        'Assists' AS [Statistic],
        [Player],
        [Total Assists] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Assists] DESC) AS [Rank]
    FROM PlayerTotals

    UNION ALL
    SELECT
        'Rebounds' AS [Statistic],
        [Player],
        [Total Rebounds] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Rebounds] DESC) AS [Rank]
    FROM PlayerTotals

    UNION ALL
    SELECT
        'Blocks' AS [Statistic],
        [Player],
        [Total Blocks] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Blocks] DESC) AS [Rank]
    FROM PlayerTotals

    UNION ALL
    SELECT
        'Steals' AS [Statistic],
        [Player],
        [Total Steals] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Steals] DESC) AS [Rank]
    FROM PlayerTotals

    UNION ALL
    SELECT
        'Turnovers' AS [Statistic],
        [Player],
        [Total Turnovers] AS [Stat Total],
        ROW_NUMBER() OVER (ORDER BY [Total Turnovers] DESC) AS [Rank]
    FROM PlayerTotals
)

SELECT
    [Statistic],
    [Player],
    [Stat Total]
FROM Leaders
WHERE Rank = 1
        
