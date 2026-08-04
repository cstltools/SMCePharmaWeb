using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class MasterPages_MasterPage : System.Web.UI.MasterPage
{
    UserBLL aUserBll = new UserBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //  Menu();
            UserNameTime();
            //Session["MarketId"] = null;
            //Session["OrderId"] = null;
            //Session["UserId"] = "1";
            //Session["LoginName"] = "admin";
            //Session["UserType"] = "Admin";
            //Session["ComUnitId"] = 1;
            MenuHtml();
        }
    }
    public void UserNameTime()
    {
        //Label1.Text = Session["LoginName"].ToString();
        //Label2.Text = Session["UserTime"].ToString();
    }
    public void MenuHtml()
    {

        DataTable aDataTable = new DataTable();
      //  aDataTable = aUserBll.LoadMenu(Session["UserId"].ToString());
        menu.InnerHtml = aDataTable.Rows[0][0].ToString();


    }
    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        Session["UserId"] = "1";
        Session["LoginName"] = "admin";
        Session["UserType"] = "Admin";
        Session["ComUnitId"] = 1;
        Session.Abandon();
        Response.Redirect("../Login.aspx");
    }
}
