using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TransferUI_MarketStructure_TransferApprove : System.Web.UI.Page
{
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    private DropDownList T_GroupSelect, T_ZoneSelect, T_AreaSelect, T_TeritorySelect, T_SubTeritory, T_MarketSelect, ddlDistributionCenter, rootDropDownList;
    private static DoctorDAL _DoctorDAL = new DoctorDAL();

    private static MarketStructureTransferDAL _CustomerInfoDAL = new MarketStructureTransferDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;


        T_GroupSelect = (DropDownList)IVMarketStructureTo.FindControl("GroupSelect") as DropDownList;
        T_ZoneSelect = (DropDownList)IVMarketStructureTo.FindControl("ZoneSelect") as DropDownList;
        T_AreaSelect = (DropDownList)IVMarketStructureTo.FindControl("AreaSelect") as DropDownList;
        T_TeritorySelect = (DropDownList)IVMarketStructureTo.FindControl("TeritorySelect") as DropDownList;
        T_SubTeritory = (DropDownList)IVMarketStructureTo.FindControl("SubTeritory") as DropDownList;
        T_MarketSelect = (DropDownList)IVMarketStructureTo.FindControl("MarketSelect") as DropDownList;
        ddlDistributionCenter = (DropDownList)IVMarketStructureTo.FindControl("ddlDistributionCenter") as DropDownList;
        rootDropDownList = (DropDownList)IVMarketStructureTo.FindControl("rootDropDownList") as DropDownList;
        if (!IsPostBack)
        {
            btnSearch_Click(null, null);
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

        btnSearch_Click(null, null);


    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public bool Validation()
    {


        if (rbType.Items[0].Selected)
        {

            if (gv_market.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_market.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_market.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

        }


        if (rbType.Items[1].Selected)
        {

            if (gv_subTerri.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_subTerri.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_subTerri.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

        }


        if (rbType.Items[2].Selected)
        {

            if (gv_Terrritory.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_Terrritory.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_Terrritory.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

        }


        if (rbType.Items[3].Selected)
        {

            if (gv_Area.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_Area.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_Area.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

        }



        if (rbType.Items[4].Selected)
        {

            if (gv_Zone.Rows.Count == 0)
            {
                showMessageBox("Table can not be Empty!");

                return false;
            }


            Int32 count = 0;

            for (int i = 0; i < gv_Zone.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)gv_Zone.Rows[i].Cells[0].FindControl("chkSelect");

                if (chkBoxRows.Checked)
                {
                    count++;
                }

                if (count > 0)
                {
                    break;
                }
            }

            if (count == 0)
            {
                showMessageBox("Please Select at least one row !!!");
                return false;
            }

        }


        return true;
    }

    //protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    //{
    //    var chkBoxHeader = (CheckBox)gv_Customer_List.HeaderRow.FindControl("chkSelectAll");

    //    for (int i = 0; i < gv_Customer_List.Rows.Count; i++)
    //    {
    //        var chkBoxRows = (CheckBox)gv_Customer_List.Rows[i].Cells[0].FindControl("chkSelect");
    //        chkBoxRows.Checked = chkBoxHeader.Checked;
    //       // CheckCustInOrder(i);

    //    }
    //}
    protected void btnSave_Click(object sender, EventArgs e)
    {

        string Type = "";
        if (Validation())
        {
            string EmpIdAA = "";

            if (rbType.Items[0].Selected)
            {

                Type = rbType.Items[0].Value;

                for (int i = 0; i < gv_market.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_market.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_market.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }


            if (rbType.Items[1].Selected)
            {

                Type = rbType.Items[1].Value;

                for (int i = 0; i < gv_subTerri.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_subTerri.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_subTerri.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }


            if (rbType.Items[2].Selected)
            {

                Type = rbType.Items[2].Value;

                for (int i = 0; i < gv_Terrritory.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_Terrritory.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_Terrritory.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }

            if (rbType.Items[3].Selected)
            {

                Type = rbType.Items[3].Value;

                for (int i = 0; i < gv_Area.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_Area.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_Area.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }

            if (rbType.Items[4].Selected)
            {

                Type = rbType.Items[4].Value;

                for (int i = 0; i < gv_Zone.Rows.Count; i++)
                {
                    CheckBox check = (CheckBox)gv_Zone.Rows[i].FindControl("chkSelect");

                    if (check.Checked)
                    {
                        int EmpId = Convert.ToInt32(gv_Zone.DataKeys[i][0]);

                        EmpIdAA += EmpId + ",";




                    }

                }
            }


            ResultInfo Res = new ResultInfo();
            EmpIdAA = EmpIdAA.Trim(',');


            Res  = _CustomerInfoDAL.UpdateMarketStructure_TransferApprove(Type, EmpIdAA, HttpContext.Current.Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','MarketStructure_TransferApprove.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }
        }


    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {

        gv_Zone.DataSource = null;
        gv_Zone.DataBind();


        gv_Area.DataSource = null;
        gv_Area.DataBind();


        gv_Terrritory.DataSource = null;
        gv_Terrritory.DataBind();

        gv_subTerri.DataSource = null;
        gv_subTerri.DataBind();

        gv_market.DataSource = null;
        gv_market.DataBind();

        //if (F_MarketSelect.SelectedValue != "")
        //{

        try
        {
                if (rbType.Items[0].Selected)
                {


                    DataTable aDataTable = _CustomerInfoDAL.GetList(rbType.Items[0].Value);
                gv_market.DataSource = aDataTable;
                gv_market.DataBind();

             
            }

            if (rbType.Items[1].Selected)
            {


                DataTable aDataTable = _CustomerInfoDAL.GetList(rbType.Items[1].Value);
                gv_subTerri.DataSource = aDataTable;
                gv_subTerri.DataBind();


                }

            if (rbType.Items[2].Selected)
            {


                DataTable aDataTable = _CustomerInfoDAL.GetList(rbType.Items[2].Value);
                gv_Terrritory.DataSource = aDataTable;
                gv_Terrritory.DataBind();

              
            }


            if (rbType.Items[3].Selected)
            {


                DataTable aDataTable = _CustomerInfoDAL.GetList(rbType.Items[3].Value);
                gv_Area.DataSource = aDataTable;
                gv_Area.DataBind();


             }

            if (rbType.Items[4].Selected)
            {


                DataTable aDataTable = _CustomerInfoDAL.GetList(rbType.Items[4].Value);
                gv_Zone.DataSource = aDataTable;
                gv_Zone.DataBind();


              }

        }
            catch (Exception ex) { }

        //}
        //else
        //{
        //    showMessageBox("Please Select Market!");
        //    F_MarketSelect.Focus();
        //}
    }

    
    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {

        int rowIndex = ((GridViewRow)(((CheckBox)sender).Parent.Parent)).RowIndex;
        try
        {
            CheckCustInOrder(rowIndex, gv_market);

        }
        catch (Exception ex)
        {

        }
    }

    private void CheckCustInOrder(int rowIndex, GridView gridView)
    {

        try
        {

            CheckBox chkSelect = (CheckBox)gridView.Rows[rowIndex].Cells[1].FindControl("chkSelect");
            HiddenField hfCustomerMasterId = (HiddenField)gridView.Rows[rowIndex].Cells[1].FindControl("hfCustomerMasterId");

            if (chkSelect.Checked)
            {
                DataTable dt = _dataLoad.GetValidationCheck(hfCustomerMasterId.Value, "CustomerTransfer");

                if (dt.Rows.Count == 0)
                {

                }
                else
                {
                    chkSelect.Checked = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Order Pending!" + "','Faild');", true);

                }
            }




        }
        catch (Exception ex)
        {

        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("Customer_Doctor_Transfer.aspx");
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Zone.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < gv_Zone.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_Zone.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }

    protected void gv_ZonechkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Zone.HeaderRow.FindControl("gv_ZonechkSelectAll");

        for (int i = 0; i < gv_Zone.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_Zone.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }

    protected void gv_AreachkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Area.HeaderRow.FindControl("gv_AreachkSelectAll");

        for (int i = 0; i < gv_Area.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_Area.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }

    protected void gv_TerrritorychkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_Terrritory.HeaderRow.FindControl("gv_TerrritorychkSelectAll");

        for (int i = 0; i < gv_Terrritory.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_Terrritory.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }

    protected void gv_subTerrichkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_subTerri.HeaderRow.FindControl("gv_subTerrichkSelectAll");

        for (int i = 0; i < gv_subTerri.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_subTerri.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }

    protected void gv_marketchkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)gv_market.HeaderRow.FindControl("gv_marketchkSelectAll");

        for (int i = 0; i < gv_market.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)gv_market.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
            // CheckCustInOrder(i);

        }
    }
}