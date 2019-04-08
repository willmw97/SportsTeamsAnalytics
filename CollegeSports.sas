/************************************
* Name: Sports Teams Analsys        *
*                                   *
* Date: March 28, 2019              *
*                                   *
* Author:  MARSHAL Will      

This SAS code does analysis on sports teams from
different Universities. This information can
be useful for professionsals wanting to make important
decsions for college sports teams.
 
************************************/


/* Earned Runs Allowed = ERA */
/* Innings Played = */

*Problem1;
PROC IMPORT	
	DATAFILE = "/folders/myfolders/Project1/Teams.csv"
	OUT = MARSHAL.Team
	DBMS = CSV
	REPLACE;
	
	GETNAMES= YES;
	DATAROW = 2;
	

RUN;

PROC IMPORT	
	DATAFILE = "/folders/myfolders/Project1/Pitching.csv"
	OUT = MARSHAL.Pitch
	DBMS = CSV
	REPLACE;
	
	GETNAMES= YES;
	DATAROW = 2;
	
RUN;


*Problem 1.a;
PROC SQL;
	SELECT playerID, ERA
	FROM MARSHAL.Pitch
	WHERE yearID=2000;
QUIT;



PROC SQL;
	SELECT playerID, teamID, yearID, ERA
		from (select playerID, teamID, yearID, ER, IPouts, IP, 9*ER/IP as ERA
			from (select playerID, teamID, yearID, ER, IPouts,  IPouts / 3 AS IP
				from (select playerID, teamID, yearID, ER, IPouts
					FROM MARSHAL.Pitch
						WHERE yearID = 2000 and (teamID = 'MIN' or teamID = 'MIL'))))
	WHERE ERA < 4.0 ;
QUIT;

PROC SQL;
	SELECT playerID, teamID, yearID, ERA
		from (select playerID, teamID, yearID, ER, IPouts, IP, 9*ER/IP as ERA
			from (select playerID, teamID, yearID, ER, IPouts,  IPouts / 3 AS IP
				from (select playerID, teamID, yearID, ER, IPouts
					FROM MARSHAL.Pitch
						WHERE yearID = 2000 and (teamID = 'MIN' or teamID = 'MIL'))))
	WHERE ERA < 4.0 ;
QUIT;

/*
Calculates Earned Run Average by taking the the ERA from 
(9*(Earned Runs Allowed/Innings Played))

*/

PROC SQL;
	SELECT yearID, ERA
	FROM MARSHAL.Pitch
	WHERE yearID=2000 or yearID=2005 or yearID=2010 or yearID=2015;
QUIT;

PROC SQL;
	SELECT teamID, yearID, ERA
		from (select  teamID, yearID, ER, IPouts, IP, 9*ERA/IP as ERA
			from (select teamID, yearID, ER, IPouts, IPouts / 3 AS IP, 
				from (select teamID, yearID, ER, IPouts
					from MARSHAL.Team 
						WHERE (yearID = 2000 or yearID = 2005 or yearID = 2010 or yearID = 2015)and(teamID = 'MIN' or teamID = 'MIL') )))
	;
QUIT;

PROC SQL;
	Select teamID, yearID, ERA, ER, 9*ERA/IPouts as CalculatedERA LABEL 'CalculatedERA', 
		IPouts/3 as InningsPitched LABEL 'InningsPitched'
		from MARSHAL.Team
			WHERE ((yearID = 2000 or yearID = 2005 or yearID = 2010 or yearID = 2015)and(teamID = 'MIN' or teamID = 'MIL')) 
	;

QUIT;


/*
Returns the average salary for teams in 2006 and 2012

Second part returns team with the highest average
*/

PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/Salaries.csv"
    OUT = MARSHAL.Salaries
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;
RUN;

PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/TeamsFranchises.csv"
    OUT = MARSHAL.TeamFranchises
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;
    
RUN;

PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/Teams.csv"
    OUT = MARSHAL.Team
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;
    
RUN;

PROC SQL;
	Select teamID, avg(Salary) as avgsalary LABEL 'AverageSalary'
	from MARSHAL.Salaries
	WHERE yearID = 2006 or yearID = 2012
	group by teamID;
QUIT;
	
PROC SQL;
	Select teamID, avg(Salary) LABEL 'AverageSalary'
	from MARSHAL.Salaries
	(SELECT A.franchID, A.franchName, B.yearID, B.teamID 
		FROM MARSHAL.TeamFrachises A LEFT JOIN MARSHAL.Team B 
		ON A.franchID = B.franchID)
		(select A.teamID, B.teamID
		from Marshal. = )
		
	Select teamID, avg(Salary) LABEL 'AverageSalary'
	from MARSHAL.Salaries
	WHERE yearID = 2006 or yearID = 2012
	group by teamID;
QUIT;
	

	
PROC SQL;
	Select teamID, avg(Salary) LABEL 'Average Salary'
	from MARSHAL.Salaries
	WHERE yearID = 2006 or yearID = 2012
	group by teamID;
	
QUIT;	
	
PROC SQL;
	Select distinct a.teamID, b.franchName, c.yearID, avg(yearID) label 'AverageSalary'
	from (select distinct franchID, teamID, yearID from Marshal.Team)
	a.
	inner join Marshal.Salaries c
	on a.teamID = c.teamID 
	where c.yearID = 2006 or c.year = 2012
	group by c.yearID, a.teamID;
QUIT;

PROC sql outobs=100;
	SELECT DISTINCT  B.yearID, A.franchName, C.teamID, avg(Salary) as AverageSalary LABEL 'AverageSalary'
	FROM MARSHAL.TeamFranchises A 
	INNER JOIN MARSHAL.Team B 
	ON A.franchID = B.franchID
	INNER JOIN MARSHAL.Salaries C
	ON B.teamID = C.teamID AND B.yearID = C.yearID
	WHERE C.yearID = 2006 or C.yearID = 2012
	GROUP BY B.teamID, C.yearID
	order by B.teamID asc;
QUIT;

* Second part, returns highest average
PROC SQL outobs=100;
	Select Distinct a.yearID as year, b.franchName as FranchiseName, a.TeamID as Team, 
	(((Select distinct avg(Salary) LABEL 'AverageSalary', c.teamID as Team from Marshal.Salaries c(select  ))))
	FROM Marshal.Team a Left Join Marshal.TeamFranchises b on a.franchID = b.franchID
	Left join Marshal.Salaries c on a.teamID =c.teamID
	WHERE a.yearID = 2006 or a.yearID = 2012
	group by a.teamID, a.yearID
	order by AverageSalary desc
	;
QUIT;

PROC sql outobs=100;
	SELECT DISTINCT  b.yearID, a.franchName, c.teamID, avg(Salary) as AverageSalary LABEL 'AverageSalary'
	FROM MARSHAL.TeamFranchises a 
	INNER JOIN MARSHAL.Team B 
	ON a.franchID = b.franchID
	INNER JOIN MARSHAL.Salaries c
	ON b.teamID = c.teamID AND b.yearID = c.yearID
	
	group by c.teamID, c.yearID
	order by AverageSalary desc
	;
QUIT;


/*
List for players who play for detroit tigers
Also, Alphabetizes player names
*/
PROC IMPORT
	DATAFILE = "/folders/myfolders/Project1/Appearances.csv"
	OUT = MARSHAL.Appearances
	DBMS = CSV
	REPLACE;
	
	GETNAMES = Yes;
	DATAROW = 2;
	
RUN;

PROC IMPORT
	DATAFILE = "/folders/myfolders/Project1/People.csv"
	OUT = MARSHAL.People
	DBMS = CSV
	REPLACE;
	
	GETNAMES = Yes;
	DATAROW = 2;
	
RUN;

PROC SQL outobs=10;
	SELECT distinct A.nameLast || ' ' || nameFirst as PlayerName, A.birthYear, B.teamID
	From MARSHAL.People A Inner join MARSHAL.Appearances B
	ON A.playerID = B.playerID
	where birthYear >= 1980 AND teamID = 'DET'
	ORDER BY PlayerName desc;
QUIT;

PROC SQL outobs=10;
SELECT distinct B.teamID, A.nameLast || ' ' || nameFirst as PlayerName LABEL 'Player Name'
From MARSHAL.People A Inner join MARSHAL.Appearances B
ON A.playerID = B.playerID
where birthYear >= 1980 AND teamID = 'DET'
/*ORDER BY PlayerName desc */
order by upper(PlayerName) desc
;
QUIT;

/*
Calculates On Base Plus Slugging and ratio for Total Bases and At Bates

*/

PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/Batting.csv"
    OUT = MARSHAL.Batting
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;
    
RUN;




PROC SQL outobs=10;
	options missing = 0;
	Select playerID, ((H + BB + INPUT(HBP, 8.)) / (AB + BB + INPUT(SH, 8.)
	+ INPUT(HBP, 8. ))) as OBP,
	((H+(2*_2B) + (3*_3B) + (4*HR))/AB) as SLG,
	((H + BB + INPUT(HBP, 8.))/(AB + BB + INPUT(SH, 8.) + INPUT(HBP, 8. ))) + 
	((H + (2*_2B) + (3*_3B) + (4*HR))/AB) AS OPS
	
	FROM MARSHAL.Batting
	WHERE yearID >= 2010 and Calculated OPS > 0
	
	
	;

QUIT;

/*
Returns the total amount of players from each University in 2009
*/


PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/CollegePlaying.csv"
    OUT = MARSHAL.CollegePlaying
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;  
RUN;

PROC IMPORT    
    DATAFILE = "/folders/myfolders/Project1/Schools.csv"
    OUT = MARSHAL.Schools
    DBMS = CSV
    REPLACE;
    
    GETNAMES = Yes;
    DATAROW = 2;  
RUN;
	


PROC SQL outobs=10;
	Select Distinct B.name_full, Count(PlayerID) as Number_of_Players
	from Marshal.CollegePlaying A Inner Join Marshal.Schools B On A.SchoolID = B.SchoolID
	Where A.yearID = 2009
	Group by name_full;
QUIT;







