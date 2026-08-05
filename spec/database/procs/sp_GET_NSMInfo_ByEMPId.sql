

 CREATE PROCEDURE [dbo].[sp_GET_NSMInfo_ByEMPId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select NSMId, FORMAT(ActiveDate,'dd MMMM, yyyy') ActiveDateStr, * from tblNSMInfo where EmployeeId = @id and IsActive=1
      
    END


