using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.UserRoleDAL;
using Library.DAO.UserRoleDAO;

public partial class UserPermission_ApprovalStepMap : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public static ApprovalMapDAL ApprovalMapDal = new ApprovalMapDAL();


    [WebMethod]
    public static string SaveMenu(ApprovalMapMaster approvalMapMaster)
    {

        int mainid=ApprovalMapDal.SaveApprovalMapMaster(approvalMapMaster);

        int id = 0;
        foreach (var approval in approvalMapMaster.ApprovalMapDetails)
        {
            approval.ApprovalMapMasterId = mainid;
            id = (ApprovalMapDal.SaveApprovalMapDetail(approval));
        }

        return "True";
    }



    [WebMethod]
    public static dynamic GetUserRole()
    {
        var list = ApprovalMapDal.GetRoleTypeDropDown();
        return list;
    }
    [WebMethod]
    public static dynamic GetMenu()
    {
        var list = ApprovalMapDal.GetMainMenuDropDown();
        return list;
    }

    [WebMethod]
    public static dynamic LoadApprovalMap(string roleId, string typeId)
    {
        var list = ApprovalMapDal.LoadApprovalMap(roleId, typeId);
        return list;
    }


}