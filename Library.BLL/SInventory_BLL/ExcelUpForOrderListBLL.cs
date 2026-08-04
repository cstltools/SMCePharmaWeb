using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class ExcelUpForOrderListBLL
    {
        ExcelUpForOrderListDAL aExcelUpForOrderListDal = new ExcelUpForOrderListDAL();
        public void LoadmanufacturerName(DropDownList ddl)
        {
            aExcelUpForOrderListDal.LoadmanufacturerName(ddl);
        }

        public void XLDataGridToDbByRow(String SalesCentre,String SalesCentreName,String MIOName,String TerritoryCode,String FECode,
                                                        String  DZSMCode,String CustomerID,String CustomerName,String ProductCode,String ProductName,decimal OrderQty,decimal GrossValue,String OrderCode,DateTime SubmissionDate,
                                                     String MIOCode, int MasterID)
        {
            aExcelUpForOrderListDal.XLDataGridToDbByRow(SalesCentre, SalesCentreName, MIOName, TerritoryCode, FECode,
                                                          DZSMCode, CustomerID, CustomerName, ProductCode, ProductName, OrderQty, GrossValue, OrderCode, SubmissionDate,
                                                           MIOCode, MasterID);
        }
        public int SaveOrder(OrderListMasterDAO aOrderListMasterDAO)
        {
            try
            {
                //if (!aCustomerMasterDAL.HasCustomerMastername(CustomerMaster))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    //int MigoMasterID = 0;
                    aOrderListMasterDAO.OrderMasterID = aClsPrimaryKeyFind.PrimaryKeyMax("OrderMasterID", "tblOrderListMaster");
                    aExcelUpForOrderListDal.SaveOrderDAL(aOrderListMasterDAO);
                    return aOrderListMasterDAO.OrderMasterID;
                }
                //else
                //{
                //    return "Company Name already exist";
                //}
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public DataTable LoadOrder()
        {
            return aExcelUpForOrderListDal.LoadOrder();
        }
        public DataTable LoadOrder(string id)
        {
            return aExcelUpForOrderListDal.LoadOrder(id);
        }
        public DataTable LoadMigobyID(int id)
        {
            return aExcelUpForOrderListDal.LoadMigobyID(id);
        }
        public bool DeleteData(int id)
        {
            return aExcelUpForOrderListDal.DeleteData(id);
        }
        public bool DeleteDetailData(int id)
        {
            return aExcelUpForOrderListDal.DeleteDetailData(id);
        }

        public DataTable LoadMigoDate(string parameter)
        {
            return aExcelUpForOrderListDal.LoadMigoDate(parameter);
        }
        public int TransfarOrderID_BLL(int id)
        {
            return aExcelUpForOrderListDal.TransfarOrderID_DAL(id);
        }

    }
}
