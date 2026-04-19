CREATE TABLE logs (
    id INT PRIMARY KEY,
    timestamp DATETIME,
    level VARCHAR(10),
    message TEXT,
    user_id INT,
    session_id VARCHAR(50)
);

CREATE INDEX idx_level ON logs (level);
CREATE INDEX idx_timestamp ON logs (timestamp);
CREATE INDEX idx_user_id ON logs (user_id);

CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE sessions (
    id VARCHAR(50) PRIMARY KEY,
    user_id INT,
    start_time DATETIME,
    end_time DATETIME
);

INSERT INTO users (id, username, email) VALUES (1, 'admin', 'admin@example.com');
INSERT INTO users (id, username, email) VALUES (2, 'user', 'user@example.com');

INSERT INTO sessions (id, user_id, start_time, end_time) VALUES ('session1', 1, '2022-01-01 00:00:00', '2022-01-01 01:00:00');
INSERT INTO sessions (id, user_id, start_time, end_time) VALUES ('session2', 2, '2022-01-02 00:00:00', '2022-01-02 01:00:00');

INSERT INTO logs (id, timestamp, level, message, user_id, session_id) VALUES (1, '2022-01-01 00:00:00', 'INFO', 'Login successful', 1, 'session1');
INSERT INTO logs (id, timestamp, level, message, user_id, session_id) VALUES (2, '2022-01-01 00:05:00', 'WARNING', 'Invalid input', 1, 'session1');
INSERT INTO logs (id, timestamp, level, message, user_id, session_id) VALUES (3, '2022-01-02 00:00:00', 'INFO', 'Login successful', 2, 'session2');
INSERT INTO logs (id, timestamp, level, message, user_id, session_id) VALUES (4, '2022-01-02 00:10:00', 'ERROR', 'Database connection failed', 2, 'session2');

CREATE PROCEDURE log_insert (@level VARCHAR(10), @message TEXT, @user_id INT, @session_id VARCHAR(50))
AS
BEGIN
    INSERT INTO logs (timestamp, level, message, user_id, session_id) VALUES (GETDATE(), @level, @message, @user_id, @session_id);
END;

CREATE VIEW log_view AS
SELECT l.id, l.timestamp, l.level, l.message, u.username, s.id AS session_id
FROM logs l
JOIN users u ON l.user_id = u.id
JOIN sessions s ON l.session_id = s.id;

CREATE FUNCTION get_log_level (@level VARCHAR(10))
RETURNS TABLE
AS
RETURN
SELECT *
FROM logs
WHERE level = @level;

CREATE TRIGGER log_trigger
ON logs
AFTER INSERT
AS
BEGIN
    UPDATE sessions
    SET end_time = GETDATE()
    WHERE id IN (SELECT session_id FROM inserted);
END;