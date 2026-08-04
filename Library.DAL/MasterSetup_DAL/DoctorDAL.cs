using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.MasterSetup_DAL
{
 public   class DoctorDAL
    {

        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable GetDoctorSetupById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_DoctorMaster_ById", aSqlParameterlist);
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

        public DataTable GetContactById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_DoctorContactDetail_ById", aSqlParameterlist);
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


        public DataTable GetSpecialDayById(string Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));

                DataTable dt = accessManager.GetDataTable("sp_GET_DoctorSpecialDayDetail_ById", aSqlParameterlist);
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
        public ResultInfo ApprovalCustomerListInfo(string Id, string rbValue, string SessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@CustomerMasterId", Id));
                gSqlParameterList.Add(new SqlParameter("@ApprovedBy", SessionUser));
                gSqlParameterList.Add(new SqlParameter("@Status", rbValue));
                aInformation.isSuccess = accessManager.UpdateData("sp_ApproveCustomerInformation", gSqlParameterList);

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


        public ResultInfo SaveInfo(DoctorMasterDAO master, string DegreeArray, string SpecialityArray, string BrandSelectArray, List<DoctorChemberDetailDAO> _ChamberDtls, List<DoctorSpecialDayDAO> _SpecialDay, List<DoctorContactDetailDAO> _ContactDtls,  string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@DoctorId", master.DoctorId));
                gSqlParameterList.Add(new SqlParameter("@DoctorName", master.DoctorName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@SecondaryCode", master.SecondaryCode ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@UPCode", master.UPCode ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DesignationId", master.DesignationId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Gender", master.Gender ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DoctorTypeId", master.DoctorTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Reamrks", master.Reamrks ?? (object)DBNull.Value));
            
                gSqlParameterList.Add(new SqlParameter("@MarketId", master.MarketId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@StationTypeId", master.StationTypeId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ProgramTypeId", master.ProgramTypeId ?? (object)DBNull.Value));
                 
                gSqlParameterList.Add(new SqlParameter("@IsActive", master.IsActive ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Activedate", master.Activedate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@InactiveDate", master.InactiveDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DivisionId", master.DivisionId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DistrictId", master.DistrictId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ThanaId", master.ThanaId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@UnionName", master.UnionName ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@DoctorCategoryId", master.DoctorCategoryId ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@SMCTypeId", master.SMCTypeId ?? (object)DBNull.Value));


                if (master.DoctorId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_DoctorMaster", gSqlParameterList);

                    pk = master.DoctorId;

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DoctorMaster", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;

                    }
                }

                if (aInformation.isSuccess)
                {

                    if (pk > 0)
                    {
                        foreach (var item in _ChamberDtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@DoctorId", pk));
                            aSQL.Add(new SqlParameter("@ChamberTypeId", item.ChamberTypeId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Name", item.Name ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Address", item.Address ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Phone", item.Phone ?? (object)DBNull.Value));


                            aInformation.isSuccess = accessManager.SaveData("sp_Save_BDoctorChemberDetail", aSQL);

                        }

                        if (DegreeArray != "")
                        {
                            string[] degreeList = DegreeArray.Split(',');

                            foreach (String item in degreeList)
                            {
                                if (item != "")
                                {
                                    List<SqlParameter> aSQL = new List<SqlParameter>();
                                    aSQL.Add(new SqlParameter("@DoctorId", pk));
                                    aSQL.Add(new SqlParameter("@DegId", item ?? (object)DBNull.Value));
                                    aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorDegreeDetail", aSQL);
                                }
                            }



                        }


                        if (SpecialityArray != "")
                        {
                            string[] SpecialityList = SpecialityArray.Split(',');

                            foreach (String item in SpecialityList)
                            {
                                if (item != "")
                                {
                                    List<SqlParameter> aSQL = new List<SqlParameter>();
                                    aSQL.Add(new SqlParameter("@DoctorId", pk));
                                    aSQL.Add(new SqlParameter("@SpecialityId", item ?? (object)DBNull.Value));
                                    aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorSpecialityDetail", aSQL);
                                }
                            }

                        }


                        if (BrandSelectArray != "")
                        {
                            string[] BrandList = BrandSelectArray.Split(',');

                            foreach (String item in BrandList)
                            {
                                if (item != "")
                                {
                                    List<SqlParameter> aSQL = new List<SqlParameter>();
                                    aSQL.Add(new SqlParameter("@DoctorId", pk));
                                    aSQL.Add(new SqlParameter("@BrandId", item ?? (object)DBNull.Value));
                                    aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorBrandDetail", aSQL);
                                }
                            }


                        }

                        foreach (var item in _ContactDtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@DoctorId", pk));
                            aSQL.Add(new SqlParameter("@ContactTypeId", item.ContactTypeId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@ContactType", item.ContactType ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@Contact", item.Contact ?? (object)DBNull.Value));



                            aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorContactDetail_New", aSQL);

                        }

                        foreach (var item in _SpecialDay)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@DoctorId", pk));
                            aSQL.Add(new SqlParameter("@SpecialDayId", item.SpecialDayId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@SpecialDate", item.SpecialDate ?? (object)DBNull.Value));
                            



                            aInformation.isSuccess = accessManager.SaveData("sp_Save_DoctorSpecialDayDetails", aSQL);

                        }

                        //foreach (var item in _ChamberDtls)
                        //{

                        //    List<SqlParameter> aSQL = new List<SqlParameter>();
                        //    aSQL.Add(new SqlParameter("@DoctorId", pk));
                        //    aSQL.Add(new SqlParameter("@ChamberTypeId", item.ChamberTypeId ?? (object)DBNull.Value));
                        //    aSQL.Add(new SqlParameter("@Name", item.Name ?? (object)DBNull.Value));
                        //    aSQL.Add(new SqlParameter("@Address", item.Address ?? (object)DBNull.Value));
                        //    aSQL.Add(new SqlParameter("@Phone", item.Phone ?? (object)DBNull.Value));


                        //    aInformation.isSuccess = accessManager.SaveData("sp_Save_BDoctorChemberDetail", aSQL);

                        //}


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

        public ResultInfo SaveDoctor_ApplogDAL(SaveDoctorAppLog_DAO atten)
        {
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@DoctorApprovalId", atten.DoctorApprovalId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Date", atten.Date ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@FromEmpId", atten.FromEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToEmpId", atten.ToEmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TableId", atten.TableId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Status", atten.Status ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Comments", atten.Comments ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Type", atten.Type ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Step", atten.Step ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@GroupId", atten.GroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@RegionId", atten.RegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AreaId", atten.AreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@TerritoryId", atten.TerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@ToGroupId", atten.ToGroupId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToRegionId", atten.ToRegionId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToAreaId", atten.ToAreaId ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToTerritoryId", atten.ToTerritoryId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByS", atten.EntryByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateS", atten.EntryDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeS", atten.EntryTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByS", atten.ApproveByS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateS", atten.ApproveDateS ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeS", atten.ApproveTimeS ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@EntryByApp", atten.EntryByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryDateApp", atten.EntryDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryTimeApp", atten.EntryTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveByApp", atten.ApproveByApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveDateApp", atten.ApproveDateApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ApproveTimeApp", atten.ApproveTimeApp ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@MenuId", atten.MenuId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                aInformation.isSuccess = accessManager.SaveData("sp_webapi_SaveDoctorAppLog", gSqlParameterList);

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

        public DataTable GetDoctor_ApplogDAL(string pram, string Role, string AppStatus, DateTime? FromDt, DateTime? ToDt, int? EmpId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@param", pram ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Role", Role ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AppStatus", AppStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@FromDt", FromDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDt", ToDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", EmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));


                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorClaimApp", gSqlParameterList);
                //SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_DoctorClaimApp", gSqlParameterList);
                return dt;
                //DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_AttendanceInformation", gSqlParameterList);
                //return dt;
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

        public DataTable GetDoctorList(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorList", aSqlParameterlist);
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


        public DataTable GetDoctorTransferList(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_DoctorTranferApprovalList", aSqlParameterlist);
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


        //public DataTable GetDoctorList(string Parm)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //        aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

        //        DataTable dt = accessManager.GetDataTable("sp_Get_DoctorList", aSqlParameterlist);
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

        public DataTable GetDoctorApprovalList(string pram, string Role, string AppStatus, DateTime? FromDt, DateTime? ToDt, string EmpId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                gSqlParameterList.Add(new SqlParameter("@param", pram ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Role", Role ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@AppStatus", AppStatus ?? (object)DBNull.Value ?? (object)DBNull.Value));

                gSqlParameterList.Add(new SqlParameter("@FromDt", FromDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDt", ToDt ?? (object)DBNull.Value ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EmpId", EmpId ?? (object)DBNull.Value ?? (object)DBNull.Value));

                DataTable dt = accessManager.GetDataTable("sp_Webapi_Get_DoctorClaimApp", gSqlParameterList);
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
