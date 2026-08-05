
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_AreaInfo]
	-- Add the parameters for the stored procedure here
   @id INT = 0 ,
    @zoneId INT ,
    @areaName NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @CodeStr NVARCHAR(MAX) ,

    @isActive BIT ,
    @acInAcDate DATETIME
AS
BEGIN


DECLARE @DistrictId NVARCHAR(max)

SET @DistrictId = STUFF(( SELECT  ',' + CAST(DistrictId AS NVARCHAR(max))
			                 FROM    dbo.tbl_AreaDistrictRelation
                WHERE  DistrictId IN (
				SELECT DistrictId FROM dbo.tbl_AreaDistrictRelation WHERE AreaId = @id
				)
              FOR
                XML PATH('')
              ), 1, 1, '')
		


	UPDATE dbo.tblArea 
	SET AreaName = @areaName,
	RegionId = @zoneId, AreaCode=@CodeStr,
	UpdateBy = @createdBy,
	UpdateDate = GETDATE(),
	IsActive = @isActive,
	Remarks = @remarks,
	AcOrInAcDate = @acInAcDate 
	WHERE AreaId = @id		
	
	DELETE FROM dbo.tbl_AreaDistrictRelation WHERE AreaId = @id
	
END


