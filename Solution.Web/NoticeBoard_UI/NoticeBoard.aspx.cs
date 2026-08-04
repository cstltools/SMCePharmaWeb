using Library.DAL.DoctorVisit_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NoticeBoard_UI_NoticeBoard : System.Web.UI.Page
{
    static NoticeDal _NoticeDAL = new NoticeDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }


    //[WebMethod]

    //public static ResultInfo Save_Notice(NoticeMaster master)
    //{

      
    //    return (_NoticeDAL.SaveNotice(master, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));

    //}
    //public ActionResult UploadFiles(/*HttpPostedFileBase file, int ID*/)
    //{
    //    string Id = Request["ID"];

    //    bool success = false;
    //    if (Id != null)
    //    {

    //        if (_NoticeDAL.Delete_NoticeImage(Convert.ToInt32(Id)))
    //        {
    //            string path = @"E:\Files\";

    //            HttpFileCollectionBase files = Request.Files;

    //            for (int i = 0; i < files.Count; i++)
    //            {
    //                HttpPostedFileBase file = files[i];

    //                if (file != null)
    //                {
    //                    if (!Directory.Exists(path))
    //                    {
    //                        Directory.CreateDirectory(path);
    //                    }
    //                    file.SaveAs(path + Path.GetFileName(file.FileName));

    //                    string fullpath = path + Path.GetFileName(file.FileName);

    //                    if (_NoticeDAL.SaveImage((fullpath), file.FileName, Convert.ToInt32(Id), 0))
    //                    {

    //                        success = true;
    //                    }
    //                    else
    //                    {

    //                        success = false;
    //                    }

    //                }

    //            }

    //        }
    //    }

    //    return Json(success, JsonRequestBehavior.AllowGet);
    //}

    [WebMethod]
    public static string GetNoticeMasterList()
    {
        DataTable dt = _NoticeDAL.GetNoticeMasterList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static ResultInfo Delete_NoticeMaster(int Id)
    {
        return (_NoticeDAL.Delete_NoticeMaster(Id));
      }

    [WebMethod]
    public static NoticeMaster GetNoticeMasterEditData(int id)
    {
        return  (_NoticeDAL.GetNoticeMasterForEdit(id));
    }

    //public ActionResult GetNoticeImageListForEdit(int id)
    //{
    //    DataTable dt = _NoticeDAL.Get_NoticeImageByNoticeId(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return Json(JSONresult, JsonRequestBehavior.AllowGet);
    //}

    [WebMethod]
    public static string GetNotticeDetailsEditForEdit(int id)
    {
        DataTable dt = _NoticeDAL.Get_NoticeDetailsByNoticeId(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }

}