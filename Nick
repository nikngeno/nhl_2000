create database NickCopyDB

create table Team(
TeamID int not null primary key identity(1,1),
TeamName nvarchar(50) not null,
Abbreviation nvarchar(10),
City nvarchar(50),
FoundYear int,
HomeArena nvarchar(50),
Conference nvarchar(50)
)

create table Player(
PlayerID int primary key,
FirstName nvarchar(50),
LastName nvarchar(50),
DateofBirth date,
Nationality nvarchar(50),
Height int,
Weight int,
PositionID int,
DraftYear int,
Status nvarchar(10)
)

create table Position(
PositionID int primary key,
PositionName nvarchar(20),
Abbreviation nvarchar(10)
)

create table Seasons(
SeasonID int primary key,
SeasonYear nvarchar(10),
StartDate date,
EndDate date
)

create table Games(
GameID int primary key,
SeasonID int,
Date date,
HomeTeamID int,
AwayTeamID int,
VenueID int,
HomeTeamScore int,
AwayTeamScore int,
Overtime bit,
Shootout bit
)
