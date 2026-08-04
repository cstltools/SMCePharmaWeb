using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using SalesSolution.DataLayer;
using SalesSolution.Web.DataLayer;

namespace Library.DAL.DoctorModule_DAL
{
    public class SetupDAL_daaw
    {
        private DataAccessManager_daaw  accessManager = new DataAccessManager_daaw ();

        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void GetCapturedBy_For_ddl(DropDownList aDropDownList)
        {
            string query = @"SELECT B.UserId EmpInfoId,(A.EmpName+'('+A.EmpMasterCode+')') AS EmpName  FROM dbo.tblEmpGeneralInfo A 
	                         INNER JOIN dbo.tblUser B ON B.EmpInfoId = A.EmpInfoId where B.IsAppsUser = 1";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "EmpName", "EmpInfoId", query, "SSIDB");
        }


        public void GetPrescriptionTypelist_For_ddl(DropDownList aDropDownList)
        {
            string query = @"SELECT * FROM tbl_PrescriptionType ";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "PrescriptionType", "PrescriptionTypeId", query, "SSIDB");
        }

        public PrescriptionType GetPrescriptionForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                PrescriptionType master = new PrescriptionType();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_PrescriptionType_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.PrescriptionTypeId = (int)dr["PrescriptionTypeId"];
                    master.PrescriptionTypename = dr["PrescriptionType"].ToString();

                    master.Activedate = (DateTime)dr["ActiveInactiveDate"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public void Get_DoctorList(DropDownList aDropDownList)
        {
            string query = @"SELECT    CONVERT(NVARCHAR(50),DM.EntryDate,106)AS EntryDate,  dgs.DesigName,     DM.DoctorName,   Us.UserName as UserEntryBy,  Up.UserName UserUpdateBy, STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName,  STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm (NOLOCK) INNER JOIN dbo.tblDoctorSpecialityDetail mgd ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') as DoctorSpeciality ,  STUFF( (SELECT CONCAT(',', mm.ProgramType , '') FROM tblDoctorProgramType mm (NOLOCK) INNER JOIN dbo.tblDoctorProgramTypeDetail mgd ON mgd.ProgramTypeId=mm.ProgramTypeId WHERE mgd.DoctorId=DM.DoctorId ORDER BY mgd. DoctorTypeDetailId FOR XML PATH ('') ),1,1,'') as ProgramType, * from tblDoctorMaster DM
                             Left Join dbo.tblDesignation dgs ON dgs.DesignationId= DM.DesignationId
                             Left Join dbo.tblDoctorProgramType pt ON pt.ProgramTypeId= DM.ProgramType
                             Left Join tblUser Us ON DM.EntryBy= Us.UserId
                             Left Join tblUser Up ON DM.UpdateBy= Up.UserId
                             ORDER BY DM.DoctorCode DESC";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "DoctorName", "DoctorId", query, "SSIDB");
        }

        public int Save_PrescriptionDetail(PrescriptionProductDetailDAO aDao)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@PrescriptionId", aDao.PrescriptionId));
                aSqlParameterlist.Add(new SqlParameter("@ProductId", aDao.ProductId));

                return accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionProductDetail", aSqlParameterlist);
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public int Save_PrescriptionMaster(PrescriptionMasterDAO aDao)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                //aSqlParameterlist.Add(new SqlParameter("@PrescriptionId", aDao.PrescriptionId));
                aSqlParameterlist.Add(new SqlParameter("@PrescriptionDate", aDao.PrescriptionDate));
                aSqlParameterlist.Add(new SqlParameter("@PrescriptionTypeId", aDao.PrescriptionTypeId));
                aSqlParameterlist.Add(new SqlParameter("@DoctorId", aDao.DoctorId));
                aSqlParameterlist.Add(new SqlParameter("@ImageName", aDao.ImageName));
                aSqlParameterlist.Add(new SqlParameter("@ImagePath", aDao.ImagePath));

                return accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionMaster", aSqlParameterlist);
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

        }

        internal DataTable GetCapturedBy_For_ddl()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_CapturedBY_For_DDL");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        internal DataTable GetPrescriptionTypelist_For_ddl()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionType_For_DDL");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        internal DataTable GetDFoctorlist_For_ddl()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_Doctor_For_DDL");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_DoctorList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorList");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_TADAList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TadaClaimList");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public void Get_ProductList(DropDownList aDropDownList)
        {
            string query = @"SELECT ProductCode +':'+ ProductName AS Product,ProductId FROM tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "Product", "ProductId", query, "SSIDB");
        }

        public DataTable Get_ProductList_For_Ddl()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_Product_For_DDl");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        //#region Area

        //public ResultInfo SaveAreaInfo(Area masterData, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.AreaId));
        //        gSqlParameterList.Add(new SqlParameter("@zoneId", masterData.ZoneId));
        //        gSqlParameterList.Add(new SqlParameter("@areaName", masterData.AreaName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.AreaId > 0)
        //        {

        //            aSqlParameterList.Add(new SqlParameter("@id", masterData.AreaId));
        //            aSqlParameterList.Add(new SqlParameter("@Name", masterData.AreaName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_AreaInfo", aSqlParameterList);
        //            if (dt.Rows.Count == 0)
        //            {

        //                aInformation.isSuccess = accessManager.UpdateData("sp_Update_AreaInfo", gSqlParameterList);
        //                pk = masterData.AreaId;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }

        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_AreaInfo", gSqlParameterList);

        //        }

        //        if (pk > 0)
        //        {
        //            int[] idS = masterData.DistrictId.Split(',').Select(Int32.Parse).ToArray();

        //            for (int i = 0; i < idS.Length; i++)
        //            {

        //                int aId = idS[i];
        //                List<SqlParameter> aSQL = new List<SqlParameter>();
        //                aSQL.Add(new SqlParameter("@areaId", pk));
        //                aSQL.Add(new SqlParameter("@districtId", aId));
        //                aInformation.isSuccess = accessManager.SaveData("sp_Save_AreaDistictRelation", aSQL);

        //            }

        //        }
        //        else
        //        {
        //            aInformation.isSuccess = false;

        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public DataTable GetAreaList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_AreaList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable GetAreaList_OnlyActive()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_AreaList_OnlyActive");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable GetAreaList_OnlyActive_ByZoneId(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@id", id));


        //        DataTable dt = accessManager.GetDataTable("sp_Get_AreaList_OnlyActive_ByZoneId", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public Area GetEditData_Area(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        Area master = new Area();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_AreaData_ByAreaId", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.AreaId = (int)dr["AreaId"];
        //            master.ZoneId = (int)dr["RegionId"];
        //            master.AreaName = dr["AreaName"].ToString();
        //            master.DistrictId = dr["DistrictId"].ToString();
        //            master.AcOrInAcDate = (DateTime)dr["AcOrInAcDate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //            master.GroupId = (int)dr["GroupId"];
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //#endregion



        public DataTable GetDistrict_ByDivision_Active(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", id));


                DataTable dt = accessManager.GetDataTable("sp_Get_DistrictList_OnlyActive_ByDivisionId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        //#region Territory
        //public ResultInfo SaveTerritory(Territory masterData, int sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.TerritoryId));
        //        gSqlParameterList.Add(new SqlParameter("@areaId", masterData.AreaId));
        //        gSqlParameterList.Add(new SqlParameter("@Name", masterData.TerritoryName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.TerritoryId > 0)
        //        {
        //            //bool result = accessManager.UpdateData("sp_Update_TerritoryData", gSqlParameterList);
        //            //pk = masterData.TerritoryId;

        //            aSqlParameterList.Add(new SqlParameter("@id", masterData.TerritoryId));
        //            aSqlParameterList.Add(new SqlParameter("@Name", masterData.TerritoryName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_TerritoryInfo", aSqlParameterList);
        //            if (dt.Rows.Count == 0)
        //            {
        //                aInformation.isSuccess = accessManager.UpdateData("sp_Update_TerritoryData", gSqlParameterList);
        //                pk = masterData.TerritoryId;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }


        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TerritoryInfo", gSqlParameterList);

        //        }

        //        if (pk > 0)
        //        {
        //            int[] idS = masterData.ThanaId.Split(',').Select(Int32.Parse).ToArray();

        //            for (int i = 0; i < idS.Length; i++)
        //            {

        //                int aId = idS[i];
        //                List<SqlParameter> aSQL = new List<SqlParameter>();
        //                aSQL.Add(new SqlParameter("@territroId", pk));
        //                aSQL.Add(new SqlParameter("@thanaId", aId));
        //                aInformation.isSuccess = accessManager.SaveData("sp_Save_TerritoryThanaRelation", aSQL);

        //            }


        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public Territory GetEditData_Territory(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        Territory master = new Territory();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_TerritoryData_ByTerritoryId", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.TerritoryId = (int)dr["TerritoryId"];
        //            master.AreaId = (int)dr["AreaId"];
        //            master.ZoneId = (int)dr["RegionId"];
        //            master.TerritoryName = dr["TerritoryName"].ToString();
        //            master.ThanaId = dr["thanaId"].ToString();
        //            master.AcOrInAcDate = (DateTime)dr["AcOrInAcDate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //            master.GroupId = (int)dr["GroupId"];
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //public ResultInfo Approve_ExpenseClaimList(string Id, string rbValue, string SessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TPMaster", Id));
        //        gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
        //        aInformation.isSuccess = accessManager.UpdateData("sp_ApproveExpenseClaimInformation", gSqlParameterList);

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo Approve_MileageClaimList(string Id, string rbValue, string SessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TPMaster", Id));
        //        gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
        //        aInformation.isSuccess = accessManager.UpdateData("sp_ApproveMileageClaimInformation", gSqlParameterList);

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo Approve_PrescriptionList(string Id, string rbValue, string SessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TPMaster", Id));
        //        gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
        //        aInformation.isSuccess = accessManager.UpdateData("sp_ApprovePrescriptionInformation", gSqlParameterList);

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //public MileageClaimDAO GetMileageClaimEditData(int id)
        //{

        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        MileageClaimDAO master = new MileageClaimDAO();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_MileageClaim_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.MileageClaimId = (int)dr["MileageClaimId"];
        //            master.MileageInKM = (decimal)dr["MileageInKM"];
        //            master.EmpInfoId = (int)dr["EmpInfoId"];
        //            master.Remarks = dr["Remarks"].ToString();
        //            master.TransportId = (int)dr["TransportId"];

        //            master.GroupId = (int)dr["GroupId"];
        //            master.RegionId = (int)dr["RegionId"];
        //            try
        //            {
        //                master.TourTypeId = (int)dr["TourTypeId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.TourTypeId = null;

        //            }
        //            try
        //            {
        //                master.AreaId = (int)dr["AreaId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.AreaId = null;

        //            }
        //            try
        //            {
        //                master.TerritoryId = (int)dr["TerritoryId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.TerritoryId = null;

        //            }

        //            try
        //            {
        //                master.MarketId = (int)dr["MarketId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.MarketId = null;

        //            }

        //            master.MeterReading = (decimal)dr["MeterReading"];
        //            try
        //            {
        //                master.MileageDate = (DateTime)dr["MileageDate"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.MileageDate = null;

        //            }


        //            master.ImageString = dr["ImageName"].ToString();
        //            master.EntryBy = Convert.ToInt32(dr["EntryBy"].ToString());
        //            string imagefullpath = (dr["ImagePreName"].ToString() + ((int)dr["MileageClaimId"]).ToString() + ".jpg");


        //            try
        //            {
        //                byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
        //                master.ImageString = Convert.ToBase64String(imageArray);
        //                master.ImagePreName = imagefullpath;

        //            }
        //            catch (Exception ex)
        //            {

        //            }



        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }


        //}
        //public DataTable GetTerritoryList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_TerritoryList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //#endregion




        //#region Market
        //public ResultInfo SaveMarket(Market masterData, int sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.MarketId));
        //        gSqlParameterList.Add(new SqlParameter("@territoryId", masterData.TerritoryId));
        //        gSqlParameterList.Add(new SqlParameter("@Name", masterData.MarketName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.MarketId > 0)
        //        {
        //            // aInformation.isSuccess = accessManager.UpdateData("sp_Update_MarketData", gSqlParameterList);

        //            aSqlParameterList.Add(new SqlParameter("@id", masterData.MarketId));
        //            aSqlParameterList.Add(new SqlParameter("@Name", masterData.MarketName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_MarketInfo", aSqlParameterList);
        //            if (dt.Rows.Count == 0)
        //            {

        //                aInformation.isSuccess = accessManager.UpdateData("sp_Update_MarketData", gSqlParameterList);
        //                pk = masterData.MarketId;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MarketData", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //        }


        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public DataTable GetMarketList(string param)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@Parameter", param));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_MarketList", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}



        //public Market GetEditData_Market(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        Market master = new Market();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));

        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_MarketData_ByMarketid", aSqlParameters);

        //        while (dr.Read())
        //        {
        //            master.TerritoryId = (int)dr["TerritoryId"];
        //            master.AreaId = (int)dr["AreaId"];
        //            master.ZoneId = (int)dr["RegionId"];
        //            master.MarketName = dr["MarketName"].ToString();
        //            master.AcOrInAcDate = (DateTime)dr["acInAcDate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //            master.GroupId = (int)dr["GroupId"];
        //        }

        //        return master;

        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}
        //#endregion



        //public ResultInfo SaveTerritory(Territory masterData, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.TerritoryId));
        //        gSqlParameterList.Add(new SqlParameter("@areaId", masterData.AreaId));
        //        gSqlParameterList.Add(new SqlParameter("@Name", masterData.TerritoryName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.TerritoryId > 0)
        //        {
        //            bool result = accessManager.UpdateData("sp_Update_TerritoryData", gSqlParameterList);
        //            pk = masterData.TerritoryId;
        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TerritoryInfo", gSqlParameterList);

        //        }

        //        if (pk > 0)
        //        {
        //            int[] idS = masterData.ThanaId.Split(',').Select(Int32.Parse).ToArray();

        //            for (int i = 0; i < idS.Length; i++)
        //            {

        //                int aId = idS[i];
        //                List<SqlParameter> aSQL = new List<SqlParameter>();
        //                aSQL.Add(new SqlParameter("@territroId", pk));
        //                aSQL.Add(new SqlParameter("@thanaId", aId));
        //                aInformation.isSuccess = accessManager.SaveData("sp_Save_TerritoryThanaRelation", aSQL);

        //            }


        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}



        //public ResultInfo SaveDoctorDegree(DoctorDegree doctorDegree, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@DegreeId ", doctorDegree.DegreeId));
        //        gSqlParameterList.Add(new SqlParameter("@DegreeName", doctorDegree.DegreeName));



        //        gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorDegree.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", doctorDegree.Activedate));

        //        if (doctorDegree.DegreeId > 0)
        //        {


        //            aSqlParameterlist.Add(new SqlParameter("@DegreeId ", doctorDegree.DegreeId));
        //            aSqlParameterlist.Add(new SqlParameter("@DegreeName", doctorDegree.DegreeName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorDegree", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorDegree", gSqlParameterList);
        //                pk = doctorDegree.DegreeId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }



        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorDegree", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;
        //        throw exception;
        //    }
        //    finally
        //    {


        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo Save_MileageClaim(MileageClaimDAO doctorDegree, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;

        //        gSqlParameterList.Add(new SqlParameter("@MileageClaimId ", doctorDegree.MileageClaimId));

        //        gSqlParameterList.Add(new SqlParameter("@MileageInKM ", doctorDegree.MileageInKM));
        //        gSqlParameterList.Add(new SqlParameter("@EmpInfoId", doctorDegree.EmpInfoId));



        //        gSqlParameterList.Add(new SqlParameter("@Remarks ", doctorDegree.Remarks));


        //        gSqlParameterList.Add(new SqlParameter("@TourTypeId", doctorDegree.TourTypeId));
        //        gSqlParameterList.Add(new SqlParameter("@MileageDate", doctorDegree.MileageDate));
        //        gSqlParameterList.Add(new SqlParameter("@TransportId", doctorDegree.TransportId));
        //        gSqlParameterList.Add(new SqlParameter("@MarketId", doctorDegree.MarketId));

        //        gSqlParameterList.Add(new SqlParameter("@MeterReading", doctorDegree.MeterReading));
        //        //gSqlParameterList.Add(new SqlParameter("@MileageImage", doctorDegree.MileageImage));

        //        if (doctorDegree.MileageClaimId > 0)
        //        {



        //            gSqlParameterList.Add(new SqlParameter("@UpdatedBy", sessionUser));
        //            bool result = accessManager.UpdateData("sp_Update_MileageClaim", gSqlParameterList);
        //            pk = doctorDegree.MileageClaimId;
        //            aInformation.isSuccess = result;

        //            if (doctorDegree.MileageImage != "")

        //            {
        //                try
        //                {
        //                    AppPrimaryDAL app = new AppPrimaryDAL();
        //                    ImagePath _path = new ImagePath();
        //                    string type = "Mileage";
        //                    _path = app.GetImagePath(type);




        //                    //string targetPath = @"E:\ZasImage";
        //                    string targetPath = @"" + _path.ImagePathValue + "";
        //                    if (!Directory.Exists(targetPath))
        //                    {
        //                        Directory.CreateDirectory(targetPath);
        //                    }

        //                    string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
        //                    File.WriteAllBytes(filePath, Convert.FromBase64String(doctorDegree.MileageImage));
        //                }
        //                catch (Exception ex)
        //                {

        //                }
        //            }


        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MileageClaim", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //                try
        //                {
        //                    AppPrimaryDAL app = new AppPrimaryDAL();
        //                    ImagePath _path = new ImagePath();
        //                    string type = "Mileage";
        //                    _path = app.GetImagePath(type);




        //                    //string targetPath = @"E:\ZasImage";
        //                    string targetPath = @"" + _path.ImagePathValue + "";
        //                    if (!Directory.Exists(targetPath))
        //                    {
        //                        Directory.CreateDirectory(targetPath);
        //                    }

        //                    string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
        //                    File.WriteAllBytes(filePath, Convert.FromBase64String(doctorDegree.MileageImage));
        //                }
        //                catch (Exception ex)
        //                {

        //                }
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;
        //        throw exception;
        //    }
        //    finally
        //    {


        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo SaveDoctorCategory(DoctorCategory doctorCategory, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@CategoryId ", doctorCategory.CategoryId));
        //        gSqlParameterList.Add(new SqlParameter("@CategoryName", doctorCategory.CategoryName));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorCategory.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", doctorCategory.Activedate));
        //        if (doctorCategory.CategoryId > 0)
        //        {

        //            aSqlParameterlist.Add(new SqlParameter("@CategoryId ", doctorCategory.CategoryId));
        //            aSqlParameterlist.Add(new SqlParameter("@CategoryName", doctorCategory.CategoryName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorCategory", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorCategory", gSqlParameterList);
        //                pk = doctorCategory.CategoryId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }



        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorCategory", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {


        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveDoctorChamber(DoctorChamber doctorChamber, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ChamberId ", doctorChamber.ChamberId));
        //        gSqlParameterList.Add(new SqlParameter("@ChamberName", doctorChamber.ChamberName));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorChamber.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", doctorChamber.Activedate));
        //        if (doctorChamber.ChamberId > 0)
        //        {



        //            aSqlParameterlist.Add(new SqlParameter("@ChamberId ", doctorChamber.ChamberId));
        //            aSqlParameterlist.Add(new SqlParameter("@ChamberName", doctorChamber.ChamberName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorChamber", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorChamber", gSqlParameterList);
        //                pk = doctorChamber.ChamberId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorChamber", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveDoctorDesignation(DoctorDesignation doctorDesignation, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@DesignationId ", doctorDesignation.DesignationId));
        //        gSqlParameterList.Add(new SqlParameter("@DesignationName", doctorDesignation.DesignationName));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive ", doctorDesignation.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", doctorDesignation.Activedate));



        //        if (doctorDesignation.DesignationId > 0)
        //        {





        //            aSqlParameterlist.Add(new SqlParameter("@DesignationId ", doctorDesignation.DesignationId));
        //            aSqlParameterlist.Add(new SqlParameter("@DesignationName", doctorDesignation.DesignationName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorDesignation", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorDesignation", gSqlParameterList);
        //                pk = doctorDesignation.DesignationId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }

        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorDesignation", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }

        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveDoctorpatientType(DoctorPatientType patientType, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PatientTypeId", patientType.PatientTypeId));
        //        gSqlParameterList.Add(new SqlParameter("@PatientType", patientType.PatientType));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", patientType.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", patientType.Activedate));
        //        if (patientType.PatientTypeId > 0)
        //        {



        //            aSqlParameterlist.Add(new SqlParameter("@PatientTypeId", patientType.PatientTypeId));
        //            aSqlParameterlist.Add(new SqlParameter("@PatientType", patientType.PatientType));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorPatientType", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorPatientType", gSqlParameterList);
        //                pk = patientType.PatientTypeId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorPatientType", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveDoctorSpeacialDay(DoctorSpecailDay doctorSpecailDay, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@SpecialDayId", doctorSpecailDay.SpecialDayId));
        //        gSqlParameterList.Add(new SqlParameter("@SpecialDay", doctorSpecailDay.SpecialDay));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", doctorSpecailDay.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", doctorSpecailDay.Activedate));
        //        if (doctorSpecailDay.SpecialDayId > 0)
        //        {


        //            gSqlParameterList.Add(new SqlParameter("@SpecialDayId", doctorSpecailDay.SpecialDayId));
        //            gSqlParameterList.Add(new SqlParameter("@SpecialDay", doctorSpecailDay.SpecialDay));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorSpecialDay", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorSpecialDay", gSqlParameterList);
        //                aInformation.isSuccess = result;
        //                pk = doctorSpecailDay.SpecialDayId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }

        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorSpecialDay", gSqlParameterList);

        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;

        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo SaveDoctorSpeaciality(DoctorSpeciality speciality, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@SpecialityId", speciality.SpecialityId));
        //        gSqlParameterList.Add(new SqlParameter("@SpecialityName", speciality.SpecialityName));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", speciality.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@Activedate", speciality.Activedate));
        //        if (speciality.SpecialityId > 0)
        //        {



        //            aSqlParameterlist.Add(new SqlParameter("@SpecialityId", speciality.SpecialityId));
        //            aSqlParameterlist.Add(new SqlParameter("@SpecialityName", speciality.SpecialityName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_DoctorSpeciality", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {
        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_DoctorSpeciality", gSqlParameterList);
        //                aInformation.isSuccess = result;
        //                pk = speciality.SpecialityId;
        //                aInformation.isSuccess = result;
        //            }

        //            else
        //            {

        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorSpeciality", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}





        //public ResultInfo DeleteDoctorDegree(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@DegreeId ", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorDegree", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo DeleteDoctorcategory(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@CategoryId ", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorCategory", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo DeleteDoctorchamber(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@DesignationId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorDesignation", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}



        //public ResultInfo DeleteDoctorPatientType(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PatientTypeId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorpatientType", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo DeleteDoctorSpecialDayType(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@SpecialDayId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorSpecailDay", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo DeleteDoctorSpeciality(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@SpecialityId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_DoctorSpeciality", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}





        //public DataTable GetDoctorDegreeList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorDegreeList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable GetExpenseClaimList(string param)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@param", param));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseClaimList", aSqlParameters);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DataTable GetMileageClaimList(string param)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@param", param));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_MileageClaimList", aSqlParameters);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable GetDoctorCategoryList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorCategoryList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DataTable GetDoctorChamberList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorChamberList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable GetDoctorDesignationList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorDesignationList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DataTable GetDoctorPatientTypeList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorPatientList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DataTable GetDoctorSpecialDayList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorSpecailDayList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DataTable GetDoctorSpecialityList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorSpecialityList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}







        //public DoctorSetup GetEditData_DoctorSetup(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorSetup master = new DoctorSetup();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorSetupData_ByDoctorId", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.DoctorId = (int)dr["DoctorId"];

        //            master.DoctorName = dr["DoctorName"].ToString();

        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DoctorDegree GetDoctorDegreeForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorDegree master = new DoctorDegree();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));

        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorDegree_ById", aSqlParameters);

        //        while (dr.Read())
        //        {
        //            master.DegreeId = (int)dr["DegreeId"];
        //            master.DegreeName = dr["DegreeName"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }

        //        return master;

        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}

        //public DataTable GetExpenseClaimEditData(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorExpenseClaim_ById", aSqlParameters);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public DoctorCategory GetDoctorCategoryForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorCategory master = new DoctorCategory();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));

        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Doctorcategory_ById", aSqlParameters);

        //        while (dr.Read())
        //        {
        //            master.CategoryId = (int)dr["CategoryId"];
        //            master.CategoryName = dr["CategoryName"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }

        //        return master;

        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}


        //public DoctorChamber GetDoctorChamberForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorChamber master = new DoctorChamber();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorChamber_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.ChamberId = (int)dr["ChamberId"];
        //            master.ChamberName = dr["ChamberName"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}


        //public DoctorDesignation GetDoctorDesignationForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorDesignation master = new DoctorDesignation();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorDesignation_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.DesignationId = (int)dr["DesignationId"];
        //            master.DesignationName = dr["DesignationName"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}

        //public DoctorPatientType GetDoctorPatientTypeForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorPatientType master = new DoctorPatientType();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorPatientType_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.PatientTypeId = (int)dr["PatientTypeId"];
        //            master.PatientType = dr["PatientType"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}


        //public DoctorSpecailDay GetDoctorSpecialDayForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorSpecailDay master = new DoctorSpecailDay();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorSpeacialDay_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.SpecialDayId = (int)dr["SpecialDayId"];
        //            master.SpecialDay = dr["SpecialDay"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}



        //public DoctorSpeciality GetDoctorSpecialityForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        DoctorSpeciality master = new DoctorSpeciality();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_DoctorSpeciality_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.SpecialityId = (int)dr["SpecialityId"];
        //            master.SpecialityName = dr["SpecialityName"].ToString();
        //            master.Activedate = (DateTime)dr["Activedate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}





        //public DataTable GetThana_All_WithTagInfo_ForEditPage(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@id", id));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_Thana_WithTagInfo_TerritoryEdit", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }


        //}


        //public ResultInfo SaveMarket(Market masterData, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.MarketId));
        //        gSqlParameterList.Add(new SqlParameter("@territoryId", masterData.TerritoryId));
        //        gSqlParameterList.Add(new SqlParameter("@Name", masterData.MarketName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.MarketId > 0)
        //        {
        //            aInformation.isSuccess = accessManager.UpdateData("sp_Update_MarketData", gSqlParameterList);
        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MarketData", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //        }


        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public DataTable GetMarketList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_MarketList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}



        //public ResultInfo SaveSubMarket(SubMarket masterData, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@id", masterData.SMId));
        //        gSqlParameterList.Add(new SqlParameter("@marketId", masterData.MarketId));
        //        gSqlParameterList.Add(new SqlParameter("@Name", masterData.SMName));
        //        gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
        //        gSqlParameterList.Add(new SqlParameter("@remarks", masterData.Remarks));
        //        gSqlParameterList.Add(new SqlParameter("@isActive", masterData.IsActive));
        //        gSqlParameterList.Add(new SqlParameter("@acInAcDate", masterData.AcOrInAcDate));

        //        if (masterData.SMId > 0)
        //        {
        //            aInformation.isSuccess = accessManager.UpdateData("sp_Update_SubMarketData", gSqlParameterList);
        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_SubMarketData", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //        }


        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public DataTable GetSubMarketList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_SubmarketList");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}


        //public SubMarket GetEditData_SubMarket(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        SubMarket master = new SubMarket();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));

        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_SubmarketData_ById", aSqlParameters);

        //        while (dr.Read())
        //        {
        //            master.TerritoryId = (int)dr["TerritoryId"];
        //            master.AreaId = (int)dr["AreaId"];
        //            master.ZoneId = (int)dr["ZoneId"];
        //            master.MarketId = (int)dr["MarketId"];
        //            master.SMName = dr["SMName"].ToString();
        //            master.AcOrInAcDate = (DateTime)dr["AcOrInAcDate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }

        //        return master;

        //    }
        //    catch (Exception exception)
        //    {

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //}

        //#region TrasnportDal
        //public ResultInfo DeleteTrasport(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TransportId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_Transport", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public DataTable GetTransportList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_Transport");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public Transport GetTransportForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        Transport master = new Transport();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Transport_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.TransportId = (int)dr["TransportId"];
        //            master.TransportName = dr["TransportName"].ToString();
        //            master.AllowedMilagePerKM = Convert.ToDecimal(dr["AllowedMilagePerKM"].ToString());

        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public ResultInfo SaveTransport(Transport transport, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TransportId", transport.TransportId));
        //        gSqlParameterList.Add(new SqlParameter("@TransportName", transport.TransportName));
        //        gSqlParameterList.Add(new SqlParameter("@AllowedMilagePerKM", transport.AllowedMilagePerKM));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", transport.IsActive));

        //        if (transport.TransportId > 0)
        //        {

        //            aSqlParameterlist.Add(new SqlParameter("@TransportId", transport.TransportId));
        //            aSqlParameterlist.Add(new SqlParameter("@TransportName", transport.TransportName));
        //            DataTable dt = accessManager.GetDataTable("sp_check_Transport", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {

        //                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //                bool result = accessManager.UpdateData("sp_Update_Transport", gSqlParameterList);
        //                aInformation.isSuccess = result;
        //                pk = transport.TransportId;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_Transport", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //#endregion


        public DataTable Get_PrescriptionDetailsByPrescriptionId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionDetails_ByPrescriptionId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public PrescriptionMaster GetEditData_Prescription(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                PrescriptionMaster master = new PrescriptionMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Prescription_ByPrescriptionId", aSqlParameters);
                while (dr.Read())
                {
                    master.PrescriptionDate = (DateTime)dr["PrescriptionDate"];
                    master.PrescriptionTypeId = (int)dr["PrescriptionTypeId"];
                    master.PrescriptionId = (int)dr["PrescriptionId"];

                    try
                    {
                        master.ChemberId = (int)dr["ChemberId"];

                    }
                    catch (Exception ex)
                    {

                    }

                    master.DoctorId = (int)dr["DoctorId"];
                    master.ImageString = dr["ImageName"].ToString();
                    master.ApprovalStatus = dr["ApprovalStatus"].ToString();
                    master.EntryBy = Convert.ToInt32(dr["EntryBy"].ToString());
                    string imagefullpath = (dr["ImagePreName"].ToString() + ((int)dr["PrescriptionId"]).ToString() + ".jpg");


                    try
                    {
                        byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
                        master.ImageString = Convert.ToBase64String(imageArray);
                        master.ImagePreName = imagefullpath;

                    }
                    catch (Exception ex)
                    {

                    }

                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        //#region Prescription

        //public PrescriptionMaster GetEditData_Prescription(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        PrescriptionMaster master = new PrescriptionMaster();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Prescription_ByPrescriptionId", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.PrescriptionDate = (DateTime)dr["PrescriptionDate"];
        //            master.PrescriptionTypeId = (int)dr["PrescriptionTypeId"];
        //            master.PrescriptionId = (int)dr["PrescriptionId"];
        //            master.DoctorId = (int)dr["DoctorId"];
        //            master.ImageString = dr["ImageName"].ToString();
        //            master.EntryBy = Convert.ToInt32(dr["EntryBy"].ToString());
        //            string imagefullpath = (dr["ImagePreName"].ToString() + ((int)dr["PrescriptionId"]).ToString() + ".jpg");


        //            try
        //            {
        //                byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
        //                master.ImageString = Convert.ToBase64String(imageArray);
        //                master.ImagePreName = imagefullpath;

        //            }
        //            catch (Exception ex)
        //            {

        //            }



        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public ResultInfo Delete_PrescriptionType(Int32 DeleteId)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_PrescriptionType", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo Delete__Prescription(Int32 DeleteId)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", DeleteId));
        //        bool result = accessManager.DeleteData("sp_Delete_Prescription_All", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo DeletePrescriptionDetailsWhenUpdate(Int32 DeleteId)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_PrescriptionDetailsWhenUpdate", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public DataTable Get_PrescriptionDetailsByPrescriptionId(int Id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@id", Id));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionDetails_ByPrescriptionId", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //#endregion



        //#region Prescriptiontype
        //public ResultInfo DeletePrescription(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", DeleteId));
        //        gSqlParameterList.Add(new SqlParameter("@DeleteBy", sessionUser));
        //        bool result = accessManager.DeleteData("sp_Delete_PrescriptionType", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}





        public DataTable GetPrescriptionTypeList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionTypeList");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable Get_PrescriptionList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_PrescriptionList", aSqlParameters);
                return dt;
            }
            catch (Exception e)
            {
                throw ;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }






        //public PrescriptionType GetPrescriptionForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        PrescriptionType master = new PrescriptionType();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_PrescriptionType_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.PrescriptionTypeId = (int)dr["PrescriptionTypeId"];
        //            master.PrescriptionTypename = dr["PrescriptionType"].ToString();

        //            master.Activedate = (DateTime)dr["ActiveInactiveDate"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        public ResultInfo SavePrescription(PrescriptionType prescription, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", prescription.PrescriptionTypeId));
                gSqlParameterList.Add(new SqlParameter("@PrescriptionType", prescription.PrescriptionTypename));

                gSqlParameterList.Add(new SqlParameter("@IsActive", prescription.IsActive));
                gSqlParameterList.Add(new SqlParameter("@Activedate", prescription.Activedate));
                if (prescription.PrescriptionTypeId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    bool result = accessManager.UpdateData("sp_Update_PrescriptionType", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = prescription.PrescriptionTypeId;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionType", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }
        //#endregion


        //#region ExpenseType

        //public ResultInfo SaveExpenseTypeMaster(ExpenseTypeMaster typeMaster, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeName", typeMaster.ExpenseTypeName));
        //        gSqlParameterList.Add(new SqlParameter("@ImageRequired", typeMaster.ImageRequired));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", typeMaster.IsActive));

        //        if (typeMaster.ExpenseTypeId > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //            bool result = accessManager.UpdateData("sp_Update_ExpenseType", gSqlParameterList);
        //            aInformation.isSuccess = result;
        //            pk = typeMaster.ExpenseTypeId;
        //            aInformation.Id = pk;
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeMaster", gSqlParameterList);
        //            //sp_Save_ExpenseTypeDetails
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //                aInformation.Id = pk;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}



        ////public ResultInfo Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster,  int sessionUser)
        ////{
        ////    int pk = 0;

        ////    ResultInfo aInformation = new ResultInfo();
        ////    try
        ////    {

        ////        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        ////        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        ////        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        ////        DateTime entryDtae = DateTime.Now;
        ////        gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeMaster.ExpenseClaimID));

        ////        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));

        ////        gSqlParameterList.Add(new SqlParameter("@ExpenseDate", typeMaster.ExpenseDate));

        ////        gSqlParameterList.Add(new SqlParameter("@EmpInfoId", typeMaster.EmpInfoId));

        ////        gSqlParameterList.Add(new SqlParameter("@Amount", typeMaster.Amount));


        ////        gSqlParameterList.Add(new SqlParameter("@Remarks", typeMaster.Remarks));

        ////        if (typeMaster.ExpenseClaimID > 0)
        ////        {
        ////            //bool result = accessManager.UpdateData("sp_Update_TerritoryData", gSqlParameterList);
        ////            //pk = masterData.TerritoryId;


        ////                aInformation.isSuccess = accessManager.UpdateData("sp_Update_ExpenseClaim", gSqlParameterList);
        ////                pk = typeMaster.ExpenseClaimID;



        ////        }
        ////        else
        ////        {
        ////            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimMaster", gSqlParameterList);

        ////        }

        ////        if (pk > 0)
        ////        {
        ////            int[] idS = masterData.ThanaId.Split(',').Select(Int32.Parse).ToArray();

        ////            for (int i = 0; i < idS.Length; i++)
        ////            {

        ////                int aId = idS[i];
        ////                List<SqlParameter> aSQL = new List<SqlParameter>();
        ////                aSQL.Add(new SqlParameter("@territroId", pk));
        ////                aSQL.Add(new SqlParameter("@thanaId", aId));
        ////                aInformation.isSuccess = accessManager.SaveData("sp_Save_TerritoryThanaRelation", aSQL);

        ////            }


        ////        }
        ////    }
        ////    catch (Exception exception)
        ////    {
        ////        accessManager.SqlConnectionClose(true);
        ////        aInformation.isSuccess = false;
        ////        aInformation.ErrorMessage = exception.Message;

        ////        throw exception;
        ////    }
        ////    finally
        ////    {
        ////        accessManager.SqlConnectionClose();
        ////    }

        ////    return aInformation;
        ////}

        //public ResultInfo Save_Prescription(PrescriptionMasterDAO typeMaster, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionId", typeMaster.PrescriptionId));

        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionDate", typeMaster.PrescriptionDate));

        //        gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", typeMaster.PrescriptionTypeId));

        //        gSqlParameterList.Add(new SqlParameter("@DoctorId", typeMaster.DoctorId));

        //        gSqlParameterList.Add(new SqlParameter("@ImageName", typeMaster.ImageName));









        //        if (typeMaster.PrescriptionId > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", typeMaster.EntryBy));
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //            bool result = accessManager.UpdateData("sp_Update_PrescriptionMaster", gSqlParameterList);
        //            aInformation.isSuccess = result;
        //            pk = typeMaster.PrescriptionId;
        //            aInformation.Id = pk;

        //            aInformation.isSuccess = true;


        //            if (typeMaster.ImageString != "")

        //            {
        //                AppPrimaryDAL app = new AppPrimaryDAL();
        //                ImagePath _path = new ImagePath();
        //                string type = "Prescription";
        //                _path = app.GetImagePath(type);




        //                //string targetPath = @"E:\ZasImage";
        //                string targetPath = @"" + _path.ImagePathValue + "";
        //                if (!Directory.Exists(targetPath))
        //                {
        //                    Directory.CreateDirectory(targetPath);
        //                }

        //                string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
        //                File.WriteAllBytes(filePath, Convert.FromBase64String(typeMaster.ImageString));
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", typeMaster.EntryBy));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionMaster", gSqlParameterList);
        //            //sp_Save_ExpenseTypeDetails
        //            if (pk > 0)
        //            {

        //                aInformation.isSuccess = true;
        //                aInformation.Id = pk;

        //                AppPrimaryDAL app = new AppPrimaryDAL();
        //                ImagePath _path = new ImagePath();
        //                string type = "Prescription";
        //                _path = app.GetImagePath(type);




        //                //string targetPath = @"E:\ZasImage";
        //                string targetPath = @"" + _path.ImagePathValue + "";
        //                if (!Directory.Exists(targetPath))
        //                {
        //                    Directory.CreateDirectory(targetPath);
        //                }

        //                string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
        //                File.WriteAllBytes(filePath, Convert.FromBase64String(typeMaster.ImageString));
        //            }
        //        }


        //        if (pk > 0)

        //        {
        //            foreach (var item in typeMaster.PrescriptionProductDetailDAOs)
        //            {
        //                ExpenseClaimDetailsDAO ADetailDao = new ExpenseClaimDetailsDAO();

        //                List<SqlParameter> gSqlParameterDetals = new List<SqlParameter>();

        //                gSqlParameterDetals.Add(new SqlParameter("@PrescriptionId", pk));
        //                gSqlParameterDetals.Add(new SqlParameter("@ProductId", item.ProductId));


        //                accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionProductDetail", gSqlParameterDetals);

        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public ResultInfo Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeMaster.ExpenseClaimID));

        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));

        //        gSqlParameterList.Add(new SqlParameter("@ExpenseDate", typeMaster.ExpenseDate));

        //        gSqlParameterList.Add(new SqlParameter("@EmpInfoId", typeMaster.EmpInfoId));

        //        gSqlParameterList.Add(new SqlParameter("@Amount", typeMaster.Amount));


        //        gSqlParameterList.Add(new SqlParameter("@Remarks", typeMaster.Remarks));






        //        if (typeMaster.ExpenseClaimID > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //            bool result = accessManager.UpdateData("sp_Update_ExpenseClaim", gSqlParameterList);
        //            aInformation.isSuccess = result;
        //            pk = typeMaster.ExpenseClaimID;
        //            aInformation.Id = pk;
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimMaster", gSqlParameterList);
        //            //sp_Save_ExpenseTypeDetails
        //            if (pk > 0)
        //            {

        //                aInformation.isSuccess = true;
        //                aInformation.Id = pk;
        //            }
        //        }


        //        if (pk > 0)

        //        {
        //            foreach (var item in typeMaster.ExpenseClaimDetailsDAOs)
        //            {
        //                ExpenseClaimDetailsDAO ADetailDao = new ExpenseClaimDetailsDAO();

        //                List<SqlParameter> gSqlParameterDetals = new List<SqlParameter>();
        //                gSqlParameterDetals.Add(new SqlParameter("@ExpenseTypDetailsId", item.ExpenseTypDetailsId));
        //                gSqlParameterDetals.Add(new SqlParameter("@ExpenseClaimID", pk));
        //                gSqlParameterDetals.Add(new SqlParameter("@ValueText", item.ValueText));


        //                accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimDetails", gSqlParameterDetals);

        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveExpenseTypeDetails(ExpenseTypeDetails typeDetails)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypDetailsId", typeDetails.ExpenseTypDetailsId));
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeDetails.ExpenseTypeId));
        //        gSqlParameterList.Add(new SqlParameter("@FieldName", typeDetails.FieldName));
        //        gSqlParameterList.Add(new SqlParameter("@IsRequied", typeDetails.IsRequied));

        //        pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeDetails", gSqlParameterList);
        //        //sp_Save_ExpenseTypeDetails
        //        if (pk > 0)
        //        {
        //            aInformation.isSuccess = true;

        //        }

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ResultInfo SaveExpenseClaimDetails(ExpenseClaimDetailsDAO typeDetails)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

        //        gSqlParameterList.Add(new SqlParameter("@ExpenseDetailId", typeDetails.ExpenseDetailId));
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypDetailsId", typeDetails.ExpenseTypDetailsId));
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeDetails.ExpenseClaimID));
        //        gSqlParameterList.Add(new SqlParameter("@ValueText", typeDetails.ValueText));


        //        pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimDetails", gSqlParameterList);
        //        //sp_Save_ExpenseTypeDetails
        //        if (pk > 0)
        //        {
        //            aInformation.isSuccess = true;

        //        }

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public DataTable Get_ExpenseTypeMasterList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseTypeMaster");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public ResultInfo Delete_ExpenseType(Int32 DeleteId)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_ExpenseType", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}

        //public ExpenseTypeMaster GetEditDataForExpenseType(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        ExpenseTypeMaster master = new ExpenseTypeMaster();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_ExpenseTypeData_ByExpenseTypeId", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.ExpenseTypeId = (int)dr["ExpenseTypeId"];
        //            master.ExpenseTypeName = dr["ExpenseTypeName"].ToString();
        //            master.ImageRequired = (bool)dr["ImageRequired"];
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //public DataTable Get_ExpenseTypeDetailsByExpenseId(int Id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@id", Id));
        //        DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseDetails_ByExpenseId", aSqlParameterlist);
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}




        //#endregion

        //#region MonthlyAllowance
        //public ResultInfo DeleteMonthlyAllowance(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@MonthlyAllowanceId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_MonthlyAllowance", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //public DataTable GetMonthlyAllowanceList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_MonthlyAllowance");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //public MonthlyAllowance GetMonthlyAllowanceForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        MonthlyAllowance master = new MonthlyAllowance();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_MonthlyAllowance_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.MonthlyAllowanceId = (int)dr["MonthlyAllowanceId"];
        //            master.MonthlyAllowanceName = (dr["MonthlyAllowanceName"].ToString());
        //            master.Allowance = Convert.ToDecimal(dr["MonthlyAllowance"].ToString());

        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);
        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //public ResultInfo SaveMonthlyAllowance(MonthlyAllowance monthlyAllowance, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@MonthlyAllowanceId", monthlyAllowance.MonthlyAllowanceId));
        //        gSqlParameterList.Add(new SqlParameter("@MonthlyAllowanceName", monthlyAllowance.MonthlyAllowanceName));
        //        gSqlParameterList.Add(new SqlParameter("@MonthlyAllowance", monthlyAllowance.Allowance));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", monthlyAllowance.IsActive));

        //        if (monthlyAllowance.MonthlyAllowanceId > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //            bool result = accessManager.UpdateData("sp_Update_MonthlyAllowance", gSqlParameterList);
        //            aInformation.isSuccess = result;
        //            pk = monthlyAllowance.MonthlyAllowanceId;
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_MonthlyAllowance", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //internal DataTable GetAllowance_For_ddl()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_Allowance_For_DDL");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //#endregion

        //#region TADAMarketRuleConfiguration
        //public ResultInfo DeleteTADAMarketRuleConfiguration(Int32 DeleteId, string sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TADAMarketRuleConfigId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_TADAMarketRulesConfig", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //public DataTable GetTADAMarketRuleConfigurationList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_TADAMarketRulesConfig");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //public TADAMarketruleConfig GeTADAMarketRuleConfigurationForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        TADAMarketruleConfig master = new TADAMarketruleConfig();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@TADAMarketRuleConfigId", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_TADAMarketRulesConfig_ByID", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.TADAMarketRuleConfigId = (int)dr["TADAMarketRuleConfigId"];
        //            master.TourType = (int)dr["TourType"];
        //            master.TAAmount = Convert.ToDecimal(dr["TAAmount"].ToString());
        //            master.DAAmount = Convert.ToDecimal(dr["DAAmount"].ToString());
        //            master.IsActive = Convert.ToBoolean(dr["IsActive"]);

        //            master.IsRoleWise = Convert.ToBoolean(dr["IsRoleWise"]);
        //            master.IsMarketWise = Convert.ToBoolean(dr["IsMarketWise"]);
        //            master.IsBoth = Convert.ToBoolean(dr["IsBoth"]);

        //            try
        //            {
        //                master.UserRoleID = (int)dr["UserRoleID"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.UserRoleID = null;
        //            }


        //            try
        //            {
        //                master.GroupId = (int)dr["GroupId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.GroupId = null;
        //            }

        //            try
        //            {
        //                master.ZoneId = (int)dr["ZoneId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.ZoneId = null;
        //            }

        //            try
        //            {
        //                master.AreaId = (int)dr["AreaId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.AreaId = null;
        //            }

        //            try
        //            {
        //                master.TerritoryId = (int)dr["TerritoryId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.TerritoryId = null;
        //            }

        //            try
        //            {
        //                master.MarketId = (int)dr["MarketId"];
        //            }
        //            catch (Exception ex)
        //            {
        //                master.MarketId = null;
        //            }

        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //public ResultInfo SaveTADAMarketRuleConfiguration(TADAMarketruleConfig tADAMarketrule, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TADAMarketRuleConfigId", tADAMarketrule.TADAMarketRuleConfigId));
        //        gSqlParameterList.Add(new SqlParameter("@TourType", tADAMarketrule.TourType));


        //        gSqlParameterList.Add(new SqlParameter("@IsRoleWise", tADAMarketrule.IsRoleWise ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@IsMarketWise", tADAMarketrule.IsMarketWise ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@IsBoth", tADAMarketrule.IsBoth ?? (object)DBNull.Value));


        //        gSqlParameterList.Add(new SqlParameter("@UserRoleID", tADAMarketrule.UserRoleID ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@GroupId", tADAMarketrule.GroupId ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@ZoneId", tADAMarketrule.ZoneId ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@AreaId", tADAMarketrule.AreaId ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@TerritoryId", tADAMarketrule.TerritoryId ?? (object)DBNull.Value));

        //        gSqlParameterList.Add(new SqlParameter("@MarketId", tADAMarketrule.MarketId ?? (object)DBNull.Value));




        //        gSqlParameterList.Add(new SqlParameter("@TAAmount", tADAMarketrule.TAAmount));


        //        gSqlParameterList.Add(new SqlParameter("@DAAmount", tADAMarketrule.DAAmount));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", tADAMarketrule.IsActive));

        //        if (tADAMarketrule.TADAMarketRuleConfigId > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

        //            aSqlParameterlist.Add(new SqlParameter("@id", tADAMarketrule.TADAMarketRuleConfigId));
        //            aSqlParameterlist.Add(new SqlParameter("@TourType", tADAMarketrule.TourType));
        //            aSqlParameterlist.Add(new SqlParameter("@UserRoleID", tADAMarketrule.UserRoleID));
        //            aSqlParameterlist.Add(new SqlParameter("@MarketId", tADAMarketrule.MarketId));
        //            aSqlParameterlist.Add(new SqlParameter("@IsRoleWise", tADAMarketrule.IsRoleWise));
        //            aSqlParameterlist.Add(new SqlParameter("@IsMarketWise", tADAMarketrule.IsMarketWise));
        //            DataTable dt = accessManager.GetDataTable("sp_check_TADAMarketRuleConfiguration", aSqlParameterlist);
        //            if (dt.Rows.Count == 0)
        //            {

        //                bool result = accessManager.UpdateData("sp_Update_TADAMarketRulesConfig", gSqlParameterList);
        //                aInformation.isSuccess = result;
        //                pk = tADAMarketrule.TADAMarketRuleConfigId;



        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;
        //            }
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TADAMarketRulesConfig", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //            else
        //            {
        //                aInformation.isSuccess = false;

        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //internal DataTable GetTADAMarketRuleConfiguration_For_ddl()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_TADAMarketRuleConfig_For_DDL");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //internal DataTable Get_UserRoleInfo()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_UserRoleInfo");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}
        //#endregion


        #region doctor Aproval


        public DataTable Get_DoctorList_Approval()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorList_Approval");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }





        //public ResultInfo ApprovalDoctorInfo(string Id, string SessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@DoctorId", Id));
        //        gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
        //        aInformation.isSuccess = accessManager.UpdateData("sp_Approve_DoctorInformation", gSqlParameterList);

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}



        #endregion


        //#region TADA Claim Approval

        //public ResultInfo ApprovalTADAClaim(string Id, string SessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TadaID", Id));
        //        gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
        //        aInformation.isSuccess = accessManager.UpdateData("sp_Approve_TADAClaim", gSqlParameterList);

        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        //#endregion

        //public DataTable Get_TADAList_For_Approval()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_TadaClaimList_Approval");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //#region Trainning

        //public ResultInfo Save_Trainning(Trainning trainning, string sessionUser)
        //{
        //    int pk = 0;
        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TrainningId", trainning.TrainningId));
        //        gSqlParameterList.Add(new SqlParameter("@Title", trainning.Title));
        //        gSqlParameterList.Add(new SqlParameter("@Description", trainning.Description));
        //        gSqlParameterList.Add(new SqlParameter("@TrainningMeterial", trainning.TrainningMeterial));
        //        gSqlParameterList.Add(new SqlParameter("@FromDate", trainning.FromDate ?? (object)DBNull.Value));
        //        gSqlParameterList.Add(new SqlParameter("@ToDate", trainning.ToDate ?? (object)DBNull.Value));
        //        gSqlParameterList.Add(new SqlParameter("@IsActive", true));

        //        if (trainning.TrainningId > 0)
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
        //            aInformation.isSuccess = accessManager.UpdateData("sp_Update_Trainning", gSqlParameterList);
        //            pk = trainning.TrainningId;
        //        }
        //        else
        //        {
        //            gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_Trainning", gSqlParameterList);
        //            if (pk > 0)
        //            {
        //                aInformation.isSuccess = true;
        //            }
        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {

        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}



        //public DataTable GetTranningList()
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        DataTable dt = accessManager.GetDataTable("sp_Get_Trainninglist");
        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}



        //public ResultInfo Delete_trainning(Int32 DeleteId)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@TrainningId", DeleteId));

        //        bool result = accessManager.DeleteData("sp_Delete_Trainning", gSqlParameterList);
        //        pk = DeleteId;
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        aInformation.isSuccess = true;
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}


        //public Trainning GetTrainningForEdit(int id)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        Trainning master = new Trainning();
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();
        //        aSqlParameters.Add(new SqlParameter("@id", id));
        //        SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Trainning_ById", aSqlParameters);
        //        while (dr.Read())
        //        {
        //            master.TrainningId = (int)dr["TrainningId"];
        //            master.Title = dr["Title"].ToString();
        //            master.Description = dr["Description"].ToString();
        //            master.TrainningMeterial = (dr["TrainningMeterial"].ToString());

        //            try
        //            {
        //                master.FromDate = Convert.ToDateTime(dr["FromDate"].ToString());
        //            }
        //            catch (Exception ex)
        //            {
        //                master.FromDate = null;
        //            }


        //            try
        //            {
        //                master.ToDate = Convert.ToDateTime(dr["ToDate"].ToString());
        //            }
        //            catch (Exception ex)
        //            {
        //                master.ToDate = null;
        //            }

        //        }
        //        return master;
        //    }
        //    catch (Exception exception)
        //    {
        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}

        //#endregion

        #region ExpenseType


        public ResultInfo delExpensDetls(string typeMaster)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster));

                bool result = accessManager.UpdateData("sp_ExpenseTypeDtl", gSqlParameterList);
                aInformation.isSuccess = result;
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }
            return aInformation;

        }

        public ResultInfo SaveExpenseTypeMaster(ExpenseTypeMaster typeMaster, List<ExpenseTypeDetails> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeName", typeMaster.ExpenseTypeName));
                gSqlParameterList.Add(new SqlParameter("@ImageRequired", typeMaster.ImageRequired));
                gSqlParameterList.Add(new SqlParameter("@IsActive", typeMaster.IsActive));
                gSqlParameterList.Add(new SqlParameter("@ExpenseAmount", typeMaster.ExpenseAmount ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@isFixed", typeMaster.isFixed ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RoleType_xp", typeMaster.RoleType_xp ?? (object)DBNull.Value));


                gSqlParameterList.Add(new SqlParameter("@EmpNameMult", typeMaster.EmpNameMult ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RoleTypeMult", typeMaster.RoleTypeMult ?? (object)DBNull.Value));


                if (typeMaster.ExpenseTypeId > 0)
                {
                   

                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();


                    aSqlParameterlist.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));
                    aSqlParameterlist.Add(new SqlParameter("@ExpenseTypeName", typeMaster.ExpenseTypeName));
                    DataTable dt = accessManager.GetDataTable("sp_check_ExpenseType", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        if (typeMaster.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", typeMaster.ExpenseTypeId));
                            aSqlprm.Add(new SqlParameter("@PageName", "ExpenseTypeName"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

                                bool result = accessManager.UpdateData("sp_Update_ExpenseType", gSqlParameterList);
                                aInformation.isSuccess = result;
                                pk = typeMaster.ExpenseTypeId;
                                aInformation.Id = pk;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                        }
                        else
                        {
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

                            bool result = accessManager.UpdateData("sp_Update_ExpenseType", gSqlParameterList);
                            aInformation.isSuccess = result;
                            pk = typeMaster.ExpenseTypeId;
                            aInformation.Id = pk;
                        }

                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeMaster", gSqlParameterList);
                    //sp_Save_ExpenseTypeDetails
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                        aInformation.Id = pk;
                    }
                }

                
                    if (pk > 0)
                    {
                    if (aInformation.isSuccess)
                    {
                        foreach (var item in _Dtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();


                            aSQL.Add(new SqlParameter("@ExpenseTypDetailsId", item.ExpenseTypDetailsId));
                            aSQL.Add(new SqlParameter("@ExpenseTypeId", pk));
                            aSQL.Add(new SqlParameter("@FieldName", item.FieldName));
                            aSQL.Add(new SqlParameter("@IsRequied", item.IsRequied));
                            //if (item.ExpenseTypDetailsId > 0)
                            //{
                            //    //pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeDetails", gSqlParameterList);
                            //    bool result = accessManager.UpdateData("sp_Update_ExpenseTypeDetails", aSQL);
                            //}
                            //else
                            //{
                                accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeDetails", aSQL);

                            ////}

                        }
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {

                }
               
                 
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

  public ResultInfo SaveTPOtherMaster(TourPurposeOtherSetup typeMaster, List<TourPurposeOtherSetupDtl> _Dtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TourPurposeOtherSetupId", typeMaster.TourPurposeOtherSetupId)); 
                gSqlParameterList.Add(new SqlParameter("@IsActive", typeMaster.IsActive));
                gSqlParameterList.Add(new SqlParameter("@TourPurposeId", typeMaster.TourPurposeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@VisitTypeId", typeMaster.VisitTypeId ?? (object)DBNull.Value)); 
                if (typeMaster.TourPurposeOtherSetupId > 0)
                {
                   

                    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();


                    //aSqlParameterlist.Add(new SqlParameter("@ExpenseTypeId", typeMaster.TourPurposeOtherSetupId));
                    //aSqlParameterlist.Add(new SqlParameter("@TourPurposeId", typeMaster.TourPurposeId));
                    //DataTable dt = accessManager.GetDataTable("sp_check_ExpenseType", aSqlParameterlist);
                    //if (dt.Rows.Count == 0)
                    //{
                    //    if (typeMaster.IsActive == false)
                    //    {
                    //        List<SqlParameter> aSqlprm = new List<SqlParameter>();
                    //        aSqlprm.Add(new SqlParameter("@MasterId", typeMaster.ExpenseTypeId));
                    //        aSqlprm.Add(new SqlParameter("@PageName", "ExpenseTypeName"));
                    //        DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                    //        if (dtMarket.Rows.Count == 0)
                    //        {
                    //            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

                    //            bool result = accessManager.UpdateData("sp_Update_ExpenseType", gSqlParameterList);
                    //            aInformation.isSuccess = result;
                    //            pk = typeMaster.ExpenseTypeId;
                    //            aInformation.Id = pk;
                    //        }
                    //        else
                    //        {
                    //            aInformation.isValiCheck = true;
                    //        }
                    //    }
                    //    else
                    //    {
                    //        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));

                    //        bool result = accessManager.UpdateData("sp_Update_ExpenseType", gSqlParameterList);
                    //        aInformation.isSuccess = result;
                    //        pk = typeMaster.ExpenseTypeId;
                    //        aInformation.Id = pk;
                    //    }

                    //}
                    //else
                    //{
                    //    aInformation.isDuplicateCheck = true;
                    //}
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("spInsertTourPurposeOtherSetup", gSqlParameterList);
                    //sp_Save_ExpenseTypeDetails
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                        aInformation.Id = pk;
                    }
                }

                
                    if (pk > 0)
                    {
                    if (aInformation.isSuccess)
                    {
                        foreach (var item in _Dtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();

 
                            aSQL.Add(new SqlParameter("@TourPurposeOtherSetupId", pk));
                            aSQL.Add(new SqlParameter("@RoleName", item.RoleName ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TourTypeId", item.TourTypeId ?? (object)DBNull.Value));


                            aInformation.isSuccess = accessManager.SaveData("spInsertTourPurposeOtherSetupDtl", aSQL);

                          

                        }
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {

                }
               
                 
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }



        //public ResultInfo Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster,  int sessionUser)
        //{
        //    int pk = 0;

        //    ResultInfo aInformation = new ResultInfo();
        //    try
        //    {

        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
        //        List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
        //        DateTime entryDtae = DateTime.Now;
        //        gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeMaster.ExpenseClaimID));

        //        gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));

        //        gSqlParameterList.Add(new SqlParameter("@ExpenseDate", typeMaster.ExpenseDate));

        //        gSqlParameterList.Add(new SqlParameter("@EmpInfoId", typeMaster.EmpInfoId));

        //        gSqlParameterList.Add(new SqlParameter("@Amount", typeMaster.Amount));


        //        gSqlParameterList.Add(new SqlParameter("@Remarks", typeMaster.Remarks));

        //        if (typeMaster.ExpenseClaimID > 0)
        //        {
        //            //bool result = accessManager.UpdateData("sp_Update_TerritoryData", gSqlParameterList);
        //            //pk = masterData.TerritoryId;


        //                aInformation.isSuccess = accessManager.UpdateData("sp_Update_ExpenseClaim", gSqlParameterList);
        //                pk = typeMaster.ExpenseClaimID;



        //        }
        //        else
        //        {
        //            pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimMaster", gSqlParameterList);

        //        }

        //        if (pk > 0)
        //        {
        //            int[] idS = masterData.ThanaId.Split(',').Select(Int32.Parse).ToArray();

        //            for (int i = 0; i < idS.Length; i++)
        //            {

        //                int aId = idS[i];
        //                List<SqlParameter> aSQL = new List<SqlParameter>();
        //                aSQL.Add(new SqlParameter("@territroId", pk));
        //                aSQL.Add(new SqlParameter("@thanaId", aId));
        //                aInformation.isSuccess = accessManager.SaveData("sp_Save_TerritoryThanaRelation", aSQL);

        //            }


        //        }
        //    }
        //    catch (Exception exception)
        //    {
        //        accessManager.SqlConnectionClose(true);
        //        aInformation.isSuccess = false;
        //        aInformation.ErrorMessage = exception.Message;

        //        throw exception;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }

        //    return aInformation;
        //}
        public Transport GetTransportForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Transport master = new Transport();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_Transport_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.TransportId = (int)dr["TransportId"];
                    master.TransportName = dr["TransportName"].ToString();
                    master.AllowedMilagePerKM = Convert.ToDecimal(dr["AllowedMilagePerKM"].ToString());

                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetTransportList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_Transport");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public ResultInfo SaveTransport(Transport transport, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@TransportId", transport.TransportId));
                gSqlParameterList.Add(new SqlParameter("@TransportName", transport.TransportName));
                gSqlParameterList.Add(new SqlParameter("@AllowedMilagePerKM", transport.AllowedMilagePerKM));
                gSqlParameterList.Add(new SqlParameter("@IsActive", transport.IsActive));

                if (transport.TransportId > 0)
                {

                    aSqlParameterlist.Add(new SqlParameter("@TransportId", transport.TransportId));
                    aSqlParameterlist.Add(new SqlParameter("@TransportName", transport.TransportName));
                    DataTable dt = accessManager.GetDataTable("sp_check_Transport", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        if (transport.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", transport.TransportId));
                            aSqlprm.Add(new SqlParameter("@PageName", "Transport"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                                bool result = accessManager.UpdateData("sp_Update_Transport", gSqlParameterList);
                                aInformation.isSuccess = result;
                                pk = transport.TransportId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                        }
                        else
                        {
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                            bool result = accessManager.UpdateData("sp_Update_Transport", gSqlParameterList);
                            aInformation.isSuccess = result;
                            pk = transport.TransportId;
                        }
                       
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_Transport", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isDuplicateCheck = true;

                    }
                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }
        public ResultInfo Save_Prescription(PrescriptionMasterDAO typeMaster, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@PrescriptionId", typeMaster.PrescriptionId));

                gSqlParameterList.Add(new SqlParameter("@PrescriptionDate", typeMaster.PrescriptionDate));

                gSqlParameterList.Add(new SqlParameter("@PrescriptionTypeId", typeMaster.PrescriptionTypeId));

                gSqlParameterList.Add(new SqlParameter("@DoctorId", typeMaster.DoctorId));
                gSqlParameterList.Add(new SqlParameter("@ChemberId", typeMaster.ChemberId));

                gSqlParameterList.Add(new SqlParameter("@ImageName", typeMaster.ImageName));









                if (typeMaster.PrescriptionId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", typeMaster.EntryBy));
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    bool result = accessManager.UpdateData("sp_Update_PrescriptionMaster", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = typeMaster.PrescriptionId;
                    aInformation.Id = pk;

                    aInformation.isSuccess = true;


                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", typeMaster.EntryBy));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionMaster", gSqlParameterList);
                    //sp_Save_ExpenseTypeDetails
                    if (pk > 0)
                    {

                        aInformation.isSuccess = true;
                        aInformation.Id = pk;
 
                    }
                }


                if (pk > 0)

                {


                    if (typeMaster.ImageString != "")

                    {
                        AppPrimaryDAL app = new AppPrimaryDAL();
                        ImagePath _path = new ImagePath();
                        string type = "Prescription";
                        _path = app.GetImagePath(type);




                        //string targetPath = @"E:\ZasImage";
                        string targetPath = @"" + _path.ImagePathValue + "";
                        if (!Directory.Exists(targetPath))
                        {
                            Directory.CreateDirectory(targetPath);
                        }

                        string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
                        File.WriteAllBytes(filePath, Convert.FromBase64String(typeMaster.ImageString));
                    }
                    foreach (var item in typeMaster.PrescriptionProductDetailDAOs)
                    {
                        ExpenseClaimDetailsDAO ADetailDao = new ExpenseClaimDetailsDAO();

                        List<SqlParameter> gSqlParameterDetals = new List<SqlParameter>();

                        gSqlParameterDetals.Add(new SqlParameter("@PrescriptionId", pk));
                        gSqlParameterDetals.Add(new SqlParameter("@ProductId", item.ProductId));


                        accessManager.SaveDataReturnPrimaryKey("sp_Save_PrescriptionProductDetail", gSqlParameterDetals);

                    }
                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }


        public ResultInfo Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeMaster.ExpenseClaimID));

                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeMaster.ExpenseTypeId));

                gSqlParameterList.Add(new SqlParameter("@ExpenseDate", typeMaster.ExpenseDate));

                gSqlParameterList.Add(new SqlParameter("@EmpInfoId", typeMaster.EmpInfoId));

                gSqlParameterList.Add(new SqlParameter("@Amount", typeMaster.Amount));


                gSqlParameterList.Add(new SqlParameter("@Remarks", typeMaster.Remarks));






                if (typeMaster.ExpenseClaimID > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    bool result = accessManager.UpdateData("sp_Update_ExpenseClaim", gSqlParameterList);
                    aInformation.isSuccess = result;
                    pk = typeMaster.ExpenseClaimID;
                    aInformation.Id = pk;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimMaster", gSqlParameterList);
                    //sp_Save_ExpenseTypeDetails
                    if (pk > 0)
                    {

                        aInformation.isSuccess = true;
                        aInformation.Id = pk;
                    }
                }


                if (pk > 0)

                {
                    foreach (var item in typeMaster.ExpenseClaimDetailsDAOs)
                    {
                        ExpenseClaimDetailsDAO ADetailDao = new ExpenseClaimDetailsDAO();

                        List<SqlParameter> gSqlParameterDetals = new List<SqlParameter>();
                        gSqlParameterDetals.Add(new SqlParameter("@ExpenseTypDetailsId", item.ExpenseTypDetailsId));
                        gSqlParameterDetals.Add(new SqlParameter("@ExpenseClaimID", pk));
                        gSqlParameterDetals.Add(new SqlParameter("@ValueText", item.ValueText));


                        accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimDetails", gSqlParameterDetals);

                    }
                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ResultInfo SaveExpenseTypeDetails(ExpenseTypeDetails typeDetails)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypDetailsId", typeDetails.ExpenseTypDetailsId));
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", typeDetails.ExpenseTypeId));
                gSqlParameterList.Add(new SqlParameter("@FieldName", typeDetails.FieldName));
                gSqlParameterList.Add(new SqlParameter("@IsRequied", typeDetails.IsRequied));
                if (typeDetails.ExpenseTypDetailsId > 0)
                {
                    //pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeDetails", gSqlParameterList);
                    bool result = accessManager.UpdateData("sp_Update_ExpenseTypeDetails", gSqlParameterList);
                }
                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseTypeDetails", gSqlParameterList);

                }
                //sp_Save_ExpenseTypeDetails
                if (pk > 0)
                {
                    aInformation.isSuccess = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ResultInfo SaveExpenseClaimDetails(ExpenseClaimDetailsDAO typeDetails)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                gSqlParameterList.Add(new SqlParameter("@ExpenseDetailId", typeDetails.ExpenseDetailId));
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypDetailsId", typeDetails.ExpenseTypDetailsId));
                gSqlParameterList.Add(new SqlParameter("@ExpenseClaimID", typeDetails.ExpenseClaimID));
                gSqlParameterList.Add(new SqlParameter("@ValueText", typeDetails.ValueText));


                pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ExpenseClaimDetails", gSqlParameterList);
                //sp_Save_ExpenseTypeDetails
                if (pk > 0)
                {
                    aInformation.isSuccess = true;

                }

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_ExpenseTypeMasterList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseTypeMaster");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public ResultInfo Delete_ExpenseType(Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ExpenseTypeId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_ExpenseType", gSqlParameterList);
                pk = DeleteId;
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;

                throw exception;
            }
            finally
            {
                aInformation.isSuccess = true;
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public ExpenseTypeMaster GetEditDataForExpenseType(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ExpenseTypeMaster master = new ExpenseTypeMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_ExpenseTypeData_ByExpenseTypeId", aSqlParameters);
                while (dr.Read())
                {
                    master.ExpenseTypeId = (int)dr["ExpenseTypeId"];
                    master.ExpenseTypeName = dr["ExpenseTypeName"].ToString();
                    master.ImageRequired = (bool)dr["ImageRequired"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable GetEditDataForId(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ExpenseTypeMaster master = new ExpenseTypeMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseTypeData_ByExpenseTypeId", aSqlParameters);
                
                return dt;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        
        public DataTable GetEditDataForTPOtherId(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ExpenseTypeMaster master = new ExpenseTypeMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPurposeOtherSetupId", aSqlParameters);
                
                return dt;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable checkFroDelete(int? Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlprm = new List<SqlParameter>();
        aSqlprm.Add(new SqlParameter("@MasterId", Id));
                            aSqlprm.Add(new SqlParameter("@PageName", "ExpenseType"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                return dtMarket;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }



        public DataTable Get_ExpenseTypeDetailsByExpenseId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseDetails_ByExpenseId", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }




        #endregion
        public DataTable GetExpenseClaimList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@param", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_ExpenseClaimList", aSqlParameters);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_UserRoleInfo()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_UserRoleInfo");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_StationTypeInfo()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_GET_StationTypeListAll");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable Get_TourPurposeInfo()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPurposeDDL");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        
        public DataTable Get_TourPurposeInfoNew()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPurposeDDLNew");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        
        public DataTable Get_TourPlanTypeDDL()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_TourPlanTypeDDL");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
    }
}
