USE esports_db;

DROP PROCEDURE IF EXISTS sp_record_match;

DELIMITER //
CREATE PROCEDURE sp_record_match(
    IN p_tournament_id INT,
    IN p_team1_id INT,
    IN p_team2_id INT,
    IN p_winner_id INT
)
BEGIN
    DECLARE v_t1_elo DECIMAL(7,2);
    DECLARE v_t2_elo DECIMAL(7,2);
    DECLARE v_loser_id INT;
    DECLARE K INT DEFAULT 32;
    DECLARE v_exp_t1 DECIMAL(5,4);
    DECLARE v_exp_t2 DECIMAL(5,4);
    DECLARE v_new_t1 DECIMAL(7,2);
    DECLARE v_new_t2 DECIMAL(7,2);

    -- Start Transaction
    START TRANSACTION;

    -- Determine Loser
    IF p_winner_id = p_team1_id THEN
        SET v_loser_id = p_team2_id;
    ELSE
        SET v_loser_id = p_team1_id;
    END IF;

    -- Get current Elo ratings
    SELECT elo_rating INTO v_t1_elo FROM teams WHERE team_id = p_team1_id;
    SELECT elo_rating INTO v_t2_elo FROM teams WHERE team_id = p_team2_id;

    -- Insert Match Record
    INSERT INTO matches (tournament_id, team1_id, team2_id, winner_team_id, team1_elo_before, team2_elo_before)
    VALUES (p_tournament_id, p_team1_id, p_team2_id, p_winner_id, v_t1_elo, v_t2_elo);

    -- Calculate Expected Scores
    SET v_exp_t1 = 1 / (1 + POW(10, (v_t2_elo - v_t1_elo) / 400));
    SET v_exp_t2 = 1 / (1 + POW(10, (v_t1_elo - v_t2_elo) / 400));

    -- Calculate New Elo Ratings
    IF p_winner_id = p_team1_id THEN
        SET v_new_t1 = ROUND(v_t1_elo + K * (1.0 - v_exp_t1), 2);
        SET v_new_t2 = ROUND(v_t2_elo + K * (0.0 - v_exp_t2), 2);
    ELSE
        SET v_new_t1 = ROUND(v_t1_elo + K * (0.0 - v_exp_t1), 2);
        SET v_new_t2 = ROUND(v_t2_elo + K * (1.0 - v_exp_t2), 2);
    END IF;

    -- Explicitly Update Team 1
    UPDATE teams 
    SET elo_rating = v_new_t1,
        wins = wins + IF(team_id = p_winner_id, 1, 0),
        losses = losses + IF(team_id = v_loser_id, 1, 0)
    WHERE team_id = p_team1_id;

    -- Explicitly Update Team 2
    UPDATE teams 
    SET elo_rating = v_new_t2,
        wins = wins + IF(team_id = p_winner_id, 1, 0),
        losses = losses + IF(team_id = v_loser_id, 1, 0)
    WHERE team_id = p_team2_id;

    COMMIT;
END //
DELIMITER ;
