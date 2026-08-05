-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_GroupList]

	@Parameter NVARCHAR(MAX)

AS
BEGIN

	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT GRP.GroupId,GRP.GroupName,GRP.IsActive,GRP.GroupCode, 
	    CASE  WHEN  ENTR.EmpName Is Null  THEN  ENUS.UserName 
		ELSE ENTR.EmpName  
		END as EntryBy,
		CONVERT(NVARCHAR(20),GRP.EntryDate,106) EntryDate,
	    CASE  WHEN UPDT.EmpName  Is Null  THEN  UPUS.UserName 
		ELSE UPDT.EmpName  
		END as  UpdateBy,
		CONVERT(NVARCHAR(20),GRP.UpdateDate,106) UpdateDate,
		CASE  WHEN APRV.EmpName  Is Null  THEN  APUS.UserName 
		ELSE APRV.EmpName  
		END as  ApproveBy,
		CONVERT(NVARCHAR(20),GRP.ApproveDate,106) ApproveDate,
		CASE  WHEN ACTV.EmpName  Is Null  THEN  ACUS.UserName 
		ELSE ACTV.EmpName  
		END as  ActiveBy,	 
	    CONVERT(NVARCHAR(20),GRP.InactiveDate,106) InactiveDate,
	CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus FROM tbl_Group AS GRP
	LEFT JOIN tblUser AS ENUS ON ENUS.UserId = GRP.EntryBy
	LEFT JOIN tblUser AS UPUS ON UPUS.UserId = GRP.UpdateBy
	LEFT JOIN tblUser AS APUS ON APUS.UserId = GRP.ApproveBy
	LEFT JOIN tblUser AS ACUS ON ACUS.UserId = GRP.InactiveBy
	LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = ENUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS UPDT ON UPDT.EmpInfoId = UPUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS APRV ON APRV.EmpInfoId = APUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS ACTV ON ACTV.EmpInfoId = ACUS.EmpInfoId
	LEFT JOIN (SELECT DISTINCT GroupId, COUNT(GroupId) NoOf FROM tblRegion where IsActive = 1 GROUP BY GroupId) AS C ON GRP.GroupId = C.GroupId
	WHERE GRP.GroupId IS NOT NULL' + @Parameter

	EXEC(@Query)



END


