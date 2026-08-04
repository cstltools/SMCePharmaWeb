using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class EmpGeneralInfoDAL
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveEmployeeInfo(EmpGeneralInfo aGeneralInfo)
        {
            string insertQuery = @"insert into tblEmpGeneralInfo (EmpInfoId,EmpMasterCode,EmpName,ShortName,FatherName,MotherName,Religion,Nationality,DateOfBirth,PlaceOfBirth,BloodGroup,Gender,AddressPresent,AddressPermanent,MedicalInformation,
                                   PhoneNo,CellNumber,Email,EmpImage,SignatureImage,MaritalStatus,NationalIdNo,RefName,RefAddress,RefCellNo,JoiningDate,DesignationId,Designation,DepartmentId,DeptName) 
            values (@EmpInfoId,@EmpMasterCode,@EmpName,@ShortName,@FatherName,@MotherName,@Religion,@Nationality,@DateOfBirth,@PlaceOfBirth,
                    @BloodGroup,@Gender,@AddressPresent,@AddressPermanent,@MedicalInformation,@PhoneNo,@CellNumber,@Email,@EmpImage,
                    @SignatureImage,@MaritalStatus,@NationalIdNo,@RefName,@RefAddress,@RefCellNo,@JoiningDate,@DesignationId,@Designation,@DepartmentId,@DeptName)";
            return SInventorySql.Execute(insertQuery, EmployeeParameters(aGeneralInfo));
        }

        public DataTable LoadEmployeeView()
        {
            string query = @"select * from tblEmpGeneralInfo";
                           
                
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadEmpGeneralInformation()
        {
            string query = @"SELECT * FROM tblEmpGeneralInfo ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public void LoadDesignationName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblDesignation";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DesigName", "DesignationId", queryStr);
        }

        public void LoadDepartmentName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblDepartment";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DeptName", "DeptId", queryStr);
        }

       
        public EmpGeneralInfo EmpInfoEditLoad(string employeeId)
        {
            string query = "select * from tblEmpGeneralInfo where EmpInfoId = @EmpInfoId";
            DataTable employeeTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@EmpInfoId", SInventorySql.DbValue(employeeId))
            });
            EmpGeneralInfo aEmpGeneralInfo = new EmpGeneralInfo();
            if (employeeTable.Rows.Count > 0)
            {
                DataRow row = employeeTable.Rows[0];
                aEmpGeneralInfo.EmpInfoId = Int32.Parse(row["EmpInfoId"].ToString());
                aEmpGeneralInfo.EmpMasterCode = row["EmpMasterCode"].ToString();
                aEmpGeneralInfo.EmpName = row["EmpName"].ToString();
                aEmpGeneralInfo.ShortName = row["ShortName"].ToString();
                aEmpGeneralInfo.FatherName = row["FatherName"].ToString();
                aEmpGeneralInfo.MotherName = row["MotherName"].ToString();
                aEmpGeneralInfo.Religion = row["Religion"].ToString();
                aEmpGeneralInfo.Nationality = row["Nationality"].ToString();
                aEmpGeneralInfo.DateOfBirth = row["DateOfBirth"].ToString();
                aEmpGeneralInfo.PlaceOfBirth = row["PlaceOfBirth"].ToString();
                aEmpGeneralInfo.BloodGroup = row["BloodGroup"].ToString();
                aEmpGeneralInfo.Gender = row["Gender"].ToString();
                aEmpGeneralInfo.AddressPresent = row["AddressPresent"].ToString();
                aEmpGeneralInfo.AddressPermanent = row["AddressPermanent"].ToString();
                aEmpGeneralInfo.MedicalInformation = row["MedicalInformation"].ToString();
                aEmpGeneralInfo.PhoneNo = row["PhoneNo"].ToString();
                aEmpGeneralInfo.CellNumber = row["CellNumber"].ToString();
                aEmpGeneralInfo.Email = row["Email"].ToString();
                aEmpGeneralInfo.MaritalStatus = row["MaritalStatus"].ToString();
                aEmpGeneralInfo.NationalIdNo = row["NationalIdNo"].ToString();
                aEmpGeneralInfo.ReferanceName = row["RefName"].ToString();
                aEmpGeneralInfo.ReferanceAddress = row["RefAddress"].ToString();
                aEmpGeneralInfo.ReferanceCellNo = row["RefCellNo"].ToString();
                aEmpGeneralInfo.DepartmentId = Int32.Parse(row["DepartmentId"].ToString());
                aEmpGeneralInfo.DeptName = (row["DepartmentId"].ToString());
                aEmpGeneralInfo.JoiningDate = Convert.ToDateTime(row["JoiningDate"].ToString());
                aEmpGeneralInfo.Designation = row["Designation"].ToString();
                aEmpGeneralInfo.DesignationId = Convert.ToInt32(row["DesignationId"].ToString());
            }
            return aEmpGeneralInfo;
        }

        public bool UpdateEmployeeInfo(EmpGeneralInfo aEmpGeneralInfo)
        {
            string query = @"UPDATE tblEmpGeneralInfo SET EmpMasterCode=@EmpMasterCode,EmpName=@EmpName,ShortName=@ShortName,FatherName=@FatherName,
                           MotherName=@MotherName,Religion=@Religion,Nationality=@Nationality,DateOfBirth=@DateOfBirth,PlaceOfBirth=@PlaceOfBirth,
                           BloodGroup=@BloodGroup,Gender=@Gender,AddressPresent=@AddressPresent,AddressPermanent=@AddressPermanent,
                           MedicalInformation=@MedicalInformation,PhoneNo=@PhoneNo,CellNumber=@CellNumber,Email=@Email,MaritalStatus=@MaritalStatus,
                           NationalIdNo=@NationalIdNo,RefCellNo=@RefCellNo,RefAddress=@RefAddress,RefName=@RefName,JoiningDate=@JoiningDate,
                           DepartmentId=@DepartmentId,DesignationId=@DesignationId,Designation=@Designation,EmpImage=@EmpImage,SignatureImage=@SignatureImage
                           WHERE EmpInfoId=@EmpInfoId";
            return SInventorySql.Execute(query, EmployeeParameters(aEmpGeneralInfo));
        }


        public List<EmpGeneralInfo> ViewAllEmployee()
        {
            List<EmpGeneralInfo> allEmpGeneralInfoList = new List<EmpGeneralInfo>();
            string query = @"select * from tblEmpGeneralInfo";

            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");

            while (dataReader.Read())
            {
                EmpGeneralInfo aGeneralInfo = new EmpGeneralInfo();
                aGeneralInfo.EmpInfoId = Int32.Parse(dataReader["EmpInfoId"].ToString());
                aGeneralInfo.EmpMasterCode = (dataReader["EmpMasterCode"].ToString());
                aGeneralInfo.EmpName = dataReader["EmpName"].ToString();
                allEmpGeneralInfoList.Add(aGeneralInfo);
            }

            return allEmpGeneralInfoList;
        }

        public List<EmpGeneralInfo> ViewEmpName(string employeeId)
        {
            List<EmpGeneralInfo> singleEmpNameList = ViewAllEmployee();
            List<EmpGeneralInfo> singleEmpName = (from EmpGeneralInfo aGeneralInfo in singleEmpNameList
                                                  where aGeneralInfo.EmpMasterCode == employeeId
                                                  select aGeneralInfo).ToList();
            return singleEmpName;
        }

        private static List<SqlParameter> EmployeeParameters(EmpGeneralInfo employee)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@EmpInfoId", employee.EmpInfoId),
                new SqlParameter("@EmpMasterCode", SInventorySql.DbValue(employee.EmpMasterCode)),
                new SqlParameter("@EmpName", SInventorySql.DbValue(employee.EmpName)),
                new SqlParameter("@ShortName", SInventorySql.DbValue(employee.ShortName)),
                new SqlParameter("@FatherName", SInventorySql.DbValue(employee.FatherName)),
                new SqlParameter("@MotherName", SInventorySql.DbValue(employee.MotherName)),
                new SqlParameter("@Religion", SInventorySql.DbValue(employee.Religion)),
                new SqlParameter("@Nationality", SInventorySql.DbValue(employee.Nationality)),
                new SqlParameter("@DateOfBirth", SInventorySql.DbValue(employee.DateOfBirth)),
                new SqlParameter("@PlaceOfBirth", SInventorySql.DbValue(employee.PlaceOfBirth)),
                new SqlParameter("@BloodGroup", SInventorySql.DbValue(employee.BloodGroup)),
                new SqlParameter("@Gender", SInventorySql.DbValue(employee.Gender)),
                new SqlParameter("@AddressPresent", SInventorySql.DbValue(employee.AddressPresent)),
                new SqlParameter("@AddressPermanent", SInventorySql.DbValue(employee.AddressPermanent)),
                new SqlParameter("@MedicalInformation", SInventorySql.DbValue(employee.MedicalInformation)),
                new SqlParameter("@PhoneNo", SInventorySql.DbValue(employee.PhoneNo)),
                new SqlParameter("@CellNumber", SInventorySql.DbValue(employee.CellNumber)),
                new SqlParameter("@Email", SInventorySql.DbValue(employee.Email)),
                new SqlParameter("@EmpImage", SInventorySql.DbValue(employee.EmpImage)),
                new SqlParameter("@SignatureImage", SInventorySql.DbValue(employee.SignatureImage)),
                new SqlParameter("@MaritalStatus", SInventorySql.DbValue(employee.MaritalStatus)),
                new SqlParameter("@NationalIdNo", SInventorySql.DbValue(employee.NationalIdNo)),
                new SqlParameter("@RefName", SInventorySql.DbValue(employee.ReferanceName)),
                new SqlParameter("@RefAddress", SInventorySql.DbValue(employee.ReferanceAddress)),
                new SqlParameter("@RefCellNo", SInventorySql.DbValue(employee.ReferanceCellNo)),
                new SqlParameter("@JoiningDate", SInventorySql.DbValue(employee.JoiningDate)),
                new SqlParameter("@DesignationId", employee.DesignationId),
                new SqlParameter("@Designation", SInventorySql.DbValue(employee.Designation)),
                new SqlParameter("@DepartmentId", employee.DepartmentId),
                new SqlParameter("@DeptName", SInventorySql.DbValue(employee.DeptName))
            };
        }

        
    }
}
