using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NoticeBoard_UI_NoticeDetailsApp : System.Web.UI.Page
{
    private static Setup2DAL _setupDAL = new Setup2DAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {


                masterId.Value = Request.QueryString["MID"];
                GetOneRecord(masterId.Value);
            }
        }
    }

    private void GetOneRecord(string value)
    {
        try
        {
            using (DataTable dt = _setupDAL.GetNoticeSetupById(value))
            {


                lblTitle.Text = dt.Rows[0]["NoticeTitle"].ToString();
                lblAnnouncement.Text = dt.Rows[0]["Announcement"].ToString();


                lblFromDate.Text = dt.Rows[0]["FromDate"].ToString();
                lblToDate.Text = dt.Rows[0]["ToDate"].ToString();




                try
                {
                    string imagefullpath = (dt.Rows[0]["ImagePreName"].ToString() + value.ToString() + ".jpg");


                    try
                    {
                        byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
                        var src = "data:image/jpeg;base64,";

                        outputimage.ImageUrl = src + Convert.ToBase64String(imageArray);
                        hfimgShow.Value = src + Convert.ToBase64String(imageArray);
                        //64.Value = imagefullpath;
                        // outputimage.ImageUrl = imagefullpath;
                        //if (hfimgShow.Value != "")
                        //{
                        //    outputimage.ImageUrl = hfimgShow.Value;
                        //}

                    }
                    catch (Exception ex)
                    {

                    }
                }
                catch (Exception ex)
                {

                }
                 




            }
        }
        catch (Exception ex) { }
    }

}