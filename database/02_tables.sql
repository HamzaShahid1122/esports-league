USE esports_db;
CREATE TABLE tournaments(
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    game VARCHAR(60) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    constraint uq_tournament_name UNIQUE(name),
    constraint chk_tournament_dates check (end_date>=start_date)
);

--har team ka row
CREATE TABLE teams(
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    region VARCHAR(60) NOT NULL,
    elo_rating DECIMAL(7,2) NOT NULL DEFAULT 1500.00,
    wins INT NOT NULL DEFAULT 0,
    losses INT NOT NULL DEFAULT 0,
    contraint uq_team_name UNIQUE (name),
    constraint chk_team_numbers check (elo_rating>0 AND wins >=0 AND losses >=0)
);

--har player ka row
CREATE Table players(
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    gamer_tag VARCHAR(40) NOT NULL,
    real_name VARCHAR(80) NOT NULL,
    role VARCHAR(30) NOT NULL,
    constraint uq_gamer_tag UNIQUE (gamer_tag),
    constraint fk_player_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id) ON delete RESTRICT
);

CREATE TABLE tournament_teams (
    tournament_id INT NOT NULL,
    team_id INT NOT NULL,
    PRIMARY KEY (tournament_id, team_id),
    CONSTRAINT fk_tt_tournament FOREIGN KEY (tournament_id)
        REFERENCES tournaments (tournament_id) ON DELETE CASCADE,
    CONSTRAINT fk_tt_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id) ON DELETE CASCADE
);

CREATE Table matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT NOT NULL,
    team1_id INT NOT NULL,
    team2_id INT NOT NULL,
    winner_team_id INT NOT NULL,
    team1_elo_before DECIMAL(7,2) NOT NULL,
    team2_elo_before DECIMAL(7,2) NOT NULL,
    played_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    constraint fk_match_tournament FOREIGN KEY (tournament_id)
        REFERENCES tournaments(tournament_id) on delete RESTRICT,
    constraint fk_match_team1 FOREIGN KEY(team2_id)
        REFERENCES teams (team_id),
    constraint fk_match_team2 FOREIGN KEY (team2_id)
        REFERENCES teams(team_id),
    constraint fk_match_winner FOREIGN KEY(winner_team_id)
        REFERENCES teams(team_id),
    constraint chk_two_different_teams check (team1_id <> team2_id),
    constraint chk_winner_played check (winner_team_id IN(team1_id,team2_id))
);

--6 stats 
CREATE Table player_stats(
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    kills INT NOT NULL DEFAULT 0,
    deaths INT NOT NULL DEFAULT 0,
    assists INT NOT NULL DEFAULT 0,
    PRIMARY KEY(match_id , player_id),
    constraint fk_stats_match FOREIGN KEY (match_id)
        REFERENCES matches(match_id) on delete CASCADE,
    constraint fk_stats_player FOREIGN KEY (player_id)
        REFERENCES players (player_id) on delete restrict,
    constraint chk_stats_not_negative check (kills>=0 and deaths>=0 and assits >=0 )
);

--7 history
CREATE Table rating_history(
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    old_elo DECIMAL(7,2) NOT NULL,
    new_elo DECIMAL(7,2) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    constraint fk_history_team FOREIGN KEY (team_id)
        refrences teams(team_id) on delete RESTRICT
;)