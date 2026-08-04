using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LeaveProcess_UI_LeaveApplicationCode : System.Web.UI.Page
{

    private static LeaveApplicationDal _leaveDal = new LeaveApplicationDal(); 

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo SaveLeaveApplication(LeaveApplication leaveApplication)
    {
        return  (_leaveDal.SaveLeaveApplication(leaveApplication));
    }
    [WebMethod]
    public static ResultInfo  UpdateLeaveApplication(LeaveApplication leaveApplication)
    {
        return  (_leaveDal.SaveLeaveApplication(leaveApplication));
    }

    [WebMethod]
    public static ResultInfo LeaveApplicationApprove(int leaveApplicationId, string ApprovalStatus)
    {
        return  (_leaveDal.ApproveLeaveApplication(leaveApplicationId, ApprovalStatus));
    }

    [WebMethod]
    public static string GetEmployeeLeaveBalance(string employeeCode)
    {
        DataTable dt = _leaveDal.GetEmployeeLeaveBalanceByCode(employeeCode);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }


    [WebMethod]
    public static String GetApplicationInfoById(int leaveApplicationId)
    {
        DataTable dt = _leaveDal.GetApplicationInfoById(leaveApplicationId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }

    
    //[WebMethod]
    //public static string GetLeaveApplications()
    //{
    //    DataTable dt = _leaveDal.GetAllLeaveRecords();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return (JSONresult);
    //}

}