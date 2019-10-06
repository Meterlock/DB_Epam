USE AdventureWorks2012;
GO

--TASK a:
ALTER TABLE dbo.Person
ADD FullName NVARCHAR(100) NULL
GO

--TASK b:
DECLARE @vPerson TABLE (
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8) NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(5) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	ID BIGINT IDENTITY(10, 10),
	FullName NVARCHAR(100) NULL
);

INSERT INTO @vPerson (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	FullName
)
SELECT
	BusinessEntityID,
	PersonType,
	NameStyle,
	(SELECT CASE Gender WHEN 'M' THEN 'Mr.' ELSE 'Ms.' END FROM HumanResources.Employee
	 WHERE HumanResources.Employee.BusinessEntityID = dbo.Person.BusinessEntityID),
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate,
	FullName
FROM dbo.Person;

SELECT * FROM @vPerson
GO

--TASK c:
UPDATE dbo.Person
SET dbo.Person.FullName = selection.Title + ' ' + selection.FirstName + ' ' + selection.LastName
FROM (SELECT * FROM @vPerson) AS selection
WHERE Person.BusinessEntityID = selection.BusinessEntityID;

SELECT * FROM dbo.Person
GO

--TASK d:
DELETE FROM dbo.Person
WHERE LEN(FullName) > 20;

SELECT * FROM dbo.Person
GO

--TASK e
ALTER TABLE dbo.Person DROP CONSTRAINT checkTitle;
ALTER TABLE dbo.Person DROP CONSTRAINT defaultSuffix;
ALTER TABLE dbo.Person DROP CONSTRAINT Person_ID;
ALTER TABLE dbo.Person DROP COLUMN ID;
GO

--TASK f
DROP TABLE dbo.Person
GO