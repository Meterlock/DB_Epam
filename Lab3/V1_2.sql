USE AdventureWorks2012;
GO

--TASK a:
ALTER TABLE dbo.Person
ADD SalesYTD MONEY, 
	SalesLastYear MONEY,
	OrdersNum INT,
	SalesDiff AS (SalesLastYear - SalesYTD)
GO

--TASK b:
CREATE TABLE #Person (
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
	SalesYTD MONEY, 
	SalesLastYear MONEY,
	OrdersNum INT,
	PRIMARY KEY (BusinessEntityID)
)
GO

--TASK c:
WITH OrdersCount AS 
(SELECT  
	BusinessEntityID,
	(SELECT COUNT(*) FROM Sales.SalesOrderHeader
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesOrderHeader.SalesPersonID) AS OrdersNum
FROM dbo.Person)
INSERT INTO #Person (
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
	SalesYTD,
	SalesLastYear,
	OrdersNum
)	
SELECT 
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
	(SELECT SalesYTD FROM Sales.SalesPerson
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID),
	(SELECT SalesLastYear FROM Sales.SalesPerson
	 WHERE dbo.Person.BusinessEntityID = Sales.SalesPerson.BusinessEntityID),
	(SELECT OrdersNum FROM OrdersCount
	 WHERE dbo.Person.BusinessEntityID = OrdersCount.BusinessEntityID)
FROM dbo.Person;

SELECT * FROM #Person
GO

--TASK d:
DELETE FROM dbo.Person WHERE BusinessEntityID = 290;

SELECT COUNT(*) AS RemainedRowsCount FROM dbo.Person
GO

--TASK e:
MERGE INTO dbo.Person AS Target_table
USING #Person AS Source_table
ON Target_table.BusinessEntityID = Source_table.BusinessEntityID
WHEN MATCHED THEN UPDATE SET
	SalesYTD = Source_table.SalesYTD,
	SalesLastYear = Source_table.SalesLastYear,
	OrdersNum = Source_table.OrdersNum
WHEN NOT MATCHED BY TARGET THEN	INSERT (
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
	SalesYTD,
	SalesLastYear,
	OrdersNum)
VALUES (
	Source_table.BusinessEntityID,
	Source_table.PersonType,
	Source_table.NameStyle,
	Source_table.Title,
	Source_table.FirstName,
	Source_table.MiddleName,
	Source_table.LastName,
	Source_table.Suffix,
	Source_table.EmailPromotion,
	Source_table.ModifiedDate,
	Source_table.SalesYTD,
	Source_table.SalesLastYear,
	Source_table.OrdersNum)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT * FROM dbo.Person
GO