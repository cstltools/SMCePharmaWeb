using System.Collections.Generic;
using Library.DAL.DoctorModule_DAL;
using Library.DAO.DoctorModule_DAO;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.Script.Serialization;
public partial class DoctorModule_UI_PrescriptionTypeView : System.Web.UI.Page
{
    public static SetupDAL _setupDAL = new SetupDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]

    public static PrescriptionTypeDao[] GetPrescriptiontTypeList()
    {

        List<PrescriptionTypeDao> leftjjjjzxz = new List<PrescriptionTypeDao>();

        using (DataTable dt = _setupDAL.GetPrescriptionTypeList())
        {
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow DR in dt.Rows)
                {

                    PrescriptionTypeDao objLeft = new PrescriptionTypeDao();

                    objLeft.PrescriptionType = DR["PrescriptionType"].ToString();
                    objLeft.ActivedateString =  (DR["ActivedateString"].ToString());
                    objLeft.IsActive = Convert.ToBoolean(DR["IsActive"].ToString());
                    objLeft.PrescriptionTypeId = Convert.ToInt32(DR["PrescriptionTypeId"].ToString());

                    leftjjjjzxz.Add(objLeft);

                }

                return leftjjjjzxz.ToArray();
            }
        }

        return leftjjjjzxz.ToArray();
     
    }

}