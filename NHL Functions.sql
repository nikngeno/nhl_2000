--create all possible Functions
select *
from Player

select *
from Team
--Function to calculate average of players at the start of the season
CREATE FUNCTION dbo.GetAverageAgePerTeamPerSeason (@SeasonID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.TeamName,
        AVG(
            DATEDIFF(year, p.DateOfBirth, s.StartDate) - 
            CASE 
                WHEN DATEADD(year, DATEDIFF(year, p.DateOfBirth, s.StartDate), p.DateOfBirth) > s.StartDate 
                THEN 1 
                ELSE 0 
            END
        ) AS AverageAge
    FROM
        Player p
    INNER JOIN
        Team t ON p.TeamID = t.TeamID
    INNER JOIN
        PlayerStats ps ON p.PlayerID = ps.PlayerID
    INNER JOIN
        Seasons s ON ps.SeasonID = s.SeasonID
    WHERE
        ps.SeasonID = @SeasonID
    GROUP BY
        t.TeamName
)

--View that shows standings with team name
create view vw_TeamStandings
as
select
	s.StandingID,
	s.SeasonID,
	s.TeamID,
	t.TeamName,
	s.Wins,
	s.Losses,
	s.OverTimeLosses,
	s.Points
from Standings s
	join Team t
		on s.TeamID = t.TeamID

--Procedure to view a specified team by season
create or alter procedure dbo.GetTeamStandingBySeasonAndID
	@SeasonID int,
	@TeamID int
as
begin
	select * from vw_TeamStandings
	where SeasonID = @SeasonID
		and TeamID = @TeamID
end

--Using procedure
exec dbo.GetTeamStandingBySeasonAndID
	@SeasonID = 1,
	@TeamID = 1

--Loops thru all 20 seasons and inserts top scoring teams into temp table
--Some teams are tied
--View top Teams by season
create or alter procedure dbo.GetTopTeamPerSeason
as
begin
	create table #TopTeams
	(
		SeasonID int,
		TeamID int,
		TeamName nvarchar(255),
		Points int
	)

	declare @CurrentSeasonID int = 1;

	while (@CurrentSeasonID <= 20)
	begin
		with RankedTeams as
		(
			select SeasonID,
				   TeamID, 
				   TeamName,
				   Points,
				   RANK() over (partition by SeasonID order by Points desc) as Rank
			from vw_TeamStandings
			where SeasonID = @CurrentSeasonID
		)
		insert into #TopTeams (SeasonID, TeamID, TeamName, Points)
		select SeasonID, TeamID, TeamName, Points
		from RankedTeams
		where Rank = 1

		set @CurrentSeasonID = @CurrentSeasonID + 1
	end

	select * from #TopTeams t
	drop table #TopTeams
end

--Executing top team
exec dbo.GetTopTeamPerSeason


-------------->I think everything below this is new


--Creating view to link Penalties and PenaltyLevel
create or alter view vw_PlayerPenalties
as
select
	p.GameID, g.SeasonID, p.PlayerID, pl.FirstName, pl.LastName, pl.TeamID, t.TeamName, p.LevelID as PenaltyLevel, pp.Description, pp.Minutes
from Penalties p
	join PenaltyLevels pp
		on p.LevelID = pp.LevelID
	join Player pl
		on p.PlayerID = pl.PlayerID
	join Team t
		on pl.TeamID = t.TeamID
	join Games g
		on p.GameID = g.GameID

--Displaying PlayerPenalties view
select * from vw_PlayerPenalties

--Displays a specified players penalties
create or alter procedure dbo.GetPlayerPenalties
	@PlayerID int
as
begin
	select *
	from vw_PlayerPenalties
	where PLayerID = @PlayerID
	order by GameID
end

--executing procedure
exec dbo.GetPlayerPenalties @PlayerID = 1

--Gets all penalties commited by player by season
create or alter procedure dbo.GetPlayerPenaltiesBySeason
	@PlayerID int,
	@SeasonID int
as
begin
	select * 
	from vw_PlayerPenalties
	where PlayerID = @PlayerID
		and SeasonID = @SeasonID
end

--Gets all of player one's penalties from the first season
exec dbo.GetPlayerPenaltiesBySeason
	@PlayerID = 1,
	@SeasonID = 1

--gets player with most penalties from each season
create or alter procedure dbo.GetTopPlayerPenaltiesBySeason
as
begin
	declare @CurrentSeasonID int = 1;

	create table #TopPlayerPenalties
	(
		SeasonID int,
		PlayerID int,
		FirstName nvarchar(50),
		LastName nvarchar(50),
		TeamID int,
		TeamName nvarchar(100),
		PenaltyCount int,
	)

	while (@CurrentSeasonID <= 20)
	begin
		with RankedPenalties as
		(
			select
				SeasonID,
				PlayerID,
				FirstName,
				LastName,
				TeamID,
				TeamName,
				COUNT(PlayerID) as PenaltyCount,
				RANK() over (partition by SeasonID order by COUNT(PlayerID) desc) as Rank
			from vw_PlayerPenalties
			where SeasonID = @CurrentSeasonID
			group by SeasonID, PlayerID, FirstName, LastName, TeamID, TeamName
		)

		insert into #TopPlayerPenalties (SeasonID, PlayerID, FirstName, LastName, TeamID ,TeamName, PenaltyCount)
		select SeasonID, PlayerID, FirstName, LastName, TeamID ,TeamName, PenaltyCount
		from RankedPenalties
		where Rank = 1

		set @CurrentSeasonID = @CurrentSeasonID + 1
	end

	select * from #TopPlayerPenalties
	drop table #TopPlayerPenalties
end

--Displays players with most penalties
exec dbo.GetTopPlayerPenaltiesBySeason