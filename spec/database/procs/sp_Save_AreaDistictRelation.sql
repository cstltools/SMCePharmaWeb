CREATE PROCEDURE [dbo].[sp_Save_AreaDistictRelation]
	-- Add the parameters for the stored procedure here
@areaId INT,
@districtId int
AS
BEGIN
	
	INSERT INTO dbo.tbl_AreaDistrictRelation
	        ( AreaId, DistrictId )
	VALUES  ( @areaId,
	@districtId
	          )
END
