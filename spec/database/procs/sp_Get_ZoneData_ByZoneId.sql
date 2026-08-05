-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ZoneData_ByZoneId]  -- [sp_Get_ZoneData_ByZoneId] 5
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	

	SELECT *,
	STUFF(( SELECT  ',' + CAST(DivisionId AS NVARCHAR(50))
                FROM    dbo.tbl_ZoneDivisionRelation
				WHERE ZoneId = @id
              FOR
                XML PATH('')
              ), 1, 1, '') AS DivisionId 
	 FROM dbo.tblRegion WHERE RegionId = @id



END

