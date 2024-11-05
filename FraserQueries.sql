-- Have to do the WITH b/c it does not like DISTINCT with string attributes
-- Lists all the drivers racing the current F1 season.
-- Is fairly simple but serves as a starting position for finding more information.
-- WITH currentDrivers AS (
--     SELECT DISTINCT drivers.driverID
--     FROM drivers INNER JOIN raceIn ON drivers.driverID = raceIn.driverID INNER JOIN races ON raceIn.raceID = races.raceID
--     WHERE races.season IN (SELECT MAX(races.season) FROM races)
-- )
-- SELECT drivers.driverID, drivers.driverFirstName, drivers.driverLastName
-- FROM drivers INNER JOIN currentDrivers ON drivers.driverID = currentDrivers.driverID;

-- Current constructors
-- Lists all the constructors in the current F1 season.
-- Is fairly simple but serves as a starting position for finding more information.
-- WITH currentConstructors AS (
--     SELECT DISTINCT constructors.constructorID
--     FROM constructors INNER JOIN partakeIn ON constructors.constructorID = partakeIn.constructorID INNER JOIN races ON partakeIn.raceID = races.raceID
--     WHERE races.season IN (SELECT MAX(races.season) FROM races)
-- )
-- SELECT constructors.constructorID, constructors.constructorName
-- FROM constructors INNER JOIN currentConstructors ON constructors.constructorID = currentConstructors.constructorID;

-- Lists the current standings in the drivers championship in order of points.
-- SELECT drivers.driverFirstName, drivers.driverLastName, driverStandings.totalPoints, driverStandings.wins
-- FROM drivers INNER JOIN driverStandings ON drivers.driverID = driverStandings.driverID
-- WHERE driverStandings.raceID IN (SELECT MAX(driverStandings.raceID) FROM driverStandings)
-- ORDER BY driverStandings.totalPoints DESC;

-- Lists the current standings in teh constructors championship in order of points.
-- SELECT constructors.constructorName, constructorStandings.totalPoints, constructorStandings.wins
-- FROM constructors INNER JOIN constructorStandings ON constructors.constructorID = constructorStandings.constructorID
-- WHERE constructorStandings.raceID IN (SELECT MAX(constructorStandings.raceID) FROM constructorStandings)
-- ORDER BY constructorStandings.totalPoints DESC;

-- Lists all drivers of a given nationality that the user inputs.
-- SELECT drivers.driverFirstName, drivers.driverLastName
-- FROM drivers 
-- WHERE CONVERT(VARCHAR, drivers.driverNationality) = 'Italian'
-- ORDER BY drivers.dob DESC;

-- Lists all constructors of a given nationality that the user inputs.
-- SELECT constructors.constructorName
-- FROM constructors 
-- WHERE CONVERT(VARCHAR, constructors.constructorNationality) = 'Italian';

-- Lists all constructors that a driver the user inputs has driven for. In this case Lewis Hamilton.
-- SELECT constructors.constructorName
-- FROM constructors INNER JOIN raceFor ON constructors.constructorID = raceFor.constructorID INNER JOIN drivers ON drivers.driverID = raceFor.driverID
-- WHERE CONVERT(VARCHAR, drivers.driverFirstName) = 'Lewis' AND CONVERT(VARCHAR, drivers.driverLastName) = 'Hamilton';

-- Lists all drivers that a constructor the user inputs have had race for them. In this case Ferrari.
-- SELECT drivers.driverFirstName, drivers.driverLastName
-- FROM constructors INNER JOIN raceFor ON constructors.constructorID = raceFor.constructorID INNER JOIN drivers ON drivers.driverID = raceFor.driverID
-- WHERE CONVERT(VARCHAR, constructors.constructorName) = 'Ferrari';

-- Lists the most positions gained in a race, the driver and the race in which it happened. Users can select how many drivers they want to view.
-- SELECT TOP 10 raceResults.startPos - results.finalPos AS positionsGained, drivers.driverFirstName, drivers.driverLastName, races.raceName, races.season
-- FROM raceResults INNER JOIN results ON raceResults.resultID = results.resultID INNER JOIN drivers ON results.driverID = drivers.driverID INNER JOIN races ON races.raceID = results.raceID
-- WHERE CONVERT(VARCHAR, raceResults.raceType) = 'GP'
-- ORDER BY positionsGained DESC;
