create database NHLDB

--Stores information about each NHL team.
create table Team(
TeamID int not null primary key identity(1,1),
TeamName nvarchar(50) not null,
Abbreviation nvarchar(10),
City nvarchar(50),
FoundYear int,
HomeArena nvarchar(50),
Conference nvarchar(50)
)

--Contains personal and career information about players.
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

--Defines the different playing positions.
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

--Add three more columns on the teams table - State or Province,Nickname and club official website
alter table Team
add StateOrProvince nvarchar(50);
alter table Team
add Nickname nvarchar(20);
alter table Team
add Website nvarchar(100);

select *
from Team


--Inserts each Teams data into the Team table
insert into Team(TeamName,Abbreviation,Nickname,City,StateOrProvince,FoundYear,HomeArena,Conference,Website)
values
('New Jersey Devils', 'NJD', 'Devils', 'New Jersey', 'New Jersey', 1974, 'Prudential Center', 'Eastern', 'http://www.newjerseydevils.com/'),
('New York Islanders', 'NYI', 'Islanders', 'New York', 'New York', 1972, 'UBS Arena', 'Eastern', 'http://www.newyorkislanders.com/'),
('New York Rangers', 'NYR', 'Rangers', 'New York', 'New York', 1926, 'Madison Square Garden', 'Eastern', 'http://www.newyorkrangers.com/'),
('Philadelphia Flyers', 'PHI', 'Flyers', 'Philadelphia', 'Pennsylvania', 1967, 'Wells Fargo Center', 'Eastern', 'http://www.philadelphiaflyers.com/'),
('Pittsburgh Penguins', 'PIT', 'Penguins', 'Pittsburgh', 'Pennsylvania', 1967, 'PPG Paints Arena', 'Eastern', 'http://pittsburghpenguins.com/'),
('Boston Bruins', 'BOS', 'Bruins', 'Boston', 'Massachusetts', 1924, 'TD Garden', 'Eastern', 'http://www.bostonbruins.com/'),
('Buffalo Sabres', 'BUF', 'Sabres', 'Buffalo', 'New York', 1970, 'KeyBank Center', 'Eastern', 'http://www.sabres.com/'),
('Montreal Canadiens', 'MTL', 'Canadiens', 'Montreal', 'Quebec, Canada', 1917, 'Bell Centre', 'Eastern', 'http://www.canadiens.com/'),
('Ottawa Senators', 'OTT', 'Senators', 'Ottawa', 'Ontario, Canada', 1991, 'Canadian Tire Centre', 'Eastern', 'http://www.ottawasenators.com/'),
('Toronto Maple Leafs', 'TOR', 'Maple Leafs', 'Toronto', 'Ontario, Canada', 1917, 'Scotiabank Arena', 'Eastern', 'http://www.mapleleafs.com/'),
('Carolina Hurricanes', 'CAR', 'Hurricanes', 'Carolina', 'North Carolina', 1979, 'PNC Arena', 'Eastern', 'http://www.carolinahurricanes.com/'),
('Florida Panthers', 'FLA', 'Panthers', 'Florida', 'Florida', 1993, 'Amerant Bank Arena', 'Eastern', 'http://www.floridapanthers.com/'),
('Tampa Bay Lightning', 'TBL', 'Lightning', 'Tampa Bay', 'Florida', 1991, 'AMALIE Arena', 'Eastern', 'http://www.tampabaylightning.com/'),
('Washington Capitals', 'WSH', 'Capitals', 'Washington', 'D.C.', 1974, 'Capital One Arena', 'Eastern', 'http://www.washingtoncapitals.com/'),
('Chicago Blackhawks', 'CHI', 'Blackhawks', 'Chicago', 'Illinois', 1926, 'United Center', 'Western', 'http://www.chicagoblackhawks.com/'),
('Detroit Red Wings', 'DET', 'Red Wings', 'Detroit', 'Michigan', 1926, 'Little Caesars Arena', 'Eastern', 'http://www.detroitredwings.com/'),
('Nashville Predators', 'NSH', 'Predators', 'Nashville', 'Tennessee', 1997, 'Bridgestone Arena', 'Western', 'http://www.nashvillepredators.com/'),
('St. Louis Blues', 'STL', 'Blues', 'St. Louis', 'Missouri', 1967, 'Enterprise Center', 'Western', 'http://www.stlouisblues.com/'),
('Calgary Flames', 'CGY', 'Flames', 'Calgary', 'Alberta, Canada', 1972, 'Scotiabank Saddledome', 'Western', 'http://www.calgaryflames.com/'),
('Colorado Avalanche', 'COL', 'Avalanche', 'Colorado', 'Colorado', 1979, 'Ball Arena', 'Western', 'http://www.coloradoavalanche.com/'),
('Edmonton Oilers', 'EDM', 'Oilers', 'Edmonton', 'Alberta, Canada', 1979, 'Rogers Place', 'Western', 'http://www.edmontonoilers.com/'),
('Vancouver Canucks', 'VAN', 'Canucks', 'Vancouver', 'British Columbia, Canada', 1970, 'Rogers Arena', 'Western', 'http://www.canucks.com/'),
('Anaheim Ducks', 'ANA', 'Ducks', 'Anaheim', 'California', 1993, 'Honda Center', 'Western', 'http://www.anaheimducks.com/'),
('Dallas Stars', 'DAL', 'Stars', 'Dallas', 'Texas', 1967, 'American Airlines Center', 'Western', 'http://www.dallasstars.com/'),
('Los Angeles Kings', 'LAK', 'Kings', 'Los Angeles', 'California', 1967, 'Crypto.com Arena', 'Western', 'http://www.lakings.com/'),
('San Jose Sharks', 'SJS', 'Sharks', 'San Jose', 'California', 1990, 'SAP Center at San Jose', 'Western', 'http://www.sjsharks.com/'),
('Columbus Blue Jackets', 'CBJ', 'Blue Jackets', 'Columbus', 'Ohio', 1997, 'Nationwide Arena', 'Eastern', 'http://www.bluejackets.com/'),
('Minnesota Wild', 'MIN', 'Wild', 'Minnesota', 'Minnesota', 1997, 'Xcel Energy Center', 'Western', 'http://www.wild.com/'),
('Winnipeg Jets', 'WPG', 'Jets', 'Winnipeg', 'Manitoba, Canada', 1997, 'Canada Life Centre', 'Western', 'http://winnipegjets.com/'),
('Arizona Coyotes', 'ARI', 'Coyotes', 'Arizona', 'Arizona', 2014, 'Mullett Arena', 'Western', 'http://www.arizonacoyotes.com/'),
('Vegas Golden Knights', 'VGK', 'Golden Knights', 'Vegas', 'Nevada', 2017, 'T-Mobile Arena', 'Western', 'http://www.vegasgoldenknights.com/'),
('Seattle Kraken', 'SEA', 'Kraken', 'Seattle', 'Washington', 2021, 'Climate Pledge Arena', 'Western', 'https://www.nhl.com/seattle')


select*
from Position
--insert Playing positions data into the Position table
insert into Position(PositionID,PositionName,Abbreviation)
values
(1,'Goaltender','G'),
(2,'Left Defense','LD'),
(3,'Right Defense','RD'),
(4,'Center','C'),
(5,'Left Wing','LW'),
(6,'Right Wing','RW')


select *
from Seasons
--insert data on each seasons
insert into Seasons(SeasonID,SeasonYear,StartDate,EndDate)
values
(1, '2000-2001', '2000-10-01', '2001-06-15'),
(2, '2001-2002', '2001-10-01', '2002-06-15'),
(3, '2002-2003', '2002-10-01', '2003-06-15'),
(4, '2003-2004', '2003-10-01', '2004-06-15'),
(5, '2004-2005', '2004-10-01', '2005-06-15'),
(6, '2005-2006', '2005-10-01', '2006-06-15'),
(7, '2006-2007', '2006-10-01', '2007-06-15'),
(8, '2007-2008', '2007-10-01', '2008-06-15'),
(9, '2008-2009', '2008-10-01', '2009-06-15'),
(10, '2009-2010', '2009-10-01', '2010-06-15'),
(11, '2010-2011', '2010-10-01', '2011-06-15'),
(12, '2011-2012', '2011-10-01', '2012-06-15'),
(13, '2012-2013', '2012-10-01', '2013-06-15'),
(14, '2013-2014', '2013-10-01', '2014-06-15'),
(15, '2014-2015', '2014-10-01', '2015-06-15'),
(16, '2015-2016', '2015-10-01', '2016-06-15'),
(17, '2016-2017', '2016-10-01', '2017-06-15'),
(18, '2017-2018', '2017-10-01', '2018-06-15'),
(19, '2018-2019', '2018-10-01', '2019-06-15'),
(20, '2019-2020', '2019-10-01', '2020-06-15')
