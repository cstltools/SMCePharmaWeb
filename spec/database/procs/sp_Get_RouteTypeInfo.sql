-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_RouteTypeInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT RouteTypeId  Value, RouteTypeName TextField  	  
		  FROM  tblRouteTypeInfo  	 WITH (NOLOCK) WHERE IsActive=1
END
