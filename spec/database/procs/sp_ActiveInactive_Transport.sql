

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_Transport]
	-- Add the parameters for the stored procedure here
    @LeaveTypeId INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from Employe_LeaveTypeInfos where LeaveTypeId =  @LeaveTypeId

	IF @Flag = 1
        UPDATE  [dbo].[Employe_LeaveTypeInfos] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  LeaveTypeId = @LeaveTypeId    
    ElSE
	    UPDATE  [dbo].[Employe_LeaveTypeInfos] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  LeaveTypeId = @LeaveTypeId   
    END

