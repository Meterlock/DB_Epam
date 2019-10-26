USE AdventureWorks2012;
GO

--TASK a:
CREATE TABLE Production.ProductCategoryHst (
	ID INT IDENTITY(1, 1) PRIMARY KEY,
	Action NCHAR(6) NOT NULL CHECK (Action IN('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate DATETIME NOT NULL,
	SourceID INT NOT NULL,
	UserName NVARCHAR(50) NOT NULL
)
GO

--TASK b:
CREATE TRIGGER Production.ProductCategoryTrigger
ON Production.ProductCategory
AFTER INSERT, UPDATE, DELETE AS
	INSERT INTO Production.ProductCategoryHst (Action, ModifiedDate, SourceID, UserName)
	SELECT
		CASE WHEN inserted.ProductCategoryID IS NULL THEN 'DELETE'
			 WHEN deleted.ProductCategoryID IS NULL THEN 'INSERT'
			 ELSE 'UPDATE'
		END,
		GETDATE(),
		COALESCE(inserted.ProductCategoryID, deleted.ProductCategoryID),
		USER_NAME()
	FROM inserted FULL OUTER JOIN deleted
	ON inserted.ProductCategoryID = deleted.ProductCategoryID;
GO

--TASK c:
CREATE VIEW Production.ProductCategoryView AS 
	SELECT * FROM Production.ProductCategory;
GO

--TASK d:
INSERT INTO Production.ProductCategoryView (Name, rowguid, ModifiedDate)
VALUES ('myproductname', NEWID(), GETDATE());

UPDATE Production.ProductCategoryView SET rowguid = NEWID() WHERE Name = 'myproductname';

DELETE Production.ProductCategoryView WHERE Name = 'myproductname';

SELECT * FROM Production.ProductCategoryHst;
GO