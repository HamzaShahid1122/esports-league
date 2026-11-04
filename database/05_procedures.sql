----Match recording

DELIMITER //

DROP Procedure IF EXISTS sp_record_match//
CREATE Procedure sp_record_match(
    in p_tournament_id int,
    in p_team1_id int,
    in p_team2_id int,
    in p_winner_id int,
    in p_team1_score int,
    in p_team2_score INT
)
begin
    DECLARE v_k_factor INT DEFAULT 32;
    DECLARE v_elo1 int;
    DECLARE v_elo2 int;
    declare v_expected1 DECIMAL(5,4);
    declare v_expected2 decimal(5,4);
    DECLARE v_actual1 decimal(3,2);
    declare v_actual2 decimal(3,2);
    declare v_new_elo1 int;
    DECLARE v_new_elo2 int;

    START TRANSACTION;

   INSERT INTO matches (tournament_id, team1_id, team2_id, winner_id, team1_score, team2_score, status)
    VALUES (p_tournament_id, p_team1_id, p_team2_id, p_winner_id, p_team1_score, p_team2_score, 'COMPLETED');

    SELECT elo_rating INTO v_elo1 FROM teams WHERE team_id = p_team1_id FOR UPDATE;
    SELECT elo_rating INTO v_elo2 FROM teams WHERE team_id = p_team2_id FOR UPDATE;

    SET v_expected1=fn_win_probability(v_elo1,v_elo2);
    SET v_expected2=1.0-v_expected1;

    if p_winner_id=p_team1_id THEN
        set v_actual1=1.0;
        set v_actual2=0.0;
        UPDATE teams set wins=wins+1 WHERE team_id=p_team1_id;
        UPDATE teams set losses=losses+1 where team_id=p_team2_id;
    ELSE
        set v_actual1=0.0;
        set v_actual2=1.0;
        UPDATE teams SET wins = wins + 1 WHERE team_id = p_team2_id;
        UPDATE teams SET losses = losses + 1 WHERE team_id = p_team1_id;
    END IF;

    SET v_new_elo1=Greatest(1000, ROUND(v_elo1+v_k_factor*(v_actual1-v_expected1)));
    SET v_new_elo2=Greatest(1000, ROUND(v_elo2+v_k_factor*(v_actual2-v_expected2)));

    UPDATE teams set elo_rating=v_new_elo1 WHERE team_id=p_team1_id;
    UPDATE teams set elo_rating=v_new_elo2 WHERE team_id=p_team2_id;

    COMMIT;
END //

DELIMITER ;