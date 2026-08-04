using Library.DAL.InternalCls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.UserProfileDAL
{
 public   class ChangePasswordDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public DataTable GetEmployeeInfoDAL(string Id)
        {

           
              string queryStr = @" SELECT nat.Description Nationality,  SpouseOccup.Description SpouseOccupation,SpusMax.Description SpouseMaxEducation, PreThana.Title PresentThana, PerThana.Title PermanentThana,PerDis.Titel PermanentDistrict, PreDis.Titel PresentDistrict,  PresDiv.Title PresentDivision, PerDiv.Title ParmanentDivision, tblOccupation.Description FatherOccupation, motherOcc.Description MotherOccupation,com.ShortName, Div.DivisionName,DivW.DivisionWingName, Sec.SectionName, dept.DepartmentName,
SuSec.SubSectionName, Cat.EmpCategoryName, Sgrd.GradeName, SStep.SalaryStepName, Desg.Designation,
DType.DesigTypeName, SLoc.SalaryLocation, JLOC.Location, EType.EmpType, Pro.ProjectName, eGen.EmpName ReportingEmp, CASE
    WHEN Emp.ConformationStatus=1 THEN 'Yes'
    WHEN Emp.ConformationStatus=0 THEN 'No'
    
    ELSE 'Not available' END AS ConformationStatus , CASE
    WHEN Emp.IsProbationary=1 THEN 'Yes'
    WHEN Emp.IsProbationary=0 THEN 'No'
    
    ELSE 'Not available' END AS    IsProbationary,
 *    from tblEmpGeneralInfo Emp
left JOIN dbo.tblCompanyInfo com ON com.CompanyId = Emp.CompanyId
left JOIN dbo.tblDivision Div ON Div.DivisionId = Emp.DivisionId
left JOIN dbo.tblDivisionWing DivW ON DivW.DivisionWId = Emp.DivisionWId
LEFT JOIN dbo.tblDepartment dept ON dept.DepartmentId = Emp.DepartmentId
LEFT JOIN dbo.tblSection Sec ON Sec.SectionId = Emp.SectionId
LEFT JOIN dbo.tblSubSection SuSec ON SuSec.SubSectionId = Emp.SubSectionId
LEFT JOIN dbo.tblEmpCategory Cat ON Cat.EmpCategoryId = Emp.EmpCategoryId
LEFT JOIN dbo.tblSalaryGrade Sgrd ON Sgrd.SalaryGradeId = Emp.SalaryGradeId
LEFT JOIN dbo.tblSalaryStep SStep ON SStep.SalaryStepId = Emp.SalaryStepId
LEFT JOIN dbo.tblDesignation Desg ON Desg.DesignationId = Emp.DesignationId
LEFT JOIN dbo.tblDesignationType DType ON DType.DesignationTypeId = Emp.DesignationTypeId
LEFT JOIN dbo.tblSalaryLocation SLoc ON SLoc.SalaryLoationId = Emp.SalaryLoationId
LEFT JOIN dbo.tblJobLocation JLOC ON JLOC.JobLocationID = Emp.JobLocationId
LEFT JOIN dbo.tblEmployeeType EType ON EType.EmpTypeId = Emp.EmpTypeId
LEFT JOIN dbo.tblProjectSetup Pro ON Pro.ProjectId = Emp.ProjectID
LEFT JOIN dbo.tblEmpGeneralInfo eGen ON eGen.EmpInfoId=Emp.ReportingEmpId
LEFT JOIN tblOccupation ON Emp.FatherOccupation=tblOccupation.OccupationID
LEFT JOIN tblOccupation motherOcc ON Emp.MotherOccupation=motherOcc.OccupationID
LEFT JOIN tblAddressDivision PresDiv ON Emp.PresentDivision= PresDiv.AddressDivisionID
LEFT JOIN tblAddressDivision PerDiv ON Emp.ParmanentDivision= PerDiv.AddressDivisionID
LEFT JOIN tblDistrict PreDis ON  Emp.PresentDistrict= PreDis.DistrictID
LEFT JOIN tblDistrict PerDis ON  Emp.PermanentDistrict= PerDis.DistrictID
LEFT JOIN tblThana PreThana ON Emp.PresentThana= PreThana.ThanaID
LEFT JOIN tblThana PerThana ON Emp.PermanentThana= PerThana.ThanaID
LEFT JOIN tblEducationName SpusMax ON Emp.SpouseMaxEducation= SpusMax.EducationNameID
LEFT JOIN tblOccupation SpouseOccup ON  Emp.SpouseOccupation= SpouseOccup.OccupationID
LEFT JOIN dbo.tblNationality nat ON  Emp.Nationality= nat.Nationality
WHERE Emp.EmpInfoId="+Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }

        public bool UpdatePass(int UserId, string Pass)
        {

            try
            {
                int pk = 0;

                if (UserId > 0)
                {
                    List<SqlParameter> aParameters = new List<SqlParameter>();
                    aParameters.Add(new SqlParameter("@UserId", UserId));
                    aParameters.Add(new SqlParameter("@Password", Pass.Trim()));


                    string query =
                        @"update tblUser set Password=@Password,IsPasswordChange=1, UpdateBy=@UserId,UpdateDate= GETDATE() where UserId=@UserId";

                    bool result = aCommonInternalDal.UpdateDataByUpdateCommandNew(query, aParameters);
                    return result;

                }

            }
            catch (Exception exception)
            {

                throw exception;
            }
            return true;
        }

        public DataTable GetUserPassInfoDAL(string Id)
        {

  
              string queryStr = @"select u.LoginName,'' Password,emp.EmpName, uRR.RoleName, uType.UserType,dgs.DesigName from tblUser  u with (nolock)
left join tblEmpGeneralInfo emp on u.EmpInfoId=emp.EmpInfoId

  left join tbl_UserRoleInfo uRR  with (nolock) on uRR.UserRoleID=u.UserRoleID
  left join tblUserType uType  with (nolock) on uType.UserTypeId=u.UserTypeId
  left join tblDesignation dgs  with (nolock) on emp.DesignationId=dgs.DesignationId where u.UserId=" + Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }

        public DataTable GetUserCurrentPasswordDAL(string Id)
        {
            string queryStr = @"select u.Password from tblUser u with (nolock) where u.UserId=" + Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr, "SSIDB");
        }


        public DataTable GetEmpChildrenInfoDAL(string Id)
        {

          
              string queryStr = @"SELECT  tblOccupation.Description AS ChildrenOccupationName, CONVERT(VARCHAR(10), tblEmpChildren.ChildrenDOB, 105) AS ChildrenDOB,* from tblEmpChildren 

LEFT JOIN dbo.tblOccupation ON dbo.tblEmpChildren.ChildrenOccupation=dbo.tblOccupation.OccupationID where EmpInfoId="+ Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr, "SSIDB");
        }


        public DataTable GetEmpEducationInfoDAL(string Id)
        {

             
              string queryStr = @"SELECT e.EmpEducationId,
       e.EmpInfoId,
       e.EducationNameId,
	   en.Description AS EducationName,
       e.BoardUniversityId,
	   bu.Description AS BoardUniversity,
       e.SubjectGroupId,
	   sg.Description AS SubjectGroup,
       e.EducationalInstituteId,
	   ei.Description AS EducationalInstitute,
       e.FieldOfSpecializationId,
	  sp.Description AS FieldOfSpecialization,
       e.PassingYear,
       e.Result,
       e.CgpaOrTotalMarks,
       e.EduIsLastLevel,
e.IsProfessionalEdu,
       e.IsActive FROM dbo.tblEmpEducation e 
	   LEFT JOIN dbo.tblEducationName en ON en.EducationNameID = e.EducationNameId
	   LEFT JOIN dbo.tblBoardUniversity bu ON bu.BoardUniversityID = e.BoardUniversityId
	   LEFT JOIN dbo.tblEducationSubjectGroup sg ON sg.EducationSubjectGroupID=e.SubjectGroupId
	   LEFT JOIN dbo.tblEducationalInstitution ei ON ei.InstitutionID=e.EducationalInstituteId
	   LEFT JOIN dbo.tblSpecialization sp ON sp.SpecializationID=e.FieldOfSpecializationId
	   WHERE e.IsActive=1 AND e.EmpInfoId="+Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }


        public DataTable GetEmpExperienceInfoDAL(string Id)
        {
 
              string queryStr = @"SELECT   CONVERT(VARCHAR(10), tblEmpExperience.ExpFromDate, 105) AS ExpFromDate, CONVERT(VARCHAR(10), tblEmpExperience.ExpToDate, 105) AS ExpToDate, * from tblEmpExperience where EmpInfoId=" + Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }


        public DataTable GetEmpTrainingInfoDAL(string Id)
        {

            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@EmpInfoId", Id));
              string queryStr = @"SELECT tblEmpTraining.TrainingName,  tblEmpInfoTrainingType.Description TrainingTypeName, dbo.tblEmpTraining.TrainingDescription, tblEmpTrainingInstitution.Description TrainingInstitutionName, tblCountry.Title TrainingCountryName,
 tblEmpTraining.TrFromDate, tblEmpTraining.TrToDate ,dbo.tblEmpTraining.TrainingAchievment, dbo.tblEmpTraining.TrainingDays, tblEmpTraining.TrainingPlace, tblEmpTraining.TrRemarks from tblEmpTraining
LEFT JOIN tblEmpInfoTrainingType ON tblEmpTraining.TrainingType=tblEmpInfoTrainingType.TrainingTypeID
LEFT JOIN tblEmpTrainingInstitution ON  tblEmpTraining.TrainingInstitution=tblEmpTrainingInstitution.InstitutionID
LEFT JOIN dbo.tblCountry ON  tblEmpTraining.TrainingCountry=tblCountry.CountryID WHERE tblEmpTraining.IsActive=1 and EmpInfoId=@EmpInfoId
UNION ALL 
SELECT mas.TrainingTitle TrainingName, tt.TrainingType TrainingTypeName,  mas.TrainingDetails TrainingDescription,ti.TrainingOrgName  TrainingInstitutionName, ' ' TrainingCountryName  
   
, FORMAT(mas.StartDate,'dd-MMM-yyyy') TrFromDate , FORMAT(mas.EndDate,'dd-MMM-yyyy') TrToDate, ' ' TrainingAchievment, mas.NoOfDays TrainingDays,
CASE
    WHEN TrainingOrgLocation = 0 THEN vn.VenueName
    WHEN TrainingOrgLocation != 0 THEN brn.BranchDetails
    
END AS TrainingPlace, '' TrRemarks FROM dbo.tblTrainingRecordMaster mas
LEFT JOIN  tbl_trainingRecordDetailsEmployee ddlt  ON mas.TrainingRecordMasterId = ddlt.TrainingRecordMasterId
   LEFT JOIN dbo.tblTrainingType tt ON tt.TrainingTypeID = mas.TrainingTypeId
  LEFT JOIN dbo.tblTrainingOrgInfo ti ON ti.TrainingOrgId=mas.TrainingOrgId
  LEFT JOIN tblSMCTrainingVenue vn ON mas.TrainingVenue= vn.SMCVenueID
  LEFT JOIN tblOfficeBranch brn ON brn.TrainingOrgId = mas.TrainingOrgId
 WHERE   ddlt.EmpinfoId    IN (SELECT tblEvaluateTrainingMaster.EmpInfoId FROM tblEvaluateTrainingMaster )  AND ddlt.EmpInfoId=" + Id; 
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }

        public DataTable GetEmpReferenceInfoDAL(string Id)
        {

 
              string queryStr = @"SELECT dbo.tblOccupation.Description RefOccupationName,* from tblEmpReference
LEFT JOIN tblOccupation ON dbo.tblEmpReference.RefOccupation=dbo.tblOccupation.OccupationID where EmpInfoId=" + Id;
            return aCommonInternalDal.DataContainerDataTable(queryStr,  "SSIDB");
        }


        
 
 
       
 
 
    }
}
