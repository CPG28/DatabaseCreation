-- *** Should this be changed to allow the user to enter any year? With 'current' being an option. Same goes for constructors.***
-- Have to do the WITH b/c it does not like DISTINCT with string attributes

-- Is fairly simple but serves as a starting position for finding more information on the current season, which is often of interest to a user.
-- Lists all the drivers racing the current F1 season.
WITH currentDrivers AS (
    SELECT DISTINCT drivers.driverID
    FROM 
        drivers 
    INNER JOIN 
        raceIn ON drivers.driverID = raceIn.driverID 
    INNER JOIN 
        races ON raceIn.raceID = races.raceID
    WHERE 
    races.season IN (SELECT MAX(races.season) FROM races)
)
SELECT
    drivers.driverID, drivers.driverFirstName, drivers.driverLastName
FROM 
    drivers 
INNER JOIN 
    currentDrivers ON drivers.driverID = currentDrivers.driverID;

-- Current constructors
-- Is fairly simple but serves as a starting position for finding more information, which is often of interest to a user.
-- Lists all the constructors in the current F1 season.
WITH currentConstructors AS (
    SELECT DISTINCT 
        constructors.constructorID
    FROM 
        constructors 
    INNER JOIN 
        partakeIn ON constructors.constructorID = partakeIn.constructorID 
    INNER JOIN 
        races ON partakeIn.raceID = races.raceID
    WHERE 
        races.season IN (SELECT MAX(races.season) FROM races)
)
SELECT 
    constructors.constructorID, constructors.constructorName
FROM 
    constructors 
INNER JOIN 
    currentConstructors ON constructors.constructorID = currentConstructors.constructorID;

-- Is fairly simple but serves as a starting position for finding more information, which is often of interest to a user.
-- Lists the current standings in the drivers championship in order of points.
SELECT 
    drivers.driverFirstName, drivers.driverLastName, driverStandings.totalPoints, driverStandings.wins
FROM 
    drivers 
INNER JOIN 
    driverStandings ON drivers.driverID = driverStandings.driverID
WHERE 
    driverStandings.raceID IN (SELECT MAX(driverStandings.raceID) FROM driverStandings)
ORDER BY
    driverStandings.totalPoints DESC;

-- Is fairly simple but serves as a starting position for finding more information, which is often of interest to a user.
-- Lists the current standings in the constructors championship in order of points.
SELECT 
    constructors.constructorName, constructorStandings.totalPoints, constructorStandings.wins
FROM 
    constructors 
INNER JOIN 
    constructorStandings ON constructors.constructorID = constructorStandings.constructorID
WHERE 
    constructorStandings.raceID IN (SELECT MAX(constructorStandings.raceID) FROM constructorStandings)
ORDER BY 
    constructorStandings.totalPoints DESC;

-- Servers as a starting place for a users to find out more about drivers of a nationality of interest to them, perhaps their own.
-- Lists all drivers of a given nationality that the user inputs.
SELECT 
    drivers.driverFirstName, drivers.driverLastName
FROM 
    drivers 
WHERE 
    CONVERT(VARCHAR, drivers.driverNationality) = ?
ORDER BY 
    drivers.dob DESC;

-- Servers as a starting place for a users to find out more about contructors of a nationality of interest to them, perhaps their own.
-- Lists all constructors of a given nationality that the user inputs.
SELECT 
    constructors.constructorName
FROM 
    constructors 
WHERE 
    CONVERT(VARCHAR, constructors.constructorNationality) = ?;

-- Allows a user to do futher research on a driver by knowing the constructors that they raced for.
-- Lists all constructors that a driver the user inputs has driven for.
SELECT 
    constructors.constructorName
FROM 
    constructors 
INNER JOIN 
    raceFor ON constructors.constructorID = raceFor.constructorID 
INNER JOIN 
    drivers ON drivers.driverID = raceFor.driverID
WHERE 
    CONVERT(VARCHAR, drivers.driverFirstName) = ? AND CONVERT(VARCHAR, drivers.driverLastName) = ?;

-- Allows a user to do futher research on a constructor by knowing the drivers that raced for them.
-- Lists all drivers that a constructor the user inputs have had race for them.
SELECT 
    drivers.driverFirstName, drivers.driverLastName
FROM 
    constructors
INNER JOIN 
    raceFor ON constructors.constructorID = raceFor.constructorID 
INNER JOIN 
    drivers ON drivers.driverID = raceFor.driverID
WHERE 
    CONVERT(VARCHAR, constructors.constructorName) = ?;

-- Serves as an interesting statistic from which a user can look further into the races and drivers.
-- Lists the most positions gained in a race, the driver and the race in which it happened. Users can select how many drivers they want to view.
SELECT TOP ? 
    raceResults.startPos - results.finalPos AS positionsGained, drivers.driverFirstName, drivers.driverLastName, races.raceName, races.season
FROM 
    raceResults 
INNER JOIN 
    results ON raceResults.resultID = results.resultID INNER JOIN drivers ON results.driverID = drivers.driverID INNER JOIN races ON races.raceID = results.raceID
WHERE 
    CONVERT(VARCHAR, raceResults.raceType) = 'GP'
ORDER BY 
    positionsGained DESC;

-- User can input how many of the top drivers to see as well as set a minimum number of circuits that
-- a driver has raced in. Setting a minimum number of races allows the user to eliminate drivers who 
-- have only raced and won at 1 or 2 circuits.
-- This query allows a user to see the dominance of a driver throughout their carrer as well as allows
-- them so see which driver have won at every track they have ever raced at, a division problem.
-- Lists the drivers who have won at the highest percentage of circuits that they have raced at.
WITH circuitsWonAt AS (
    SELECT 
        drivers.driverID, COUNT(DISTINCT circuits.circuitID) AS numWins
    FROM 
        drivers
    INNER JOIN 
        results ON drivers.driverID = results.driverID 
    INNER JOIN 
        raceResults ON raceResults.resultID = results.resultID 
    INNER JOIN 
        races ON results.raceID = races.raceID 
    INNER JOIN 
        circuits ON races.circuitID = circuits.circuitID
    WHERE 
        CONVERT(VARCHAR, raceResults.raceType) = 'GP' AND results.finalPos = 1
    GROUP BY 
        drivers.driverID
), 

circuitsDrivenAt AS (
    SELECT 
        drivers.driverID, COUNT(DISTINCT circuits.circuitID) AS numCircuits
    FROM 
        drivers 
    INNER JOIN 
        raceIN ON drivers.driverID = raceIn.driverID
    INNER JOIN 
        races ON raceIn.raceID = races.raceID
    INNER JOIN 
        circuits ON races.circuitID = circuits.circuitID
    GROUP BY 
        drivers.driverID
    HAVING 
        COUNT(DISTINCT circuits.circuitID) > ?
)
SELECT TOP ? 
    drivers.driverFirstName, drivers.driverLastName, ROUND(CAST(circuitsWonAt.numWins AS float) / CAST(circuitsDrivenAt.numCircuits AS float), 3) AS percentageOfCircuitsWonAt
FROM 
    drivers 
INNER JOIN 
    circuitsWonAt ON drivers.driverID = circuitsWonAt.driverID
INNER JOIN 
    circuitsDrivenAt ON drivers.driverID = circuitsDrivenAt.driverID
ORDER BY 
    percentageOfCircuitsWonAt DESC;