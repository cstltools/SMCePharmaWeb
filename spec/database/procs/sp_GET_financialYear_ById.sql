

 CREATE PROCEDURE [dbo].[sp_GET_financialYear_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 SELECT FORMAT(YearFromDate , 'dd MMMM, yyyy') YearFromDate,FORMAT(YearTodate , 'dd MMMM, yyyy') YearTodate, * from tblFiscalYearInfos where FiscalYearId = @id
      
    END


