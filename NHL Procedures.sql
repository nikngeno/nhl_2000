--Create all possible procedure here

--First procedure is for updating data into the database
select *
from Venues
--Adding Venue
CREATE PROCEDURE AddNewVenue
    @VenueName NVARCHAR(50),
    @City NVARCHAR(50),
    @StateorProvince NVARCHAR(50),
    @Capacity INT,
    @OpenedYear INT,
    @TeamID INT
AS
BEGIN
    
    INSERT INTO Venues (VenueName, StateorProvince, Capacity, OpenedYear, TeamID, City)
    VALUES (@VenueName, @City, @StateorProvince, @Capacity, @OpenedYear, @TeamID);
    
    PRINT 'New venue added successfully.';
END

------------------------------------------------------------------------------------------------------------
select *
from Team
-- Adding Teams
CREATE PROCEDURE AddNewTeam
	@TeamName nvarchar(50),
	@Abbreviation nvarchar(10),
	@City nvarchar(50),
	@FoundedYear int,
	@HomeArena nvarchar(50),
	@Conference nvarchar(50),
	@StateOrProvince nvarchar(50),
	@Website nvarchar(100),
	@Nickname nvarchar(20)

AS
BEGIN

	INSERT INTO TEAM(TeamName,Abbreviation,City,FoundYear,HomeArena,Conference,StateOrProvince,Website,Nickname)
	VALUES (@TeamName,@Abbreviation,@City,@FoundedYear,@HomeArena,@Conference,@StateOrProvince,@Website,@Nickname);

	PRINT 'New Team added succesfully.'
END
-----------------------------------------------------------------------------------------------------------------------
select *
from Player
--Add new player
CREATE PROCEDURE AddNewPlayer
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@DateofBirth date,
	@Nationality nvarchar(50),
	@Height int,
	@Weight int,
	@TeamID int,
	@PositionID int

AS
BEGIN

	INSERT INTO Player(FirstName,LastName,DateofBirth,Nationality,Height,Weight,TeamID,PositionID)
	VALUES (@FirstName,@LastName,@DateofBirth,@Nationality,@Height,@Weight,@TeamID,@PositionID)

	PRINT 'New Player added successfully'
END
-------------------------------------------------------------------------------------------------------
--Procedure for delete data from the above table - this would probably be used if a team is relegated or ceases to exist, players is banned from NHL or a venue is destroyed a new one is put in place

--Procedure for removing a venue
CREATE PROCEDURE RemoveVenue @VenueID int
AS
BEGIN
	DELETE FROM Venues
	WHERE VenueID = @VenueID
END

--Procedure for removing a team
CREATE PROCEDURE RemoveTeam @TeamID int
AS
BEGIN
	DELETE FROM Team
	WHERE TeamID = @TeamID
END

--Procedure for removing a player
CREATE PROCEDURE RemovePlayer @PlayerID int
AS
BEGIN
	DELETE FROM Player
	WHERE PlayerID = @PlayerID
END
-----------------------------------------------------------------------------------------------------------------------
--Procedures for getting player game and team statistics
select *
from Seasons
--Retrieve the top-scoring team for a specific season
ALTER PROCEDURE GetTopScoringTeamPerSeason @SeasonID int
AS
BEGIN
	select top 5
	    t.TeamName,
        SUM(CASE 
                WHEN g.HomeTeamID = t.TeamID THEN g.HomeTeamScore
                WHEN g.AwayTeamID = t.TeamID THEN g.AwayTeamScore
                ELSE 0
            END) AS TotalGoals
    FROM 
        Games g
    JOIN 
        Team t ON g.HomeTeamID = t.TeamID OR g.AwayTeamID = t.TeamID
    WHERE 
        g.SeasonID = @SeasonID
    GROUP BY 
        t.TeamName
    ORDER BY 
        TotalGoals DESC;
END
--Sample execution
EXEC GetTopScoringTeamPerSeason @SeasonID = 11;

--Retrieve the Top 10 scorer for each season, how many goals they scored, which team they are in
ALTER PROCEDURE GetTopScorerPerSeason @SeasonID INT
AS
BEGIN

   SELECT TOP 10
        p.FirstName,
        p.LastName,
        p.Nationality,
        t.TeamName,
        pt.PositionName,
        ps.Goals AS [Total Goals]
    FROM 
        Player p
    INNER JOIN 
        PlayerStats ps ON p.PlayerID = ps.PlayerID
    INNER JOIN 
        Team t ON p.TeamID = t.TeamID
    INNER JOIN 
        Position pt ON p.PositionID = pt.PositionID
    WHERE 
        ps.SeasonID = @SeasonID
    ORDER BY 
        ps.Goals DESC;
END

Exec GetTopScorerPerSeason @SeasonID = 12

--Procedure for win and loss records per season per team
ALTER PROCEDURE sp_GetTeamWinLossRecord @TeamID INT, @SeasonID INT
AS
BEGIN

    SELECT 
        t.TeamName,
        COUNT(g.GameID) AS GamesPlayed,
        SUM(CASE 
                WHEN (g.HomeTeamID = t.TeamID AND g.HomeTeamScore > g.AwayTeamScore) 
                     OR (g.AwayTeamID = t.TeamID AND g.AwayTeamScore > g.HomeTeamScore) 
                THEN 1 
                ELSE 0 
            END) AS Wins,
        SUM(CASE 
                WHEN (g.HomeTeamID = t.TeamID AND g.HomeTeamScore < g.AwayTeamScore) 
                     OR (g.AwayTeamID = t.TeamID AND g.AwayTeamScore < g.HomeTeamScore) 
                THEN 1 
                ELSE 0 
            END) AS Losses
    FROM 
        Games g
    JOIN 
        Team t ON g.HomeTeamID = t.TeamID OR g.AwayTeamID = t.TeamID
    WHERE 
        t.TeamID = @TeamID AND g.SeasonID = @SeasonID
    GROUP BY 
        t.TeamName;
END

Exec sp_GetTeamWinLossRecord @TeamID = 1, @SeasonID = 11

--Procedure for team overall standing per season using data from Team and Games(HomeTeamScore and AwayTeamScore) data a win is 3 points for win and 0 for loss
ALTER PROCEDURE sp_GetTeamStandingsPerSeason 
    @SeasonID INT
AS
BEGIN

    SELECT
        t.TeamName,
        t.Nickname,
        t.Conference,
        COUNT(g.GameID) AS GamesPlayed,
        SUM(
            CASE 
                WHEN (g.HomeTeamID = t.TeamID AND g.HomeTeamScore > g.AwayTeamScore) 
                     OR (g.AwayTeamID = t.TeamID AND g.AwayTeamScore > g.HomeTeamScore) 
                THEN 1 
                ELSE 0 
            END
        ) AS Wins,
        SUM(
            CASE 
                WHEN (g.HomeTeamID = t.TeamID AND g.HomeTeamScore < g.AwayTeamScore) 
                     OR (g.AwayTeamID = t.TeamID AND g.AwayTeamScore < g.HomeTeamScore) 
                THEN 1 
                ELSE 0 
            END
        ) AS Losses,
        SUM(
            CASE 
                WHEN (g.HomeTeamID = t.TeamID AND g.HomeTeamScore > g.AwayTeamScore) 
                     OR (g.AwayTeamID = t.TeamID AND g.AwayTeamScore > g.HomeTeamScore) 
                THEN 3 
                ELSE 0 
            END
        ) AS Points
    FROM
        Team t
    LEFT JOIN
        Games g ON (g.HomeTeamID = t.TeamID OR g.AwayTeamID = t.TeamID) 
               AND g.SeasonID = @SeasonID
    GROUP BY
        t.TeamName,
        t.Nickname,
        t.Conference
    ORDER BY
        Points DESC;
END

Exec sp_GetTeamStandingsPerSeason @SeasonID = 1
