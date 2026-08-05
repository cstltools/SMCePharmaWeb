
CREATE PROCEDURE [dbo].[DynamicPivotDoctorWiseDoctorVisitPlan]
  @param  NVARCHAR(max) 
AS
BEGIN
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'
select COUNT(DoctorCount) DoctorCount ,DoctorName,DoctorCode,Degree,Speciality,ProgramTypeName,DoctorTypeName from (
select     (tpDtl.DoctorId) DoctorCount,   doc.DoctorName  ,doc.DoctorCode ,STUFF( (SELECT CONCAT('','', mm.DegreeName , '''') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=tpDtl.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('''') ),1,1,'''') AS [Degree],ISNULL(STUFF( (SELECT CONCAT('','', mm.SpecialityName , '''') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=tpDtl.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('''') ),1,1,''''),'''') as [Speciality], pt.ProgramTypeName ,dt.DoctorTypeName    from  tblDoctorMaster doc WITH (NOLOCK) 
 inner join tbl_DoctorTourPlanDetail tpDtl  WITH (NOLOCK)    on tpDtl.DoctorId=doc.DoctorId
 inner join tbl_DoctorTourPlanMaster tpMas  WITH (NOLOCK)    on tpMas.DocTPMaster=tpDtl.DocTPMaster
 left join tblProgramType pt  WITH (NOLOCK)    on doc.ProgramTypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId

  where  tpMas.DocTPMaster is not null '+@param+' ) tbl



  group by DoctorName,DoctorCode,Degree,Speciality,ProgramTypeName,DoctorTypeName

 
 '

  EXEC(@SqlStatement)
 
END
 