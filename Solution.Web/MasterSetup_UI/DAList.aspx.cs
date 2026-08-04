using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.MasterSetup_DAL;

public partial class MasterSetup_UI_DAList : System.Web.UI.Page
{
    DAInfoDal aDal = new DAInfoDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDAInfo();
        }
    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    private void LoadDAInfo()
    {
        DataTable aTable = new DataTable();

        //if (Session["RoleTypeId"].ToString() == "5" || Session["RoleTypeId"].ToString() == "11")
        //{
            aTable = aDal.GetDAInfo(Convert.ToInt32(Session["UserId"].ToString()));
        //}
        //else
        //{
        //    aTable = aDal.GetDAInfo(" and DA.EntryBy="+ Session["UserId"].ToString());
        //}

       

        if (aTable.Rows.Count > 0)
        {
            loadGridView.DataSource = aTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            Session["DAEdit"] = e.CommandArgument.ToString();
            Response.Redirect("DASetup.aspx");
        }

    }
}