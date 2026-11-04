use esports_db;

delimiter ;

DROP VIEW if EXISTS vw_team_leaderboard;
CREATE VIEW vw_team_leaderboard AS
SELECT
    team_id,
    name as team_name,
    wins,
    losses,
    CASE 
        WHEN (wins+losses)=0 THEN 0.00  
        ELSE  round((wins/(wins+losses))*100,2)
    END as win_percentage_rate,
    elo_rating
FROM teams
ORDER BY elo_rating DESC,wins DESC;

DROP VIEW if EXISTS vw_player_stats;

CREATE VIEW vw_player_stats AS
SELECT 
    p.player_id,
    p.gamer_tag AS player_handle,
    p.real_name,
    t.name AS team_name,
    ps.kills AS total_kills,
    ps.deaths AS total_deaths,
    fn_kd_ratio(ps.kills, ps.deaths) AS kd_ratio
FROM players p
LEFT JOIN teams t ON p.team_id = t.team_id
LEFT JOIN player_stats ps ON p.player_id = ps.player_id
ORDER BY kd_ratio DESC;

-- 3. Detailed Match History View
DROP VIEW IF EXISTS vw_match_history;
CREATE VIEW vw_match_history AS
SELECT 
    m.match_id,
    tourn.name AS tournament_name,
    t1.name AS team1_name,
    t2.name AS team2_name,
    w.name AS winner_name,
    m.team1_elo_before,
    m.team2_elo_before,
    m.played_at AS match_date
FROM matches m
JOIN tournaments tourn ON m.tournament_id = tourn.tournament_id
JOIN teams t1 ON m.team1_id = t1.team_id
JOIN teams t2 ON m.team2_id = t2.team_id
LEFT JOIN teams w ON m.winner_team_id = w.team_id
ORDER BY m.played_at DESC;