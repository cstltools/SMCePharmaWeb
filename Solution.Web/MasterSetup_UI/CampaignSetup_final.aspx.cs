using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_CampaignSetup_final : System.Web.UI.Page
{
    private static BonusCampaignNewDAL _BonusCampaignNewDAL = new BonusCampaignNewDAL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private QuotedPriceSetupDAL _Dal = new QuotedPriceSetupDAL();

    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            LoadInitialInfo();


            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }
        }
    }

    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _BonusCampaignNewDAL.GetCampaignSetupById(Id))
            {
                txtCampaignName.Text = dt.Rows[0]["CampaignName"].ToString();
                ddlChemistType.SelectedValue = dt.Rows[0]["CustomerTypeId"].ToString();

                ddlProLine.SelectedValue = dt.Rows[0]["ProductLineID"].ToString();


                ddlCampaignType.SelectedValue = dt.Rows[0]["CampainTypeId"].ToString();


                try
                {
                    chkMultipleProductAdd.Checked = Convert.ToBoolean(dt.Rows[0]["IsMultipleProductAdd"].ToString());
                }
                catch (Exception ex)
                {
                    chkMultipleProductAdd.Checked = false;
                }

                try
                {
                    chkManualRationSetup.Checked = Convert.ToBoolean(dt.Rows[0]["IsManualRationSetup"].ToString());
                }
                catch (Exception ex)
                {
                    chkManualRationSetup.Checked = false;
                }


                if(chkMultipleProductAdd.Checked==false && chkManualRationSetup.Checked == false)
                {
                    chkMultipleProductAdd.Enabled = false;
                    chkManualRationSetup.Enabled = false;
                }

                if (chkMultipleProductAdd.Checked == true)
                {
                   
                    chkManualRationSetup.Enabled = false;
                }
                if (chkManualRationSetup.Checked == true)
                {

                    chkMultipleProductAdd.Enabled = false;
                }

                ddlCampaignType_SelectedIndexChanged(null, null);

                ddlProLine.SelectedValue = dt.Rows[0]["ProductLineID"].ToString();

                txtAmount.Text = dt.Rows[0]["Amount"].ToString();
                txtProductQty.Text = dt.Rows[0]["ProductQty"].ToString();
                txtMaxAmount.Text = dt.Rows[0]["MaxAmount"].ToString();
                ddlProduct.SelectedValue = dt.Rows[0]["BonusProductId"].ToString();

                txtMaxAmount.Text = dt.Rows[0]["MaxAmount"].ToString();
                DateTime dtss = Convert.ToDateTime(dt.Rows[0]["FromDate"]);
                frmDate.Text = dtss.ToString("yyyy-MM-dd HH:mm:ss").Replace(' ', 'T');


                DateTime dttoDate = Convert.ToDateTime(dt.Rows[0]["Todate"]);

                toDate.Text = dttoDate.ToString("yyyy-MM-dd HH:mm:ss").Replace(' ', 'T');

                try
                {
                    chkTradePolicy.Checked = Convert.ToBoolean(dt.Rows[0]["IsTradePolicy"].ToString());
                }
                catch (Exception ex)
                {
                    chkTradePolicy.Checked = false;
                }

                try
                {
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());
                }
                catch (Exception ex)
                {
                    chkIsActive.Checked = false;
                }





            }


            using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailById(Id))
            {
                gv_ProductOffer.DataSource = dtDetail;
                gv_ProductOffer.DataBind();

                for (int i = 0; i < gv_ProductOffer.Rows.Count; i++)
                {
                    HiddenField hfBonusTypeId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfBonusTypeId"));

                    if (hfBonusTypeId.Value == "5")
                    {

                        ddlOfferType.SelectedValue = "5";
                        ddlOfferType_SelectedIndexChanged(null, null);
                        chkManualRationSetup.Visible = true;
                    }
                }
            }


            using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailMarketById(Id))
            {
                gv_Market.DataSource = dtDetail;
                gv_Market.DataBind();

            }

            using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailCustomerById(Id))
            {
                gv_Customer.DataSource = dtDetail;
                gv_Customer.DataBind();

            }


           


            //    using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailMulProById(Id))
            //{
            //    gv_MultipleProductAdd.DataSource = dtDetail;
            //    gv_MultipleProductAdd.DataBind();


            //    for (int i = 0; i < dtDetail.Rows.Count; i++)
            //    {
            //        try
            //        {
            //            using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
            //            {
            //                DropDownList ddlProduct_MultipleProductAdd = ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("ddlProduct_MultipleProductAdd"));
            //                ddlProduct_MultipleProductAdd.DataSource = dt;

            //                ddlProduct_MultipleProductAdd.DataValueField = "ProductId";
            //                ddlProduct_MultipleProductAdd.DataTextField = "ProductName";
            //                ddlProduct_MultipleProductAdd.DataBind();
            //                ddlProduct_MultipleProductAdd.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            //                ddlProduct_MultipleProductAdd.SelectedIndex = 0;


            //                HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
            //                ddlProduct_MultipleProductAdd.CssClass = "form-select form-select-sm mb-3";

            //                ddlProduct_MultipleProductAdd.SelectedValue = dtDetail.Rows[i]["ProductId"].ToString();
            //                hfProductId_MultipleProductAdd.Value = dtDetail.Rows[i]["ProductId"].ToString();
            //            }
            //        }

            //        catch (Exception ex) { }
            //    }

            //}

           


        }
        catch (Exception ex) { }
    }



    private void LoadInitialInfo()
    {



        try
        {
            using (DataTable dt = _seedRepo.GetChemistTypeList())
            {
                ddlChemistType.DataSource = dt;
                ddlChemistType.DataValueField = "CustomerTypeId";
                ddlChemistType.DataTextField = "CustomerType";
                ddlChemistType.DataBind();
                ddlChemistType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlChemistType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _seedRepo.GetProLineDataTableList())
            {
                ddlProLine.DataSource = dt;
                ddlProLine.DataValueField = "ProductLineID";
                ddlProLine.DataTextField = "LineName";
                ddlProLine.DataBind();
                ddlProLine.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProLine.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _seedRepo.GetCampaignTypeList())
            {
                ddlCampaignType.DataSource = dt;

                ddlCampaignType.DataValueField = "CampainTypeId";
                ddlCampaignType.DataTextField = "TypeName";
                ddlCampaignType.DataBind();
                ddlCampaignType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlCampaignType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }





        try
        {
            using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
            {
                ddlProduct.DataSource = dt;

                ddlProduct.DataValueField = "ProductId";
                ddlProduct.DataTextField = "ProductName";
                ddlProduct.DataBind();
                ddlProduct.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProduct.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _Dal.GetProductListActiveForALl())
            {
                ddlProductList.DataSource = dt;

                ddlProductList.DataValueField = "ProductId";
                ddlProductList.DataTextField = "ProductName";
                ddlProductList.DataBind();
                ddlProductList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProductList.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        Market_gv_Initial();
        Customer_gv_Initial();
        ProductOffer_gv_Initial();
    }
    public void Customer_gv_Initial()
    {
        DataTable aDataTableCus = new DataTable();
        aDataTableCus.Columns.Add("CustomerMasterId");
        aDataTableCus.Columns.Add("CustomerName");
        gv_Customer.DataSource = aDataTableCus;
        gv_Customer.DataBind();
    }

    public void ProductOffer_gv_Initial()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("BonusTypeId");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("TypeName");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Qty");
        aDataTable.Columns.Add("Amount");
        aDataTable.Columns.Add("PercentAmount");

        gv_ProductOffer.DataSource = aDataTable;
        gv_ProductOffer.DataBind();
    }
    public void Market_gv_Initial()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("GroupId");
        aDataTable.Columns.Add("RegionId");
        aDataTable.Columns.Add("AreaId");
        aDataTable.Columns.Add("TerritoryId");
        aDataTable.Columns.Add("SubTerritoryId");
        aDataTable.Columns.Add("MarketId");

        aDataTable.Columns.Add("GroupName");
        aDataTable.Columns.Add("RegionName");
        aDataTable.Columns.Add("AreaName");
        aDataTable.Columns.Add("TerritoryName");
        aDataTable.Columns.Add("SubTerritoryName");
        aDataTable.Columns.Add("MarketName");
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();

    }

    protected void ddlCampaignType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (id_mastetID.Value == "")
        {
            chkManualRationSetup.Checked = false;
            chkMultipleProductAdd.Checked = false;
        }
        

        divrbType.Visible = false;
        DivPrdQty.Visible = false;
        divAmount.Visible = false;
        divDisType.Visible = false;
        divProduct.Visible = false;
        divProductList.Visible = false;
        divBtn.Visible = false;
        lblDisType.InnerText = "";
        txtProductQty.Text = "";
        txtAmount.Text = "";

        txtAmount.Text = "";
        txtMaxAmount.Text = "";
        ProductOffer_gv_Initial();
        ddlProduct.SelectedValue = "";
        if (ddlCampaignType.SelectedIndex > 0)
        {
            try
            {
                using (DataTable dt = _seedRepo.GetOfferTypeInfo(Convert.ToInt32(ddlCampaignType.SelectedValue)))
                {
                    ddlOfferType.DataSource = dt;

                    ddlOfferType.DataValueField = "BonusTypeId";
                    ddlOfferType.DataTextField = "TypeName";
                    ddlOfferType.DataBind();
                    ddlOfferType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlOfferType.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }


            if (ddlCampaignType.SelectedValue == "1")
            {
                divProduct.Visible = true;
                lblProQty.InnerText = "Quantity:";
                DivPrdQty.Visible = true;
                divrbType.Visible = true;


            }

            if (ddlCampaignType.SelectedValue == "2")
            {
                divProduct.Visible = true;
                divAmount.Visible = true;
                lblProQty.InnerText = "Amount:";
                DivPrdQty.Visible = false;
            }

            if (ddlCampaignType.SelectedValue == "3")
            {
                divAmount.Visible = true;



            }
        }
    }

    protected void ddlOfferType_SelectedIndexChanged(object sender, EventArgs e)
    {

        divDisType.Visible = false;
        divProductList.Visible = false;
        divBtn.Visible = false;
        lblDisType.InnerText = "";
        chkManualRationSetup.Visible = false;

        if (ddlOfferType.SelectedIndex > 0)
        {

            if (ddlCampaignType.SelectedValue == "1" || ddlCampaignType.SelectedValue == "2")
            {
                if (ddlOfferType.SelectedValue == "1")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount (%):";

                    divBtn.Visible = true;

                }

                if (ddlOfferType.SelectedValue == "2")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount:";

                    divBtn.Visible = true;

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount:";

                    divBtn.Visible = true;

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    divDisType.Visible = true;
                    chkManualRationSetup.Visible = true;
                    divProductList.Visible = true;
                    lblDisType.InnerText = "Quantity:";

                    divBtn.Visible = true;

                }
            }
            else
            {
                if (ddlOfferType.SelectedValue == "1")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount (%):";

                    divBtn.Visible = true;

                }

                if (ddlOfferType.SelectedValue == "7")
                {
                    divDisType.Visible = true;


                    lblDisType.InnerText = "Amount :";

                    divBtn.Visible = true;

                }


                if (ddlOfferType.SelectedValue == "6")
                {
                    divDisType.Visible = true;


                    lblDisType.InnerText = "Amount (%):";

                    divBtn.Visible = true;

                }

                if (ddlOfferType.SelectedValue == "2")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount:";

                    divBtn.Visible = true;

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Amount:";

                    divBtn.Visible = true;

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    divDisType.Visible = true;

                    divProductList.Visible = true;
                    lblDisType.InnerText = "Quantity:";

                    divBtn.Visible = true;

                }
            }

        }
    }



    protected void bnAddList_Click(object sender, EventArgs e)
    {

        if (ValiDeltList())
        {
            AddOffer();
        }


    }

    private bool ValiDeltList()
    {
        ddlCampaignType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlOfferType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2";

        txtQtyList.CssClass = "form-control form-control-sm";




        if (ddlCampaignType.SelectedValue == "")
        {
            ddlCampaignType.ToolTip = "please fill out this field";
            ddlCampaignType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlCampaignType.Focus();
            return false;
        }

        if (ddlOfferType.SelectedValue == "")
        {
            ddlOfferType.ToolTip = "please fill out this field";
            ddlOfferType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlOfferType.Focus();
            return false;
        }



        if (ddlOfferType.SelectedIndex > 0)
        {

            if (ddlCampaignType.SelectedValue == "1" || ddlCampaignType.SelectedValue == "2")
            {
                if (ddlOfferType.SelectedValue == "1")
                {


                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }


                }

                if (ddlOfferType.SelectedValue == "2")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }
            }
            else
            {
                if (ddlOfferType.SelectedValue == "1")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }

                if (ddlOfferType.SelectedValue == "7")
                {



                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }


                if (ddlOfferType.SelectedValue == "6")
                {



                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }

                if (ddlOfferType.SelectedValue == "2")
                {

                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    if (ddlProductList.SelectedValue == "")
                    {
                        ddlProductList.ToolTip = "please fill out this field";
                        ddlProductList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ddlProductList.Focus();
                        return false;
                    }


                    if (txtQtyList.Text == "")
                    {
                        txtQtyList.ToolTip = "please fill out this field";
                        txtQtyList.CssClass = "form-control form-control-sm is-invalid";
                        txtQtyList.Focus();
                        return false;
                    }

                }
            }

        }


        return true;
    }

    protected void BtnProductOffer_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveOffer(rowindex);
    }

    public void AddOffer()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("BonusTypeId");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("TypeName");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Qty");
        aDataTable.Columns.Add("Amount");
        aDataTable.Columns.Add("PercentAmount");
        aDataTable.Columns.Add("CampaignDetailId");




        DataRow dataRow = null;
        for (int i = 0; i < gv_ProductOffer.Rows.Count; i++)
        {




            dataRow = aDataTable.NewRow();


            HiddenField hfBonusTypeId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfBonusTypeId"));
            HiddenField hfProductId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfProductId"));
            HiddenField CampaignDetailId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("CampaignDetailId"));


            Label lbl_OfferType = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_OfferType"));
            Label lbl_ProductName = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_ProductName"));
            Label lbl_Qty = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_Qty"));
            Label lbl_Amount = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_Amount"));
            Label lbl_PercentAmount = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_PercentAmount"));


            dataRow["CampaignDetailId"] = CampaignDetailId.Value;
            dataRow["BonusTypeId"] = hfBonusTypeId.Value;
            dataRow["ProductId"] = hfProductId.Value;


            dataRow["TypeName"] = lbl_OfferType.Text;
            dataRow["ProductName"] = lbl_ProductName.Text;


            dataRow["Qty"] = lbl_Qty.Text;
            dataRow["Amount"] = lbl_Amount.Text;
            dataRow["PercentAmount"] = lbl_PercentAmount.Text;




            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();

        dataRow["BonusTypeId"] = ddlOfferType.SelectedValue;

        dataRow["TypeName"] = ddlOfferType.SelectedItem.Text;




        if (ddlOfferType.SelectedIndex > 0)
        {

            if (ddlCampaignType.SelectedValue == "1" || ddlCampaignType.SelectedValue == "2")
            {
                if (ddlOfferType.SelectedValue == "1")
                {


                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";
                    //  dataRow["PercentAmount"] = "";
                    dataRow["Amount"] = "";
                    dataRow["PercentAmount"] = txtQtyList.Text;

                }

                if (ddlOfferType.SelectedValue == "2")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";
                    dataRow["Amount"] = txtQtyList.Text;

                    dataRow["PercentAmount"] = "";

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = txtQtyList.Text;
                    dataRow["PercentAmount"] = "";

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = txtQtyList.Text;

                    dataRow["Amount"] = "";
                    dataRow["PercentAmount"] = "";

                }
            }
            else
            {
                if (ddlOfferType.SelectedValue == "1")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = txtQtyList.Text;
                    dataRow["PercentAmount"] = "";

                }

                if (ddlOfferType.SelectedValue == "7")
                {
                    dataRow["ProductId"] = "";
                    dataRow["ProductName"] = "";

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = txtQtyList.Text;
                    dataRow["PercentAmount"] = "";

                }


                if (ddlOfferType.SelectedValue == "6")
                {
                    dataRow["ProductId"] = "";
                    dataRow["ProductName"] = "";

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = "";
                    dataRow["PercentAmount"] = txtQtyList.Text;

                }

                if (ddlOfferType.SelectedValue == "2")
                {

                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = txtQtyList.Text;
                    dataRow["PercentAmount"] = "";

                }

                if (ddlOfferType.SelectedValue == "3")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = "";

                    dataRow["Amount"] = txtQtyList.Text;
                    dataRow["PercentAmount"] = "";

                }


                if (ddlOfferType.SelectedValue == "5")
                {
                    dataRow["ProductId"] = ddlProductList.SelectedValue;
                    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

                    dataRow["Qty"] = txtQtyList.Text;

                    dataRow["Amount"] = "";
                    dataRow["PercentAmount"] = "";

                }
            }

        }

        //if (ddlOfferType.SelectedValue == "2")
        //{
        //    dataRow["ProductId"] = ddlProductList.SelectedValue;
        //    dataRow["ProductName"] = ddlProductList.SelectedItem.Text;

        //    dataRow["Qty"] = txtQtyList.Text;

        //    dataRow["Amount"] = "";
        //}
        //else
        //{
        //    dataRow["Amount"] = txtQtyList.Text;
        //    dataRow["Qty"] = "";
        //    dataRow["ProductId"] = "";
        //    dataRow["ProductName"] ="";


        //}


        aDataTable.Rows.Add(dataRow);
        gv_ProductOffer.DataSource = aDataTable;
        gv_ProductOffer.DataBind();


        ddlProductList.SelectedValue = string.Empty;
        txtQtyList.Text = string.Empty;
        ddlOfferType.SelectedValue = string.Empty;

    }

    public void AddMarket()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("GroupId");
        aDataTable.Columns.Add("RegionId");
        aDataTable.Columns.Add("AreaId");
        aDataTable.Columns.Add("TerritoryId");
        aDataTable.Columns.Add("SubTerritoryId");
        aDataTable.Columns.Add("MarketId");

        aDataTable.Columns.Add("GroupName");
        aDataTable.Columns.Add("RegionName");
        aDataTable.Columns.Add("AreaName");
        aDataTable.Columns.Add("TerritoryName");
        aDataTable.Columns.Add("SubTerritoryName");
        aDataTable.Columns.Add("MarketName");




        DataRow dataRow = null;
        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {




            dataRow = aDataTable.NewRow();


            HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
            HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
            HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
            HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

            HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

            HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));


            Label lbl_GroupName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_GroupName"));

            Label lbl_RegionName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_RegionName"));
            Label lbl_AreaName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_AreaName"));
            Label lbl_TerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_TerritoryName"));
            Label lbl_SubTerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_SubTerritoryName"));
            Label lbl_MarketName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_MarketName"));


            dataRow["GroupId"] = hfGroupId.Value;
            dataRow["RegionId"] = hfRegionId.Value;
            dataRow["AreaId"] = hfAreaId.Value;
            dataRow["TerritoryId"] = hfTerritoryId.Value;
            dataRow["SubTerritoryId"] = hfSubTerritoryId.Value;
            dataRow["MarketId"] = hfMarketId.Value;

            dataRow["GroupName"] = lbl_GroupName.Text;
            dataRow["RegionName"] = lbl_RegionName.Text;
            dataRow["AreaName"] = lbl_AreaName.Text;
            dataRow["TerritoryName"] = lbl_TerritoryName.Text;
            dataRow["SubTerritoryName"] = lbl_SubTerritoryName.Text;
            dataRow["MarketName"] = lbl_MarketName.Text;



            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();
        dataRow["GroupId"] = GroupSelect.SelectedIndex > 0 ? int.Parse(GroupSelect.SelectedValue) : (int?)null;
        dataRow["RegionId"] = ZoneSelect.SelectedIndex > 0 ? int.Parse(ZoneSelect.SelectedValue) : (int?)null;
        dataRow["AreaId"] = AreaSelect.SelectedIndex > 0 ? int.Parse(AreaSelect.SelectedValue) : (int?)null;
        dataRow["TerritoryId"] = TeritorySelect.SelectedIndex > 0 ? int.Parse(TeritorySelect.SelectedValue) : (int?)null;
        dataRow["SubTerritoryId"] = SubTeritory.SelectedIndex > 0 ? int.Parse(SubTeritory.SelectedValue) : (int?)null;
        dataRow["MarketId"] = MarketSelect.SelectedIndex > 0 ? int.Parse(MarketSelect.SelectedValue) : (int?)null;


        dataRow["GroupName"] = GroupSelect.SelectedIndex > 0 ? GroupSelect.SelectedItem.Text : null;
        dataRow["RegionName"] = ZoneSelect.SelectedIndex > 0 ? ZoneSelect.SelectedItem.Text : null;


        dataRow["AreaName"] = AreaSelect.SelectedIndex > 0 ? AreaSelect.SelectedItem.Text : null;
        dataRow["TerritoryName"] = TeritorySelect.SelectedIndex > 0 ? TeritorySelect.SelectedItem.Text : null;
        dataRow["SubTerritoryName"] = SubTeritory.SelectedIndex > 0 ? SubTeritory.SelectedItem.Text : null;
        dataRow["MarketName"] = MarketSelect.SelectedIndex > 0 ? MarketSelect.SelectedItem.Text : null;




        aDataTable.Rows.Add(dataRow);
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        GroupSelect.SelectedValue = string.Empty;
        ZoneSelect.Items.Clear();
        AreaSelect.Items.Clear();
        TeritorySelect.Items.Clear();
        SubTeritory.Items.Clear();
        MarketSelect.Items.Clear();


    }

    protected void MarketdeleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMarket(rowindex);
    }
    public void RemoveMarket(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("GroupId");
        aDataTable.Columns.Add("RegionId");
        aDataTable.Columns.Add("AreaId");
        aDataTable.Columns.Add("TerritoryId");
        aDataTable.Columns.Add("SubTerritoryId");
        aDataTable.Columns.Add("MarketId");

        aDataTable.Columns.Add("GroupName");
        aDataTable.Columns.Add("RegionName");
        aDataTable.Columns.Add("AreaName");
        aDataTable.Columns.Add("TerritoryName");
        aDataTable.Columns.Add("SubTerritoryName");
        aDataTable.Columns.Add("MarketName");

        DataRow dataRow = null;
        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
                HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
                HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

                HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

                HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));


                Label lbl_GroupName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_GroupName"));

                Label lbl_RegionName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_RegionName"));
                Label lbl_AreaName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_AreaName"));
                Label lbl_TerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_TerritoryName"));
                Label lbl_SubTerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_SubTerritoryName"));
                Label lbl_MarketName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_MarketName"));


                dataRow["GroupId"] = hfGroupId.Value;
                dataRow["RegionId"] = hfRegionId.Value;
                dataRow["AreaId"] = hfAreaId.Value;
                dataRow["TerritoryId"] = hfTerritoryId.Value;
                dataRow["SubTerritoryId"] = hfSubTerritoryId.Value;
                dataRow["MarketId"] = hfMarketId.Value;

                dataRow["GroupName"] = lbl_GroupName.Text;
                dataRow["RegionName"] = lbl_RegionName.Text;
                dataRow["AreaName"] = lbl_AreaName.Text;
                dataRow["TerritoryName"] = lbl_TerritoryName.Text;
                dataRow["SubTerritoryName"] = lbl_SubTerritoryName.Text;
                dataRow["MarketName"] = lbl_MarketName.Text;

                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();

    }
    protected void btnAddtoListMarket_Click(object sender, EventArgs e)
    {
        GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (GroupSelect.SelectedValue != "")
        {
            AddMarket();

        }
        else
        {
            GroupSelect.ToolTip = "please fill out this field";
            GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            GroupSelect.Focus();

        }
    }

    protected void deleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMarket(rowindex);
    }
    public void RemoveOffer(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("BonusTypeId");
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("TypeName");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("Qty");
        aDataTable.Columns.Add("Amount");
        aDataTable.Columns.Add("PercentAmount");
        aDataTable.Columns.Add("CampaignDetailId");

        DataRow dataRow = null;
        for (int i = 0; i < gv_ProductOffer.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                HiddenField hfBonusTypeId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfBonusTypeId"));
                HiddenField hfProductId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfProductId"));
                HiddenField CampaignDetailId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("CampaignDetailId"));


                Label lbl_OfferType = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_OfferType"));
                Label lbl_ProductName = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_ProductName"));
                Label lbl_Qty = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_Qty"));
                Label lbl_Amount = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_Amount"));
                Label lbl_PercentAmount = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_PercentAmount"));

                dataRow["CampaignDetailId"] = CampaignDetailId.Value;
                dataRow["BonusTypeId"] = hfBonusTypeId.Value;
                dataRow["ProductId"] = hfProductId.Value;


                dataRow["TypeName"] = lbl_OfferType.Text;
                dataRow["ProductName"] = lbl_ProductName.Text;
                dataRow["Qty"] = lbl_Qty.Text;
                dataRow["Amount"] = lbl_Amount.Text;
                dataRow["PercentAmount"] = lbl_PercentAmount.Text;

                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_ProductOffer.DataSource = aDataTable;
        gv_ProductOffer.DataBind();

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


        txtCampaignName.CssClass = "form-control form-control-sm";
        ddlChemistType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlCampaignType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlProLine.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2";

        txtProductQty.CssClass = "form-control form-control-sm";
        txtAmount.CssClass = "form-control form-control-sm";
        txtMaxAmount.CssClass = "form-control form-control-sm";


        toDate.CssClass = "form-control form-control-sm";



        if (txtCampaignName.Text == "")
        {
            txtCampaignName.ToolTip = "please fill out this field";
            txtCampaignName.CssClass = "form-control form-control-sm is-invalid";
            txtCampaignName.Focus();
            return false;
        }


        if (ddlChemistType.SelectedValue == "")
        {
            ddlChemistType.ToolTip = "please fill out this field";
            ddlChemistType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlChemistType.Focus();
            return false;
        }
        if (ddlCampaignType.SelectedValue == "")
        {
            ddlCampaignType.ToolTip = "please fill out this field";
            ddlCampaignType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlCampaignType.Focus();
            return false;
        }

        if (ddlProLine.SelectedValue == "")
        {
            ddlProLine.ToolTip = "please fill out this field";
            ddlProLine.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlProLine.Focus();
            return false;
        }


        if (frmDate.Text == "")
        {
            showMessageBox("Please Select Valid From Date!");

            frmDate.Focus();
            return false;
        }



        if (toDate.Text == "")
        {
            showMessageBox("Please Select Valid To Date!");

            toDate.Focus();
            return false;
        }
        if (ddlCampaignType.SelectedValue != "")
        {





            if (ddlCampaignType.SelectedValue == "1")
            {

                if (ddlProduct.SelectedValue == "")
                {
                    ddlProduct.ToolTip = "please fill out this field";
                    ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ddlProduct.Focus();
                    return false;
                }

                if (txtProductQty.Text == "")
                {
                    txtProductQty.ToolTip = "please fill out this field";
                    txtProductQty.CssClass = "form-control form-control-sm is-invalid";
                    txtProductQty.Focus();
                    return false;
                }
            }

            if (ddlCampaignType.SelectedValue == "2")
            {
                if (ddlProduct.SelectedValue == "")
                {
                    ddlProduct.ToolTip = "please fill out this field";
                    ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ddlProduct.Focus();
                    return false;
                }


                if (txtAmount.Text == "")
                {
                    txtAmount.ToolTip = "please fill out this field";
                    txtAmount.CssClass = "form-control form-control-sm is-invalid";
                    txtAmount.Focus();
                    return false;
                }


                if (txtMaxAmount.Text == "")
                {
                    txtMaxAmount.ToolTip = "please fill out this field";
                    txtMaxAmount.CssClass = "form-control form-control-sm is-invalid";
                    txtMaxAmount.Focus();
                    return false;
                }

            }

            if (ddlCampaignType.SelectedValue == "3")
            {


                if (txtAmount.Text == "")
                {
                    txtAmount.ToolTip = "please fill out this field";
                    txtAmount.CssClass = "form-control form-control-sm is-invalid";
                    txtAmount.Focus();
                    return false;
                }


                if (txtMaxAmount.Text == "")
                {
                    txtMaxAmount.ToolTip = "please fill out this field";
                    txtMaxAmount.CssClass = "form-control form-control-sm is-invalid";
                    txtMaxAmount.Focus();
                    return false;
                }

            }



        }


        if (gv_ProductOffer.Rows.Count == 0)
        {

            string text6 = "please Add to List Product Offer!";
            ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
           

            return false;
        }


        if (gv_Market.Rows.Count == 0 && gv_Customer.Rows.Count == 0)
        {
         
            string text6 = "please Add to List Market Structure or Customer!";
            ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);

            return false;
        }


        if(chkManualRationSetup.Checked==true && chkMultipleProductAdd.Checked == true)
        {
            string text6 = "please select Multiple Product Add or Manual Ration Setup!";
            ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);


            return false;
        }

        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {

            List<BonusCampaignMarketDetailDAO> MarketList = new List<BonusCampaignMarketDetailDAO>();


            for (int i = 0; i < gv_Market.Rows.Count; i++)
            {
                HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
                HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
                HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

                HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

                HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));




                BonusCampaignMarketDetailDAO _DAO = new BonusCampaignMarketDetailDAO();

                _DAO.GroupId = string.IsNullOrEmpty(hfGroupId.Value) ? (int?)null : int.Parse(hfGroupId.Value);

                _DAO.RegionId = string.IsNullOrEmpty(hfRegionId.Value) ? (int?)null : int.Parse(hfRegionId.Value);
                _DAO.AreaId = string.IsNullOrEmpty(hfAreaId.Value) ? (int?)null : int.Parse(hfAreaId.Value);
                _DAO.TerritoryId = string.IsNullOrEmpty(hfTerritoryId.Value) ? (int?)null : int.Parse(hfTerritoryId.Value);
                _DAO.SubTerritoryId = string.IsNullOrEmpty(hfSubTerritoryId.Value) ? (int?)null : int.Parse(hfSubTerritoryId.Value);
                _DAO.MarketId = string.IsNullOrEmpty(hfMarketId.Value) ? (int?)null : int.Parse(hfMarketId.Value);








                MarketList.Add(_DAO);

            }

            List<BonusCampaignNewDetailDAO> DtlList = new List<BonusCampaignNewDetailDAO>();


            for (int i = 0; i < gv_ProductOffer.Rows.Count; i++)
            {
                HiddenField hfBonusTypeId = (HiddenField)gv_ProductOffer.Rows[i].FindControl("hfBonusTypeId");
                HiddenField hfProductId = (HiddenField)gv_ProductOffer.Rows[i].FindControl("hfProductId");
                HiddenField CampaignDetailId = (HiddenField)gv_ProductOffer.Rows[i].FindControl("CampaignDetailId");
                Label lbl_Qty = (Label)gv_ProductOffer.Rows[i].FindControl("lbl_Qty");
                Label lbl_Amount = (Label)gv_ProductOffer.Rows[i].FindControl("lbl_Amount");
                Label lbl_PercentAmount = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_PercentAmount"));




                BonusCampaignNewDetailDAO _DAO = new BonusCampaignNewDetailDAO();

                _DAO.CampaignDetailId = string.IsNullOrEmpty(CampaignDetailId.Value) ? (int?)null : int.Parse(CampaignDetailId.Value);
                _DAO.BonusTypeId = string.IsNullOrEmpty(hfBonusTypeId.Value) ? (int?)null : int.Parse(hfBonusTypeId.Value);
                _DAO.BonusProductId = string.IsNullOrEmpty(hfProductId.Value) ? (int?)null : int.Parse(hfProductId.Value);
                _DAO.ProductId = ddlProduct.SelectedIndex > 0 ? int.Parse(ddlProduct.SelectedValue) : (int?)null;

                _DAO.BonusQuantity = string.IsNullOrEmpty(lbl_Qty.Text) ? (decimal?)null : decimal.Parse(lbl_Qty.Text);
                _DAO.DiscountPercentage = string.IsNullOrEmpty(lbl_PercentAmount.Text) ? (decimal?)null : Decimal.Parse(lbl_PercentAmount.Text);
                _DAO.QuantityDteail = string.IsNullOrEmpty(lbl_Amount.Text) ? (decimal?)null : decimal.Parse(lbl_Amount.Text);


                _DAO.Quantity = string.IsNullOrEmpty(txtProductQty.Text) ? (decimal?)null : decimal.Parse(txtProductQty.Text);



                DtlList.Add(_DAO);

            }


            List<CampaignCustomerDetailDAO> DtlCustList = new List<CampaignCustomerDetailDAO>();


            for (int i = 0; i < gv_Customer.Rows.Count; i++)
            {
                HiddenField hfCustomerMasterId = (HiddenField)gv_Customer.Rows[i].FindControl("hfCustomerMasterId");





                CampaignCustomerDetailDAO _DAO = new CampaignCustomerDetailDAO();

                _DAO.CustomerMasterId = string.IsNullOrEmpty(hfCustomerMasterId.Value) ? (int?)null : int.Parse(hfCustomerMasterId.Value);





                DtlCustList.Add(_DAO);

            }



            List<ManualRationSetupCampDAO> ManualRationProList = new List<ManualRationSetupCampDAO>();


            for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
            {
                TextBox txtMainQuantity_From = (TextBox)gv_ManualRationSetup.Rows[i].FindControl("txtMainQuantity_From");
                TextBox txtMainQuantity_ManualRationSetup = (TextBox)gv_ManualRationSetup.Rows[i].FindControl("txtMainQuantity_ManualRationSetup");
                TextBox txtBonusQuantity_ManualRationSetup = (TextBox)gv_ManualRationSetup.Rows[i].FindControl("txtBonusQuantity_ManualRationSetup");





                ManualRationSetupCampDAO _DAOMRP = new ManualRationSetupCampDAO();
                _DAOMRP.ProductId = ddlProduct.SelectedIndex > 0 ? int.Parse(ddlProduct.SelectedValue) : (int?)null;
                _DAOMRP.BounsProductId =  string.IsNullOrEmpty(hfOferProId.Value) ? (int?)null : int.Parse(hfOferProId.Value);


                _DAOMRP.MainQuantity_From = string.IsNullOrEmpty(txtMainQuantity_From.Text) ? (decimal?)null : decimal.Parse(txtMainQuantity_From.Text);

                _DAOMRP.MainQuantity_ManualRationSetup = string.IsNullOrEmpty(txtMainQuantity_ManualRationSetup.Text) ? (decimal?)null : decimal.Parse(txtMainQuantity_ManualRationSetup.Text);

                _DAOMRP.BonusQuantity_ManualRationSetup = string.IsNullOrEmpty(txtBonusQuantity_ManualRationSetup.Text) ? (decimal?)null : decimal.Parse(txtBonusQuantity_ManualRationSetup.Text);



                ManualRationProList.Add(_DAOMRP);

            }



            List<MultipleProductAddCampDAO> MultipleProductList = new List<MultipleProductAddCampDAO>();


            for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
            {
                DropDownList ddlProduct_MultipleProductAdd = (DropDownList)gv_MultipleProductAdd.Rows[i].FindControl("ddlProduct_MultipleProductAdd");
                TextBox txtProQty_MultipleProductAdd = (TextBox)gv_MultipleProductAdd.Rows[i].FindControl("txtProQty_MultipleProductAdd");





                MultipleProductAddCampDAO _DAOmpa = new MultipleProductAddCampDAO();

                _DAOmpa.ProductId = ddlProduct_MultipleProductAdd.SelectedIndex > 0 ? int.Parse(ddlProduct_MultipleProductAdd.SelectedValue) : (int?)null;

                _DAOmpa.ProQty_MultipleProductAdd = string.IsNullOrEmpty(txtProQty_MultipleProductAdd.Text) ? (decimal?)null : decimal.Parse(txtProQty_MultipleProductAdd.Text);



                MultipleProductList.Add(_DAOmpa);

            }



            BonusCampaignNewMasterDAO aMaster = new BonusCampaignNewMasterDAO();

            aMaster.CampgainMasterId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.CampaignName = string.IsNullOrEmpty(txtCampaignName.Text) ? null : txtCampaignName.Text;
            aMaster.CustomerTypeId = ddlChemistType.SelectedIndex > 0 ? int.Parse(ddlChemistType.SelectedValue) : (int?)null;

            aMaster.CampainTypeId = ddlCampaignType.SelectedIndex > 0 ? int.Parse(ddlCampaignType.SelectedValue) : (int?)null;

            aMaster.ProductLineID = ddlProLine.SelectedIndex > 0 ? int.Parse(ddlProLine.SelectedValue) : (int?)null;

            aMaster.Amount = string.IsNullOrEmpty(txtAmount.Text) ? (decimal?)null : decimal.Parse(txtAmount.Text);
            aMaster.ProductQty = string.IsNullOrEmpty(txtProductQty.Text) ? (decimal?)null : decimal.Parse(txtProductQty.Text);


            aMaster.BonusProductId = ddlProduct.SelectedIndex > 0 ? int.Parse(ddlProduct.SelectedValue) : (int?)null;

            aMaster.MaxAmount = string.IsNullOrEmpty(txtMaxAmount.Text) ? (decimal?)null : Decimal.Parse(txtMaxAmount.Text);

            aMaster.FromDate = string.IsNullOrEmpty(frmDate.Text) ? (DateTime?)null : DateTime.Parse(frmDate.Text);
            aMaster.Todate = string.IsNullOrEmpty(toDate.Text) ? (DateTime?)null : DateTime.Parse(toDate.Text);
            aMaster.IsTradePolicy = chkTradePolicy.Checked;
            aMaster.IsActive = chkIsActive.Checked;

            aMaster.IsMultipleProductAdd = chkMultipleProductAdd.Checked;
            aMaster.IsManualRationSetup = chkManualRationSetup.Checked;






            ResultInfo Res = _BonusCampaignNewDAL.SaveBonusCampaign_final(aMaster, DtlList, MarketList, DtlCustList, Session["UserId"].ToString(), ManualRationProList, MultipleProductList);
            if (Res.isSuccess == true)
            {
                System.Threading.Thread.Sleep(100);

                MailMessage mail = new MailMessage();

                try
                {
                    mail.To.Add("towsifcreatrix@gmail.com");
                }
                catch (Exception)
                {

                    //throw;
                }

                //mail.To.Add
                mail.From = new MailAddress("shuvo.creatrixbd@gmail.com");
                mail.From.User.ToString();

                mail.Sender = new System.Net.Mail.MailAddress("shuvo.creatrixbd@gmail.com");
                mail.Subject = "SMC Campaign Setup";
                //if (txtMailCC.Text != "")
                //{
                //    MailAddress copy = new MailAddress(txtMailCC.Text);
                //    mail.CC.Add(copy);
                //}
                MailAddress copy2 = new MailAddress("shuvo.creatrixbd@gmail.com");
                mail.Bcc.Add(copy2);

                if (aMaster.CampgainMasterId > 0)
                {
                    mail.Body = "Salauddin Bhai Update <br> Campaign Name:" + aMaster.CampaignName + "<br> Campaign Type:" + ddlCampaignType.SelectedItem.Text;
                }
                else
                {
                    mail.Body = "Salauddin Bhai Save <br> Campaign Name:" + aMaster.CampaignName + "<br> Campaign Type:" + ddlCampaignType.SelectedItem.Text;
                }


                mail.IsBodyHtml = true;
                mail.Priority = System.Net.Mail.MailPriority.High;

                //Attach file using FileUpload Control and put the file in memory stream

                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com"; //Or Your SMTP Server Address
                smtp.Credentials = new System.Net.NetworkCredential
                     ("shuvo.creatrixbd@gmail.com", "siehdmjwseazaqcs");
                smtp.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
                smtp.Port = 587;
                smtp.EnableSsl = true;

                try
                {
                    smtp.Send(mail);

                }
                catch (System.Net.Mail.SmtpException ex)
                {
                    // showMessageBox("Email has not Sent, Try Once More time");
                }
                catch (Exception exe)
                {
                    //showMessageBox("Email has not Sent, Try Once More time");
                }


                System.Threading.Thread.Sleep(100);

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CampaignView.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }

    }



    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = custNameTextBox.Text.Trim();
        if (empName.Contains(':'))
        {
            string[] emp = empName.Split('|');

            hfCustomerId.Value = emp[1].Trim();
            custNameTextBox.Text = emp[0].Trim();



        }
        else
        {

            custNameTextBox.Text = "";
            hfCustomerId.Value = "";
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Input Correct Data !" + "','Faild');", true);
        }


    }


    protected void btnCustomerAdd_Click(object sender, EventArgs e)
    {
        custNameTextBox.CssClass = "form-control form-control-sm";



        if (hfCustomerId.Value != "")
        {

            if (AddCustomerVali())
            {
                AddCustomer();
            }
            else
            {
                string text6 = "The customer already exists in the list!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                custNameTextBox.CssClass = "form-control form-control-sm is-invalid";
                custNameTextBox.Focus();
                hfCustomerId.Value = "";
                custNameTextBox.Text = "";
            }
           
        }
        else
        {
            custNameTextBox.ToolTip = "please fill out this field";
            custNameTextBox.CssClass = "form-control form-control-sm is-invalid";
            custNameTextBox.Focus();

        }

    }
    public bool AddCustomerVali()
    {

      bool  vvv = true;
        
     for (int i = 0; i < gv_Customer.Rows.Count; i++)
        {
           
            HiddenField hfCustomerMasterId = ((HiddenField)gv_Customer.Rows[i].Cells[1].FindControl("hfCustomerMasterId"));

            if(hfCustomerId.Value.Trim() == hfCustomerMasterId.Value)
            {
                vvv = false;
            }
        }
        return vvv;
    }

    public void AddCustomer()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("CustomerMasterId");
        aDataTable.Columns.Add("CustomerName");


        DataRow dataRow = null;
        for (int i = 0; i < gv_Customer.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            HiddenField hfCustomerMasterId = ((HiddenField)gv_Customer.Rows[i].Cells[1].FindControl("hfCustomerMasterId"));
            Label lbl_CustomerName = ((Label)gv_Customer.Rows[i].Cells[1].FindControl("lbl_CustomerName"));
            dataRow["CustomerMasterId"] = hfCustomerMasterId.Value;
            dataRow["CustomerName"] = lbl_CustomerName.Text;
            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();
        dataRow["CustomerName"] = custNameTextBox.Text.Trim();
        dataRow["CustomerMasterId"] = hfCustomerId.Value.Trim();


        aDataTable.Rows.Add(dataRow);
        gv_Customer.DataSource = aDataTable;
        gv_Customer.DataBind();
        custNameTextBox.Text = string.Empty;
        hfCustomerId.Value = string.Empty;

    }
    public void RemoveCustomer(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("CustomerMasterId");
        aDataTable.Columns.Add("CustomerName");

        DataRow dataRow = null;
        for (int i = 0; i < gv_Customer.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                HiddenField hfCustomerMasterId = ((HiddenField)gv_Customer.Rows[i].Cells[1].FindControl("hfCustomerMasterId"));
                Label lbl_CustomerName = ((Label)gv_Customer.Rows[i].Cells[1].FindControl("lbl_CustomerName"));

                dataRow["CustomerName"] = lbl_CustomerName.Text ;
                dataRow["CustomerMasterId"] = hfCustomerMasterId.Value;
                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_Customer.DataSource = aDataTable;
        gv_Customer.DataBind();

    }
    


    protected void deleteCustomer_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveCustomer(rowindex);
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("CampaignSetup.aspx");
    }

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        

     
        // ClientScript.RegisterStartupScript(this.GetType(), "Popup", "$('#exampleExtraLargeModal').modal('show')", true);
    }


    protected void rmv_MultipleProductAdd_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMultipleProductAdd(rowindex);
    }


    public void AddMultipleProductAdd()
    {
        gv_MultipleProductAdd.DataSource = null;
        gv_MultipleProductAdd.DataBind();

        if (chkMultipleProductAdd.Checked)
        {
            if (txtProductQty.Text.Trim() != "" && ddlProduct.SelectedValue.Trim() != "")
            {


                DataTable aDataTable = new DataTable();
                aDataTable.Columns.Add("ProductId");
                aDataTable.Columns.Add("ProQty_MultipleProductAdd");


                DataRow dataRow = null;
                for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
                {
                    dataRow = aDataTable.NewRow();
                    HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
                    TextBox txtProQty_MultipleProductAdd = ((TextBox)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("txtProQty_MultipleProductAdd"));
                    dataRow["ProductId"] = hfProductId_MultipleProductAdd.Value;
                    dataRow["ProQty_MultipleProductAdd"] = txtProQty_MultipleProductAdd.Text;
                    aDataTable.Rows.Add(dataRow);
                }
                dataRow = aDataTable.NewRow();
                dataRow["ProQty_MultipleProductAdd"] = txtProductQty.Text.Trim();
                dataRow["ProductId"] = ddlProduct.SelectedValue.Trim();


                aDataTable.Rows.Add(dataRow);
                gv_MultipleProductAdd.DataSource = aDataTable;
                gv_MultipleProductAdd.DataBind();



               
                        for (int i = 0; i < aDataTable.Rows.Count; i++)
                        {
                    try
                    {
                        using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
                        {
                            DropDownList ddlProduct_MultipleProductAdd = ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("ddlProduct_MultipleProductAdd"));
                            ddlProduct_MultipleProductAdd.DataSource = dt;

                            ddlProduct_MultipleProductAdd.DataValueField = "ProductId";
                            ddlProduct_MultipleProductAdd.DataTextField = "ProductName";
                            ddlProduct_MultipleProductAdd.DataBind();
                            ddlProduct_MultipleProductAdd.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                            ddlProduct_MultipleProductAdd.SelectedIndex = 0;


                            HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
                            ddlProduct_MultipleProductAdd.CssClass = "form-select form-select-sm mb-3";

                            ddlProduct_MultipleProductAdd.SelectedValue= aDataTable.Rows[i]["ProductId"].ToString();
                            hfProductId_MultipleProductAdd.Value= aDataTable.Rows[i]["ProductId"].ToString();
                        }
                    }
                    
                catch (Exception ex) { }
            }


               

            }
        }


        for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
        {

            LinkButton rmv_MultipleProductAdd = ((LinkButton)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("rmv_MultipleProductAdd"));

            if (i == 0)
            {
                rmv_MultipleProductAdd.Visible = false;
            }
        }


        }


 
    public void RemoveMultipleProductAdd(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("ProductId");
        aDataTable.Columns.Add("ProQty_MultipleProductAdd");

        DataRow dataRow = null;
        for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();

                dataRow["ProductId"] = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd")).Value;

                dataRow["ProQty_MultipleProductAdd"] =
                    ((TextBox)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("txtProQty_MultipleProductAdd")).Text.Trim();

             

              
                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_MultipleProductAdd.DataSource = aDataTable;
        gv_MultipleProductAdd.DataBind();


        for (int i = 0; i < aDataTable.Rows.Count; i++)
        {
            try
            {
                using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
                {
                    DropDownList ddlProduct_MultipleProductAdd = ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("ddlProduct_MultipleProductAdd"));
                    ddlProduct_MultipleProductAdd.DataSource = dt;

                    ddlProduct_MultipleProductAdd.DataValueField = "ProductId";
                    ddlProduct_MultipleProductAdd.DataTextField = "ProductName";
                    ddlProduct_MultipleProductAdd.DataBind();
                    ddlProduct_MultipleProductAdd.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlProduct_MultipleProductAdd.SelectedIndex = 0;


                    HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
                    ddlProduct_MultipleProductAdd.CssClass = "form-select form-select-sm mb-3 ";
                    ddlProduct_MultipleProductAdd.SelectedValue = aDataTable.Rows[i]["ProductId"].ToString();
                    hfProductId_MultipleProductAdd.Value = aDataTable.Rows[i]["ProductId"].ToString();
                }
            }

            catch (Exception ex) { }
        }
        for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
        {

            LinkButton rmv_MultipleProductAdd = ((LinkButton)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("rmv_MultipleProductAdd"));

            if (i == 0)
            {
                rmv_MultipleProductAdd.Visible = false;
            }
        }

    }



    protected void btnNo_Click(object sender, EventArgs e)
    {
        mpe_1.Hide();
    }

    protected void plus_MultipleProductAdd_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)(((LinkButton)sender).Parent.Parent)).RowIndex;
         
        DataTable aTable = new DataTable();
        aTable.Columns.Add("ProductId");
        aTable.Columns.Add("ProQty_MultipleProductAdd");
        DataRow dr;

     
        for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
        {
            dr = aTable.NewRow();

            

            dr["ProductId"] = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd")).Value;
            
            dr["ProQty_MultipleProductAdd"] =
                ((TextBox)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("txtProQty_MultipleProductAdd")).Text.Trim();

            dr["ProductId"] =
                ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[2].FindControl("ddlProduct_MultipleProductAdd"))
                    .SelectedValue.Trim();


            aTable.Rows.Add(dr);
            if (rowIndex == i)
            {
                dr = aTable.NewRow();

              

                dr["ProductId"] = "";
                dr["ProQty_MultipleProductAdd"] = "";
                
                aTable.Rows.Add(dr);
            }
        }

        gv_MultipleProductAdd.DataSource = null;
        gv_MultipleProductAdd.DataBind();
        gv_MultipleProductAdd.DataSource = aTable;
        gv_MultipleProductAdd.DataBind();


        for (int i = 0; i < aTable.Rows.Count; i++)
        {
            try
            {
                using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
                {
                    DropDownList ddlProduct_MultipleProductAdd = ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("ddlProduct_MultipleProductAdd"));
                    ddlProduct_MultipleProductAdd.DataSource = dt;

                    ddlProduct_MultipleProductAdd.DataValueField = "ProductId";
                    ddlProduct_MultipleProductAdd.DataTextField = "ProductName";
                    ddlProduct_MultipleProductAdd.DataBind();
                    ddlProduct_MultipleProductAdd.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlProduct_MultipleProductAdd.SelectedIndex = 0;


                    HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
                    ddlProduct_MultipleProductAdd.CssClass = "form-select form-select-sm mb-3 ";
                    ddlProduct_MultipleProductAdd.SelectedValue = aTable.Rows[i]["ProductId"].ToString();
                    hfProductId_MultipleProductAdd.Value = aTable.Rows[i]["ProductId"].ToString();
                }
            }

            catch (Exception ex) { }
        }
        for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
        {

            LinkButton rmv_MultipleProductAdd = ((LinkButton)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("rmv_MultipleProductAdd"));

            if (i == 0)
            {
                rmv_MultipleProductAdd.Visible = false;
            }
        }


    }

    protected void rmvModalManualRationSetup_Click(object sender, EventArgs e)
    {
        mp_2.Hide();
    }



    public void AddManualRationSetup()
    {
        gv_ManualRationSetup.DataSource = null;
        gv_ManualRationSetup.DataBind();

        if (chkManualRationSetup.Checked)
        {
            if (txtProductQty.Text.Trim() != "" && ddlProduct.SelectedValue.Trim() != "")
            {

                lblInfo.Text = "Manual Ration Setup for : " + ddlProduct.SelectedItem.Text;

                DataTable aDataTable = new DataTable();
                aDataTable.Columns.Add("MainQuantity_ManualRationSetup");  
                aDataTable.Columns.Add("MainQuantity_From"); 
                aDataTable.Columns.Add("BonusQuantity_ManualRationSetup");


                DataRow dataRow = null;
                for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
                {
                    dataRow = aDataTable.NewRow();

                    TextBox txtBonusQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtBonusQuantity_ManualRationSetup"));
                    TextBox txtMainQuantity_From = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_From"));

                    TextBox txtMainQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_ManualRationSetup"));


                    dataRow["BonusQuantity_ManualRationSetup"] = txtBonusQuantity_ManualRationSetup.Text;
                    dataRow["MainQuantity_ManualRationSetup"] = txtMainQuantity_ManualRationSetup.Text;
                    dataRow["MainQuantity_From"] = txtMainQuantity_From.Text;
                    aDataTable.Rows.Add(dataRow);
                }
                dataRow = aDataTable.NewRow();
                dataRow["MainQuantity_ManualRationSetup"] = txtProductQty.Text.Trim();
                dataRow["MainQuantity_From"] = txtProductQty.Text.Trim();


                for (int i = 0; i < gv_ProductOffer.Rows.Count; i++)
                {
                    HiddenField hfProductId = ((HiddenField)gv_ProductOffer.Rows[i].Cells[1].FindControl("hfProductId"));
                    Label lbl_Qty = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_Qty"));
                    Label lbl_ProductName = ((Label)gv_ProductOffer.Rows[i].Cells[1].FindControl("lbl_ProductName"));
                    dataRow["BonusQuantity_ManualRationSetup"] = lbl_Qty.Text;

                    hfOferProId.Value = hfProductId.Value;
                    OferPro.Text ="Offer Product Name: "+ lbl_ProductName.Text;



                }



                aDataTable.Rows.Add(dataRow);
                gv_ManualRationSetup.DataSource = aDataTable;
                gv_ManualRationSetup.DataBind();



                for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
                {

                    LinkButton rmv_ManualRationSetup = ((LinkButton)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("rmv_ManualRationSetup"));

                    if (i == 0)
                    {
                        rmv_ManualRationSetup.Visible = false;
                    }
                }




            }
        }





    }

    protected void plus_ManualRationSetup_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)(((LinkButton)sender).Parent.Parent)).RowIndex;

        DataTable aTable = new DataTable();
        aTable.Columns.Add("MainQuantity_ManualRationSetup");
        aTable.Columns.Add("BonusQuantity_ManualRationSetup");
        aTable.Columns.Add("MainQuantity_From");
        DataRow dr;


        for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
        {
            dr = aTable.NewRow();



            TextBox txtBonusQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtBonusQuantity_ManualRationSetup"));
            TextBox txtMainQuantity_From = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_From"));

            TextBox txtMainQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_ManualRationSetup"));

            dr["BonusQuantity_ManualRationSetup"] = txtBonusQuantity_ManualRationSetup.Text;
            dr["MainQuantity_ManualRationSetup"] = txtMainQuantity_ManualRationSetup.Text;
            dr["MainQuantity_From"] = txtMainQuantity_From.Text;



            aTable.Rows.Add(dr);
            if (rowIndex == i)
            {
                dr = aTable.NewRow();



                dr["BonusQuantity_ManualRationSetup"] = "";
                dr["MainQuantity_ManualRationSetup"] = "";
                dr["MainQuantity_From"] = "";

                aTable.Rows.Add(dr);
            }
        }

        gv_ManualRationSetup.DataSource = null;
        gv_ManualRationSetup.DataBind();
        gv_ManualRationSetup.DataSource = aTable;
        gv_ManualRationSetup.DataBind();

        for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
        {

            LinkButton rmv_ManualRationSetup = ((LinkButton)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("rmv_ManualRationSetup"));

            if (i == 0)
            {
                rmv_ManualRationSetup.Visible = false;
            }
        }
    }


    public void RemoveManualRationSetup(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("MainQuantity_ManualRationSetup");
        aDataTable.Columns.Add("BonusQuantity_ManualRationSetup");
        aDataTable.Columns.Add("MainQuantity_From");

        DataRow dataRow = null;
        for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();

              

                TextBox txtBonusQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtBonusQuantity_ManualRationSetup"));
                TextBox txtMainQuantity_From = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_From"));

                TextBox txtMainQuantity_ManualRationSetup = ((TextBox)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("txtMainQuantity_ManualRationSetup"));

                dataRow["BonusQuantity_ManualRationSetup"] = txtBonusQuantity_ManualRationSetup.Text;
                dataRow["MainQuantity_ManualRationSetup"] = txtMainQuantity_ManualRationSetup.Text;
                dataRow["MainQuantity_From"] = txtMainQuantity_From.Text;




                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_ManualRationSetup.DataSource = aDataTable;
        gv_ManualRationSetup.DataBind();

        for (int i = 0; i < gv_ManualRationSetup.Rows.Count; i++)
        {

            LinkButton rmv_ManualRationSetup = ((LinkButton)gv_ManualRationSetup.Rows[i].Cells[1].FindControl("rmv_ManualRationSetup"));

            if (i == 0)
            {
                rmv_ManualRationSetup.Visible = false;
            }
        }

    }

        protected void rmv_ManualRationSetup_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        RemoveManualRationSetup(rowindex);
    }

    protected void chkMultipleProductAdd_CheckedChanged(object sender, EventArgs e)
    {
        //gv_MultipleProductAdd.DataSource = null;
        //gv_MultipleProductAdd.DataBind();

        //gv_ManualRationSetup.DataSource = null;
        //gv_ManualRationSetup.DataBind();

        

       

          if (id_mastetID.Value != "")
        {


            mpe_1.Show();
            using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailMulProById(id_mastetID.Value))
            {
                gv_MultipleProductAdd.DataSource = dtDetail;
                gv_MultipleProductAdd.DataBind();


                for (int i = 0; i < dtDetail.Rows.Count; i++)
                {
                    chkMultipleProductAdd.Checked = true;
                    try
                    {
                        using (DataTable dt = _BonusCampaignNewDAL.GetProductForDDL())
                        {
                            DropDownList ddlProduct_MultipleProductAdd = ((DropDownList)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("ddlProduct_MultipleProductAdd"));
                            ddlProduct_MultipleProductAdd.DataSource = dt;

                            ddlProduct_MultipleProductAdd.DataValueField = "ProductId";
                            ddlProduct_MultipleProductAdd.DataTextField = "ProductName";
                            ddlProduct_MultipleProductAdd.DataBind();
                            ddlProduct_MultipleProductAdd.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                            ddlProduct_MultipleProductAdd.SelectedIndex = 0;


                            HiddenField hfProductId_MultipleProductAdd = ((HiddenField)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("hfProductId_MultipleProductAdd"));
                            ddlProduct_MultipleProductAdd.CssClass = "form-select form-select-sm mb-3";

                            ddlProduct_MultipleProductAdd.SelectedValue = dtDetail.Rows[i]["ProductId"].ToString();
                            hfProductId_MultipleProductAdd.Value = dtDetail.Rows[i]["ProductId"].ToString();
                        }
                    }

                    catch (Exception ex) { }
                }

                for (int i = 0; i < gv_MultipleProductAdd.Rows.Count; i++)
                {

                    LinkButton rmv_MultipleProductAdd = ((LinkButton)gv_MultipleProductAdd.Rows[i].Cells[1].FindControl("rmv_MultipleProductAdd"));

                    if (i == 0)
                    {
                        rmv_MultipleProductAdd.Visible = false;
                    }
                }

            }

        }

        else if (gv_MultipleProductAdd.Rows.Count > 0)
        {
            mpe_1.Show();
            //chkMultipleProductAdd.Checked = true;
        }


        else
        {

            if (Validationfor_multi())
            {

                if (chkMultipleProductAdd.Checked)
                {

                    mpe_1.Show();
                    AddMultipleProductAdd();
                }
            }
            else
            {
                chkMultipleProductAdd.Checked = false;
                gv_MultipleProductAdd.DataSource = null;
                gv_MultipleProductAdd.DataBind();
                mpe_1.Hide();
            }
        }
    }

    protected void chkManualRationSetup_CheckedChanged(object sender, EventArgs e)
    {

        //gv_MultipleProductAdd.DataSource = null;
        //gv_MultipleProductAdd.DataBind();

        //gv_ManualRationSetup.DataSource = null;
        //gv_ManualRationSetup.DataBind();

     


             if (id_mastetID.Value != "")
        {


            using (DataTable dtDetail = _BonusCampaignNewDAL.GetCampaignSetupDetailMannualRatioById(id_mastetID.Value))
            {
                gv_ManualRationSetup.DataSource = dtDetail;
                gv_ManualRationSetup.DataBind();


                mp_2.Show();

                if (gv_ManualRationSetup.Rows.Count > 0)
                {


                    hfOferProId.Value = dtDetail.Rows[0]["BounsProductId"].ToString(); 
                    OferPro.Text = "Offer Product Name: " + dtDetail.Rows[0]["BounsProductName"].ToString();

                    lblInfo.Text = "Manual Ration Setup for : " + dtDetail.Rows[0]["MainProductName"].ToString();

                    chkManualRationSetup.Checked = true;
                }
            }
        }

        else if (gv_ManualRationSetup.Rows.Count > 0)
        {
            mp_2.Show();
            //chkManualRationSetup.Checked = true;
        }

        else
        {

            if (Validationfor_Ratio())
            {
                if (chkManualRationSetup.Checked)
                {
                    mp_2.Show();
                    AddManualRationSetup();
                }
            }
            else
            {
                chkManualRationSetup.Checked = false;
                gv_ManualRationSetup.DataSource = null;
                gv_ManualRationSetup.DataBind();
                mp_2.Hide();
            }


        }

    }

    public bool Validationfor_multi()
    {


        txtProductQty.CssClass = "form-control form-control-sm";
        ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (ddlProduct.SelectedValue == "")
        {
            ddlProduct.ToolTip = "please fill out this field";
            ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlProduct.Focus();
            return false;
        }

        if (txtProductQty.Text == "")
        {
            txtProductQty.ToolTip = "please fill out this field";
            txtProductQty.CssClass = "form-control form-control-sm is-invalid";
            txtProductQty.Focus();
            return false;
        }
       

       
        return true;
    }


    public bool Validationfor_Ratio()
    {


        txtProductQty.CssClass = "form-control form-control-sm";
        ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (ddlProduct.SelectedValue == "")
        {
            ddlProduct.ToolTip = "please fill out this field";
            ddlProduct.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlProduct.Focus();
            return false;
        }

        if (txtProductQty.Text == "")
        {
            txtProductQty.ToolTip = "please fill out this field";
            txtProductQty.CssClass = "form-control form-control-sm is-invalid";
            txtProductQty.Focus();
            return false;
        }
        if (gv_ProductOffer.Rows.Count == 0)
        {
            string text6 = "Add to List Offer Product!";
            ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
            return false;
        }


        return true;
    }

}
