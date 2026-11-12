USE esports_db;

-- 1. Create an Admin Audit Log table for administrative actions
CREATE TABLE IF NOT EXISTS admin_audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_user VARCHAR(100) NOT NULL,
    action_performed VARCHAR(255) NOT NULL,
    target_entity VARCHAR(100),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create a Stored Procedure for Secure Admin Actions with Logging
DROP PROCEDURE IF EXISTS sp_admin_log_action;

DELIMITER //
CREATE PROCEDURE sp_admin_log_action(
    IN p_admin_user VARCHAR(100),
    IN p_action VARCHAR(255),
    IN p_target VARCHAR(100)
)
BEGIN
    INSERT INTO admin_audit_logs (admin_user, action_performed, target_entity)
    VALUES (p_admin_user, p_action, p_target);
END //
DELIMITER ;