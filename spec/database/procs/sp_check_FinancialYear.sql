

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_FinancialYear]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @FiscalYearDesc    NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblFiscalYearInfos WHERE FiscalYearDesc=@FiscalYearDesc  AND  FiscalYearId NOT IN ( @id)

END



