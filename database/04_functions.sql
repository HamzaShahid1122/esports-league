----functions
USE esports_db;
DELIMITER //

DROP Function IF EXISTS fn_win_probability//
CREATE Function fn_win_propability(team1_elo int,team2_elo int)
RETURNS decimal(5,4)
deterministic
BEGIN
    DECLARE diff decimal(10,4);
    DECLARE prob decimal(5,4);


    set diff=(team2_elo-team1_elo)/400.0;
    SET prob=1.0/(1.0+POW(10.0,diff));

    return prob;
END//

DROP FUNCTION if EXISTS fn_kd_ratio//
CREATE FUNCTION fn_kd_ratio(total_kills int,total_deaths int)
RETURNS DECIMAL(5,2)
deterministic
BEGIN
    if total_deaths=0 then
        return total_kills;
    ELSE
        RETURN round(total_kills/total_deaths,2);
    end if;
end//

DELIMITER;