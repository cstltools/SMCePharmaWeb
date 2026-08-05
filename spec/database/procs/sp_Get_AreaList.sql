CREATE PROCEDURE [dbo].[sp_Get_AreaList]
	-- Add the parameters for the stored procedure here
	@RegionId int =0
AS
BEGIN
	
	  SELECT
		 DPT.AreaId,	B.RegionName,	 DPT.AreaCode  AreaCode, DPT.AreaName, DPT.IsActive, G.GroupName,
		 CASE  WHEN  Entryemp.EmpName Is Null  THEN  us.UserName 
		ELSE Entryemp.EmpName  
		END as EMPEntryBy,
	        CASE  WHEN updateBy.EmpName  Is Null  THEN  up.UserName 
		ELSE updateBy.EmpName  
		END as  EMPUpdateBy,
		    CASE  WHEN empAcIn.EmpName  Is Null  THEN  AcIN.UserName 
		ELSE empAcIn.EmpName  
		END as  EMPActiveInactiveBy,					
		CONVERT(NVARCHAR(50),DPT.EntryDate,106)AS EntryDatee,
		CONVERT(NVARCHAR(50),DPT.UpdateDate,106)AS UpdateDatee,
		CONVERT(NVARCHAR(50),DPT.AcOrInAcDate,106)AS InactiveDatee,	 
		CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '''' END AS DeleteStatus,  
		  STUFF(( SELECT  ',' + DistrictName
                FROM    dbo.tbl_District
                WHERE  DistrictId IN (
				SELECT DistrictId FROM dbo.tbl_AreaDistrictRelation WHERE AreaId = DPT.AreaId
				)
              FOR
                XML PATH('')
              ), 1, 1, '') AS DistrictName
		FROM tblArea AS DPT 
		LEFT JOIN dbo.tblRegion B ON B.RegionId = DPT.RegionId
		LEFT JOIN dbo.tbl_Group G ON G.GroupId = B.GroupId
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.ActiveInactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId		
		LEFT JOIN (SELECT DISTINCT AreaId, COUNT(AreaId) NoOf FROM dbo.tblTerritory GROUP BY AreaId) AS C ON DPT.AreaId = C.AreaId
		WHERE DPT.RegionId is not null    AND (@RegionId = 0 OR DPT.RegionId = @RegionId);
END