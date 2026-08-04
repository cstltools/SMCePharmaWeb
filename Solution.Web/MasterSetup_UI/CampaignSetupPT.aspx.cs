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

public partial class MasterSetup_UI_CampaignSetupPT : System.Web.UI.Page
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


                ddlCampaignCategory.SelectedValue = dt.Rows[0]["CampaignCategoryId"].ToString();
                ddlCampaignType.SelectedValue = dt.Rows[0]["CampainTypeId"].ToString();
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


                bool _chkTradePolicy = false;
                try
                {
                    _chkTradePolicy = Convert.ToBoolean(dt.Rows[0]["IsTradePolicy"].ToString());
                }
                catch (Exception ex)
                {
                    
                } 
                
                bool _chkFCFS = false;
                try
                {
                    _chkFCFS = Convert.ToBoolean(dt.Rows[0]["IsFCFS"].ToString());
                }
                catch (Exception ex)
                {
                    
                }
                if (_chkTradePolicy)
                {
                    chkTradePolicy.Checked = true;
                }
                 if (_chkFCFS)
                {
                    chkFCFS.Checked = true;

                }

                try
                {
                    chkIsRatioWiseIncrement.Checked = Convert.ToBoolean(dt.Rows[0]["IsRatioWiseIncrement"].ToString());
                }
                catch (Exception ex)
                {
                    chkIsRatioWiseIncrement.Checked = false;
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
            using (DataTable dt = _seedRepo.GetCampaignCategory())
            {
                ddlCampaignCategory.DataSource = dt;

                ddlCampaignCategory.DataValueField = "CampaignCategoryId";
                ddlCampaignCategory.DataTextField = "CampaignCategory";
                ddlCampaignCategory.DataBind();
                ddlCampaignCategory.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlCampaignCategory.SelectedIndex = 0;
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
        ddlCampaignCategory.CssClass = "form-select form-select-sm mb-3 mySelect2";
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

        if (ddlCampaignCategory.SelectedValue == "")
        {
            ddlCampaignCategory.ToolTip = "please fill out this field";
            ddlCampaignCategory.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlCampaignCategory.Focus();
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
            showMessageBox("please Add to List Product Offer");

            return false;
        }


        if (gv_Market.Rows.Count == 0 && gv_Customer.Rows.Count == 0)
        {
            showMessageBox("please Add to List Market Structure or Customer!");

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
                _DAO.IsRatioWiseIncrementPro = false;
                if (chkIsRatioWiseIncrement.Checked)
                {
                    try
                    {
                        if (_DAO.BonusProductId > 0)
                        {
                            _DAO.IsRatioWiseIncrementPro= chkIsRatioWiseIncrement.Checked;
                        }
                    }
                    catch
                    {

                    }
                }

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


            BonusCampaignNewMasterDAO aMaster = new BonusCampaignNewMasterDAO();

            aMaster.CampgainMasterId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.CampaignName = string.IsNullOrEmpty(txtCampaignName.Text) ? null : txtCampaignName.Text;
            aMaster.CustomerTypeId = ddlChemistType.SelectedIndex > 0 ? int.Parse(ddlChemistType.SelectedValue) : (int?)null;

            aMaster.CampainTypeId = ddlCampaignType.SelectedIndex > 0 ? int.Parse(ddlCampaignType.SelectedValue) : (int?)null;
            aMaster.CampaignCategoryId = ddlCampaignCategory.SelectedIndex > 0 ? int.Parse(ddlCampaignCategory.SelectedValue) : (int?)null;

            aMaster.ProductLineID = ddlProLine.SelectedIndex > 0 ? int.Parse(ddlProLine.SelectedValue) : (int?)null;

            aMaster.Amount = string.IsNullOrEmpty(txtAmount.Text) ? (decimal?)null : decimal.Parse(txtAmount.Text);
            aMaster.ProductQty = string.IsNullOrEmpty(txtProductQty.Text) ? (decimal?)null : decimal.Parse(txtProductQty.Text);


            aMaster.BonusProductId = ddlProduct.SelectedIndex > 0 ? int.Parse(ddlProduct.SelectedValue) : (int?)null;

            aMaster.MaxAmount = string.IsNullOrEmpty(txtMaxAmount.Text) ? (decimal?)null : Decimal.Parse(txtMaxAmount.Text);

            aMaster.FromDate = string.IsNullOrEmpty(frmDate.Text) ? (DateTime?)null : DateTime.Parse(frmDate.Text);
            aMaster.Todate = string.IsNullOrEmpty(toDate.Text) ? (DateTime?)null : DateTime.Parse(toDate.Text);







            aMaster.IsTradePolicy = chkTradePolicy.Checked;
            aMaster.IsFCFS = chkFCFS.Checked;
             
            aMaster.IsRatioWiseIncrement = chkIsRatioWiseIncrement.Checked;
            aMaster.IsActive = chkIsActive.Checked;





            ResultInfo Res = _BonusCampaignNewDAL.SaveBonusCampaign(aMaster, DtlList, MarketList, DtlCustList, Session["UserId"].ToString());
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
                    mail.Body = "Salauddin Bhai Update <br> Campaign Name:" + aMaster.CampaignName + "<br> Campaign Type:" + ddlCampaignType.SelectedItem.Text+"<br>Date Range: "+frmDate.Text+" to "+toDate.Text;
                }
                else
                {
                    mail.Body = "Salauddin Bhai Save <br> Campaign Name:" + aMaster.CampaignName + "<br> Campaign Type:" + ddlCampaignType.SelectedItem.Text + "<br>Date Range: " + frmDate.Text + " to " + toDate.Text;
                }


                mail.IsBodyHtml = true;
                mail.Priority = System.Net.Mail.MailPriority.High;

                //Attach file using FileUpload Control and put the file in memory stream

                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com"; //Or Your SMTP Server Address
                smtp.Credentials = new System.Net.NetworkCredential
                     ("shuvo.creatrixbd@gmail.com", "glgg rjov qtig veqz");
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
}
