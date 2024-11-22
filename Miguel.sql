create table TeamCoaches
(
	TeamCoachID int primary key,
	TeamID int,
	CoachID int,
	SeasonID int,
	StartDate date,
	EndDate date,
	constraint FK_TeamID foreign key (TeamID) references Team(TeamID),
	constraint FK_CoachID foreign key (CoachId) references Coaches(CoachID),
	constraint FK_SeasonID foreign key (SeasonID) references Seasons(SeasonID)
)
create table Events
(
	EventID int primary key,
	GameID int,
	EventType nvarchar(50),
	Period int,
	Time date,
	PlayerID int,
	TeamID int,
	AssistPlayerID int null,
	Penaltytype nvarchar(50) null,
	PenaltyMinutes date null,
	constraint FK_GameID foreign key (GameID) references Games(GameID),
	constraint FK_PlayerID foreign key (PlayerID) references Player(PlayerID),
	constraint FK_TeamID foreign key (TeamID) references Team(TeamID),
	constraint FK_AssistPlayerID foreign key (AssistPlayerID) references Player(PLayerID)
)
