USE AdventureWorks2012;
GO

--TASK a:
DECLARE @XMLvariable XML;

SET @XMLvariable = (
    SELECT
        BusinessEntityID AS '@ID',
        NationalIDNumber AS 'NationalIDNumber',
        JobTitle AS 'JobTitle'
    FROM HumanResources.Employee
    FOR XML
        PATH ('Employee'),
        ROOT ('Employees')
);

SELECT @XMLvariable;

--TASK b:
CREATE TABLE #EmployeesTMP (
    BusinessEntityID INT NOT NULL,
    NationalIDNumber NVARCHAR(15) NOT NULL,
    JobTitle NVARCHAR(50) NOT NULL
);

INSERT INTO #EmployeesTMP (
	BusinessEntityID,
	NationalIDNumber,
	JobTitle
)
SELECT
    BusinessEntityID = node.value('@ID', 'INT'),
    NationalIDNumber = node.value('NationalIDNumber[1]', 'NVARCHAR(15)'),
    JobTitle = node.value('JobTitle[1]', 'NVARCHAR(50)')
FROM @XMLvariable.nodes('/Employees/Employee') AS xml(node);

SELECT * FROM #EmployeesTMP;