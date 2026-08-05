

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_Employee_LeaveInfo]
	-- Add the parameters for the stored procedure here
    @LeaveTypeId INT = 0    
AS
    BEGIN

	Delete From Employe_LeaveTypeInfos where LeaveTypeId = @LeaveTypeId
            
    END


