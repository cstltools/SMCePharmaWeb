-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Notice_MarketDetail]
	-- Add the parameters for the stored procedure here
	 

@NoticeId INT,
@GroupId  INT,
@RegionId  INT,
@AreaId  INT,
@TerritoryId  INT,
@SubTerritoryId  INT,
@MarketId  INT
AS
    BEGIN
	
    INSERT INTO [dbo].tbl_Notice_MarketDetails
           (NoticeId
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId])
     VALUES
           (@NoticeId
           ,@GroupId 
           ,@RegionId 
           ,@AreaId 
           ,@TerritoryId 
           ,@SubTerritoryId 
           ,@MarketId )

	--DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	--INSERT INTO dbo.tblNotice_Employee
	--(
	--    EmployeeId,
	--    IsAppCheck,
	--    MasterId,
	--    Server_SeenDate,
	--    Apps_SeenDate
	--)
	--SELECT EmpInfoId,'1',@NoticeId,GETDATE(),GETDATE() FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpTerrId=ISNULL(@TerritoryId,EmpTerrId)
	-- AND EmpAreaId=ISNULL(@AreaId,EmpAreaId) AND EmpRegionId=ISNULL(@RegionId,EmpRegionId) AND EmpGroupId=ISNULL(@GroupId,EmpGroupId)
	-- AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)



	 DECLARE @Skip BIT=0
	
		IF(@TerritoryId IS NOT NULL AND @Skip=0)
		BEGIN
		    
--	DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	INSERT INTO dbo.tblNotice_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId
	)
	SELECT EmpInfoId,'0',@NoticeId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpTerrId=ISNULL(@TerritoryId,EmpTerrId) 
	 AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)

			SET @Skip=1
		END
		IF(@AreaId IS NOT NULL AND @Skip=0)
		BEGIN
		    
	--DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	INSERT INTO dbo.tblNotice_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId
	)
	SELECT EmpInfoId,'0',@NoticeId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE   EmpAreaId=ISNULL(@AreaId,EmpAreaId)   
	 AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)

			SET @Skip=1
		END
		IF(@RegionId IS NOT NULL AND @Skip=0)
		BEGIN
		    
	--DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	INSERT INTO dbo.tblNotice_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId
	)
	SELECT EmpInfoId,'0',@NoticeId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE   EmpRegionId=ISNULL(@RegionId,EmpRegionId)  
	 AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)

			SET @Skip=1
		END
		IF(@GroupId IS NOT NULL AND @Skip=0 )
		BEGIN
		   
	--DELETE FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId

	INSERT INTO dbo.tblNotice_Employee
	(
	    EmployeeId,
	    IsAppCheck,
	    MasterId
	)
	SELECT EmpInfoId,'0',@NoticeId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE   EmpGroupId=ISNULL(@GroupId,EmpGroupId)
	 AND EmpInfoId NOT IN (SELECT EmployeeId FROM dbo.tblNotice_Employee WHERE MasterId=@NoticeId)

			SET @Skip=1
		END
		



		
        
		

 

END

