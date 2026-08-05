-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TrainingMarketDetail]
	-- Add the parameters for the stored procedure here
	 

@TrainningId  INT,
@GroupId  INT,
@RegionId  INT,
@AreaId  INT,
@TerritoryId  INT,
@SubTerritoryId  INT,
@MarketId  INT
AS
    BEGIN
	
    INSERT INTO [dbo].[tbl_TrainingMarketDetail]
           (TrainningId
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId])
     VALUES
           (@TrainningId
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId )


	DELETE FROM dbo.tblTraining_Employee WHERE MasterId=@TrainningId

	INSERT INTO dbo.tblTraining_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId,
	    Server_SeenDate,
	    Apps_SeenDate
	)
	SELECT EmpInfoId,'1',@TrainningId,GETDATE(),GETDATE() FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpTerrId=ISNULL(@TerritoryId,EmpTerrId)
	 AND EmpAreaId=ISNULL(@AreaId,EmpAreaId) AND EmpRegionId=ISNULL(@RegionId,EmpRegionId) AND EmpGroupId=ISNULL(@GroupId,EmpGroupId)
	 AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblTraining_Employee WHERE MasterId=@TrainningId)

 

END

