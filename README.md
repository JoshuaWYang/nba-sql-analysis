# NBA SQL Analysis

A SQL-based analysis of NBA player, team, league, and game performance using Microsoft SQL Server. This project uses NBA data spanning 1996 to the present to analyze player comparisons, team trends, league leaderboards, and notable game performances.

## Project Overview

The goal of this project is to use SQL to analyze NBA statistics at four levels:

* **Player Analysis** — career performance, season trends, splits, comparisons, and career highs
* **League Analysis** — scoring leaders, triple-doubles, statistical leaders, and year-to-year improvement
* **Team Analysis** — team records, home/away performance, season progression, and year-to-year improvement
* **Game Analysis** — highest-scoring games, largest blowouts, combined scoring performances, and high-scoring losses

The project focuses on regular-season data and demonstrates the use of SQL for cleaning, aggregating, comparing, and analyzing large sports datasets.

## Tools & Technologies

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* SQL

## SQL Techniques Used

* Common Table Expressions (CTEs)
* Aggregate functions (`AVG`, `SUM`, `COUNT`)
* `GROUP BY` and `HAVING`
* `CASE` statements
* `JOIN`
* `OUTER APPLY`
* Window functions
* `ROW_NUMBER`
* `LAG`
* `UNION ALL`
* Conditional aggregation
* Data type conversion and formatting
* Percentage and rate calculations
* Multi-season comparisons

## Analysis

### Player Analysis

Analyzes LeBron James' regular-season career performance and compares his statistics across different situations and seasons.

Includes:

* Career averages
* Highest-scoring games
* Home vs. away performance
* Win vs. loss performance
* Season-by-season progression
* LeBron James vs. Stephen Curry comparison
* Career-high season averages across major statistical categories

### League Analysis

Analyzes league-wide player performance during the 2025-26 NBA season.

Includes:

* Top 10 scoring leaderboard
* Triple-double leaderboard
* Year-to-year PPG improvement from 2024-25 to 2025-26
* League leaders in points, assists, rebounds, blocks, steals, and turnovers

Minimum-game requirements are used where appropriate to avoid rankings being distorted by small sample sizes.

### Team Analysis

Analyzes NBA team performance with additional focus on the Los Angeles Lakers.

Includes:

* League-wide team records
* Home and away records
* Lakers season-by-season progression
* Lakers home vs. away performance
* Offensive and defensive ratings
* Year-to-year team improvement based on win percentage

### Game Analysis

Analyzes notable regular-season games across the dataset.

Includes:

* Highest-scoring games
* Leading scorer from each highest-scoring game
* Largest blowouts
* Leading scorers for winning and losing teams
* Games with the highest combined scoring from the top two players
* Highest-scoring losing teams

## Dataset

The project uses the **NBA Stats Dataset: 1996 - Present** from Kaggle.

Dataset:
https://www.kaggle.com/datasets/chevronronson/nba-stats-dataset

The raw dataset is not included in this repository due to file size. The original dataset can be downloaded from Kaggle using the link above.

## Data Preparation

The original Kaggle files were renamed for consistency before being imported into Microsoft SQL Server:

* `player_boxscores.csv` → `PlayerStatistics.csv`
* `games_index.csv` → `GameStatistics.csv`
* `team_boxscores.csv` → `TeamStatistics.csv`

The datasets were then imported into SQL Server as the PlayerStatistics, GameStatistics, and TeamStatistics tables.

Additional data preparation included:

* Reviewing and correcting SQL data types
* Handling missing values
* Preserving game and player identifiers
* Filtering regular-season games
* Standardizing calculations for averages and shooting percentages
* Using unique player and team IDs when grouping records

Shooting percentages across multiple games are calculated using total makes divided by total attempts rather than averaging individual-game percentages.

## Future Improvements

Potential future additions include:

* Play-by-play analysis
* Largest comeback victories
* Lead-change analysis
* Clutch performance analysis
* Scoring-run analysis
* Data visualizations and dashboards
