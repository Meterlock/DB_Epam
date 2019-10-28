USE AdventureWorks2012;
GO

CREATE PROCEDURE dbo.OrdersByYear (@Years NVARCHAR(100)) AS
BEGIN
	DECLARE @Query AS NVARCHAR(500);
	SET @Query = '
		SELECT Name, ' + @Years + ' FROM (
			SELECT Name, YEAR(OrderDate) AS y, OrderQty FROM Sales.SalesOrderHeader
			JOIN Sales.SalesOrderDetail ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
			JOIN Production.Product ON Product.ProductID = SalesOrderDetail.ProductID) AS selected
		PIVOT (  
			sum(OrderQty) FOR y IN(' + @Years + ') 
		) AS pvt'
    EXEC(@Query)
END;
GO
	                
EXECUTE dbo.OrdersByYear '[2008], [2007], [2006]';
GO
