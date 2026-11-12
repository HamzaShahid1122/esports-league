USE esports_db;

-- Drop view if it already exists
DROP VIEW IF EXISTS vw_ranked_leaderboard;

-- Create Advanced Ranked Leaderboard using SQL Window Functions
CREATE VIEW vw_ranked_leaderboard AS
SELECT 
    team_id,
    name AS team_name,
    region,
    elo_rating,
    wins,
    losses,
    -- Global Ranking based on Elo
    RANK() OVER (ORDER BY elo_rating DESC, wins DESC) AS global_rank,
    -- Regional Ranking scoped by region partition
    RANK() OVER (PARTITION BY region ORDER BY elo_rating DESC, wins DESC) AS regional_rank
FROM teams;