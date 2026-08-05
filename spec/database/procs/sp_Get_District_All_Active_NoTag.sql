
CREATE PROCEDURE [dbo].[sp_Get_District_All_Active_NoTag]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	
SELECT  A.DistrictId , 0 AS IsDisable , A.DistrictName
FROM    dbo.tbl_District A
        --LEFT JOIN dbo.tbl_AreaDistrictRelation B ON B.DistrictId = A.DistrictId
        --LEFT JOIN dbo.tblArea C ON C.AreaId = B.AreaId
WHERE   A.IsActive = 1 order by  A.DistrictName asc 

END
