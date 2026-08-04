using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace Library.DAL.DoctorVisit_DAL
{
 public   class NoticeDal
    {

        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo SaveNotice(NoticeMaster master, string _ProLineArray, List<BonusCampaignMarketDetailDAO> _MarketDtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@NoticeId", master.NoticeId));
                gSqlParameterList.Add(new SqlParameter("@NoticeTitle", master.NoticeTitle));
                gSqlParameterList.Add(new SqlParameter("@Announcement", master.Announcement));
                gSqlParameterList.Add(new SqlParameter("@FromDate", master.FromDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@ToDate", master.ToDate ?? (object)DBNull.Value));

                if (master.NoticeId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_NoticeMaster", gSqlParameterList);

                    pk = master.NoticeId;

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NoticeMaster", gSqlParameterList);

                }

                if (pk > 0)
                {
                    aInformation.isSuccess = true;
                    if (aInformation.isSuccess)
                    {

                        foreach (var item in _MarketDtls)
                        {

                            List<SqlParameter> aSQL = new List<SqlParameter>();
                            aSQL.Add(new SqlParameter("@NoticeId", pk));
                            aSQL.Add(new SqlParameter("@GroupId", item.GroupId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@RegionId", item.RegionId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@AreaId", item.AreaId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@SubTerritoryId", item.SubTerritoryId ?? (object)DBNull.Value));
                            aSQL.Add(new SqlParameter("@MarketId", item.MarketId ?? (object)DBNull.Value));

                            aInformation.isSuccess = accessManager.SaveData("sp_Save_Notice_MarketDetail", aSQL);

                        }

                        if (_ProLineArray != "")
                        {
                            string[] ProLine = _ProLineArray.Split(',');

                            foreach (String item in ProLine)
                            {
                                if (item != "")
                                {
                                    List<SqlParameter> aSQL = new List<SqlParameter>();
                                    aSQL.Add(new SqlParameter("@NoticeId", pk));
                                    aSQL.Add(new SqlParameter("@UserRoleID", item ?? (object)DBNull.Value));
                                    aInformation.isSuccess = accessManager.SaveData("sp_Save_NoticeUserRoleDetail", aSQL);
                                }
                            }



                        }


                        if (master.ImageString != "")

                        {
                            AppPrimaryDAL app = new AppPrimaryDAL();
                            ImagePath _path = new ImagePath();
                            string type = "Notice";
                            _path = app.GetImagePath(type);




                            //string targetPath = @"E:\ZasImage";
                            string targetPath = @"" + _path.ImagePathValue + "";
                            if (!Directory.Exists(targetPath))
                            {
                                Directory.CreateDirectory(targetPath);
                            }

                            string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
                            File.WriteAllBytes(filePath, Convert.FromBase64String(master.ImageString));
                        }
                        //foreach (var item in master.NoticeMarketDetails)
                        //{
                        //    NoticeMarketDetails ADetailDao = new NoticeMarketDetails();
                        //    ADetailDao.NoticeId = pk;
                        //    ADetailDao.GroupId = item.GroupId;
                        //    ADetailDao.RegionId = item.RegionId;
                        //    ADetailDao.AreaId = item.AreaId;
                        //    ADetailDao.TerritoryId = item.TerritoryId;
                        //    ADetailDao.MarketId = item.MarketId;

                        //    List<SqlParameter> aSQL = new List<SqlParameter>();
                        //    aSQL.Add(new SqlParameter("@NoticeDetailsId", ADetailDao.NoticeDetailsId));
                        //    aSQL.Add(new SqlParameter("@NoticeId", ADetailDao.NoticeId));
                        //    aSQL.Add(new SqlParameter("@GroupId", ADetailDao.GroupId));
                        //    aSQL.Add(new SqlParameter("@RegionId", ADetailDao.RegionId));
                        //    aSQL.Add(new SqlParameter("@AreaId", ADetailDao.AreaId));
                        //    aSQL.Add(new SqlParameter("@TerritoryId", ADetailDao.TerritoryId));
                        //    aSQL.Add(new SqlParameter("@MarketId", ADetailDao.MarketId));
                        //    aInformation.isSuccess = accessManager.SaveData("sp_Save_NoticeDetails", aSQL);

                        //}
                    }

                     
                        if (master.file != null)
                        {


                            AppPrimaryDAL app = new AppPrimaryDAL();
                            ImagePath _path = new ImagePath();
                            string type = "Image";
                            _path = app.GetImagePath(type);




                            //string targetPath = @"E:\ZasImage";
                            string targetPath = @"" + _path.ImagePathValue + "";
                            if (!Directory.Exists(targetPath))
                            {
                                Directory.CreateDirectory(targetPath);
                            }

                            string filePath = targetPath + "/" + _path.ImagePreName + pk + "." + "jpg";
                            File.WriteAllBytes(filePath, Convert.FromBase64String(master.file));

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





        public bool SaveImage(string path, string name, int id, int ImageId)
        {
            bool status = false;
            string meesage = "";

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", ImageId));
                gSqlParameterList.Add(new SqlParameter("@NoticeId", id));
                gSqlParameterList.Add(new SqlParameter("@ImageName", name));
                gSqlParameterList.Add(new SqlParameter("@ImagePath", path));
                status = accessManager.SaveData("sp_Save_NoticeImage", gSqlParameterList, false);
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                status = false;
                meesage = exception.Message;

                throw exception;
            }
            finally
            {


                accessManager.SqlConnectionClose();
            }

            return status;
        }




        public ResultInfo SaveNoticeImage(string path, string name, int id)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", 0));
                gSqlParameterList.Add(new SqlParameter("@NoticeImageId", id));
                gSqlParameterList.Add(new SqlParameter("@ImageName", name));
                gSqlParameterList.Add(new SqlParameter("@ImagePath", path));

                pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NoticeImage", gSqlParameterList);
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


        public DataTable GetNoticeMasterList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_NoticeMaster");
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


        public bool Delete_NoticeImage(int Id)
        {
            bool status = false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> sqlParameters = new List<SqlParameter>();
                sqlParameters.Add(new SqlParameter("@NoticeId", Id));
                status = accessManager.DeleteData("sp_DEL_NoticeImage", sqlParameters);
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return status;
        }

        public ResultInfo Delete_NoticeMaster(Int32 DeleteId)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NoticeId", DeleteId));

                bool result = accessManager.DeleteData("sp_Delete_NoticeMaster", gSqlParameterList);
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


        public NoticeMaster GetNoticeMasterForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                NoticeMaster master = new NoticeMaster();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_NoticeMaster_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.NoticeId = (int)dr["NoticeId"];
                    master.NoticeTitle = dr["NoticeTitle"].ToString();
                    master.Announcement = dr["Announcement"].ToString();
                    try
                    {
                        master.FromDate = (DateTime)dr["FromDate"];
                    }
                    catch(Exception ex)
                    {
                        master.FromDate = null;
                    }
                    try
                    {
                        master.ToDate = (DateTime)dr["ToDate"];
                    }
                    catch(Exception ex)
                    {
                        master.ToDate = null;
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


        public DataTable Get_NoticeImageByNoticeId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_NoticeImage_By_NoticeId", aSqlParameterlist);
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


        public DataTable Get_NoticeDetailsByNoticeId(int Id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@id", Id));
                DataTable dt = accessManager.GetDataTable("sp_Get_Noticedetails_By_NoticeId", aSqlParameterlist);
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
 