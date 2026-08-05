-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_NationalList]

	@Parameter NVARCHAR(MAX)
	 
AS
BEGIN

	DECLARE @Query NVARCHAR(MAX)

	SET @Query = 'SELECT GRP.NationalId,GRP.NationalName,GRP.IsActive,GRP.NationalCode, 
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
	 ''disabled''  AS DeleteStatus FROM tbl_National AS GRP
	LEFT JOIN tblUser AS ENUS ON ENUS.UserId = GRP.EntryBy
	LEFT JOIN tblUser AS UPUS ON UPUS.UserId = GRP.UpdateBy
	LEFT JOIN tblUser AS APUS ON APUS.UserId = GRP.ApproveBy
	LEFT JOIN tblUser AS ACUS ON ACUS.UserId = GRP.InactiveBy
	LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = ENUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS UPDT ON UPDT.EmpInfoId = UPUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS APRV ON APRV.EmpInfoId = APUS.EmpInfoId
	LEFT JOIN tblEmpGeneralInfo AS ACTV ON ACTV.EmpInfoId = ACUS.EmpInfoId
	 
	WHERE GRP.NationalId IS NOT NULL' + @Parameter

	EXEC(@Query)



END


