USE esports_db;

START TRANSACTION;

-- Create a temporary valid match for testing
INSERT INTO matches (
    tournament_id, team1_id, team2_id, winner_team_id,
    team1_elo_before, team2_elo_before
)
VALUES (1, 1, 2, 1, 1500, 1500);

-- Test 1: Negative kills should be rejected
INSERT INTO player_stats (match_id, player_id, kills, deaths, assists)
VALUES (LAST_INSERT_ID(), 1, -5, 2, 3);

-- Test 2: A team cannot play against itself
INSERT INTO matches (
    tournament_id, team1_id, team2_id, winner_team_id,
    team1_elo_before, team2_elo_before
)
VALUES (1, 1, 1, 1, 1500, 1500);

-- Test 3: Winner must be one of the two playing teams
INSERT INTO matches (
    tournament_id, team1_id, team2_id, winner_team_id,
    team1_elo_before, team2_elo_before
)
VALUES (1, 1, 2, 3, 1500, 1500);

ROLLBACK;
