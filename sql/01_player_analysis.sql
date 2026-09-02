/* ============================================================
   NBA PLAYER STATISTICS ANALYSIS
   Player: LeBron James
   Focus: Regular Season Performance
   ============================================================ */

/* ============================================================
   CAREER AVERAGES
   Calculates LeBron James' career regular-season averages
   across scoring, playmaking, rebounding, defense, and shooting
   ============================================================ */

SELECT 
	player_name AS [Player],
	CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
	CAST(ROUND(AVG(CAST(ast AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [APG],
	CAST(ROUND(AVG(CAST(reb AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [RPG],
	CAST(ROUND(AVG(CAST(stl AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [SPG],
	CAST(ROUND(AVG(CAST(blk AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [BPG],
	CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
	COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE player_name = 'Lebron James' 
	AND min > 0 
	AND game_id LIKE '2%'
GROUP BY player_name;

/* ============================================================
   HIGHEST-SCORING GAMES
   Shows LeBron James' ten highest-scoring regular-season games
   along with his other statistics from each game
   ============================================================ */

SELECT TOP 10 
    player_name AS [Player],
    FORMAT(game_date, 'MM/dd/yyyy') AS [Game Date],
    matchup AS [Matchup],
    pts AS [PTS],
    reb AS [REB],
    ast AS [AST],
	fga AS [FGA],
	fgm AS [FGM],
	fta AS [FTA],
	ftm AS [FTM],

    CONCAT(CAST(ROUND(CAST(fgm AS DECIMAL(10,2)) / NULLIF(fga, 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
    CONCAT(CAST(ROUND(CAST(fg3m AS DECIMAL(10,2)) / NULLIF(fg3a, 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(CAST(ftm AS DECIMAL(10,2)) / NULLIF(fta, 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(min, 1) AS DECIMAL(5,1)) AS [MIN]
FROM PlayerStatistics
WHERE player_name = 'Lebron James'
    AND min > 0
    AND game_id LIKE '2%'
ORDER BY pts DESC;

/* ============================================================
   HOME VS. AWAY PERFORMANCE
   Compares LeBron James' regular-season performance
   in home and away games
   ============================================================ */

SELECT
    CASE 
		WHEN is_home = 0 THEN 'Away'
		ELSE 'Home' 
	END AS [Location],
	player_name AS [Player],
	CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
	CAST(ROUND(AVG(CAST(ast AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [APG],
	CAST(ROUND(AVG(CAST(reb AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [RPG],
	CAST(ROUND(AVG(CAST(stl AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [SPG],
	CAST(ROUND(AVG(CAST(blk AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [BPG],
	CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
	COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE player_name = 'Lebron James' 
	AND min > 0 
	AND game_id LIKE '2%'
GROUP BY is_home, player_name
ORDER BY is_home DESC, player_name;

/* ============================================================
   WIN VS. LOSS PERFORMANCE
   Compares LeBron James' regular-season performance
   in wins and losses
   ============================================================ */

SELECT
    CASE 
		WHEN wl = 1 THEN 'Win'
		ELSE 'Loss' 
	END AS [Result],
	player_name AS [Player],
	CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
	CAST(ROUND(AVG(CAST(ast AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [APG],
	CAST(ROUND(AVG(CAST(reb AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [RPG],
	CAST(ROUND(AVG(CAST(stl AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [SPG],
	CAST(ROUND(AVG(CAST(blk AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [BPG],
	CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
	COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE player_name = 'Lebron James' 
	AND min > 0 
	AND game_id LIKE '2%'
GROUP BY wl, player_name
ORDER BY wl DESC, player_name;

/* ============================================================
   SEASON-BY-SEASON PERFORMANCE
   Shows how LeBron James' regular-season averages
   have changed throughout his career
   ============================================================ */

SELECT 
	season_year AS [Season],
	player_name AS [Player],
	CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
	CAST(ROUND(AVG(CAST(ast AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [APG],
	CAST(ROUND(AVG(CAST(reb AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [RPG],
	CAST(ROUND(AVG(CAST(stl AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [SPG],
	CAST(ROUND(AVG(CAST(blk AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [BPG],
	CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
	CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
	COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE player_name = 'Lebron James' 
	AND min > 0 
	AND game_id LIKE '2%'
GROUP BY season_year, player_name
ORDER BY season_year DESC, player_name;

/* ============================================================
   PLAYER COMPARISON
   Compares regular-season averages between LeBron James
   and Stephen Curry
   ============================================================ */

SELECT
    player_name AS [Player],
	CAST(ROUND(AVG(CAST(pts AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [PPG],
	CAST(ROUND(AVG(CAST(ast AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [APG],
	CAST(ROUND(AVG(CAST(reb AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [RPG],
	CAST(ROUND(AVG(CAST(stl AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [SPG],
	CAST(ROUND(AVG(CAST(blk AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [BPG],
	CAST(ROUND(AVG(CAST(tov AS DECIMAL(10,2))), 1) AS DECIMAL(5,1)) AS [TPG],
	CONCAT(CAST(ROUND(SUM(CAST(fgm AS DECIMAL(10,2))) / NULLIF(SUM(fga), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FG%],
	CONCAT(CAST(ROUND(SUM(CAST(fg3m AS DECIMAL(10,2))) / NULLIF(SUM(fg3a), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [3P%],
	CONCAT(CAST(ROUND(SUM(CAST(ftm AS DECIMAL(10,2))) / NULLIF(SUM(fta), 0) * 100, 1) AS DECIMAL(5,1)), '%') AS [FT%],
    CAST(ROUND(AVG(min), 1) AS DECIMAL(5,1)) AS [MIN],
    COUNT(DISTINCT game_id) AS [Games Played]
FROM PlayerStatistics
WHERE player_name IN ('Lebron James', 'Stephen Curry')
    AND min > 0
    AND game_id LIKE '2%'
GROUP BY player_name;

/* ============================================================
   PLAYER CAREER HIGHS
   Finds LeBron James' highest season averages
   in major statistical categories
   ============================================================ */

WITH SeasonAverages AS (
	SELECT
		player_name AS [Player],
		season_year AS [Season],
	AVG(CAST(pts AS DECIMAL(10,2))) AS [PPG],
	AVG(CAST(ast AS DECIMAL(10,2))) AS [APG],
	AVG(CAST(reb AS DECIMAL(10,2))) AS [RPG],
	AVG(CAST(stl AS DECIMAL(10,2))) AS [SPG],
	AVG(CAST(blk AS DECIMAL(10,2))) AS [BPG]
	FROM PlayerStatistics
	WHERE player_name = 'Lebron James'
		AND game_id LIKE '2%'
		AND min > 0
	GROUP BY player_name, season_year
),

PPGRank AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY [PPG] DESC) AS PPG_Rank
    FROM SeasonAverages
),

APGRank AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY [APG] DESC) AS APG_Rank
    FROM SeasonAverages
),

RPGRank AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY [RPG] DESC) AS RPG_Rank
    FROM SeasonAverages
),

SPGRank AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY [SPG] DESC) AS SPG_Rank
    FROM SeasonAverages
),

BPGRank AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY [BPG] DESC) AS BPG_Rank
    FROM SeasonAverages
)

SELECT
	[Player],
    'PPG' AS [Stat],
	CAST([PPG] AS DECIMAL(5,1)) AS [Career High],
    [Season]
FROM PPGRank
WHERE PPG_Rank = 1

UNION ALL

SELECT
	[Player],
    'APG',
    CAST([APG] AS DECIMAL(5,1)) AS [Career High],
    [Season]
FROM APGRank
WHERE APG_Rank = 1

UNION ALL

SELECT
	[Player],
    'RPG',
    CAST([RPG] AS DECIMAL(5,1)) AS [Career High],
    [Season]
FROM RPGRank
WHERE RPG_Rank = 1

UNION ALL

SELECT
	[Player],
    'SPG',
    CAST([SPG] AS DECIMAL(5,1)) AS [Career High],
    [Season]
FROM SPGRank
WHERE SPG_Rank = 1

UNION ALL

SELECT
	[Player],
    'BPG',
    CAST([BPG] AS DECIMAL(5,1)) AS [Career High],
    [Season]
FROM BPGRank
WHERE BPG_Rank = 1;
