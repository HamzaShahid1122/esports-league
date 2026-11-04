USE esports_db;

-- 1. Tournaments
CREATE TABLE tournaments (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    game VARCHAR(60) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT uq_tournament_name UNIQUE (name),
    CONSTRAINT chk_tournament_dates CHECK (end_date >= start_date)
);

-- 2. Teams
CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60) NOT NULL,
    region VARCHAR(60) NOT NULL,
    elo_rating DECIMAL(7,2) NOT NULL DEFAULT 1500.00,
    wins INT NOT NULL DEFAULT 0,
    losses INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_team_name UNIQUE (name),
    CONSTRAINT chk_team_numbers CHECK (
        elo_rating > 0 AND wins >= 0 AND losses >= 0
    )
);

-- 3. Players
CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    gamer_tag VARCHAR(40) NOT NULL,
    real_name VARCHAR(80) NOT NULL,
    role VARCHAR(30) NOT NULL,
    CONSTRAINT uq_gamer_tag UNIQUE (gamer_tag),
    CONSTRAINT fk_player_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id) ON DELETE RESTRICT
);

-- 4. Tournament registrations
CREATE TABLE tournament_teams (
    tournament_id INT NOT NULL,
    team_id INT NOT NULL,
    PRIMARY KEY (tournament_id, team_id),
    CONSTRAINT fk_tt_tournament FOREIGN KEY (tournament_id)
        REFERENCES tournaments (tournament_id) ON DELETE CASCADE,
    CONSTRAINT fk_tt_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id) ON DELETE CASCADE
);

-- 5. Matches
CREATE TABLE matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_id INT NOT NULL,
    team1_id INT NOT NULL,
    team2_id INT NOT NULL,
    winner_team_id INT NOT NULL,
    team1_elo_before DECIMAL(7,2) NOT NULL,
    team2_elo_before DECIMAL(7,2) NOT NULL,
    played_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_tournament FOREIGN KEY (tournament_id)
        REFERENCES tournaments (tournament_id) ON DELETE RESTRICT,
    CONSTRAINT fk_match_team1 FOREIGN KEY (team1_id)
        REFERENCES teams (team_id),
    CONSTRAINT fk_match_team2 FOREIGN KEY (team2_id)
        REFERENCES teams (team_id),
    CONSTRAINT fk_match_winner FOREIGN KEY (winner_team_id)
        REFERENCES teams (team_id),
    CONSTRAINT chk_two_different_teams CHECK (team1_id <> team2_id),
    CONSTRAINT chk_winner_played CHECK (
        winner_team_id IN (team1_id, team2_id)
    )
);

-- 6. Player statistics
CREATE TABLE player_stats (
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    kills INT NOT NULL DEFAULT 0,
    deaths INT NOT NULL DEFAULT 0,
    assists INT NOT NULL DEFAULT 0,
    PRIMARY KEY (match_id, player_id),
    CONSTRAINT fk_stats_match FOREIGN KEY (match_id)
        REFERENCES matches (match_id) ON DELETE CASCADE,
    CONSTRAINT fk_stats_player FOREIGN KEY (player_id)
        REFERENCES players (player_id) ON DELETE RESTRICT,
    CONSTRAINT chk_stats_not_negative CHECK (
        kills >= 0 AND deaths >= 0 AND assists >= 0
    )
);

-- 7. Rating history
CREATE TABLE rating_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    old_elo DECIMAL(7,2) NOT NULL,
    new_elo DECIMAL(7,2) NOT NULL,
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_history_team FOREIGN KEY (team_id)
        REFERENCES teams (team_id) ON DELETE RESTRICT
);
