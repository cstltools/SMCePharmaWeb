
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_FinanCialyearforDDL]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
		 

SELECT FiscalYearId ,YEAR(YearFromDate) AS FiscalYearDesc FROM tblFiscalYearInfos  ;

END


