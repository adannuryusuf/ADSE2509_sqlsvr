-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Adan Yusuf
-- Create date: 12-05-2026
-- Description:	Returns sales to year date for a teritorry
-- =============================================
CREATE PROCEDURE uspGetTotals 
	-- Add the parameters for the stored procedure here
	@territory nvarchar(40) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.BusinessEntityID, B.SalesYTD, B.SalesLastYear
	from AdventureWorks2022.Sales.SalesPerson A
	join AdventureWorks2022.Sales.SalesTerritory B
	on A.TerritoryID = B.TerritoryID
	where B.Name = @territory
END
GO
