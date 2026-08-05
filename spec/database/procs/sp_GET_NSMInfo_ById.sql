

 CREATE PROCEDURE [dbo].[sp_GET_NSMInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select FORMAT(ActiveDate,'dd-MMM-yyyy') ActiveDateStr, * from tblNSMInfo where NSMId = @id
      
    END


