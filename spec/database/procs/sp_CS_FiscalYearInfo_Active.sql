CREATE PROCEDURE [dbo].[sp_CS_FiscalYearInfo_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT * FROM dbo.tblFiscalYearInfos WHERE IsActive = 1
END
