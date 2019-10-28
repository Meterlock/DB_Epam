USE AdventureWorks2012;
GO

--TASK a:
CREATE FUNCTION HumanResources.GetDepartmentsAmount (@GroupName	NVARCHAR(50))
RETURNS INT AS
BEGIN
	DECLARE @result INT

	SELECT @result = COUNT(*)
	FROM HumanResources.Department
	WHERE Department.GroupName = @GroupName

	RETURN @result
END;
GO

--TASK b:
CREATE FUNCTION HumanResources.GetTopThreeOldFags(@DepartmentID INT)
RETURNS TABLE AS RETURN (
	SELECT TOP(3)
		Employee.BusinessEntityID,
		NationalIDNumber,
		LoginID,
		OrganizationNode,
		OrganizationLevel,
		JobTitle,
		BirthDate,
		MaritalStatus,
		Gender,
		HireDate,
		SalariedFlag,
		VacationHours,
		SickLeaveHours,CurrentFlag,
		rowguid,
		Employee.ModifiedDate
	FROM HumanResources.Employee
	JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
	WHERE DepartmentID = @DepartmentID AND EndDate IS NULL AND StartDate >= '2005'
	ORDER BY BirthDate ASC
);
GO

--TASK c:
SELECT * FROM HumanResources.Department CROSS APPLY HumanResources.GetTopThreeOldFags(DepartmentID);
SELECT * FROM HumanResources.Department OUTER APPLY HumanResources.GetTopThreeOldFags(DepartmentID);
GO

--TASK d:
CREATE FUNCTION HumanResources.GetTopThreeOldFags(@DepartmentID INT)
RETURNS @result TABLE(
	BusinessEntityID INT NOT NULL,
	NationalIDNumber NVARCHAR(15) NOT NULL,
	LoginID NVARCHAR(256) NOT NULL,
	OrganizationNode HIERARCHYID NULL,
	OrganizationLevel SMALLINT NULL,
	JobTitle NVARCHAR(50) NOT NULL,
	BirthDate DATE NOT NULL,
	MaritalStatus NCHAR(1) NOT NULL,
	Gender NCHAR(1) NOT NULL,
	HireDate DATE NOT NULL,
	SalariedFlag BIT NOT NULL,
	VacationHours SMALLINT NOT NULL,
	SickLeaveHours SMALLINT NOT NULL,
	CurrentFlag BIT NOT NULL,
	rowguid UNIQUEIDENTIFIER NOT NULL,
	ModifiedDate DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT TOP(3)
		Employee.BusinessEntityID,
		NationalIDNumber,
		LoginID,
		OrganizationNode,
		OrganizationLevel,
		JobTitle,
		BirthDate,
		MaritalStatus,
		Gender,
		HireDate,
		SalariedFlag,
		VacationHours,
		SickLeaveHours,CurrentFlag,
		rowguid,
		Employee.ModifiedDate
	FROM HumanResources.Employee
	JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
	WHERE DepartmentID = @DepartmentID AND EndDate IS NULL AND StartDate >= '2005'
	ORDER BY BirthDate ASC
	RETURN
END;
GO
