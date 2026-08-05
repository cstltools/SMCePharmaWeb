

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TADAMarketRulesConfig]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

 SELECT ur.DisplayName RoleName, tp.StationTypeName as TourType ,* from tbl_TADAMarketRulesConfig A
 Left join dbo.tblStationType tp On tp.StationTypeId = A.TourType
 Left join dbo.tblRoleType ur On ur.RoleTypeId = A.UserRoleID 


END


