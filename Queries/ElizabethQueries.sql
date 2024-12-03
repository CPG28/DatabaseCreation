use cs3380;

-- 1. drivers number of wins of all time
with racesRaced as (
    select races.* from races join driverStandings on races.raceID = driverStandings.raceID
    where driverID = 830
),
finalSeasonRaces as(
    select season, max(raceNum) as finalRace from racesRaced
    GROUP by season
),
finalRaceIDs as (
    select races.* from finalSeasonRaces join races on 
    finalSeasonRaces.season = races.season and finalSeasonRaces.finalRace = races.raceNum
)
SELECT sum(wins) as totalWins from driverStandings
where driverID = 830 and raceID in (SELECT raceID from finalRaceIDs);


-- 2. drivers number of wins over a season(INCLUDES SPRINTS RN,)
with seasonsFinalRace as (
    select distinct races.raceID from races join driverStandings on races.raceID = driverStandings.raceID
    where season = 2024 and raceNum = (
        SELECT max(raceNum) from races join driverStandings on races.raceID = driverStandings.raceID 
        where season = 2024)
)
SELECT * from driverStandings
where driverID = 830 and raceID in (select raceID from seasonsFinalRace);


-- 3. drivers wins over all time
-- include sprints!!! i think
select races.raceName, races.raceDate, raceResults.raceType from results join raceResults on results.resultID = raceResults.resultID 
join races on results.raceID = races.raceID
where driverID = 830 and finalPos = 1
ORDER BY raceDate;


-- 4. drivers wins in a season
select races.raceName, races.raceDate, raceResults.raceType from results join raceResults on results.resultID = raceResults.resultID 
join races on results.raceID = races.raceID
where driverID = 830 and finalPos = 1 and season = 2020
ORDER BY raceDate;


-- 5. number of wins for a driver at a given circuit (or each circuit?)
-- where finalPos = 1 and circuit = ___

WITH gpResults AS (
    SELECT raceResults.resultID 
    FROM raceResults 
    WHERE CAST(raceType AS VARCHAR(255)) = 'GP'
),
gpRaces as (
    select driverID, raceID, finalPos from results
    where resultID in (select resultID from gpResults)
),
driversWinsAtCircuit as (
select driverID, COUNT(CASE WHEN gpRaces.finalPos = 1 THEN 1 END) as numWins from gpRaces
join races on gpRaces.raceID = races.raceID
join circuits on races.circuitID = circuits.circuitID
where circuits.circuitID = 9
GROUP BY driverID
having COUNT(CASE WHEN gpRaces.finalPos = 1 THEN 1 END) >= 1
)
select driverFirstName, driverLastName, numWins from drivers
join driversWinsAtCircuit on drivers.driverID = driversWinsAtCircuit.driverID
order by numWins desc;


-- 6. number of wins for a constructor at a given circuit (or each circuit?)
WITH gpResults AS (
    SELECT raceResults.resultID 
    FROM raceResults 
    WHERE CAST(raceType AS VARCHAR(255)) = 'GP'
),
gpRaces as (
    select constructorID, raceID, finalPos from results
    where resultID in (select resultID from gpResults)
),
constructorsWinsAtCircuit as (
select constructorID, COUNT(CASE WHEN gpRaces.finalPos = 1 THEN 1 END) as numWins from gpRaces
join races on gpRaces.raceID = races.raceID
join circuits on races.circuitID = circuits.circuitID
where circuits.circuitID = 9
GROUP BY constructorID
having COUNT(CASE WHEN gpRaces.finalPos = 1 THEN 1 END) >= 1
)
select constructorName, numWins from constructors
join constructorsWinsAtCircuit on constructors.constructorID = constructorsWinsAtCircuit.constructorID
order by numWins desc;


-- 7. average conversion rate of starting position to race win
WITH gpResults AS (
    SELECT raceResults.resultID 
    FROM raceResults 
    WHERE CAST(raceType AS VARCHAR(255)) = 'GP'
)
SELECT raceResults.startPos,
(COUNT(CASE WHEN results.finalPos = 1 THEN 1 END) * 1.0 / COUNT(*)) * 100 AS avgConversionRate
FROM results
JOIN raceResults ON results.resultID = raceResults.resultID
WHERE raceResults.resultID IN (SELECT resultID FROM gpResults)
and startPos != 0
GROUP BY raceResults.startPos
order by startPos;



-- standings after a certain race


-- championship winners every year
-- 1st in standings in last race

select * from driverStandings;

with racesRaced as (
    select races.* from races join driverStandings on races.raceID = driverStandings.raceID
)
-- finalSeasonRaces as(
    select raceID, season, max(raceNum) as finalRace from racesRaced
    GROUP by season;








