using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class RollBackBLL
    {
        RollBackDAL aRollBackDal=new RollBackDAL();

        public DataTable GetStockInTransfer(string reqId)
        {
            return aRollBackDal.GetStockInTransfer(reqId);
        }
        public bool UpdatePickingInformationOnRequisitionDAL(string id)
        {
            return aRollBackDal.UpdatePickingInformationOnRequisitionDAL(id);
        }
        public bool UpdateIssueInformationOnRequisitionChildDAL(string id)
        {
            return aRollBackDal.UpdateIssueInformationOnRequisitionChildDAL(id);
        }
        public bool UpdateCentralStockStockOut(decimal quantity, string receiveId)
        {
            return aRollBackDal.UpdateCentralStockStockOut(quantity, receiveId);
        }
        public bool DeleteStockInTransfer(string id)
        {
            return aRollBackDal.DeleteStockInTransfer(id);
        }

        public DataTable GetAllStockRcvByDcDAL()
        {
            return aRollBackDal.GetAllStockRcvByDcDAL();
        }
        public void UpdateStockTransfarInfoUpdate(string Reqid)
        {
           // foreach (var stockInTransfar in aStockInTransfarList)
           // {
                //aRequisitionDal.UpdateStockTransfarInfoUpdateDAL(stockInTransfar);
            aRollBackDal.UpdateReqDetailIssueStatusDAL(Reqid);
           // }
           // ReqQtyUpdateInReqDetail(aStockInTransfarList);
           // return "Data Save Successfully!!";
        }
        public bool UpdateIssueInformationOnRequisition(string Reqid)
        {
            return aRollBackDal.UpdateIssueInformationOnRequisitionDAL(Reqid);
        } 
    }
}
