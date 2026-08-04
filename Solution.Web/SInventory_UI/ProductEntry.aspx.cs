using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class SInventory_UI_ProductEntry : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private static CustomerInfoDAL _DAL = new CustomerInfoDAL();

    ProductBLL aProductBLL = new ProductBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Form.Attributes.Add("enctype", "multipart/form-data");

        if (hfDocFile.Value!="")
        {
            img_emp.ImageUrl = "../UploadFile/" + hfDocFile.Value;
        }
        if (!IsPostBack)
        {
            LoadProductCategory();

            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;

                productIdHiddenField.Value = Request.QueryString["ID"];
                ProductEditLoad(productIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
           
        }
       
    }

    private void ProductEditLoad(string productId)
    {
        Product Product = new Product();
        Product = aProductBLL.ProductEditLoad(productId);
        productNameTextBox.Text = Product.ProductName;
        descriptionTextBox.Text = Product.Description;
        productCodeTextBox.Text = Product.ProductCode;

        if (Product.CategoryId > 0)
            categoryNameDropDownList.SelectedValue = Product.CategoryId.ToString();
        if (Product.ManufacId > 0)
            manufacDropDownList.SelectedValue = Product.ManufacId.ToString();
        if (Product.PackSizeId > 0)
            packSizeDropDownList.SelectedValue = Product.PackSizeId.ToString();
        if (Product.ProTypeId > 0)
            typeDropDownList.SelectedValue = Product.ProTypeId.ToString();
        if (Product.ProductBrandId > 0)
            productSQDropDownList.SelectedValue = Product.ProductBrandId.ToString();
        if (Product.CaseId > 0)
            shippingCartonSizeDropDownList.SelectedValue = Product.CaseId.ToString();
        if (Product.StockUOMId > 0)
            stockUOMDropDownList.SelectedValue = Product.StockUOMId.ToString();

        img_emp.ImageUrl = "../UploadFile/" + Product.ProductImage;
        hfDocFile.Value = Product.ProductImage;

        if (Product.TherapueticGroupId.HasValue && Product.TherapueticGroupId.Value > 0)
            ddlTherapeutic.SelectedValue = Product.TherapueticGroupId.Value.ToString();
        if (Product.GenericGroupId.HasValue && Product.GenericGroupId.Value > 0)
            ddlGenericGroup.SelectedValue = Product.GenericGroupId.Value.ToString();
        if (Product.ProductGroupId.HasValue && Product.ProductGroupId.Value > 0)
            ddlProTypeNew.SelectedValue = Product.ProductGroupId.Value.ToString();
        if (Product.ProductLineID.HasValue && Product.ProductLineID.Value > 0)
            ddlProLine.SelectedValue = Product.ProductLineID.Value.ToString();

        if (Product.IsActive == true)
        {
            chkIsActive.Checked = true;
        }
        else
        {
            chkIsActive.Checked = false;

        }


        string[] degree = Product.ProductDCID.ToString().Split(',');

        foreach (ListItem item in ddlDistributionCenter.Items)
        {
            for (int i = 0; i < degree.Length; i++)
            {
                if (item.Value == degree[i].ToString())
                {
                    item.Selected = true;

                }
            }
        }



    }

    public void LoadProductCategory()
    {
        aProductBLL.LoadProductCategory(categoryNameDropDownList);
        aProductBLL.LoadManufac(manufacDropDownList);
        aProductBLL.LoadPackSize(packSizeDropDownList);
        aProductBLL.LoadStockUOM(stockUOMDropDownList);
        aProductBLL.LoadType(typeDropDownList);
        aProductBLL.LoadShippingCartonSize(shippingCartonSizeDropDownList);
        aProductBLL.LoadProductSQ(productSQDropDownList);

        aProductBLL.LoadGenericGroup(ddlGenericGroup);
        aProductBLL.LoadTherapeuticGroup(ddlTherapeutic);
        aProductBLL.LoadProductType_new(ddlProTypeNew);


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
            using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
            {
                ddlDistributionCenter.DataSource = dt;
                ddlDistributionCenter.DataValueField = "ComUnitId";
                ddlDistributionCenter.DataTextField = "ComUnitName";
                ddlDistributionCenter.DataBind();
                try
                {
                    ddlDistributionCenter.Items.Insert(-1, "");
                    ddlDistributionCenter.SelectedIndex = 0;
                }
                catch (Exception ex) { }

           

            }
        }

        catch (Exception ex) { }
    

}

    private void Clear()
    {
        productNameTextBox.Text = string.Empty;
        categoryNameDropDownList.SelectedValue = null;
        descriptionTextBox.Text = string.Empty;
        packSizeDropDownList.SelectedIndex = 0;
        manufacDropDownList.SelectedIndex = 0;
        stockUOMDropDownList.SelectedIndex = 0;
        typeDropDownList.SelectedIndex = 0;
        productCodeTextBox.Text = string.Empty;
        productSQDropDownList.SelectedIndex = 0;
        shippingCartonSizeDropDownList.SelectedIndex = 0;

    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {

        if (productCodeTextBox.Text == "")
        {
            showMessageBox("Please Input Product Code!!");
            productCodeTextBox.Focus();

            return false;
        }
        if (productNameTextBox.Text == "")
        {
            showMessageBox("Please Input Product Name!!");
            productNameTextBox.Focus();

            return false;
        }
       
        if (descriptionTextBox.Text == "")
        {
            showMessageBox("Please Input Description!!");
            descriptionTextBox.Focus();

            return false;
        }


        if (ddlGenericGroup.SelectedIndex == 0)
        {
            showMessageBox("Please Input Generic Group!!");
            ddlGenericGroup.Focus();

            return false;
        }


        if (ddlTherapeutic.SelectedIndex == 0)
        {
            showMessageBox("Please Input Therapeutic Group!!");
            ddlTherapeutic.Focus();

            return false;
        }

        if (ddlProTypeNew.SelectedIndex == 0)
        {
            showMessageBox("Please Input Product Group!!");
            ddlProTypeNew.Focus();

            return false;
        }

        if (ddlProLine.SelectedIndex == 0)
        {
            showMessageBox("Please Input Product Line!!");
            ddlProLine.Focus();

            return false;
        }


        if (categoryNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Category!!");
            categoryNameDropDownList.Focus();

            return false;
        }

        if (manufacDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Manufacturer!!");
            manufacDropDownList.Focus();

            return false;
        }

        if (packSizeDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Pack Size!!");
            packSizeDropDownList.Focus();

            return false;
        }
       
        if (stockUOMDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input  UOM!!");
            stockUOMDropDownList.Focus();

            return false;
        }
        if (typeDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Product Type!!");
            typeDropDownList.Focus();
            return false;
        }
        
        if (productSQDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Product Brand!!");
            productSQDropDownList.Focus();

            return false;
        }
        if (shippingCartonSizeDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input Shipping Carton Size!!");
            shippingCartonSizeDropDownList.Focus();
            return false;
        }

        return true;
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
         if (Validation() == true)
        {
            Product aProduct = new Product()
            {
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                Description = string.IsNullOrEmpty(descriptionTextBox.Text) ? null : descriptionTextBox.Text,
                PackSize = packSizeDropDownList.SelectedItem.Text,
                CategoryId = Convert.ToInt32(categoryNameDropDownList.SelectedValue),
                CategoryName = categoryNameDropDownList.SelectedItem.Text,
                ManufacId = Convert.ToInt32(manufacDropDownList.SelectedValue),
                PackSizeId = Convert.ToInt32(packSizeDropDownList.SelectedValue),
                StockUOMId = Convert.ToInt32(stockUOMDropDownList.SelectedValue),
                ProTypeId = Convert.ToInt32(typeDropDownList.SelectedValue),
                ProductBrandId = Convert.ToInt32(productSQDropDownList.SelectedValue),
                CaseId= Convert.ToInt32(shippingCartonSizeDropDownList.SelectedValue),
                TherapueticGroupId= ddlTherapeutic.SelectedIndex > 0 ? int.Parse(ddlTherapeutic.SelectedValue) : (int?)null,
                ProductLineID = ddlProLine.SelectedIndex > 0 ? int.Parse(ddlProLine.SelectedValue) : (int?)null,
                GenericGroupId =   ddlGenericGroup.SelectedIndex > 0 ? int.Parse(ddlGenericGroup.SelectedValue) : (int?)null,
                ProductGroupId =  ddlProTypeNew.SelectedIndex > 0 ? int.Parse(ddlProTypeNew.SelectedValue) : (int?)null,
                ProductImage = 
                string.IsNullOrEmpty(hfDocFile.Value) ? null : hfDocFile.Value,
                IsActive = chkIsActive.Checked



            };

            ProductBLL aProductBLL = new ProductBLL();
            
            if (aProductBLL.SaveProduct(aProduct))
            {
                


            string DisArray = "";

                foreach (ListItem item in ddlDistributionCenter.Items)
                {
                    if (item.Selected)
                    {

                        DisArray = DisArray + item.Value + ",";
                    }
                }

                DisArray = DisArray.TrimEnd(',');

                ResultInfo Res = _DAL.SaveProductDist(aProduct.ProductId, DisArray);



            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProductView.aspx');", true);
                 

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
        //else
        //{
        //    showMessageBox("Please input data in all Textbox");
        //}
    }

    
    protected void productImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("ProductView.aspx");
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProductView.aspx");
    }

    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        
        Response.Redirect("ProductEntry.aspx");

    }

    protected void catLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadProductCategory(categoryNameDropDownList);
    }

    protected void ManufacturerLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadManufac(manufacDropDownList);
    }

    protected void packSizeLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadPackSize(packSizeDropDownList);
    }

    protected void UOMLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadStockUOM(stockUOMDropDownList);
    }

    protected void ProtypeLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadType(typeDropDownList);
    }

    protected void productBrandLoad_Click(object sender, EventArgs e)
    {

        aProductBLL.LoadProductSQ(productSQDropDownList);
    }

    protected void ShippingLoad_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadShippingCartonSize(shippingCartonSizeDropDownList);
    }

    protected void loadTherapeutic_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadTherapeuticGroup(ddlTherapeutic);
    }

    protected void loadGenericGroup_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadGenericGroup(ddlGenericGroup);
    }

    protected void loadp_Group_Click(object sender, EventArgs e)
    {
        aProductBLL.LoadProductType_new(ddlProTypeNew);

    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            int categoryId = 0, manufacId = 0, packSizeId = 0, stockUOMId = 0, typeId = 0, brandId = 0, caseId = 0;
            int.TryParse(categoryNameDropDownList.SelectedValue, out categoryId);
            int.TryParse(manufacDropDownList.SelectedValue, out manufacId);
            int.TryParse(packSizeDropDownList.SelectedValue, out packSizeId);
            int.TryParse(stockUOMDropDownList.SelectedValue, out stockUOMId);
            int.TryParse(typeDropDownList.SelectedValue, out typeId);
            int.TryParse(productSQDropDownList.SelectedValue, out brandId);
            int.TryParse(shippingCartonSizeDropDownList.SelectedValue, out caseId);

            int? tGroup = null, pLine = null, gGroup = null, pGroup = null;
            int temp;
            if (ddlTherapeutic.SelectedIndex > 0 && int.TryParse(ddlTherapeutic.SelectedValue, out temp)) tGroup = temp;
            if (ddlProLine.SelectedIndex > 0 && int.TryParse(ddlProLine.SelectedValue, out temp)) pLine = temp;
            if (ddlGenericGroup.SelectedIndex > 0 && int.TryParse(ddlGenericGroup.SelectedValue, out temp)) gGroup = temp;
            if (ddlProTypeNew.SelectedIndex > 0 && int.TryParse(ddlProTypeNew.SelectedValue, out temp)) pGroup = temp;
            
            int productId = 0;
            int.TryParse(productIdHiddenField.Value, out productId);

            Product aProduct = new Product()
            {
                ProductId = productId,
                ProductCode = productCodeTextBox.Text,
                ProductName = productNameTextBox.Text,
                Description = descriptionTextBox.Text,
                PackSize = packSizeDropDownList.SelectedItem != null ? packSizeDropDownList.SelectedItem.Text : "",
                CategoryId = categoryId,
                CategoryName = categoryNameDropDownList.SelectedItem != null ? categoryNameDropDownList.SelectedItem.Text : "",
                ManufacId = manufacId,
                PackSizeId = packSizeId,
                StockUOMId = stockUOMId,
                ProTypeId = typeId,
                ProductBrandId = brandId,
                CaseId = caseId,
                TherapueticGroupId = tGroup,
                ProductLineID = pLine,
                GenericGroupId = gGroup,
                ProductGroupId = pGroup,
                ProductImage = string.IsNullOrEmpty(hfDocFile.Value) ? null : hfDocFile.Value,
                IsActive = chkIsActive.Checked
            };

            ProductBLL aProductBLL = new ProductBLL();

            if (!aProductBLL.UpdateDataForProduct(aProduct))
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }
            else
            {


                string DisArray = "";

                foreach (ListItem item in ddlDistributionCenter.Items)
                {
                    if (item.Selected)
                    {

                        DisArray = DisArray + item.Value + ",";
                    }
                }

                DisArray = DisArray.TrimEnd(',');

                ResultInfo Res = _DAL.SaveProductDist(Convert.ToInt32(productIdHiddenField.Value), DisArray);



                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ProductView.aspx');", true);
            }
           
        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

    protected void load_ProLine_Click(object sender, EventArgs e)
    {
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
    }

    protected void ddlProTypeNew_SelectedIndexChanged(object sender, EventArgs e)
    {

        if(ddlProTypeNew.SelectedValue== "1") {
        try
        {
            using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    foreach (ListItem item in ddlDistributionCenter.Items)
                    {
                        item.Selected = true;
                    }
                }
            }
        }
        catch (Exception ex) { }
        }
        else
        {
            try
            {
                using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
                {
                    ddlDistributionCenter.DataSource = dt;
                    ddlDistributionCenter.DataValueField = "ComUnitId";
                    ddlDistributionCenter.DataTextField = "ComUnitName";
                    ddlDistributionCenter.DataBind();
                    try
                    {
                        ddlDistributionCenter.Items.Insert(-1, "");
                        ddlDistributionCenter.SelectedIndex = 0;
                    }
                    catch (Exception ex) { }



                }
            }

            catch (Exception ex) { }
        }
    }
}