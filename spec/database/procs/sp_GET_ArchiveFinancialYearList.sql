
create PROCEDURE [dbo].[sp_GET_ArchiveFinancialYearList]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT FinancialYearId,
           FinancialYearDesc
    FROM dbo.tblFinancialYear  
    where FinancialYearDesc in (select FY from SalesDisDB_SMC_NEWDB..tblArcDBConnect)
END
