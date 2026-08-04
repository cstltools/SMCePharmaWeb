using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.Panal_Entities;

namespace Library.DAL.Panal_DAL
{
  public class PanalDAL
    {
      ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
      public bool MenuSaveDal(ObjPanal aObjPanal)
      {
          string query = @"INSERT INTO dbo.tblMainMenu (SL, ManuName, URL, ParantId)
                           VALUES (@SL, @ManuName, @URL, @ParantId)";
          return aCommonInternalDal.SaveDataByInsertCommand(query, new List<SqlParameter>
          {
              new SqlParameter("@SL", aObjPanal.SL),
              new SqlParameter("@ManuName", DbValue(aObjPanal.ManuName)),
              new SqlParameter("@URL", DbValue(aObjPanal.URL)),
              new SqlParameter("@ParantId", DbValue(aObjPanal.ParantId))
          }, "SSIDB");
      }


      public bool MenuPermissionRemove(int sl, int userId)
      {
          string parantId = Convert.ToString(sl);
          string query = @"DELETE dbo.tblMenuDistribution WHERE MenuSL IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @SL) AND UserId = @UserId";
          string query1 = @"DELETE dbo.tblMenuDistribution WHERE MenuSL IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId = @ParantId) AND UserId = @UserId";
          string query2 = @"DELETE dbo.tblMenuDistribution WHERE MenuSL IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId = @ParantId)) AND UserId = @UserId";
          string query3 = @"DELETE dbo.tblMenuDistribution WHERE MenuSL IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE ParantId = @ParantId))) AND UserId = @UserId";

          bool ok = aCommonInternalDal.UpdateDataByUpdateCommandNew(query, MenuPermissionParameters(sl, userId, parantId));
          bool ok1 = aCommonInternalDal.UpdateDataByUpdateCommandNew(query1, MenuPermissionParameters(sl, userId, parantId));
          bool ok2 = aCommonInternalDal.UpdateDataByUpdateCommandNew(query2, MenuPermissionParameters(sl, userId, parantId));
          bool ok3 = aCommonInternalDal.UpdateDataByUpdateCommandNew(query3, MenuPermissionParameters(sl, userId, parantId));

          return true;
      }



      public void MainMenuDropDown(DropDownList aDropDownList)
      {
          string query = "select * from tblMainMenu where ParantId is null or ParantId=''";
          aCommonInternalDal.LoadDropDownValue(aDropDownList, "ManuName", "SL", query,"SSIDB");
      }
      public void MenuDropDown(DropDownList aDropDownList,string id)
      {
          string query = "select * from tblMainMenu where ParantId = @ParantId";
          aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDropDownList, "ManuName", "SL", query, new List<SqlParameter>
          {
              new SqlParameter("@ParantId", DbValue(id))
          });

      }

      public bool CheckMenuSl(int MenuSl, int userId)
      {
          string query = @"select * from tblMenuDistribution where MenuSL = @MenuSL and UserId = @UserId";
          DataTable aTable = new DataTable();
          aTable = aCommonInternalDal.DataContainerDataTable(query, new List<SqlParameter>
          {
              new SqlParameter("@MenuSL", MenuSl),
              new SqlParameter("@UserId", userId)
          }, "SSIDB");
          if (aTable.Rows.Count==0)
          {
              return false;
          }

          return true;
      }

      public string GetParantId(int sL)
      {
          string parantId = string.Empty;
          string query = "select * from tblMainMenu where SL = @SL";
          DataTable aTable = new DataTable();
          aTable = aCommonInternalDal.DataContainerDataTable(query, new List<SqlParameter>
          {
              new SqlParameter("@SL", sL)
          }, "SSIDB");
          parantId = aTable.Rows[0]["ParantId"].ToString();

          return parantId;
      }

      public bool SaveMainMenu(int MenuSl, int userId)
      {
          ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
          int SL = aClsPrimaryKeyFind.PrimaryKeyMax("SL", "tblMenuDistribution", "SSIDB");
          string query = @"INSERT INTO tblMenuDistribution (SL, UserId, MenuSL, Status)
                           VALUES (@SL, @UserId, @MenuSL, @Status)";
          return aCommonInternalDal.SaveDataByInsertCommand(query, new List<SqlParameter>
          {
              new SqlParameter("@SL", SL),
              new SqlParameter("@UserId", userId),
              new SqlParameter("@MenuSL", MenuSl),
              new SqlParameter("@Status", true)
          }, "SSIDB");
      }



      public void UserDdl(DropDownList userDropDownList)
      {
          string query = "select * from tblUser";
          aCommonInternalDal.LoadDropDownValue(userDropDownList, "UserName", "UserId", query, "SSIDB");
      }

      public void MainMenu(DropDownList userDropDownList, string userId)
      {
          string query = "select * from tblMainMenu INNER JOIN tblMenuDistribution ON tblMainMenu.SL = tblMenuDistribution.MenuSL where UserId = @UserId and (ParantId IS NULL OR ParantId = '')";
          aCommonInternalDal.LoadDropDownValueWithoutDataBase(userDropDownList, "ManuName", "SL", query, new List<SqlParameter>
          {
              new SqlParameter("@UserId", DbValue(userId))
          });
      }
      public DataTable MainMenuLoad(string userId)
      {
          string query = @"   SELECT  tbltemp.* FROM  (SELECT MM.*,ISNULL(MD.Status,'False') AS Status  FROM dbo.tblMainMenu MM "+
                            " LEFT JOIN tblMenuDistribution MD ON MM.SL=MD.MenuSL "+
                            " WHERE MD.UserId = @UserId  " +
                            " union  "+
                            " SELECT MM.*, Status=0  FROM dbo.tblMainMenu MM   "+
                            " WHERE MM.SL NOT IN (SELECT MenuSL FROM tblMenuDistribution WHERE UserId = @UserId)  )   " +
                            " AS tbltemp WHERE tbltemp.ParantId IS NULL OR tbltemp.ParantId =''   " +
                            " ORDER BY tbltemp.SL";


          return aCommonInternalDal.DataContainerDataTable(query, new List<SqlParameter>
          {
              new SqlParameter("@UserId", DbValue(userId))
          }, "SSIDB");
      }

      public DataTable OtherMenuLoad(string userId,string parantId)
      {
          //string query = @"   SELECT  tbltemp.* FROM  (SELECT MM.*,ISNULL(MD.Status,'False') AS Status  FROM dbo.tblMainMenu MM " +
          //                  " LEFT JOIN tblMenuDistribution MD ON MM.SL=MD.MenuSL " +
          //                  " WHERE MD.UserId = '" + userId + "'  " +
          //                  " union  " +
          //                  " SELECT MM.*, Status=0  FROM dbo.tblMainMenu MM   " +
          //                  " WHERE MM.SL NOT IN (SELECT MenuSL FROM tblMenuDistribution WHERE UserId='" + userId + "')  )   " +
          //                  " AS tbltemp WHERE  tbltemp.ParantId ='" + parantId + "'   " +
          //                  " ORDER BY tbltemp.SL";


          string Query = @" SELECT tblSelected.* FROM  (SELECT tblMenuTemp.*,tbl1.[Status]  FROM  (SELECT * FROM dbo.tblMainMenu WHERE  " +
                              "  ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId) " +

                              "    UNION " +

                              "   SELECT * FROM dbo.tblMainMenu WHERE " +
                              "   ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE  " +
                              "   ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId)) " +

                               "   UNION  " +

                              "   SELECT * FROM dbo.tblMainMenu WHERE " +
                              "   ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE  " +
                              "   ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE  " +
                              "   ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId))))   " +
                              "   AS tblMenuTemp   " +

                              "   INNER JOIN (SELECT MM.*,ISNULL(MD.Status,'False') AS [Status]  FROM dbo.tblMainMenu MM   " +
                              "   LEFT JOIN tblMenuDistribution MD ON MM.SL=MD.MenuSL   " +
                              "   WHERE (MM.ParantId IS NOT NULL OR MM.ParantId <>'') and MD.UserId = @UserId) AS tbl1 ON tblMenuTemp.SL = tbl1.SL)   " +
                              "   AS tblSelected  " +


                             "    UNION   " +

                              "   SELECT tblMenuTemp.* ,Status=0 FROM  (SELECT * FROM dbo.tblMainMenu WHERE   " +
                              "   ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId)  " +

                              "    UNION  " +

                              "   SELECT * FROM dbo.tblMainMenu WHERE   " +
                              "   ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE   " +
                              "   ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId))  " +

                              "    UNION  " +

                              "   SELECT * FROM dbo.tblMainMenu WHERE   " +
                              "   ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE   " +
                             "    ParantId IN(SELECT SL FROM dbo.tblMainMenu WHERE   " +
                             "    ParantId IN (SELECT SL FROM dbo.tblMainMenu WHERE SL = @ParantId))))   " +
                            "     AS tblMenuTemp WHERE tblMenuTemp.SL NOT IN (SELECT MenuSL FROM tblMenuDistribution WHERE UserId = @UserId)";
                                

          return aCommonInternalDal.DataContainerDataTable(Query, new List<SqlParameter>
          {
              new SqlParameter("@UserId", DbValue(userId)),
              new SqlParameter("@ParantId", DbValue(parantId))
          }, "SSIDB");
      }

      private static object DbValue(object value)
      {
          return value ?? DBNull.Value;
      }

      private static List<SqlParameter> MenuPermissionParameters(int sl, int userId, string parantId)
      {
          return new List<SqlParameter>
          {
              new SqlParameter("@SL", sl),
              new SqlParameter("@UserId", userId),
              new SqlParameter("@ParantId", DbValue(parantId))
          };
      }

    }
}
