
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_Trainning]
	-- Add the parameters for the stored procedure here
    @TrainningId INT = 0    
AS
    BEGIN

	Delete From tblTrainning where TrainningId = @TrainningId
            
    END

