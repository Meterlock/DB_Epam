USE AdventureWorks2012;
GO

--TASK 1:
SELECT EmployeePayHistory.BusinessEntityID, Employee.JobTitle, MAX(EmployeePayHistory.Rate) AS MaxRate 
FROM HumanResources.Employee
JOIN HumanResources.EmployeePayHistory ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
GROUP BY EmployeePayHistory.BusinessEntityID, Employee.JobTitle
GO

--TASK 2:
SELECT EmployeePayHistory.BusinessEntityID, Employee.JobTitle, EmployeePayHistory.Rate,
	DENSE_RANK() OVER(ORDER BY EmployeePayHistory.Rate) RankRate
FROM HumanResources.Employee
JOIN HumanResources.EmployeePayHistory ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
ORDER BY EmployeePayHistory.Rate
GO

--TASK 3:
SELECT Department.Name AS DepName, Employee.BusinessEntityID, 
	Employee.JobTitle, EmployeeDepartmentHistory.ShiftID AS ShiftID
FROM HumanResources.Employee
JOIN HumanResources.EmployeeDepartmentHistory ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID
JOIN HumanResources.Department ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
WHERE EmployeeDepartmentHistory.EndDate IS NULL
ORDER BY Department.Name, 
	CASE Department.Name WHEN 'Document Control' THEN ShiftID 
	ELSE Employee.BusinessEntityID END
GO