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
    public class OrderListBLL
    {
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        OrderListDAL aOrderListDal=new OrderListDAL();
        public bool SaveOrderMaster(OrderInfoMaster aListMasterDao,out int maxorderId)
        {
            maxorderId = OrderId();
            aListMasterDao.OrderId = maxorderId;
            aListMasterDao.OrderCode = OrdNo();
            return aOrderListDal.SaveOrderMaster(aListMasterDao);
        }
        private int OrderId()
        {
            int ReqId = 0;
            ReqId = aClsPrimaryKeyFind.PrimaryKeyMax("OrderId", "tblOrder", "SSIDB");
            return ReqId;
        }
        public string OrdNo()
        {
            string ordNo = string.Empty;

            ordNo = OrdnNoGenerator(aOrderListDal.OrderManualId());

            return ordNo;
        }
        private string OrdnNoGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "0" + Id;
            }
            code = "ORD-" + Id;
            return code;
        }
        public DataTable CustomerInfo(string custCode)
        {
            return aOrderListDal.CustomerInfo(custCode);
        }
        public string SaveOrderDetail(List<OrderInfoDetail> aOrderListDetailDaoList)
        {
            foreach (var aOrderListDetailDao in aOrderListDetailDaoList)
            {
                aOrderListDal.SaveOrderDetail(aOrderListDetailDao);
            }
            return "Data Saved Successfully";
        }
        public void LoadmanufacturerName(DropDownList ddl)
        {
            aOrderListDal.LoadmanufacturerName(ddl);
        }

        public void DCLoad(DropDownList aDownList)
        {
            aOrderListDal.DCLoad(aDownList);

        }
        public bool UpdateDataForCompanyInfo(OrderInfoMaster aOrderInfoMaster)
        {
            return aOrderListDal.UpdateCompanyInfo(aOrderInfoMaster);
        }

    }
}
