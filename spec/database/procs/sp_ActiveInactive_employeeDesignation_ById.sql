
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_employeeDesignation_ById]
	-- Add the parameters for the stored procedure here
    @DesignationId  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblDesignation where DesignationId = @DesignationId

	IF @Flag = 1
        UPDATE  [dbo].[tblDesignation] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  DesignationId = @DesignationId    
    ElSE
	    UPDATE  [dbo].[tblDesignation] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  DesignationId = @DesignationId   
    END


