USE AdventureWorks2012;
GO

--TASK 1:
SELECT BusinessEntityID, JobTitle, Gender, HireDate
FROM AdventureWorks2012.HumanResources.Employee
WHERE JobTitle IN ('Accounts Manager', 'Benefits Specialist', 
				   'Engineering Manager', 'Finance Manager',
				   'Maintenance Supervisor', 'Master Scheduler',
				   'Network Manager')
GO

--TASK 2:
SELECT COUNT(BusinessEntityID) AS EmpCount
FROM AdventureWorks2012.HumanResources.Employee
WHERE HireDate >= '2004'
GO

--TASK 3:
SELECT TOP(5) BusinessEntityID, JobTitle, MaritalStatus, Gender, BirthDate, HireDate
FROM AdventureWorks2012.HumanResources.Employee
WHERE MaritalStatus = 'M' AND YEAR(HireDate) = 2004
ORDER BY BirthDate DESC
GO