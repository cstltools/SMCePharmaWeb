
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[sp_Get_AllActive_Zone_BI_Report]
	-- Add the parameters for the stored procedure here
AS
BEGIN
    SELECT RegionCode,RegionName+': '+RegionCode AS RegionName  FROM tblRegion Where IsActive=1
END


