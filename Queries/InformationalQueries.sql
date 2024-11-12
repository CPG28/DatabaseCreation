
-- List all circuits
SELECT 
    * 
FROM 
    circuits;

-- List all contructors in a given year
SELECT DISTINCT
    constructors.constructorID, CAST(constructors.constructorName AS NVARCHAR(MAX)) AS name, CAST(constructors.constructorNationality AS NVARCHAR(MAX)) AS nationality
FROM
    constructors
INNER JOIN 
    partakeIn ON constructors.constructorID = partakeIn.constructorID
INNER JOIN
    races ON partakeIn.raceID = races.raceID
WHERE
    races.season = ?;

-- List all driver in a given year
SELECT DISTINCT
    drivers.driverID, CAST(drivers.driverFirstName AS NVARCHAR(MAX)) as firstName, CAST(drivers.driverLastName AS NVARCHAR(MAX)) AS lastName, CAST(drivers.driverNationality AS NVARCHAR(MAX)) AS nationality
FROM
    drivers
INNER JOIN 
    raceIn ON drivers.driverID = raceIn.driverID
INNER JOIN
    races ON raceIn.raceID = races.raceID
WHERE
    races.season = ?;

-- List races in a given year
SELECT
    races.raceID, races.raceName, races.raceDate, races.raceNum, races.circuitID
FROM
    races
WHERE
    races.season = ?;

-- Constructor standings after a given race
SELECT
    constructorStandings.constructorID, constructors.constructorName, constructorStandings.totalPoints, constructorStandings.wins
FROM
    constructorStandings
INNER JOIN
    constructors ON constructorStandings.constructorID = constructors.constructorID
WHERE
    constructorStandings.raceID = ?
ORDER BY
    constructorStandings.totalPoints DESC;

-- Driver standings after a given race
SELECT
    driverStandings.driverID, drivers.driverFirstName, drivers.driverLastName, driverStandings.totalPoints, driverStandings.wins
FROM
    driverStandings
INNER JOIN
    drivers on driverStandings.driverID = drivers.driverID
WHERE
    driverStandings.raceID = ?
ORDER BY
    driverStandings.totalPoints DESC;

-- Race results given a race ID and result type?
-- Qualifying results for a race
SELECT
    drivers.driverID, drivers.driverFirstName, drivers.driverLastName, constructors.constructorID, constructors.constructorName, results.finalPos, results.carNum, 
    qualifyingResults.q1Time, qualifyingResults.q2Time, qualifyingResults.q3Time
FROM
    qualifyingResults
INNER JOIN
    results ON qualifyingResults.resultID = results.resultID
INNER JOIN
    drivers ON results.driverID = drivers.driverID
INNER JOIN
    constructors ON results.constructorID = constructors.constructorID
WHERE
    results.raceID = ?;

-- GP results for a race
SELECT
    drivers.driverID, drivers.driverFirstName, drivers.driverLastName, constructors.constructorID, constructors.constructorName, results.finalPos, results.carNum, 
    raceResults.startPos, raceResults.numPoints
FROM
    raceResults
INNER JOIN
    results ON raceResults.resultID = results.resultID
INNER JOIN
    drivers ON results.driverID = drivers.driverID
INNER JOIN
    constructors ON results.constructorID = constructors.constructorID
WHERE
    results.raceID = ? AND CONVERT(VARCHAR, raceResults.raceType) = ?;