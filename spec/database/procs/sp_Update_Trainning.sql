


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Trainning]
	-- Add the parameters for the stored procedure here
    @TrainningId INT,
    @Title Nvarchar(MAX) =NULL,
	@Description Nvarchar(MAX) =null,
	@TrainningMeterial Nvarchar(MAX) =null,
	@FromDate Datetime =null,
	@ToDate Datetime =null,
	@UpdateBy int = null,
	@IsActive bit = null

AS
    BEGIN
        UPDATE  [dbo].[tblTrainning]
        SET     Title = @Title,
		        Description = @Description,
				TrainningMeterial = @TrainningMeterial,
				FromDate = @FromDate,
				ToDate = @ToDate,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE()
                      
        WHERE   TrainningId = @TrainningId   

		delete from tbl_TrainingMarketDetail where TrainningId=@TrainningId
		delete from tblTrainingUserRoleDetail where TrainningId=@TrainningId


    END



