USE AdventureWorks2012;
GO

--TASK a:
CREATE VIEW Production.CategoryAndSubView (
	ProductCategoryID,
	CategoryName,
	CategoryRowguid,
	CategoryModifiedDate,
	ProductSubCategoryID,
	SubCategoryName,
	SubCategoryRowguid,
	SubCategoryModifiedDate
)
WITH ENCRYPTION, SCHEMABINDING AS
	SELECT 
		pc.ProductCategoryID,
		pc.Name,
		pc.rowguid,
		pc.ModifiedDate,
		psc.ProductSubcategoryID,
		psc.Name,
		psc.rowguid,
		psc.ModifiedDate
	FROM Production.ProductCategory AS pc JOIN Production.ProductSubcategory AS psc
	ON pc.ProductCategoryID = psc.ProductCategoryID;
GO
	
CREATE UNIQUE CLUSTERED INDEX CategoryAndSubID_Index ON Production.CategoryAndSubView (ProductCategoryID, ProductSubCategoryID);
GO

SELECT * FROM Production.CategoryAndSubView;
GO

--TASK b:
CREATE TRIGGER Production.CategoryAndSubViewInsert
ON Production.CategoryAndSubView
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO Production.ProductCategory (Name, rowguid, ModifiedDate)
	SELECT 
		CategoryName, CategoryRowguid, CategoryModifiedDate
	FROM inserted;
	INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name, rowguid, ModifiedDate)
	SELECT 
		SCOPE_IDENTITY(), SubCategoryName, SubCategoryRowguid, SubCategoryModifiedDate
	FROM inserted;
END;
GO

CREATE TRIGGER Production.CategoryAndSubViewUpdate
ON Production.CategoryAndSubView
INSTEAD OF UPDATE AS
BEGIN
	UPDATE Production.ProductCategory SET
		Name = inserted.CategoryName,
		rowguid = inserted.CategoryRowguid,
		ModifiedDate = inserted.CategoryModifiedDate
	FROM inserted
	WHERE inserted.ProductCategoryID = Production.ProductCategory.ProductCategoryID;
	UPDATE Production.ProductSubcategory SET		
		Name = inserted.SubCategoryName,
		rowguid = inserted.SubCategoryRowguid,
		ModifiedDate = inserted.SubCategoryModifiedDate
	FROM inserted
	WHERE inserted.ProductSubCategoryID = Production.ProductSubcategory.ProductSubcategoryID;
END;
GO

CREATE TRIGGER Production.CategoryAndSubViewDelete
ON Production.CategoryAndSubView
INSTEAD OF DELETE AS
BEGIN
	DELETE FROM Production.ProductSubcategory WHERE ProductSubcategoryID IN (SELECT ProductSubCategoryID FROM deleted);
	DELETE FROM Production.ProductCategory WHERE ProductCategoryID IN (SELECT ProductCategoryID FROM deleted) AND
		ProductCategoryID NOT IN (SELECT ProductCategoryID FROM Production.ProductSubcategory);
END;
GO

--TASK c:
INSERT INTO Production.CategoryAndSubView (	
	CategoryName,
	CategoryRowguid,
	CategoryModifiedDate,	
	SubCategoryName,
	SubCategoryRowguid,
	SubCategoryModifiedDate)
VALUES ('CATEGORY', NEWID(), GETDATE(),'SUB_CATEGORY', NEWID(), GETDATE());

UPDATE Production.CategoryAndSubView SET
	CategoryName = 'HELLO',
	CategoryRowguid = NEWID(),
	CategoryModifiedDate = GETDATE(),
	SubCategoryName = 'WORLD',
	SubCategoryRowguid = NEWID(),
	SubCategoryModifiedDate = GETDATE()
WHERE SubCategoryName = 'SUB_CATEGORY';

DELETE Production.CategoryAndSubView WHERE SubCategoryName = 'WORLD';
GO