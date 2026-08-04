using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_Prescription : System.Web.UI.Page
{
    private static SetupDAL _setupDAL = new SetupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }


    [WebMethod]
    public static PrescriptionMaster GetPrescriptionEditData(int id)
    {
        return (_setupDAL.GetEditData_Prescription(id));
    }

 
   
        [WebMethod]
        public static string GetPrescriptionDetailsListForEdit(int id)
        {
            DataTable dt = _setupDAL.Get_PrescriptionDetailsByPrescriptionId(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }



    [WebMethod]
    public static ResultInfo Save_Prescription(PrescriptionMasterDAO typeMaster)
    {
        var Id = HttpContext.Current.Session["UserId"].ToString();
        
        return (_setupDAL.Save_Prescription(typeMaster, Id));
    }

 


}