using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class DoctorModule_UI_PrescriptionType : System.Web.UI.Page
{
    private static SetupDAL _setupDAL = new SetupDAL();


    protected void Page_Load(object sender, EventArgs e)
    {
    }
 
    //[WebMethod(EnableSession = true)]
    //public static ResultInfo Save(int prescriptionTypeId)
    //{
    //    ResultInfo resultInfo = new ResultInfo();
    //    resultInfo.isSuccess = true;
    //    return resultInfo;
    //}
    [WebMethod]

    public static PrescriptionType GetPrescriptionTypeForEdit(int id)
    {
        return (_setupDAL.GetPrescriptionForEdit(id));
    }  
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Save_PrescriptionType(PrescriptionType prescription)
    {
       
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = _setupDAL.SavePrescription(prescription,1.ToString());

        if (resultInfo.isSuccess)
        {
            DoctorModule_UI_PrescriptionType aType = new DoctorModule_UI_PrescriptionType();
            aType.showMessageBox("Data Saved Successfully !!");
        }
        else
        {
            DoctorModule_UI_PrescriptionType aType = new DoctorModule_UI_PrescriptionType();
            aType.showMessageBox("Data not saved successfully !!");
        }

        return resultInfo;
    }
         
}