
CREATE PROCEDURE [dbo].[sp_RPT_DoctorInfoReport]
	-- Add the parameters for the stored procedure here
  
	@frmDate nvarchar(max),
	@toDate  nvarchar(max) ,
	@Parameter  nvarchar(max)

AS
    BEGIN

	--DECLARE @Query NVARCHAR(MAX)
		--SET @Query = '

SELECT RG.RegionCode+' : '+ RG.RegionName  RegionName,AR.AreaCode+' : '+AR.AreaName AreaName,  TE.TerritoryCode+ ' : '+Te.TerritoryName TerritoryName, EMP.EmpMasterCode+' : '+ EMP.EmpName  MIO, ISNULL(tblAssaignBSP.AssignBSP,0) AssignBSP, ISNULL(tblAssaignGSP.AssignGSP,0) AssignGSP, ISNULL(tblAssaignPSP.AssignPSP,0) AssignPSP, 
ISNULL(tblAssaignGeneralSP.AssignGeneralSP,0) AssignGeneralSP,  
(ISNULL(tblAssaignBSP.AssignBSP,0)+ ISNULL(tblAssaignGSP.AssignGSP,0)+ISNULL(tblAssaignPSP.AssignPSP,0)+ ISNULL(tblAssaignGeneralSP.AssignGeneralSP,0)) AssignTotal, 
ISNULL(VisiBSP.VisiBSP,0) VisiBSP,  ISNULL(VisiGSP.VisiGSP,0) VisiGSP , ISNULL(VisiPSP.VisiPSP,0)VisiPSP, ISNULL(VisiGeneralSP.VisiGeneralSP,0)VisiGeneralSP, 

(ISNULL(VisiBSP.VisiBSP,0)+ISNULL(VisiGSP.VisiGSP,0)+ISNULL(VisiPSP.VisiPSP,0)+ISNULL(VisiGeneralSP.VisiGeneralSP,0)) Visitotal, 
0 as repBSP, 0 as repGSP, 0 as repPSP, 0 as repGeneralSP,  0 as reptotal,
ISNULL(prescBSP.prescBSP,0) prescBSP,  ISNULL(prescGSP.prescGSP,0) prescGSP, ISNULL(prescPSP.prescPSP,0) prescPSP, ISNULL(prescGeneralSP.prescGeneralSP,0) prescGeneralSP,
(ISNULL(prescBSP.prescBSP,0) +  ISNULL(prescGSP.prescGSP,0) + ISNULL(prescPSP.prescPSP,0) + ISNULL(prescGeneralSP.prescGeneralSP,0))
presctotal

FROM tblMIOInfo MIO  WITH (NOLOCK)
LEFT JOIN tblEmpGeneralInfo EMP  WITH (NOLOCK) ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN tblTerritory TE  WITH (NOLOCK) ON MIO.TerritoryId = TE.TerritoryId
LEFT JOIN tblArea AR  WITH (NOLOCK) ON Te.AreaId  = AR.AreaId
LEFT JOIN tblRegion  RG  WITH (NOLOCK) ON  AR.RegionId = RG.RegionId

LEFT JOIN (Select  tr.TerritoryId, count(tr.TerritoryId) AssignBSP  from tblDoctorMaster DOC  WITH (NOLOCK)
inner join tblMarket MK  WITH (NOLOCK) ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST  WITH (NOLOCK) ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr  WITH (NOLOCK) ON tr.TerritoryId  = ST.TerritoryId
Where DOC.IsActive=1 and DOC.ApprovalStatus = '2' and DOC.ProgramTypeId=1
GROUP BY tr.TerritoryId )tblAssaignBSP ON MIO.TerritoryId = tblAssaignBSP.TerritoryId

LEFT JOIN (Select  tr.TerritoryId, count(tr.TerritoryId) AssignGSP  from tblDoctorMaster DOC  WITH (NOLOCK)
inner join tblMarket MK  WITH (NOLOCK) ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST  WITH (NOLOCK) ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr  WITH (NOLOCK) ON tr.TerritoryId  = ST.TerritoryId
Where DOC.IsActive=1 and DOC.ApprovalStatus = '2' and DOC.ProgramTypeId=2
GROUP BY tr.TerritoryId )tblAssaignGSP ON MIO.TerritoryId = tblAssaignGSP.TerritoryId

LEFT JOIN (Select  tr.TerritoryId, count(tr.TerritoryId) AssignPSP  from tblDoctorMaster DOC  WITH (NOLOCK)
inner join tblMarket MK  WITH (NOLOCK) ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST  WITH (NOLOCK) ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr  WITH (NOLOCK) ON tr.TerritoryId  = ST.TerritoryId
Where DOC.IsActive=1 and DOC.ApprovalStatus = '2' and DOC.ProgramTypeId=3
GROUP BY tr.TerritoryId )tblAssaignPSP ON MIO.TerritoryId = tblAssaignPSP.TerritoryId

LEFT JOIN (Select  tr.TerritoryId, count(tr.TerritoryId) AssignGeneralSP  from tblDoctorMaster DOC  WITH (NOLOCK)
inner join tblMarket MK  WITH (NOLOCK) ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST  WITH (NOLOCK) ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr  WITH (NOLOCK) ON tr.TerritoryId  = ST.TerritoryId
Where DOC.IsActive=1 and DOC.ApprovalStatus = '2' and DOC.ProgramTypeId=4
GROUP BY tr.TerritoryId )tblAssaignGeneralSP  ON MIO.TerritoryId = tblAssaignGeneralSP.TerritoryId


LEFT JOIN (
SELECT DCR.TerritoryId, SUM(ISNULL(DCR.DoctorProgramypeId,0)) VisiBSP FROM tbl_DCRInfo DCR   WITH (NOLOCK)
 
Where DCR.ApprovalStatus = '2' AND DCR.DoctorProgramypeId = 1 and CONVERT(Date,DCR.DcrDate) between  @frmDate and @toDate GROUP BY  DCR.TerritoryId)  VisiBSP ON MIO.TerritoryId = VisiBSP.TerritoryId

LEFT JOIN (
SELECT  DCR.TerritoryId, SUM(ISNULL(DCR.DoctorProgramypeId,0)) VisiGSP FROM tbl_DCRInfo DCR   WITH (NOLOCK)
Where DCR.ApprovalStatus = '2' AND DCR.DoctorProgramypeId = 2  and CONVERT(Date,DCR.DcrDate) between  @frmDate and @toDate GROUP BY  DCR.TerritoryId)  VisiGSP ON MIO.TerritoryId = VisiGSP.TerritoryId

LEFT JOIN (
SELECT DCR.TerritoryId, SUM(ISNULL(DCR.DoctorProgramypeId,0)) VisiPSP FROM tbl_DCRInfo DCR   WITH (NOLOCK) 
 
Where DCR.ApprovalStatus = '2' AND DCR.DoctorProgramypeId = 3 and CONVERT(Date,DCR.DcrDate) between  @frmDate and @toDate GROUP BY  DCR.TerritoryId)  VisiPSP ON MIO.TerritoryId = VisiPSP.TerritoryId

LEFT JOIN (
SELECT DCR.TerritoryId, SUM(ISNULL(DCR.DoctorProgramypeId,0)) VisiGeneralSP FROM tbl_DCRInfo DCR   WITH (NOLOCK)
Where  DCR.ApprovalStatus = '2' AND DCR.DoctorProgramypeId = 4 and CONVERT(Date,DCR.DcrDate) between  @frmDate and @toDate GROUP BY DCR.TerritoryId)  VisiGeneralSP ON MIO.TerritoryId = VisiGeneralSP.TerritoryId

LEFT JOIN (
SELECT PM.TerritoryId, SUM(ISNULL(PM.DoctorProgramypeId,0)) prescBSP FROM tbl_PrescriptionMaster PM   WITH (NOLOCK)
 
Where PM.ApprovalStatus = '2' AND PM.DoctorProgramypeId = 1 and CONVERT(Date,PM.PrescriptionDate) between  @frmDate and @toDate  GROUP BY  PM.TerritoryId) prescBSP ON  MIO.TerritoryId  = prescBSP.TerritoryId

LEFT JOIN (
SELECT PM.TerritoryId, SUM(ISNULL(PM.DoctorProgramypeId,0)) prescGSP FROM tbl_PrescriptionMaster PM   WITH (NOLOCK)
 
Where PM.ApprovalStatus = '2' AND PM.DoctorProgramypeId = 2  and CONVERT(Date,PM.PrescriptionDate) between  @frmDate and @toDate   GROUP BY  PM.TerritoryId) prescGSP ON  MIO.TerritoryId  = prescGSP.TerritoryId


LEFT JOIN (
SELECT PM.TerritoryId, SUM(ISNULL(PM.DoctorProgramypeId,0)) prescPSP FROM tbl_PrescriptionMaster PM   WITH (NOLOCK)
 
 
Where PM.ApprovalStatus = '2' AND PM.DoctorProgramypeId = 3 and CONVERT(Date,PM.PrescriptionDate) between  @frmDate and @toDate  GROUP BY  PM.TerritoryId) prescPSP ON  MIO.TerritoryId  = prescPSP.TerritoryId

LEFT JOIN (
SELECT PM.TerritoryId, SUM(ISNULL(PM.DoctorProgramypeId,0)) prescGeneralSP FROM tbl_PrescriptionMaster PM   WITH (NOLOCK) 
Where PM.ApprovalStatus = '2' AND PM.DoctorProgramypeId = 4 and CONVERT(Date,PM.PrescriptionDate) between  @frmDate and @toDate  GROUP BY  PM.TerritoryId) prescGeneralSP ON  MIO.TerritoryId  = prescGeneralSP.TerritoryId

WHERE MIO.MIOId IS NOT NULL and (ISNULL(VisiBSP.VisiBSP,0)+ISNULL(VisiGSP.VisiGSP,0)+ISNULL(VisiPSP.VisiPSP,0)+ISNULL(VisiGeneralSP.VisiGeneralSP,0)+ (ISNULL(prescBSP.prescBSP,0) +  ISNULL(prescGSP.prescGSP,0) + ISNULL(prescPSP.prescPSP,0) + ISNULL(prescGeneralSP.prescGeneralSP,0)) )>0   ORDER BY TerritoryCode asc


    END

