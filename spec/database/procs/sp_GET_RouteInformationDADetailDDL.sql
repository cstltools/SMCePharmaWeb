

 CREATE PROCEDURE [dbo].[sp_GET_RouteInformationDADetailDDL]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	SELECT Distinct dtl.DAId AS DANameId, DACode + ' : ' + da.Name AS DAName
FROM tblRouteInformationDADetail dtl WITH (NOLOCK)
LEFT JOIN tblDAInfo da WITH (NOLOCK) ON da.DAId = dtl.DAId
  WHERE dtl.RouteInformationMasterId = @id

UNION ALL

SELECT DAId  DANameId,  Name AS DAName from tblDAInfo da where DAId=112
UNION ALL
SELECT DAId  DANameId,  Name AS DAName from tblDAInfo da where DAId=323

      
    END


