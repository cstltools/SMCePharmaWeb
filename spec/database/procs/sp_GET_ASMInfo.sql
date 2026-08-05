-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_ASMInfo]
	
	-- Add the parameters for the stored procedure here
	@Parameter NVARCHAR(MAX)

AS
BEGIN
   

   DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'SELECT ASM.ASMId, RGN.RegionId,RGN.RegionCode + '':''+ RGN.RegionName AS Region,
   ARA.AreaCode + '':'' + ARA.AreaName AS Area,
   EGI.EmpMasterCode + '':'' + EGI.EmpName AS EmployeeName,
   ASM.IsActive,CONVERT(NVARCHAR(50),ASM.ActiveInActiveDate,106)AS ActiveInActiveDate,
   CASE WHEN ISNULL(C.NoOf,0) > 0 THEN ''disabled'' ELSE '''' END AS DeleteStatus
   FROM tblASMInfo AS ASM
   LEFT JOIN tblArea AS ARA ON ARA.AreaId = ASM.AreaId
   LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId
   LEFT JOIN tblEmpGeneralInfo AS EGI ON ASM.EmployeeId = EGI.EmpInfoId 
   LEFT JOIN (SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder GROUP BY ASMId) AS C ON ASM.ASMId = C.ASMId
   WHERE ASM.ASMId IS NOT NULL  ' + @Parameter


   --SELECT ASM.ASMId, RGN.RegionId,RGN.RegionCode + ':'+ RGN.RegionName AS Region,
   --ARA.AreaCode + ':' + ARA.AreaName AS Area,
   --EGI.EmpMasterCode + ':'+ EGI.EmpName AS EmployeeName,
   --ASM.IsActive,CONVERT(NVARCHAR(50),ASM.ActiveDate,106)AS ActiveInActiveDate,
   --CASE WHEN ISNULL(C.NoOf,0) > 0 THEN 'disabled' ELSE '' END AS DeleteStatus
   --FROM tblASMInfo AS ASM
   --LEFT JOIN tblArea AS ARA ON ARA.AreaId = ASM.AreaId
   --LEFT JOIN tblRegion AS RGN ON RGN.RegionId = ARA.RegionId
   --LEFT JOIN tblEmpGeneralInfo AS EGI ON ASM.EmployeeId = EGI.EmpInfoId 
   --LEFT JOIN (SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder GROUP BY ASMId) AS C ON ASM.ASMId = C.ASMId
   --WHERE ASM.ASMId IS NOT NULL  


   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
