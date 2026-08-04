using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using Library.DAL.DoctorModule_DAL;
using Library.DAO.DoctorModule_DAO;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_DoctorDegreeEntry : System.Web.UI.Page
{
    public static DoctorDegreeDal setup = new DoctorDegreeDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["id"] != "" && Request.QueryString["id"] != null)
            {
                masterId.Text = Request.QueryString["id"];
            }
            else
            {
                masterId.Text = 0.ToString();
            }

        }
    }

    [WebMethod(EnableSession = true)]
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Save_DoctorDegree(DoctorDegreeDao doctorDegree)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.SaveDoctorDegree(doctorDegree);
        return resultInfo;
    }

    [WebMethod(EnableSession = true)]
    public static DoctorDegreeDao[] GetDoctorDegreeEditData(string id)
    {
        List<DoctorDegreeDao> leftjjjjzxz = new List<DoctorDegreeDao>();

        try
        {
            using (DataTable dt = setup.GetDoctorDegreeEditdata(id))
            {
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow DR in dt.Rows)
                    {
                        DoctorDegreeDao objLeft = new DoctorDegreeDao();
                        objLeft.DegreeId = (int)DR["DegreeId"];
                        objLeft.DoctorTypeId = (int)DR["DoctorTypeId"];
                        objLeft.DegreeName = DR["DegreeName"].ToString();
                        objLeft.IsActive = Convert.ToBoolean(DR["IsActive"].ToString());
                        objLeft.Activedate = Convert.ToDateTime(DR["Activedate"].ToString());
                        leftjjjjzxz.Add(objLeft);
                    }

                    return leftjjjjzxz.ToArray();
                }
            }
        }
        catch (Exception)
        {
           
        }
        
        return leftjjjjzxz.ToArray();

    }
}