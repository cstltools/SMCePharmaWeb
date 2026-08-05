CREATE PROCEDURE [dbo].[sp_GET_tFiscalYearList]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN

	SELECT TOP 1
    FinancialYearDesc,
    FinancialYearId 
FROM
    dbo.tblFinancialYear AS GRP WITH (NOLOCK)
WHERE
    Status = 'Active'
    AND GETDATE() BETWEEN StartDate AND EndDate

	union all 
	SELECT  
    FinancialYearDesc,
    FinancialYearId 
FROM
    dbo.tblFinancialYear AS GRP WITH (NOLOCK)
WHERE
    Status = 'Active' and FinancialYearId not in (	SELECT TOP 1
  
    FinancialYearId 
FROM
    dbo.tblFinancialYear AS GRP WITH (NOLOCK)
WHERE
    Status = 'Active'
    AND GETDATE() BETWEEN StartDate AND EndDate)
    
 

 
 


 END
