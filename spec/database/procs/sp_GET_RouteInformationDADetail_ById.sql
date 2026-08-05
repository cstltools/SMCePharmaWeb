

 CREATE PROCEDURE [dbo].[sp_GET_RouteInformationDADetail_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select  dtl.DAId DANameId,DACode+' : '+ da.Name DAName    from tblRouteInformationDADetail dtl with (nolock)
	 left join tblDAInfo da  with (nolock) on da.DAId=dtl.DAId
	  where dtl.RouteInformationMasterId = @id
      
    END


