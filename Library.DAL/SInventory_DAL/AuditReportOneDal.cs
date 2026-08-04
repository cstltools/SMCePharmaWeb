using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class AuditReportOneDal
    {
        ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

        public void GetSalesCenter(DropDownList ddl)
        {
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitCode", queryStr);
        }

        public void GetCustomer(DropDownList ddl)
        {
            string queryStr = "SELECT CustomerMasterId ,CustomerCode FROM dbo.tblCustMaster";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CustomerCode", "CustomerMasterId", queryStr); ;
        }

        public DataTable GetDeleteOrderReport(string parameter)
        {
            string queryStr = @"SELECT  ODDtls.ProductCode, ODDtls.ProductName, ODDtls.Quantity, ODDtls.TradePrice, ODDtls.TotalTradePrice, OD.OrderCode, OD.ComUnitCode AS SalesCenterCode, OD.ComUnitName AS SalesCenterName,MIO.EmpMasterCode  MIOCode, MIO.EmpName MIOName, tr.TerritoryName AS TeritoryName,
tr.TerritoryCode AS TeritoryCode ,DZSM.EmpMasterCode AS FECode, DZSM.EmpName AS FEName,  DZSM.EmpName AS DZSMCode, rg.RegionName AS DZSMName,OD.CustomerCode,
 OD.CustomerName,OD.GrossValue, OD.SubmissionDate, us.LoginName DeleteBy, OD.DelDate FROM tblOrderDel AS OD WITH(NOLOCK)
 INNER JOIN  dbo.tblCustMaster AS VC ON VC.CustomerMasterId = OD.CustomerMasterId 
 left JOIN  dbo.tblUser AS us ON us.UserId = OD.DelBy 
 LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON OD.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON OD.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON OD.MIOId=MIO.EmpInfoId
 
		left join tblmarket mr   with (nolock) on mr.MarketId=OD.MarketId
		left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=OD.SubTerritoryId
		left join tblTerritory tr  with (nolock) on OD.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=OD.AreaId
		left join tblRegion rg  with (nolock) on OD.RegionId=rg.RegionId
		left join dbo.tbl_Group gr  with (nolock) on OD.GroupId=gr.GroupId
  INNER JOIN  dbo.tblOrderDetailDel  AS ODDtls ON ODDtls.OrderId = OD.OrderId   " + parameter;
            return aInternalDal.DataContainerDataTable(queryStr);
        }

        public DataTable GetDeleteOrderNationalReport(string parameter)
        {
            string queryStr = @"SELECT  ODDtls.ProductCode, ODDtls.ProductName, ODDtls.Quantity, ODDtls.TradePrice, ODDtls.TotalTradePrice, OD.OrderCode, OD.ComUnitCode AS SalesCenterCode, OD.ComUnitName AS SalesCenterName,MIO.EmpMasterCode  MIOCode, MIO.EmpName MIOName, tr.TerritoryName AS TeritoryName,
tr.TerritoryCode AS TeritoryCode ,DZSM.EmpMasterCode AS FECode, DZSM.EmpName AS FEName,  DZSM.EmpName AS DZSMCode, rg.RegionName AS DZSMName,OD.CustomerCode,
 OD.CustomerName,OD.GrossValue, OD.SubmissionDate, us.LoginName DeleteBy, OD.DelDate FROM tblOrderDel AS OD WITH(NOLOCK)
 INNER JOIN  dbo.tblCustMaster AS VC ON VC.CustomerMasterId = OD.CustomerMasterId 
 left JOIN  dbo.tblUser AS us ON us.UserId = OD.DelBy 
 LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON OD.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON OD.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON OD.MIOId=MIO.EmpInfoId
 
		left join tblmarket mr   with (nolock) on mr.MarketId=OD.MarketId
		left join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=OD.SubTerritoryId
		left join tblTerritory tr  with (nolock) on OD.TerritoryId=tr.TerritoryId
		left join tblArea ar   with (nolock)  on ar.AreaId=OD.AreaId
		left join tblRegion rg  with (nolock) on OD.RegionId=rg.RegionId
		left join dbo.tbl_Group gr  with (nolock) on OD.GroupId=gr.GroupId
  INNER JOIN  dbo.tblOrderDetailDel  AS ODDtls ON ODDtls.OrderId = OD.OrderId  " + parameter;
            return aInternalDal.DataContainerDataTable(queryStr);
        }
    }
}
