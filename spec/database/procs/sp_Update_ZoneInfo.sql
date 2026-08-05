
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_ZoneInfo]
	-- Add the parameters for the stored procedure here
	@zoneId INT,
    @zoneName NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) =null,
    @CodeStr NVARCHAR(MAX) ,

    @remarks NVARCHAR(MAX)=null ,
	@isActive BIT,
	@acInAcDate DATETIME,
	@GroupId INT
AS
BEGIN


DECLARE @divsioId NVARCHAR(max)

SET @divsioId = STUFF(( SELECT  ',' + CAST(DivisionId AS NVARCHAR(max))
			                 FROM    dbo.tbl_Division
                WHERE  DivisionId IN (
				SELECT DivisionId FROM dbo.tbl_ZoneDivisionRelation WHERE ZoneId = @zoneId
				)
              FOR
                XML PATH('')
              ), 1, 1, '')
		


	INSERT INTO dbo.tblRegion_Log
	        ( [RegionId]
      ,[RegionCode]
      ,[RegionName]
      ,[CompanyId]
      ,[Region]
      ,[IsActive]
      ,[GroupId]
      ,[EntryBy]
      ,[UpdateBy]
      ,[EntryDate]
      ,[UpdateDate]
      ,[AcOrInAcDate]
      ,[Remarks]
      ,[ActiveOrInactiveBy]
      ,[DelDate]
      ,[DelBy]
	        )
SELECT [RegionId]
      ,[RegionCode]
      ,[RegionName]
      ,[CompanyId]
      ,[Region]
      ,[IsActive]
      ,[GroupId]
      ,[EntryBy]
      ,[UpdateBy]
      ,[EntryDate]
      ,[UpdateDate]
      ,[AcOrInAcDate]
      ,[Remarks]
      ,[ActiveOrInactiveBy]
	  ,GETDATE()
      ,@createdBy
      
	   
	   FROM dbo.tblRegion WHERE RegionId = @zoneId
	

	UPDATE dbo.tblRegion 
	SET RegionName = @zoneName,
	UpdateBy = @createdBy,RegionCode=@CodeStr,
	UpdateDate = GETDATE(),
	IsActive = @isActive,
	Remarks = @remarks,
	AcOrInAcDate = @acInAcDate,
    GroupId = @GroupId
	WHERE RegionId = @zoneId		
	
	DELETE FROM dbo.tbl_ZoneDivisionRelation WHERE ZoneId = @zoneId
	
END


