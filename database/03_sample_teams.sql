
USE esports_db;

-- =========================================
-- 1. INSERT SAMPLE TOURNAMENT
-- =========================================

INSERT INTO tournaments (name, game, start_date, end_date)
VALUES (
    'Pakistan Esports Championship 2026',
    'Valorant',
    '2026-11-10',
    '2026-11-15'
);

-- =========================================
-- 2. INSERT SIX PAKISTANI TEAMS
-- =========================================

INSERT INTO teams (name, region, elo_rating, wins, losses)
VALUES
('Indus Falcons', 'Sindh', 1500.00, 0, 0),
('Margalla Wolves', 'Islamabad', 1500.00, 0, 0),
('Khyber Titans', 'Khyber Pakhtunkhwa', 1500.00, 0, 0),
('Ravi Raiders', 'Punjab', 1500.00, 0, 0),
('Thar Vipers', 'Sindh', 1500.00, 0, 0),
('Hunza Hawks', 'Gilgit-Baltistan', 1500.00, 0, 0);

-- =========================================
-- 3. REGISTER ALL SIX TEAMS
--    IN THE SAMPLE TOURNAMENT
-- =========================================

INSERT INTO tournament_teams (tournament_id, team_id)
SELECT t.tournament_id, tm.team_id
FROM tournaments t
CROSS JOIN teams tm
WHERE t.name = 'Pakistan Esports Championship 2026'
AND tm.name IN (
    'Indus Falcons',
    'Margalla Wolves',
    'Khyber Titans',
    'Ravi Raiders',
    'Thar Vipers',
    'Hunza Hawks'
);

-- =========================================
-- 4. INSERT PLAYERS FOR INDUS FALCONS
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'FalconX', 'Ali Ahmed', 'Duelist'
FROM teams WHERE name = 'Indus Falcons';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'ShadowFalcon', 'Usman Khan', 'Controller'
FROM teams WHERE name = 'Indus Falcons';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'FalconAce', 'Hamza Malik', 'Sentinel'
FROM teams WHERE name = 'Indus Falcons';

-- =========================================
-- 5. INSERT PLAYERS FOR MARGALLA WOLVES
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'WolfStrike', 'Ahmed Raza', 'Duelist'
FROM teams WHERE name = 'Margalla Wolves';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'AlphaWolf', 'Bilal Hussain', 'Controller'
FROM teams WHERE name = 'Margalla Wolves';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'WolfGuard', 'Saad Iqbal', 'Sentinel'
FROM teams WHERE name = 'Margalla Wolves';

-- =========================================
-- 6. INSERT PLAYERS FOR KHYBER TITANS
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'TitanKing', 'Zain Shah', 'Duelist'
FROM teams WHERE name = 'Khyber Titans';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'TitanGhost', 'Fahad Ali', 'Controller'
FROM teams WHERE name = 'Khyber Titans';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'TitanShield', 'Danish Khan', 'Sentinel'
FROM teams WHERE name = 'Khyber Titans';

-- =========================================
-- 7. INSERT PLAYERS FOR RAVI RAIDERS
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'RaviRage', 'Usama Tariq', 'Duelist'
FROM teams WHERE name = 'Ravi Raiders';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'RaiderPro', 'Hassan Javed', 'Controller'
FROM teams WHERE name = 'Ravi Raiders';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'RaviSniper', 'Abdullah Noor', 'Sentinel'
FROM teams WHERE name = 'Ravi Raiders';

-- =========================================
-- 8. INSERT PLAYERS FOR THAR VIPERS
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'ViperVenom', 'Ahsan Sheikh', 'Duelist'
FROM teams WHERE name = 'Thar Vipers';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'DesertViper', 'Rehan Ahmed', 'Controller'
FROM teams WHERE name = 'Thar Vipers';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'ViperEye', 'Saifullah Khan', 'Sentinel'
FROM teams WHERE name = 'Thar Vipers';

-- =========================================
-- 9. INSERT PLAYERS FOR HUNZA HAWKS
-- =========================================

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'HawkEye', 'Shahzaib Karim', 'Duelist'
FROM teams WHERE name = 'Hunza Hawks';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'SkyHawk', 'Muneeb Abbas', 'Controller'
FROM teams WHERE name = 'Hunza Hawks';

INSERT INTO players (team_id, gamer_tag, real_name, role)
SELECT team_id, 'HawkClaw', 'Ibrahim Shah', 'Sentinel'
FROM teams WHERE name = 'Hunza Hawks';
