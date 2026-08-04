using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using Library.BLL.MasterSetup_BLL;
using Library.DAO.MasterSetup_DAO;

public partial class MasterSetup_UI_CustomerInvoiceLimit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Initialization if needed
        }
    }

    [WebMethod]
    public static string Save(CustomerInvoiceLimitModel model)
    {
        try
        {
            // For a real app, you would retrieve the logged-in user from Session
            // model.CreatedBy = HttpContext.Current.Session["UserId"].ToString();
            model.CreatedBy = "Admin"; 

            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.Save(model);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static string Update(CustomerInvoiceLimitModel model)
    {
        try
        {
            // model.UpdatedBy = HttpContext.Current.Session["UserId"].ToString();
            model.UpdatedBy = "Admin"; 

            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.Update(model);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static string Delete(int id)
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.Delete(id);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static CustomerInvoiceLimitViewModel GetById(int id)
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetById(id);
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }

    [WebMethod]
    public static List<CustomerInvoiceLimitViewModel> GetList()
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetList();
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }

    [WebMethod]
    public static List<CustomerAutoCompleteViewModel> GetCustomerAutoComplete(string keyword)
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetCustomerAutoComplete(keyword);
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }

    [WebMethod]
    public static List<CustomerTypeViewModel> GetCustomerTypeListActive()
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetCustomerTypeListActive();
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }

    [WebMethod]
    public static string SaveInvoiceNotBinding(InvoiceNotBindingModel model)
    {
        try
        {
            model.CreatedBy = "Admin";
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.SaveInvoiceNotBinding(model);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static string UpdateInvoiceNotBinding(InvoiceNotBindingModel model)
    {
        try
        {
            model.UpdatedBy = "Admin";
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.UpdateInvoiceNotBinding(model);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static string DeleteInvoiceNotBinding(int id)
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.DeleteInvoiceNotBinding(id);
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public static InvoiceNotBindingViewModel GetInvoiceNotBindingById(int id)
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetInvoiceNotBindingById(id);
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }

    [WebMethod]
    public static List<InvoiceNotBindingViewModel> GetInvoiceNotBindingList()
    {
        try
        {
            CustomerInvoiceLimitService service = new CustomerInvoiceLimitService();
            return service.GetInvoiceNotBindingList();
        }
        catch (Exception ex)
        {
            throw new Exception("Error: " + ex.Message);
        }
    }
}
