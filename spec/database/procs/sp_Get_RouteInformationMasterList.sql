
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_RouteInformationMasterList]
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   
 DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT  cunit.ComUnitCode+'' : ''+cunit.ComUnitName  ComUnitName,  
        CASE  WHEN  ENTR.EmpName Is Null  THEN  ENUS.UserName 
		ELSE ENTR.EmpName  
		END as EntryBy,
	    CASE  WHEN UPDT.EmpName  Is Null  THEN  UPUS.UserName 
		ELSE UPDT.EmpName  
		END as  UpdateBy, 
		CONVERT(NVARCHAR(50),A.EntryDate,106)AS EntryDate , 
		CONVERT(NVARCHAR(50),A.UpdateDate,106)AS UpdateDate,
		A.*,
		DA.DANames
from dbo.tblRouteInformationMaster A WITH (NOLOCK)
LEFT JOIN tblUser AS ENUS ON ENUS.UserId = A.EntryBy
LEFT JOIN tblUser AS UPUS ON UPUS.UserId = A.UpdateBy
left join tblCompanyUnit cunit on A.DCId=cunit.ComUnitId
LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = ENUS.EmpInfoId
LEFT JOIN tblEmpGeneralInfo AS UPDT ON UPDT.EmpInfoId = UPUS.EmpInfoId
OUTER APPLY (
    SELECT STUFF((
        SELECT '', '' + da.DACode+ '' : ''+da.Name
        FROM tblRouteInformationDADetail dad
        INNER JOIN tblDAInfo da ON dad.DAId = da.DAId
        WHERE dad.RouteInformationMasterId = A.RouteInformationMasterId
        FOR XML PATH(''''), TYPE
    ).value(''.'', ''NVARCHAR(MAX)''), 1, 2, '''') AS DANames
) DA
where A.RouteInformationMasterId is not null  
and A.RouteInformationMasterId in (select RouteInformationMasterId from tblRouteInformationMarketDetail where isnull(MarketId,0) >0 )
 ' + @Parameter

   EXEC(@Query)


END

