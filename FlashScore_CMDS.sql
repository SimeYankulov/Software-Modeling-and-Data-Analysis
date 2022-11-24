Create table sport (
	id int primary key,
	sportname varchar(10)
);

Create table stadium(
	id int primary key,
	stadiumname varchar(30)
);

Create table nationality(
	id int primary key,
	countryname varchar(30)
);

Create table Club(
	id int primary key,
	ClubName varchar(30),
	sportid int foreign key references Sport(id),
	stadiumid int foreign key references Stadium(id),
	natid int foreign key references Nationality(id)
);

create table Player(
	id int primary key,
	name varchar(30),
	surname varchar(30),
	dob date,
	position varchar(3),
	natid int foreign key references Nationality(id),
	clubid int foreign key references Club(id)
);

Create table Competition(
	id int primary key,
	comp_name varchar(30)
);

create table Club_Competition(
	clubid int not null,
	compid int not null,
	constraint PK_Competition primary key (clubid, compid)
);
alter table Club_Competition
	add constraint FK_Club foreign key(clubid)
	references club(id)
	on update cascade on delete cascade

alter table Club_Competition
	add constraint FK_Competition foreign key(compid)
	references competition(id)
	on update cascade on delete cascade

create table Match(
	id int primary key,
	H_Club int foreign key references Club(id),
	HGoals int,
	AGoals int, 
	A_Club int foreign key references Club(id),
	Comp_id int foreign key references Competition(id),
	MStart datetime,
	Finished int check ((Finished = 0) or (Finished =1)),
);


insert into sport(id,sportname)
	values(1,'Football');


insert into nationality(id,countryname)
	values
		(1,'Spain'),
		(2,'Germany'),
		(3,'France'),
		(4,'England'),
		(5,'Netherlands'),
		(6,'Poland'),
		(7,'Italy'),
		(8,'Belgium'),
		(9,'Switserland'),
		(10,'Greece'),

		(11,'Argentina'),
		(12,'Brazil'),
		(13,'Uruguay'),
		(14,'Colombia'),
		(15,'Mexico'),

		(16,'South Africa'),
		(17,'Egypt'),
		(18,'Nigeria'),
		(19,'Senegal'),
		(20,'Kenya');

insert into stadium(id,stadiumname)
values
	(1,'Diego Armando Maradona Stadium'),
	(2,'Anfield'),
	(3,'Johan Cruijff ArenA'),
	(4,'Ibrox Stadium');

insert into Club(id,clubname,sportid,stadiumid,natid)
values
	(1,'Napoli',1,1,7),
	(2,'Liverpool',1,2,4),
	(3,'Ajax',1,3,5),
	(4,'Rangers',1,4,4);

insert into player(id,name,surname,dob,position,natid,clubid)
values
	(1,'Trent','Alexander-Arnold','1998-10-07','DEF',4,2),
	(2,'Alisson','Becker','1992-10-02','GK',12,2),
	(3,'Roberto','Firmino','1991-10-2','FOR',12,2),
	(4,'Curtis','Jones','2001-01-30','MF',4,2),
	(5,'Ibrahima','Konate','1999-05-25','DEF',3,2),
	(6,'Mohamed','Salah','1992-06-15','FOR',17,2),

	(7,'Giovanni','Di Lorenzo','1993-08-04','DEF',7,1),
	(8,'Alex','Meret','1997-03-22','GK',7,1),
	(9,'Tanguy','Ndombele','1996-12-28','MF',3,1),
	(10,'Mathias','Olivera','1997-10-31','DEF',13,1),
	(11,'Victor','Osimhen','1998-12-29','FOR',18,1),
	(12,'Matteo','Politano','1993-08-03','FOR',7,1),

	(13,'Edson','Alvarez','1997-10-24','DEF',15,3),
	(14,'Steven','Berghuis','1991-12-19','MF',5,3),
	(15,'Remko','Pasveer','1993-11-08','GK',5,3),
	(16,'Kenneth','Taylor','2002-05-16','MF',5,3),
	(17,'Jurrien','Timber','2001-06-17','DEF',5,3),
	(18,'Mohhamed','Kudus','2000-08-02','MF',17,3),

	(19,'Allan','McGregor','1982-01-31','GK',4,4),
	(20,'Steven','Davis','1985-01-01','MF',4,4),
	(21,'Ryan','Kent','1996-11-11','FOR',4,4),
	(22,'James','Tavernier','1991-10-31','DEF',4,4),
	(23,'Malik','Tillman','2002-05-28','MF',4,4),
	(24,'Scott','Arfield','1998-11-1','MF',4,4);

insert into competition(id,comp_name)
values (1,'Champions League');

insert into Club_Competition(clubid,compid)
values (1,1),(2,1),(3,1),(4,1);

insert into Match(id,H_Club,HGoals,AGoals,A_Club,Comp_id,MStart,Finished)
values 
	(1,3,4,0,4,1,'2022-09-07 19:45:00',0),
	(2,1,4,1,2,1,'2022-09-07 22:00:00',1),

	(3,2,2,1,3,1,'2022-09-13 22:00:00',1),
	(4,4,0,3,1,1,'2022-09-14 22:00:00',1),

	(5,3,1,6,1,1,'2022-10-04 22:00:00',1),
	(6,2,2,0,4,1,'2022-10-04 22:00:00',1),

	(7,4,1,7,2,1,'2022-10-12 22:00:00',1),
	(8,1,4,2,3,1,'2022-10-12 22:00:00',1),

	(9,3,0,3,2,1,'2022-10-26 22:00:00',1),
	(10,1,3,0,4,1,'2022-10-26 22:00:00',1),

	(11,4,1,3,3,1,'2022-11-1 22:00:00',1),
	(12,2,2,0,1,1,'2022-11-1 22:00:00',1);
	

Create Trigger GoalScored
On Match 
For update
as
	if (update (HGoals) OR update (AGoals)) 
	begin 

		select  c1.ClubName , M.HGoals, M.AGoals, c2.ClubName ,'Goal!!!'
		from match M
			join club c1
			on (m.H_Club = c1.id)
			 join club c2 
			on(m.A_Club = c2.id)
			where m.Finished = 0;
	end

--drop trigger GoalScored

update match 
set match.HGoals=5
where id = 1;

update match 
set match.AGoals=3
where id = 1;


Create procedure ResultsForDate @ddate datetime
as 
			select  c1.ClubName , M.HGoals, M.AGoals, c2.ClubName,m.MStart
		from match M
			join club c1
			on (m.H_Club = c1.id)
			 join club c2 
			on(m.A_Club = c2.id)

			where cast(m.MStart as date) = cast(@ddate as date)
			
exec ResultsForDate @ddate = '2022-11-1'

--drop procedure ResultsForDate

Create function Players () returns table
as 
return 
		Select p.name as Name,p.surname as Surname,p.dob as DOB,
			n.countryname as Nationality,c.ClubName as Club ,p.position as Position
		from Player p
		join Club c
		 on(p.clubid = c.id)
		join nationality n
		 on(p.natid = n.id)


Select * from Match

USE FlashScore;


