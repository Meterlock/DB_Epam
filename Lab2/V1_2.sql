USE AdventureWorks2012;
GO

--TASK a:
CREATE TABLE dbo.Person (
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8) NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL
)
GO

--TASK b:
ALTER TABLE dbo.Person
ADD ID BIGINT IDENTITY(10, 10),
CONSTRAINT Person_ID PRIMARY KEY (ID)
GO

--TASK c:
ALTER TABLE dbo.Person
ADD CONSTRAINT checkTitle CHECK (Title IN ('Mr.','Ms.'))
GO

--TASK d:
ALTER TABLE dbo.Person
ADD CONSTRAINT defaultSuffix DEFAULT 'N/A' FOR Suffix
GO

--TASK e:
INSERT INTO dbo.Person (
	BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	ModifiedDate
)	
SELECT 
	Person.BusinessEntityID,
	PersonType,
	NameStyle,
	Title,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	EmailPromotion,
	Person.ModifiedDate
FROM Person.Person
JOIN HumanResources.Employee ON Employee.BusinessEntityID = Person.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Person.BusinessEntityID
JOIN HumanResources.Department ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
WHERE EmployeeDepartmentHistory.EndDate IS NULL AND Department.Name <> 'Executive'
GO

--TASK f:
ALTER TABLE dbo.Person
ALTER COLUMN Suffix NVARCHAR(5) NULL
GO