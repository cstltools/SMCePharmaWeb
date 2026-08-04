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
  public class ChallanReportViewBLL
    {
      ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
      ChallanReportViewDAL aRequisitionDal = new ChallanReportViewDAL();
      ProductBLL aProductBll = new ProductBLL();


      public Requesition SalesCenterEditLoad(string ComUnitId)
      {
          return aRequisitionDal.SalesCenterEditLoad(ComUnitId);
      }


      public Requesition CheckAlreadyDone(string ComUnitId)
      {
          return aRequisitionDal.CheckAlreadyDone(ComUnitId);
      }


      public bool UpdateDataForSalesCenter(Requesition aCompanyUnit)
      {
          return aRequisitionDal.UpdateSalesCenter(aCompanyUnit);
      }


      public bool SaveRequsition(Requesition aRequesition, out int maxReqId)
      {
          maxReqId = ReqId();
          aRequesition.ReqId = maxReqId;
          aRequesition.ReqNo = ReqNo();

          return aRequisitionDal.SaveReuqisitionDAL(aRequesition);
      }
      public bool UpdateManufacturerInfo(Requesition aManufacturer)
      {
          return aRequisitionDal.UpdateManufacturerInfo(aManufacturer);

      }
      public string SaveRequsitionChild(List<RequsitionChild> aRequsitionChildrenList)
      {
         
          string msg = "Save Data Successfully!!";
          foreach (RequsitionChild aChild in aRequsitionChildrenList)
          {
              aChild.ReqChildId = ReqChildId();
              aRequisitionDal.SaveReuqisitionChildDAL(aChild);
          }
          return msg;
      }
      public DataTable GetRequisitionView()
      {
          return aRequisitionDal.GetRequisitionView();
      }

      public DataTable GetDataInfoByIdBll(Int32 id)
      {
          return aRequisitionDal.GetDataInfoByIdDAL(id);
      }

      public DataTable GetDataInfoByIdBllDtls(Int32 id)
      {
          return aRequisitionDal.GetDataInfoByIdBllDtls(id);
      }

      private int ReqChildId()
      {
          int reqChildId = 0;

          reqChildId = aClsPrimaryKeyFind.PrimaryKeyMax("ReqChildId", "tblRequsitionChild", "SSIDB");
          return reqChildId;
      }

      private int ReqId()
      {
          int ReqId = 0;
          ReqId = aClsPrimaryKeyFind.PrimaryKeyMax("ReqId", "tblRequisition", "SSIDB");
          return ReqId;
      }
      public string ReqNo()
      {
          string reqNo = string.Empty;

          reqNo = ReqnNoGenerator(aClsPrimaryKeyFind.PrimaryKeyMax("ReqId", "tblRequisition", "SSIDB"));

          return reqNo;
      }
      private string ReqnNoGenerator(int id)
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
          code = "REQ-" + Id;
          return code;
      }

      public string ChalanNo(string reqNo)
      {
          string chalanNo = "";
          string clnPart = reqNo.Trim().Substring(4);
         chalanNo= "CLN-" + clnPart;
          return chalanNo;
      }
      public string PickingNo(string reqNo)
      {
          string picNo = "";
          string picPart = reqNo.Trim().Substring(4);
          picNo = "PIK-" + picPart;
          return picNo;
      }
      public string Chalan(string reqNo)
      {
          string picNo = "";
          string picPart = reqNo.Trim().Substring(4);
          picNo = "CLN-" + picPart;
          return picNo;
      }
      public void WareHouseLoad(DropDownList aDownList)
      {
          aRequisitionDal.WareHouseLoad(aDownList);
      }
      public void LoadmanufacturerName(DropDownList ddl)
      {
          aRequisitionDal.LoadmanufacturerName(ddl);
      }

      public void ProductLoad(DropDownList aDownList)
      {
          aRequisitionDal.ProductLoad(aDownList);
      }

      public void DCLoad(DropDownList aDownList)
      {
          aRequisitionDal.DCLoad(aDownList);

      }
      public void SubdeportLoad(DropDownList aDownList, string ComUnitId)
      {
          aRequisitionDal.SubdeportLoad(aDownList, ComUnitId);

      }
      public void DCLoad(DropDownList aDownList,string ComUnitId)
      {
          aRequisitionDal.DCLoad(aDownList, ComUnitId);

      }
      public DataTable GetAllNonSubmitReq()
      {

          return aRequisitionDal.GetAllNonSubmitReqDAL();
      }

      public DataTable GetAllNonPickReq()
      {

          return aRequisitionDal.GetAllNonPickReqDAL();
      }
      public bool DeleteRequisition(string reqId)
      {
          return aRequisitionDal.DeleteRequisition(reqId);
      }
      public bool DeleteRequisitionDtls(string reqId)
      {
          return aRequisitionDal.DeleteRequisitionDtls(reqId);
      }
      public DataTable GetRequisitionDetailByReqId(string reqId)
      {
          return aRequisitionDal.GetRequisitionDetailByReqIdDAL(reqId);
      }

       public DataTable GetPickingDataForIssue(string reqId)
       {
           return aRequisitionDal.GetPickingDataForIssueDAL(reqId);
       }

      public DataTable GetRequisitionInfoByReqId(string reqId)
      {

          return aRequisitionDal.GetRequisitionInfoByReqIdDAL(reqId);
      }
      public DataTable GetRequisitionInfoTransferReqId(string reqId)
      {

          return aRequisitionDal.GetRequisitionInfofromTransferDAL(reqId);
      }
      public DataTable ChallanExistsBll(string reqId)
      {

          return aRequisitionDal.ChallanExistsDAL(reqId);
      }
      public bool UpdateIssueInformationOnRequisition(Requesition aRequesition)
      {
          return aRequisitionDal.UpdateIssueInformationOnRequisitionDAL(aRequesition);
      }
      public bool UpdatePickingInformationOnRequisition(Requesition aRequesition)
      {

          return aRequisitionDal.UpdatePickingInformationOnRequisitionDAL(aRequesition);
      }

      public string UpdateStockTransfarInfoUpdate(List<StockInTransfar> aStockInTransfarList)
      {
          foreach (var stockInTransfar in aStockInTransfarList)
          {
              aRequisitionDal.UpdateStockTransfarInfoUpdateDAL(stockInTransfar);
              aRequisitionDal.UpdateReqDetailIssueStatusDAL(stockInTransfar);
          }
          ReqQtyUpdateInReqDetail(aStockInTransfarList);
          return "Data Save Successfully!!";
      }


      public void ReqQtyUpdateInReqDetail(List<StockInTransfar> aStockInTransfarList)
      {
         

          var reqChildIdAndUnitPriceCollection = from p in aStockInTransfarList
                                                 group p by p.ReqChildId into g
                                                 select new { ReqChildId = g.Key, Quantity = g.Sum(a => a.Quantity), 
                                                     PriceAmount = g.Sum(a => a.PriceAmount), 
                                                     VATAmount = g.Sum(a => a.VATAmount), 
                                                     TotalPriceAmount=g.Sum(a=>a.TotalPriceAmount) };
          int rcID = 0;
          decimal totalQuantity = 0;
          decimal totalPriceAmount = 0;
          decimal totalVATAmount = 0;
          decimal totalPriceAmountSum = 0;
          foreach (var items in reqChildIdAndUnitPriceCollection)
          {
              rcID = items.ReqChildId;
              totalQuantity = items.Quantity;
              totalPriceAmount = items.PriceAmount;
              totalVATAmount = items.VATAmount;
              totalPriceAmountSum = items.TotalPriceAmount;
              aRequisitionDal.ReqDetailUpdateAfterIssue(rcID, totalQuantity, totalPriceAmount, totalVATAmount, totalPriceAmountSum);
          }

      }
      public string UpdateIssueInformationOnRequisitionChild(List<RequsitionChild> aRequsitionChildrenList)
      {
          string msg = "Data Save Successfully!!";
          
          DataTable aTable;
          foreach (RequsitionChild aRequsitionChild in aRequsitionChildrenList)
          {
              UpdateCentralStockAndStockInTransfar(aRequsitionChild);

              ////////////////////////////////////////ForMusak///////////////////////////////////
              aTable = new DataTable();
              aTable = aProductBll.ProductPriceDetailWithCaseBLL(aRequsitionChild.ProductCode);
              decimal musakRatePerUnit = 0;
              aRequsitionChild.MusakVATAmount =0;
              aRequsitionChild.MusakTotalPrice =0;
              ///////////////////////////////////////////////////////////////////////////
              aRequisitionDal.UpdateIssueInformationOnRequisitionChildDAL(aRequsitionChild);
          }


          return msg;
      }

      public bool UpdateCentralStockAndStockInTransfar(RequsitionChild aRequsitionChild)
      {
          StockInTransfar aStockInTransfar = new StockInTransfar();
          DataTable aDataTableCurrentStockofCentralStock = new DataTable();
          DataTable aTablePriceCase = new DataTable();
          aDataTableCurrentStockofCentralStock = aRequisitionDal.GetCurrentStockofCentralStock(aRequsitionChild.ProductCode);
          aTablePriceCase = aProductBll.ProductPriceDetailWithCaseBLL(aRequsitionChild.ProductCode);
          decimal restQty1 = 0;
          
          if (aDataTableCurrentStockofCentralStock.Rows.Count>0)

          {

              for(int i=0;aDataTableCurrentStockofCentralStock.Rows.Count>i;i++)
              {
                  RequsitionChildToStockInTransfar(out aStockInTransfar, aRequsitionChild);
                  decimal restQty = 0;
                  if (restQty1 != 0)
                  {
                      restQty =
                          Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim()) +
                          restQty1;
                  }
                  else
                  {
                      restQty = Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim()) -
                              aRequsitionChild.IssueQty;
                  }
                  
                  string receiveId = aDataTableCurrentStockofCentralStock.Rows[i]["ReceiveId"].ToString().Trim();
                  if(restQty<0)
                  {
                      //////////////////////////////////for Stock In Transfar////////////////
                      aStockInTransfar.BatchNo = aDataTableCurrentStockofCentralStock.Rows[i]["BatchNo"].ToString().Trim();
                      aStockInTransfar.Quantity =
                          Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim());
                      aStockInTransfar.PickingQty = Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim());
                      aStockInTransfar.ReceiveId = Convert.ToInt32(aDataTableCurrentStockofCentralStock.Rows[i]["ReceiveId"].ToString().Trim());
                      aStockInTransfar.PriceAmount =
                          Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim())*
                          aStockInTransfar.UnitPrice;
                      aStockInTransfar.VATAmount = Convert.ToDecimal(aTablePriceCase.Rows[0]["VATAmountPerUnit"].ToString())*Convert.ToDecimal(aDataTableCurrentStockofCentralStock.Rows[i]["Quantity"].ToString().Trim());
                      aStockInTransfar.TotalPriceAmount = aStockInTransfar.PriceAmount + aStockInTransfar.VATAmount;
                      aStockInTransfar.ExpDate =
                          Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["ExpDate"].ToString().Trim());
                      aStockInTransfar.MfgDate =
                        Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["mfgDate"].ToString().Trim());
                      aStockInTransfar.ReceiveDate = Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["ReceiveDate"].ToString().Trim());
                      //////////////////////////////////end////////////////////
                      restQty1 = restQty;
                      aStockInTransfar.StockInTransfarId = aClsPrimaryKeyFind.PrimaryKeyMax("StockInTransfarId", "tblStockInTransfar", "SSIDB");
                      aRequisitionDal.StockInTransfarInsertDAL(aStockInTransfar);
                      aRequisitionDal.UpdateCentralStockStockOut(0, receiveId);
                  }
                  else
                  {
                      decimal qty = 0;
                      if (restQty1 != 0)
                      {
                          qty = Convert.ToDecimal(Convert.ToString(restQty1).Substring(1));
                      }
                      else
                      {
                          qty = aRequsitionChild.IssueQty;
                      }
                      //////////////////////////////////for Stock In Transfar////////////////
                      aStockInTransfar.BatchNo = aDataTableCurrentStockofCentralStock.Rows[i]["BatchNo"].ToString().Trim();
                      aStockInTransfar.Quantity =
                          qty;
                      aStockInTransfar.PickingQty =
                          qty;
                      aStockInTransfar.PriceAmount =
                          qty *
                          aStockInTransfar.UnitPrice;
                      aStockInTransfar.VATAmount = qty*Convert.ToDecimal(aTablePriceCase.Rows[0]["VATAmountPerUnit"].ToString());
                      aStockInTransfar.ReceiveId = Convert.ToInt32(aDataTableCurrentStockofCentralStock.Rows[i]["ReceiveId"].ToString().Trim());
                      aStockInTransfar.TotalPriceAmount = aStockInTransfar.PriceAmount + aStockInTransfar.VATAmount;
                      aStockInTransfar.ExpDate =
                          Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["ExpDate"].ToString().Trim());
                      aStockInTransfar.MfgDate =
                       Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["mfgDate"].ToString().Trim());
                      aStockInTransfar.ReceiveDate = Convert.ToDateTime(aDataTableCurrentStockofCentralStock.Rows[i]["ReceiveDate"].ToString().Trim());
                      //////////////////////////////////end////////////////////
                      aStockInTransfar.StockInTransfarId= aClsPrimaryKeyFind.PrimaryKeyMax("StockInTransfarId", "tblStockInTransfar", "SSIDB");
                      aRequisitionDal.StockInTransfarInsertDAL(aStockInTransfar);
                      aRequisitionDal.UpdateCentralStockStockOut(restQty, receiveId);
                      break;
                  }
                 
              }
          }
          return true;
      }
      private void RequsitionChildToStockInTransfar(out StockInTransfar aStockInTransfar, RequsitionChild aRequsitionChild)
      {
          aStockInTransfar = new StockInTransfar();
          aStockInTransfar.ReqId = aRequsitionChild.ReqId;
          aStockInTransfar.ReqChildId = aRequsitionChild.ReqChildId;
          aStockInTransfar.ProductCode = aRequsitionChild.ProductCode;
          aStockInTransfar.ProductName = aRequsitionChild.ProductName;
          aStockInTransfar.PackSize = aRequsitionChild.PackSize;
          aStockInTransfar.UnitPrice = aRequsitionChild.UnitPrice;
      }
      
      public DataTable GetAllStockRcvByDc(string comUnitId)
      {
          return aRequisitionDal.GetAllStockRcvByDcDAL(comUnitId);
      }
      public DataTable GetStockInTransfarByReqId(string reqId)
      {
          return aRequisitionDal.GetStockInTransfarByReqIdDAL(reqId);
      }

      public string DCStockIn(List<DCStockNew> aDcStockNewsList)
      {
          string msg = "Data Save Successfully!!";

          foreach (DCStockNew aDcStockNew in aDcStockNewsList)
          {
              aDcStockNew.DCStoreId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreId", "tblDCStore", "SSIDB");
              aRequisitionDal.DCStockInDAL(aDcStockNew);
              aRequisitionDal.StockInTransfarStatusUpdate(aDcStockNew.StockInTransfarId.ToString());
              aRequisitionDal.UpdateReceiveIssueStatus(aDcStockNew.ReqId.ToString(), aDcStockNew.StockRcvDate);
          }
          
          return msg;
      }
      
      ///////////////////////////////////////////////////////////////////////////////
      
      public DataTable DCStoreReport(string reqId)
      {
          return aRequisitionDal.DCStoreReport(reqId);
      }
      
      /// /////////////////////////////////////////////////////////

      public int DCStockIn2(DCStockNew aDcStockNew)
      {
          string msg = "Data Save Successfully!!";
          int DCStoreId = 0;

          
              DCStoreId=aDcStockNew.DCStoreId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreId", "tblDCStore", "SSIDB");
              aRequisitionDal.DCStockInDAL(aDcStockNew);
              aRequisitionDal.StockInTransfarStatusUpdate(aDcStockNew.StockInTransfarId.ToString());
              aRequisitionDal.UpdateReceiveIssueStatus(aDcStockNew.ReqId.ToString(), aDcStockNew.StockRcvDate);
          

          return DCStoreId;
      }
       public DataTable StockTransportOrderGridDataBLL(DateTime date)
       {
           return aRequisitionDal.StockTransportOrderGridDataDAL(date);
       }
       public DataTable ChallanReportDAL(DateTime date)
       {
           return aRequisitionDal.ChallanReportDAL(date);
       }
       public DataTable ChallanReportDAL2(DateTime date, DateTime date2, string unit)
       {
           return aRequisitionDal.ChallanReportDAL2(date,date2,unit);
       }
       public DataTable ChallanReportDAL2(DateTime date, DateTime date2)
       {
           return aRequisitionDal.ChallanReportDAL2(date, date2);
       }
       public string SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStockNew)
       {
           string msg = "Data Save Successfully!!";
           
               ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
               aDcStockNew.DCStoreFreezeId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreFreezeId",
                   "tblDCStoreFreeze");
               aRequisitionDal.SaveDCStoreFreeze2(aDcStockNew);
           
           return msg;
       }



       public void DCCodeLoad(DropDownList aDownList)
       {
           aRequisitionDal.DCLoad(aDownList);

       }
       public void SubdeportCodeLoad(DropDownList aDownList, string ComUnitId)
       {
           aRequisitionDal.SubdeportLoad(aDownList, ComUnitId);

       }
       public DataTable ChallanDetailReportDAL2(DateTime date, DateTime date2, string unit)
       {
           return aRequisitionDal.ChallanDetailReportDAL2(date, date2, unit);
       }
       public DataTable ChallanDetailReportDAL2(DateTime date, DateTime date2)
       {
           return aRequisitionDal.ChallanDetailReportDAL2(date, date2);
       }


       public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime date2, string unit)
       {
           return aRequisitionDal.ChallanSummaryReportDAL2(date, date2, unit);
       }
       public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime date2)
       {
           return aRequisitionDal.ChallanSummaryReportDAL2(date, date2);
       }
    }
}
