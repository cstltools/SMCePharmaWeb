using Library.DAL.MasterSetup_DAL;
using Library.DAL.SAP_IntegrationDAL;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SAP_Integration_SAP_IntrigationPointDIC : System.Web.UI.Page
{
    private static SAP_IntrigationPointDAL _DAL = new SAP_IntrigationPointDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            DataTable comUnitDetailDataTable = new DataTable();


            comUnitDetailDataTable = _DAL.GetSAP_IntrigationPointHeaderDAL("", "");


            if (comUnitDetailDataTable.Rows.Count > 0)
            {
                gv_HeaderInfo.DataSource = comUnitDetailDataTable;
                gv_HeaderInfo.DataBind();

               
            }
            else
            {
                gv_HeaderInfo.DataSource = null;
                gv_HeaderInfo.DataBind();
               

            }

            rbType_SelectedIndexChanged(null, null);

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
    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadInfoNewMethod();
    }

    private void LoadInfoNewMethod()
    {
        string selectedValue = rbType.SelectedValue;

        gv_ProductInfo.DataSource = null;
        gv_ProductInfo.DataBind();

        gv_EmpInfo.DataSource = null;
        gv_EmpInfo.DataBind();

        gv_StockReceive.DataSource = null;
        gv_StockReceive.DataBind();
        DataTable dtTable = new DataTable();

        if (selectedValue == "Product Info")
        {

            dtTable = _DAL.GetSAP_ProductInfoDAL("", "");
            if (dtTable.Rows.Count > 0)
            {
                gv_ProductInfo.DataSource = dtTable;
                gv_ProductInfo.DataBind();


            }
            else
            {
                gv_ProductInfo.DataSource = null;
                gv_ProductInfo.DataBind();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No data found!" + "','Faild');", true);

            }
        }
        else if (selectedValue == "Employee Info")
        {

            dtTable = _DAL.GetSAP_EmpInfoDAL("", "");

            if (dtTable.Rows.Count > 0)
            {
                gv_EmpInfo.DataSource = dtTable;
                gv_EmpInfo.DataBind();


            }
            else
            {
                gv_EmpInfo.DataSource = null;
                gv_EmpInfo.DataBind();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No data found!" + "','Faild');", true);

            }
        }


        else if (selectedValue.Trim() == "Stock Receive".Trim())
        {
            dtTable = _DAL.GetSAP_StockReceivePendingDataDIC("");

            if (dtTable.Rows.Count > 0)
            {
                gv_StockReceive.DataSource = dtTable;
                gv_StockReceive.DataBind();

                for (int i = 0; i < gv_StockReceive.Rows.Count; i++)
                {
                    HiddenField hfstatus = ((HiddenField)gv_StockReceive.Rows[i].Cells[1].FindControl("hfstatus"));

                    try
                    {
                        DataTable dtCheck = _DAL.HideChallanByChallanNo(hfstatus.Value.Trim());

                        if (dtCheck.Rows.Count > 0)
                        {
                            gv_StockReceive.Rows[i].Visible = false;
                        }
                    }
                    catch
                    {

                    }
                }

                    

            }
            else
            {
                gv_StockReceive.DataSource = null;
                gv_StockReceive.DataBind();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No data found!" + "','Faild');", true);

            }
        }
    }
    protected void previewButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Session["StockMovementMasterId"] = gv_StockReceive.DataKeys[rowindex]["StockMovementMasterId"].ToString();
        Response.Redirect("SAP_StockReceiveDIC.aspx");
    }

    protected void gv_StockReceive_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ApproveData")
        {

            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField challanNo = ((HiddenField)gv_StockReceive.Rows[rowindex].Cells[1].FindControl("hfstatus"));


            //if (AllConditionCheck(hfproduct_id.Value, hfproduct_code.Value, hfstatus.Value))
            {
                ResultInfo Res = _DAL.SaveStockReceive(challanNo.Value.Trim());

                if (Res.isSuccess == true)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                    LoadInfoNewMethod();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }

            }

        }

    }
    protected void gv_StockReceive_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    protected void gv_StockReceive_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[6].Attributes.Add("style", "word-break:break-all;word-wrap:break-word;");
        }
    }
    protected void gv_EmpInfo_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ApproveData")
        {

            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfemployee_id = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfemployee_id"));
            HiddenField hfemployee_code = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfemployee_code"));
            HiddenField hfRoleType = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfRoleType"));
            HiddenField hfaction = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfaction"));



            if (AllConditionCheckForEmp(hfemployee_id.Value, hfemployee_code.Value, hfRoleType.Value, hfaction.Value))
            {
                ResultInfo Res = _DAL.SaveEmpInfoDAL( hfemployee_id.Value, hfemployee_code.Value, hfRoleType.Value, hfaction.Value);
                if (Res.isSuccess == true)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                    LoadInfoNewMethod();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }

            }



        }
    }

    private bool AllConditionCheck(string femployee_id, string employee_code, string RoleType)
    {
        DataTable dtCheck = new DataTable();// _DAL.CheckSAP_EmpInfoDAL(femployee_id, employee_code, RoleType);

        if (dtCheck.Rows.Count>0)
        {
          int   dataCheck= 0;
            try
            {
                  dataCheck = Convert.ToInt32(dtCheck.Rows[0]["Datacheck"].ToString());
            }
            catch (Exception ex) { }

            if (dataCheck > 0)
            {

                string msg = dtCheck.Rows[0]["Msg"].ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + msg + "','Faild');", true);
                return false;
            }
        
        }

        return true;
    }
    private bool AllConditionCheckForProduct(string femployee_id, string employee_code, string RoleType)
    {
        DataTable dtCheck = new DataTable();// _DAL.CheckSAP_EmpInfoDAL(femployee_id, employee_code, RoleType);

        if (dtCheck.Rows.Count > 0)
        {
            int dataCheck = 0;
            try
            {
                dataCheck = Convert.ToInt32(dtCheck.Rows[0]["Datacheck"].ToString());
            }
            catch (Exception ex) { }

            if (dataCheck > 0)
            {

                string msg = dtCheck.Rows[0]["Msg"].ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + msg + "','Faild');", true);
                return false;
            }

        }

        return true;
    }


    private bool AllConditionCheckForEmp(string femployee_id, string employee_code, string RoleType, string ActionStatus)
    {
        DataTable dtCheck = _DAL.CheckSAP_EmpInfoDAL(femployee_id, employee_code, RoleType, ActionStatus);

        if (dtCheck.Rows.Count > 0)
        {
            int dataCheck = 0;
            try
            {
                dataCheck = Convert.ToInt32(dtCheck.Rows[0]["Datacheck"].ToString());
            }
            catch (Exception ex) { }

            if (dataCheck > 0)
            {

                string msg = dtCheck.Rows[0]["Msg"].ToString();
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + msg + "','Faild');", true);
                return false;
            }

        }

        return true;
    }
    protected void gv_ProductInfo_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ApproveData")
        {

            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfstatus = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfstatus"));
            HiddenField hfproduct_code = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfproduct_code"));
            HiddenField hfproduct_id = ((HiddenField)gv_EmpInfo.Rows[rowindex].Cells[1].FindControl("hfproduct_id"));



            //if (AllConditionCheck(hfproduct_id.Value, hfproduct_code.Value, hfstatus.Value))
            {
                ResultInfo Res = _DAL.SaveProductInfoDAL(hfproduct_id.Value, hfproduct_code.Value, hfstatus.Value);
                if (Res.isSuccess == true)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                    LoadInfoNewMethod();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }

            }



        }
    }
}