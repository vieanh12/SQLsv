--1 create database
CREATE DATABASE NTB_DB
USE NTB_DB

--2 Create table
CREATE TABLE Location (
    LocationID CHAR(6) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(100)
);

CREATE TABLE Land (
    LandID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100) NOT NULL,
    LocationID CHAR(6) FOREIGN KEY REFERENCES Location(LocationID),
    Detail NVARCHAR(1000),
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL
);

CREATE TABLE Building (
    BuildingID INT PRIMARY KEY IDENTITY,
    LandID INT FOREIGN KEY REFERENCES Land(LandID),
    BuildingType NVARCHAR(50),
    Area INT DEFAULT 50,
    Floors INT DEFAULT 1,
    Rooms INT DEFAULT 1,
	Cost money
);

--3. Insert into each table at least three records.
INSERT INTO Location (LocationID, Name, Description)
VALUES
    ('123456', 'Urban', 'Urban Region'),
    ('234567', 'Suburban', 'Suburban Region'),
    ('345678', 'Rural', 'Rural Region');

INSERT INTO Land (Title, LocationID, Detail, StartDate, EndDate)
VALUES
    ('Thanh Xuan', '123456', 'My Dinh in Urban Region', '2011-01-01', '2012-12-31'),
    ('Hoan Kiem', '234567', 'Hoai Duc in Suburban Region', '2014-02-01', '2022-11-30'),
    ('Cau Giay', '345678', 'An Thuong in Rural Region', '2002-03-01', '2015-10-31');

INSERT INTO Building (LandID, BuildingType, Area, Floors, Rooms, Cost)
VALUES
    (1, 'Villa', 200, 2, 4, 1000),
    (2, 'Apartment', 150, 3, 6, 800),
    (3, 'Supermarket', 300, 1, 1, 1500);
--4. List all the buildings with a floor area of 100m2 or more.
SELECT * FROM Building
WHERE Area >= 100;
--5. List the construction land will be completed before January 2013.
SELECT * FROM Land
WHERE EndDate < '2013-01-01';
--6. List all buildings to be built in the land of title "My Dinh�
SELECT Building.* FROM Building
JOIN Land ON Building.LandID = Land.LandID
WHERE Land.Title = 'Thanh Xuan';
--7. Create a view v_Buildings contains the following information (BuildingID, Title, Name, BuildingType, Area, Floors) from table Building, Land and Location.
CREATE VIEW v_Buildings AS
SELECT Building.BuildingID, Land.Title, Location.Name, Building.BuildingType, Building.Area, Building.Floors
FROM Building
JOIN Land ON Building.LandID = Land.LandID
JOIN Location ON Land.LocationID = Location.LocationID;
--8. Create a view v_TopBuildings about 5 buildings with the most expensive price per m2.
CREATE VIEW v_TopBuildings AS
SELECT TOP 5 BuildingID, BuildingType, Area, Cost/Area AS PricePerM2
FROM Building
ORDER BY PricePerM2 DESC;
--9. Create a store called sp_SearchLandByLocation with input parameter is the area code and retrieve planned land for this area.
CREATE PROCEDURE sp_SearchLandByLocation @AreaCode char(6)
AS
BEGIN
    SELECT Land.* FROM Land
    JOIN Location ON Land.LocationID = Location.LocationID
    WHERE Location.LocationID = @AreaCode;
END;
--10. Create a store called sp_SearchBuidingByLand procedure input parameter is the land code and retrieve the buildings built on that land.
CREATE PROCEDURE sp_SearchBuildingByLand @LandCode int
AS
BEGIN
    SELECT * FROM Building
    WHERE LandID = @LandCode;
END;


