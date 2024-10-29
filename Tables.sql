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
    dob DATE NOT NULL,
);

CREATE TABLE constructors (
    constructorID INT PRIMARY KEY,
    constructorName TEXT NOT NULL,
    constructorNationality TEXT NOT NULL
);

CREATE TABLE raceFor (
    driverID INT REFERENCES drivers(driverID),
    constructorID INT REFERENCES constructors(constructorID),
    PRIMARY KEY(driverID, constructorID),
);

CREATE TABLE races (
    raceID INT PRIMARY KEY,
    circuitID INT REFERENCES circuit(circuitID),
    season INT NOT NULL,
    raceNum INT NOT NULL,
    raceName TEXT NOT NULL,
    raceDate DATE NOT NULL
);

CREATE TABLE raceIn (
    driverID INT REFERENCES drivers(driverID),
    raceID INT REFERENCES races(raceID),
    PRIMARY KEY(driverID, raceID)
);

CREATE TABLE partakeIn (
    constructorID INT REFERENCES constructors(constructorID),
    raceID INT REFERENCES races(raceID),
    PRIMARY KEY(constructorID, raceID)
);

CREATE TABLE driverStandings (
    driverStandingID INT PRIMARY KEY,
    raceID INT REFERENCES races(raceID),
    driverID INT REFERENCES drivers(driverID),
    standingsPos INT NOT NULL,
    wins INT NOT NULL,
    totalPoints INT NOT NULL
);

CREATE TABLE constructorStandings (
    constructorStandingID INT PRIMARY KEY,
    raceID INT REFERENCES races(raceID),
    constructorID INT REFERENCES constructors(constructorID),
    standingsPos INT NOT NULL,
    wins INT NOT NULL,
    totalPoints INT NOT NULL
);

CREATE TABLE results (
    resultID INT PRIMARY KEY IDENTITY(1,1),
    driverID INT REFERENCES drivers(driverID),
    constructorID INT REFERENCES constructors(constructorID),
    raceID INT REFERENCES races(raceID),
    finalPos INT,
    carNum INT NOT NULL
);

CREATE TABLE qualifyingResults (
    resultID INT PRIMARY KEY REFERENCES results(resultID),
    q1Time TIME,
    q2Time TIME,
    q3Time TIME,
);

CREATE TABLE raceResults (
    resultID INT PRIMARY KEY REFERENCES results(resultID),
    startPos INT NOT NULL,
    numPoints INT NOT NULL,
    raceType TEXT NOT NULL
);