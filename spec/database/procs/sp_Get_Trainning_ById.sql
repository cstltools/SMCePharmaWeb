

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_Trainning_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        Select  format(FromDate,'dd MMMM, yyyy') FromDate,format(ToDate,'dd MMMM, yyyy') ToDate, STUFF( (SELECT CONCAT(',', brn.UserRoleID , '') FROM dbo.tblTrainingUserRoleDetail brn  with (nolock)   WHERE brn.TrainningId=mas.TrainningId ORDER BY brn.UserRoleID FOR XML PATH ('') ),1,1,'') AS UserRoleID, * from tblTrainning mas with (nolock) where TrainningId = @id

    END


