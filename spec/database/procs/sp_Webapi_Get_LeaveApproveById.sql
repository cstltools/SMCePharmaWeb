-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_LeaveApproveById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN
	
        DECLARE @appSttaus NVARCHAR(50)

        SELECT  @appSttaus = ActionText
        FROM    dbo.tblAction
        WHERE   ActionId = 3


        SELECT  *
        FROM    dbo.Employee_LeaveApplications
        WHERE   LeaveApplicationId = @id
                AND ApprovalStatus = @appSttaus


    END

