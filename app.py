import streamlit as st
import pandas as pd
import mysql.connector

# Page Configuration
st.set_page_config(
    page_title="E-Sports League Manager",
    page_icon="🕹️",
    layout="wide"
)

# --- VIBRANT RETRO ARCADE THEME CSS ---
st.markdown("""
    <style>
    /* Main Background - Deep Arcade Navy/Purple */
    .stApp {
        background: linear-gradient(135deg, #120428 0%, #080110 100%);
        color: #f1f5f9;
        font-family: 'Courier New', Courier, monospace;
    }
    
    /* Sharp, Clean Retro Headers */
    h1, h2, h3, h4 {
        color: #ffcc00 !important;
        font-family: 'Impact', Charcoal, sans-serif;
        text-transform: uppercase;
        letter-spacing: 2px;
        text-shadow: 3px 3px 0px #ff0055;
    }
    
    /* Sidebar Styling */
    [data-testid="stSidebar"] {
        background-color: #1a0833;
        border-right: 3px solid #ff0055;
    }
    
    /* Vibrant Arcade Buttons */
    .stButton>button {
        background: linear-gradient(90deg, #ff0055, #ff5500);
        color: #ffffff;
        border: 2px solid #ffcc00;
        border-radius: 6px;
        font-weight: bold;
        font-size: 1rem;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        box-shadow: 0 4px 0 #990033;
        transition: all 0.1s ease;
    }
    
    .stButton>button:active {
        transform: translateY(4px);
        box-shadow: 0 0 0 #990033;
    }
    
    /* Input Fields - Sharp and High Contrast */
    div[data-baseweb="input"] > div, div[data-baseweb="select"] > div {
        background-color: #240a4a !important;
        color: #00ffcc !important;
        border: 2px solid #00ffcc !important;
        border-radius: 4px;
    }
    
    /* Crisp Dataframe Card */
    [data-testid="stDataFrame"] {
        background-color: #150529;
        border: 3px solid #00ffcc;
        border-radius: 8px;
        padding: 5px;
        box-shadow: 5px 5px 0px rgba(0, 255, 204, 0.2);
    }

    /* Tabs Styling */
    .stTabs [data-baseweb="tab-list"] button {
        color: #00ffcc;
        font-weight: bold;
        font-size: 1.1rem;
        background-color: #1a0833;
        border-radius: 4px 4px 0 0;
        margin-right: 4px;
    }
    
    .stTabs [data-baseweb="tab-list"] button[aria-selected="true"] {
        color: #ffffff !important;
        background-color: #ff0055 !important;
        border-bottom: 3px solid #ffcc00 !important;
    }
    </style>
""", unsafe_allow_html=True)

# Database Connection Helper
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",          
        password="Hamza1234",          # Put your MySQL password here if you have one
        database="esports_db"
    )

def execute_query(query, params=None, fetch=False):
    """Executes SQL queries safely."""
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params or ())
        if fetch:
            result = cursor.fetchall()
            df = pd.DataFrame(result)
        else:
            conn.commit()
            df = None
        cursor.close()
        conn.close()
        return df
    except Exception as e:
        st.error(f"Database Error: {e}")
        return pd.DataFrame() if fetch else False

# --- APP HEADER ---
st.title("🕹️ ARCADE LEAGUE CONTROL CENTER")
st.markdown("<b>[ SYSTEM STATUS: ONLINE ]</b> — *Enterprise Tournament & Elo Engine*", unsafe_allow_html=True)
st.divider()

# --- SIDEBAR: RBAC & ADMIN CONTROLS ---
with st.sidebar:
    st.header("🔐 ACCESS CONTROL (RBAC)")
    user_role = st.selectbox("Select Role", ["Viewer / Player", "League Admin"])
    
    is_admin = False
    if user_role == "League Admin":
        admin_pass = st.text_input("Admin Passcode", type="password")
        if admin_pass == "admin123":
            is_admin = True
            st.success("Admin Access Granted!")
        else:
            st.warning("Enter admin passcode (try: admin123)")
    
    st.divider()
    
    if is_admin:
        st.header("⚙️ ARCADE CONSOLE (ADMIN)")
        
        # 1. Register New Team
        with st.expander("➕ Register New Team"):
            with st.form("team_form", clear_on_submit=True):
                team_name = st.text_input("Team Name")
                region = st.selectbox("Region", ["Islamabad", "Punjab", "Sindh", "Khyber Pakhtunkhwa", "Gilgit-Baltistan", "Global"])
                submitted_team = st.form_submit_button("Save Team")
                
                if submitted_team:
                    if team_name.strip():
                        try:
                            conn = get_connection()
                            cursor = conn.cursor()
                            cursor.execute(
                                "INSERT INTO teams (name, region, elo_rating, wins, losses) VALUES (%s, %s, 1500.00, 0, 0);", 
                                (team_name.strip(), region)
                            )
                            conn.commit()
                            cursor.close()
                            conn.close()
                            st.success(f"Team '{team_name}' registered!")
                            st.rerun()
                        except mysql.connector.Error as err:
                            st.error(f"Database Error: {err}")
                    else:
                        st.warning("Please enter a valid team name.")

        # 2. Sign New Player
        with st.expander("👤 Sign New Player"):
            teams_df = execute_query("SELECT team_id, name FROM teams;", fetch=True)
            if not teams_df.empty:
                team_dict = dict(zip(teams_df['name'], teams_df['team_id']))
                with st.form("player_form", clear_on_submit=True):
                    player_team = st.selectbox("Assign to Team", list(team_dict.keys()))
                    gamer_tag = st.text_input("Gamer Tag")
                    real_name = st.text_input("Real Name")
                    role = st.selectbox("Role", ["IGL", "Entry Fragger", "Support", "Sniper", "Lurker"])
                    
                    submitted_player = st.form_submit_button("Sign Player")
                    if submitted_player:
                        if gamer_tag.strip() and real_name.strip():
                            t_id = team_dict[player_team]
                            try:
                                conn = get_connection()
                                cursor = conn.cursor()
                                cursor.execute(
                                    "INSERT INTO players (team_id, gamer_tag, real_name, role) VALUES (%s, %s, %s, %s);",
                                    (t_id, gamer_tag.strip(), real_name.strip(), role)
                                )
                                conn.commit()
                                cursor.close()
                                conn.close()
                                st.success(f"Player '{gamer_tag}' signed!")
                                st.rerun()
                            except mysql.connector.Error as err:
                                st.error(f"Database Error: {err}")
                        else:
                            st.warning("Please fill in all details.")
            else:
                st.info("Register a team first.")

        # 3. Record Match Result
        with st.expander("⚔️ Record Match Result"):
            teams_df = execute_query("SELECT team_id, name FROM teams;", fetch=True)
            tourns_df = execute_query("SELECT tournament_id, name FROM tournaments;", fetch=True)
            
            if not teams_df.empty and not tourns_df.empty and len(teams_df) >= 2:
                team_dict = dict(zip(teams_df['name'], teams_df['team_id']))
                tourn_dict = dict(zip(tourns_df['name'], tourns_df['tournament_id']))
                
                with st.form("match_form", clear_on_submit=True):
                    tourn_name = st.selectbox("Tournament", list(tourn_dict.keys()))
                    team1_name = st.selectbox("Team 1", list(team_dict.keys()), index=0)
                    team2_name = st.selectbox("Team 2", list(team_dict.keys()), index=1 if len(team_dict) > 1 else 0)
                    winner_name = st.selectbox("Winner Team", [team1_name, team2_name])
                    
                    submitted_match = st.form_submit_button("Submit Match Result")
                    
                    if submitted_match:
                        if team1_name == team2_name:
                            st.error("A team cannot play against itself!")
                        else:
                            t1_id = team_dict[team1_name]
                            t2_id = team_dict[team2_name]
                            tr_id = tourn_dict[tourn_name]
                            w_id = team_dict[winner_name]
                            
                            try:
                                conn = get_connection()
                                cursor = conn.cursor()
                                cursor.callproc('sp_record_match', (tr_id, t1_id, t2_id, w_id))
                                conn.commit()
                                cursor.close()
                                conn.close()
                                st.success(f"Match recorded! Winner: {winner_name}")
                                st.rerun()
                            except mysql.connector.Error as err:
                                st.error(f"Database Error: {err}")
            else:
                st.info("Need at least 2 teams and 1 tournament.")

        # 4. Admin Security Console
        with st.expander("🔒 Admin Security Console"):
            admin_user = st.text_input("Admin Username", value="LeagueCommissioner")
            admin_action_desc = st.text_input("Log Action Note", value="Verified Rankings")
            
            if st.button("Commit Security Audit Log"):
                try:
                    conn = get_connection()
                    cursor = conn.cursor()
                    cursor.callproc('sp_admin_log_action', (admin_user, admin_action_desc, 'System Controls'))
                    conn.commit()
                    cursor.close()
                    conn.close()
                    st.success("Action logged securely via DB!")
                    st.rerun()
                except mysql.connector.Error as err:
                    st.error(f"Database Error: {err}")
    else:
        st.info("👀 **Viewer Mode Active**\n\nYou are viewing as a general player/spectator. Switch role to **League Admin** above with passcode `admin123` to access management consoles.")

# --- MAIN DASHBOARD TABS ---
tab1, tab2, tab3 = st.tabs([
    "🏆 ELO LEADERBOARD", 
    "👾 ROSTERS & STATS", 
    "📜 MATCH LOGS"
])

with tab1:
    st.subheader("🏆 LIVE GLOBAL & REGIONAL ELO RANKINGS")
    st.markdown("*Powered by MySQL 8.4 Window Functions (`RANK() OVER`) yielding live regional and global competitive standing.*")
    
    df_ranked = execute_query("SELECT * FROM vw_ranked_leaderboard ORDER BY global_rank ASC;", fetch=True)
    if df_ranked.empty:
        df_ranked = execute_query("SELECT * FROM teams;", fetch=True)
    
    if not df_ranked.empty:
        st.dataframe(df_ranked, width="stretch", hide_index=True)
    else:
        st.info("No team ranking data available.")

with tab2:
    st.subheader("PLAYER ROSTERS & PROFILES")
    df_players = execute_query("SELECT * FROM vw_player_stats;", fetch=True)
    if df_players.empty:
        df_players = execute_query("""
            SELECT p.player_id, t.name AS team_name, p.gamer_tag, p.real_name, p.role 
            FROM players p JOIN teams t ON p.team_id = t.team_id;
        """, fetch=True)
        
    if not df_players.empty:
        st.dataframe(df_players, width="stretch", hide_index=True)
    else:
        st.info("No players signed yet.")

with tab3:
    st.subheader("⚔️ MATCH HISTORY & AUDIT LOGS")
    match_query = """
        SELECT m.match_id, tr.name AS tournament, t1.name AS team1, t2.name AS team2, 
               w.name AS winner, m.played_at
        FROM matches m
        JOIN tournaments tr ON m.tournament_id = tr.tournament_id
        JOIN teams t1 ON m.team1_id = t1.team_id
        JOIN teams t2 ON m.team2_id = t2.team_id
        JOIN teams w ON m.winner_team_id = w.team_id
        ORDER BY m.played_at DESC;
    """
    match_df = execute_query(match_query, fetch=True)
    
    if not match_df.empty:
        st.dataframe(match_df, width="stretch", hide_index=True)
    else:
        st.info("No matches recorded yet. Submit a match from the admin sidebar!")