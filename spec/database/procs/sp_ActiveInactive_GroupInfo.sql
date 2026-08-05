



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_GroupInfo]
	-- Add the parameters for the stored procedure here
    @Id  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tbl_Group where GroupId =  @Id

	IF @Flag = 1
        UPDATE  [dbo].[tbl_Group] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  GroupId = @Id    
    ElSE
	    UPDATE  [dbo].[tbl_Group] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  GroupId = @Id   
    END



