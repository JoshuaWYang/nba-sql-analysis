/* ============================================================
   NBA GAME ANALYSIS
   Focus: Regular Season Performance
   ============================================================ */

/* ============================================================
   HIGHEST-SCORING GAMES
   Finds the ten highest-scoring regular-season games
   and the highest-scoring player in each game
   ============================================================ */

WITH GameData AS (
	SELECT
		g.matchup AS [Matchup],
		FORMAT(g.game_date, 'MM/dd/yyyy') AS [Game Date],
		g.winner AS [Winner],
		g.pts_home AS [Home Points],
		g.pts_away AS [Away Points],
		g.pts_home + g.pts_away AS [Total Points],
		g.min AS [Game Duration],
		p.player_name AS [Highest Scorer],
		p.pts AS [Points Scored],
		ROW_NUMBER() OVER (
			PARTITION BY g.game_id
			ORDER BY p.pts DESC
		) AS [Player Rank]
	FROM GameStatistics AS g
	JOIN PlayerStatistics AS p 
		ON g.game_id = p.game_id
	WHERE g.game_id LIKE '2%'
)
 
SELECT TOP 10
	[Matchup],
	[Game Date],
	[Winner],
	[Home Points],
	[Away Points],
	[Total Points],
	[Game Duration],
	[Highest Scorer],
	[Points Scored]
FROM GameData
WHERE [Player Rank] = 1
ORDER BY [Total Points] DESC;

/* ============================================================
   LARGEST BLOWOUTS
   Finds the ten regular-season games with the largest
   point differential and each team's leading scorer
   ============================================================ */

SELECT TOP 10
	g.matchup AS [Matchup],
	FORMAT(g.game_date, 'MM/dd/yyyy') AS [Game Date],
	g.winner AS [Winner],
	ABS(g.pts_home - g.pts_away) AS [Point Differential],
	WinnerScorer.player_name AS [Winner's Highest Scorer],
    WinnerScorer.pts AS [Winner's Scorer Points],
    LoserScorer.player_name AS [Loser's Highest Scorer],
    LoserScorer.pts AS [Loser's Scorer Points]

FROM GameStatistics AS g

OUTER APPLY (
	SELECT TOP 1
		p.player_name,
		p.pts
	FROM PlayerStatistics AS p
	WHERE p.game_id = g.game_id
		AND p.team_abbreviation = g.winner
	ORDER BY p.pts DESC
) AS WinnerScorer

OUTER APPLY (
	SELECT TOP 1
		p.player_name,
		p.pts
	FROM PlayerStatistics AS p
	WHERE p.game_id = g.game_id
		AND p.team_abbreviation != g.winner
	ORDER BY p.pts DESC
) AS LoserScorer

WHERE g.game_id LIKE '2%'
ORDER BY [Point Differential] DESC;

/* ============================================================
   HIGHEST-COMBINED SCORERS GAMES
   Finds the ten regular-season games with the highest
   combined points from the two highest-scoring players
   ============================================================ */

SELECT TOP 10
	g.matchup AS [Matchup],
	FORMAT(g.game_date, 'MM/dd/yyyy') AS [Game Date],
	HighestScorer.pts + SecondHighestScorer.pts AS [Combined Points],
	HighestScorer.player_name AS [Player 1 Name],
	HighestScorer.pts AS [Player 1 Points],
	SecondHighestScorer.player_name AS [Player 2 Name],
	SecondHighestScorer.pts AS [Player 2 Points]
FROM GameStatistics AS g

OUTER APPLY (
	SELECT TOP 1
		p.player_name,
		p.pts
	FROM PlayerStatistics AS p
	WHERE p.game_id = g.game_id
	ORDER BY p.pts DESC
) AS HighestScorer

OUTER APPLY (
	SELECT
		p.player_name,
		p.pts
	FROM PlayerStatistics AS p
	WHERE p.game_id = g.game_id
	ORDER BY p.pts DESC
	OFFSET 1 ROW
	FETCH NEXT 1 ROWS ONLY
) AS SecondHighestScorer

WHERE g.game_id LIKE '2%'
ORDER BY [Combined Points] DESC;

/* ============================================================
   HIGHEST-SCORING LOSING TEAMS
   Finds the ten highest-scoring teams that lost
   a regular-season game
   ============================================================ */

SELECT TOP 10
	g.matchup AS [Matchup],
	FORMAT(g.game_date, 'MM/dd/yyyy') AS [Game Date],
	g.winner AS [Winner],

	CASE
		WHEN g.pts_home < g.pts_away THEN RIGHT(g.matchup, 3)
		ELSE LEFT(g.matchup, 3)
	END AS [Loser],

	CASE
		WHEN g.pts_home < g.pts_away THEN g.pts_home
		ELSE g.pts_away
	END AS [Losing Team Points],

		CASE
		WHEN g.pts_home > g.pts_away THEN g.pts_home
		ELSE g.pts_away
	END AS [Winning Team Points]
FROM GameStatistics AS g
WHERE g.game_id LIKE '2%'
ORDER BY [Losing Team Points] DESC;
