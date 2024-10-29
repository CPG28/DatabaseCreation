CREATE TABLE circuits (
    circuitID INT PRIMARY KEY,
    circuitAltitude NUMERIC NOT NULL,
    circuitLongitude NUMERIC NOT NULL,
    circuitLatitude NUMERIC NOT NULL,
    circuitCountry TEXT NOT NULL,
    circuitName TEXT NOT NULL
);

CREATE TABLE drivers (
    driverID INT PRIMARY KEY,
    driverNationality TEXT NOT NULL,
    driverNumber INT,
    driverFirstName TEXT NOT NULL,
    driverLastName TEXT NOT NULL,
    dob DATE NOT NULL
);

CREATE TABLE constructors (
    constructorID INT PRIMARY KEY,
    constructorName TEXT NOT NULL,
    constructorNationality TEXT NOT NULL
);

CREATE TABLE raceFor (
    driverID INT REFERENCES drivers(driverID) ON DELETE CASCADE,
    constructorID INT REFERENCES constructors(constructorID) ON DELETE CASCADE,
    PRIMARY KEY(driverID, constructorID)
);

CREATE TABLE races (
    raceID INT PRIMARY KEY,
    circuitID INT REFERENCES circuit(circuitID) ON DELETE SET NULL,
    season INT NOT NULL,
    raceNum INT NOT NULL,
    raceName TEXT NOT NULL,
    raceDate DATE NOT NULL
);

CREATE TABLE raceIn (
    driverID INT REFERENCES drivers(driverID) ON DELETE CASCADE,
    raceID INT REFERENCES races(raceID) ON DELETE CASCADE,
    PRIMARY KEY(driverID, raceID)
);

CREATE TABLE partakeIn (
    constructorID INT REFERENCES constructors(constructorID) ON DELETE CASCADE,
    raceID INT REFERENCES races(raceID) ON DELETE CASCADE,
    PRIMARY KEY(constructorID, raceID)
);

CREATE TABLE driverStandings (
    driverStandingID INT PRIMARY KEY,
    raceID INT REFERENCES races(raceID) ON DELETE CASCADE,
    driverID INT REFERENCES drivers(driverID) ON DELETE CASCADE,
    standingsPos INT NOT NULL,
    wins INT NOT NULL,
    totalPoints INT NOT NULL
);

CREATE TABLE constructorStandings (
    constructorStandingID INT PRIMARY KEY,
    raceID INT REFERENCES races(raceID) ON DELETE CASCADE,
    constructorID INT REFERENCES constructors(constructorID) ON DELETE CASCADE,
    standingsPos INT NOT NULL,
    wins INT NOT NULL,
    totalPoints INT NOT NULL
);

CREATE TABLE results (
    resultID INT PRIMARY KEY IDENTITY(1,1),
    driverID INT REFERENCES drivers(driverID) ON DELETE CASCADE,
    constructorID INT REFERENCES constructors(constructorID) ON DELETE CASCADE,
    raceID INT REFERENCES races(raceID) ON DELETE CASCADE,
    finalPos INT,
    carNum INT NOT NULL
);

CREATE TABLE qualifyingResults (
    resultID INT PRIMARY KEY REFERENCES results(resultID) ON DELETE CASCADE,
    q1Time TIME,
    q2Time TIME,
    q3Time TIME
);

CREATE TABLE raceResults (
    resultID INT PRIMARY KEY REFERENCES results(resultID) ON DELETE CASCADE,
    startPos INT NOT NULL,
    numPoints INT NOT NULL,
    raceType TEXT NOT NULL
);