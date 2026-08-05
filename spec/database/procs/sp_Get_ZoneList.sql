
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_ZoneList]
	-- Add the parameters for the stored procedure here
AS
    BEGIN
    --    SELECT  A.*,
		  --      STUFF(( SELECT  ',' + DivisionName
    --            FROM    dbo.tbl_Division
    --            WHERE  DivisionId IN (
				--SELECT DivisionId FROM dbo.tbl_ZoneDivisionRelation WHERE ZoneId = A.RegionId
				--)
    --          FOR
    --            XML PATH('')
    --          ), 1, 1, '') AS DivisionName 
    --    FROM    dbo.tblRegion A
      


	  SELECT
		 DPT.RegionId,	G.GroupName	,DPT.RegionCode,
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
	    DPT.RegionCode, DPT.RegionName, DPT.AcOrInAcDate,
		DPT.IsActive,CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '''' END AS DeleteStatus,  
		STUFF(( SELECT  ',' + DivisionName
                FROM    dbo.tbl_Division
                WHERE  DivisionId IN (
				SELECT DivisionId FROM dbo.tbl_ZoneDivisionRelation WHERE ZoneId = DPT.RegionId
				)
              FOR
                XML PATH('')
              ), 1, 1, '') AS DivisionName 
		 
		FROM tblRegion AS DPT  WITH (NOLOCK)
		 LEFT JOIN tbl_Group G On G.GroupId = DPT.GroupId
		LEFT JOIN tblUser us ON us.UserId = DPT.EntryBy
		LEFT JOIN tblUser up ON up.UserId = DPT.UpdateBy
		LEFT JOIN tblUser AcIN ON AcIN.UserId = DPT.ActiveOrInactiveBy
		LEFT JOIN tblEmpGeneralInfo Entryemp  ON Entryemp.EmpInfoId = us.EmpInfoId	
		LEFT JOIN tblEmpGeneralInfo updateBy  ON updateBy.EmpInfoId = up.EmpInfoId
		LEFT JOIN tblEmpGeneralInfo empAcIn  ON  empAcIn.EmpInfoId = AcIN.EmpInfoId		
		LEFT JOIN (SELECT DISTINCT RegionId, COUNT(RegionId) NoOf FROM tblArea WHERE IsActive = 1 GROUP BY RegionId) AS C ON DPT.RegionId = C.RegionId
		WHERE DPT.RegionId is not null
	
    END 


