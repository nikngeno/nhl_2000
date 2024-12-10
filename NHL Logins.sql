-- Create database users for each login
CREATE LOGIN Admin1 WITH PASSWORD = 'Admin1234!';
CREATE USER Admin1 FOR LOGIN Admin1;

CREATE LOGIN QATeam WITH PASSWORD = 'QATeam1234!';
CREATE USER QATeam FOR LOGIN QATeam;

CREATE LOGIN RegularUser WITH PASSWORD = 'RegularUser1234!';
CREATE USER RegularUser FOR LOGIN RegularUser;

-- Grant SELECT permission on Player, Team, Position, Game, PlayerStats, Season to Admin and QATeam
GRANT SELECT ON Player TO Admin1;
GRANT SELECT ON Player TO QATeam;

GRANT SELECT ON Team TO Admin1;
GRANT SELECT ON Team TO QATeam;

GRANT SELECT ON Position TO Admin1;
GRANT SELECT ON Position TO QATeam;

GRANT SELECT ON Games TO Admin1;
GRANT SELECT ON Games TO QATeam;

GRANT SELECT ON PlayerStats TO Admin1;
GRANT SELECT ON PlayerStats TO QATeam;

GRANT SELECT ON Seasons TO Admin1;
GRANT SELECT ON Seasons TO QATeam;

-- Grant SELECT, INSERT, UPDATE, DELETE permissions on Player, Team, Position, Game, PlayerStats, Season to Admin and QATeam
GRANT SELECT, INSERT, UPDATE, DELETE ON Player TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Player TO QATeam;

GRANT SELECT, INSERT, UPDATE, DELETE ON Team TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Team TO QATeam;

GRANT SELECT, INSERT, UPDATE, DELETE ON Position TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Position TO QATeam;

GRANT SELECT, INSERT, UPDATE, DELETE ON Games TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Games TO QATeam;

GRANT SELECT, INSERT, UPDATE, DELETE ON PlayerStats TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON PlayerStats TO QATeam;

GRANT SELECT, INSERT, UPDATE, DELETE ON Seasons TO Admin1;
GRANT SELECT, INSERT, UPDATE, DELETE ON Seasons TO QATeam;

-- RegularUser has read-only access
GRANT SELECT ON Player TO RegularUser;
GRANT SELECT ON Team TO RegularUser;
GRANT SELECT ON Position TO RegularUser;
GRANT SELECT ON Games TO RegularUser;
GRANT SELECT ON PlayerStats TO RegularUser;
GRANT SELECT ON Seasons TO RegularUser;

-- Deny UPDATE for RegularUser
DENY UPDATE ON Player TO RegularUser;
DENY UPDATE ON Team TO RegularUser;
DENY UPDATE ON Position TO RegularUser;
DENY UPDATE ON Games TO RegularUser;
DENY UPDATE ON PlayerStats TO RegularUser;
DENY UPDATE ON Seasons TO RegularUser;
