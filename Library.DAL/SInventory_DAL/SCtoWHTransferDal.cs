using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class SCtoWHTransferDal
    {

        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void WareHouseLoad(DropDownList aDownList)
        {
            string wareHouse = "select WearhouseId, (WearhouseCode +':'+ WearhouseName) AS WearhouseName from tblWearhouse";
            aCommonInternalDal.LoadDropDownValue(aDownList, "WearhouseName", "WearhouseId", wareHouse, "SSIDB");
        }
        public void LoadmanufacturerName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public void DCLoad(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitId", dc, "SSIDB");
        }
        public void ProductLoad(DropDownList aDownList)
        {
            string dc = "SELECT (ProductCode+':'+ProductName)Pro,* FROM dbo.tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Pro", "ProductId", dc, "SSIDB");
        }
        public void SubdeportLoad(DropDownList aDownList, string ComUnitId)
        {
            string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId='" + ComUnitId + "'";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "SubDepotId", dc, "SSIDB");
        }
        public void DCLoad(DropDownList aDownList, string comUnitId)
        {

            string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                                       " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId='" + comUnitId.Trim() + "')";

            aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "ComUnitName", "ComUnitId", queryStr);
        }

        public DataTable LoadComUnit(string ComUnitId)
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT * FROM tblCompanyUnit where ComUnitCode='" + ComUnitId.Trim() + "' ";
            aDataTable = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTable;
        }


        public DataTable WareHouseInfoLoad(string whId)
        {
            DataTable aDataTable = new DataTable();
            string query = @"select * from tblWearhouse WHERE WearhouseId ='" + whId + "' ";
            aDataTable = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTable; 
        }

        public DataTable GetProductDcStoreSubdeport(string productCode, string comunitId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT 0 AS DCStoreFreezeId, ISNULL(VATAmountPerUnit,0)VATAmountPerUnit,ISNULL(VATPercentage,0)VATPercentage,UnitPrice,*,
            tblProduct.ProductCode AS PCode , tblProduct.ProductName AS PName 
            FROM dbo.tblDCStore
            LEFT JOIN dbo.tblProduct ON dbo.tblDCStore.ProductCode = dbo.tblProduct.ProductCode 
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDCStore.ComUnitId = dbo.tblCompanyUnit.ComUnitId 
            LEFT JOIN dbo.tblUnitPrice ON dbo.tblDCStore.ProductCode=dbo.tblUnitPrice.ProductCode
            WHERE  ComUnitCode='" + comunitId + "' AND tblProduct.ProductId='" + productCode + "'  AND tblUnitPrice.IsActive='True' AND StockQty>0 order by tblProduct.ProductCode";
            //tblDCStore.StockInTransfarId is not null AND
            aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }

        public DataTable GetProductDcFreezeStore(string productCode, string comunitId)
        {
            DataTable aDataTableEmpInfo = new DataTable();

            string query = @"SELECT ComUnitCode,PD.ProductId,ISNULL(VATAmountPerUnit,0)VATAmountPerUnit,ISNULL(VATPercentage,0)VATPercentage,UnitPrice,*,
            PD.ProductCode AS PCode , PD.ProductName AS PName FROM dbo.tblDCStoreFreeze AS DCF
            LEFT JOIN dbo.tblProduct AS PD ON DCF.ProductCode = PD.ProductCode 
            LEFT JOIN dbo.tblCompanyUnit UNT ON DCF.ComUnitId = UNT.ComUnitId 
            LEFT JOIN dbo.tblUnitPrice UP ON DCF.ProductCode = UP.ProductCode
            WHERE  ComUnitCode='" + comunitId + "' AND PD.ProductId='" + productCode + "'  AND UP.IsActive='True' AND StockQty>0 order by PD.ProductCode";

            aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }

        public bool SaveDataForChalanInfo(DepoToWHTransferDao aChalanInfo)
        {
            string insertQuery = @"insert into tblDepotToWHChalanInfo (SChalanId,ChalanDate,ChalanNo,TrackNo,DriverName,FromComUnitCode,FromComUnitName,FromComUnitAddress,WHCode,WHName,WHAddress,TotalValue,TotalVat,GrandTotal,ManufacId,IsDeliver) 
            values (" + aChalanInfo.ChalanId + ",'" + aChalanInfo.ChalanDate + "','" + aChalanInfo.ChalanNo + "','" + aChalanInfo.TrackNo + "','" + aChalanInfo.DriverName + "','" + aChalanInfo.FromComUnitCode + "','" + aChalanInfo.FromComUnitName + "','" + aChalanInfo.FromComUnitAddress + "','" + aChalanInfo.WHCode + "','" + aChalanInfo.WHName + "','" + aChalanInfo.WHAddress + "','" + aChalanInfo.TotalValue + "','" + aChalanInfo.TotalVat + "','" + aChalanInfo.GrandTotal + "','" + aChalanInfo.ManufacId + "','" + false + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveDataForChalanDetail(DepoToWHTransferDetailDao aChalanDetail)
        {
            string insertQuery = @"insert into tblDepotToWHChalanDetail (SChalanDetailsId,ProductCode,ProductName,Quantity,BatchNo,UnitPrice,Value,Vat,ValueWVat,SChalanId,DCStoreId,DCStoreFreezeId,PurposeId) 
            values (" + aChalanDetail.ChalanDetailId + ",'" + aChalanDetail.ProductCode + "','" + aChalanDetail.ProductName + "','" + aChalanDetail.Quantity + "','" + aChalanDetail.BatchNo + "','" + aChalanDetail.UnitPrice + "','" + aChalanDetail.Value + "','" + aChalanDetail.Vat + "','" + aChalanDetail.ValueWVat + "'," + aChalanDetail.ChalanId + ",'" + aChalanDetail.DCStoreId + "','" + aChalanDetail.DCStoreFreezeId + "','" + aChalanDetail.PurposeId + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            string query = "SELECT * FROM dbo.tblDCStore WHERE DCStoreId='" + dcstoreId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadChalanById(string id)
        {
            string query = @"SELECT * FROM dbo.tblSubDepotChalanInfo WHERE SChalanId='" + id + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool  UpdateDCStockQuantity(string stockId, string Quantity)
        {
            string updateQuery = @"UPDATE tblDCStore SET StockQty='" + Quantity + "' WHERE DCStoreId='" + stockId.Trim() + "'   ";
            return aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }

        public DataTable GetWarehouseRcvStock(string whId)
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT DPC.SChalanId AS ReqId,ChalanNo AS IssueChalanNo ,ChalanDate AS IssuChalanDate,TrackNo AS TruckNo,DriverName FROM tblDepotToWHChalanInfo AS DPC
                             WHERE  IsDeliver !='OK'";
            aDataTable = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTable; 
        }

        public DataTable DcFreezeInfoId(string dcFreezeId)
        {
            string query = @"SELECT * FROM dbo.tblDCStoreFreeze WHERE DCStoreFreezeId = '" + dcFreezeId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool UpdateFreezeQuantity(string dcFreezeId, string quantity)
        {
            string updateQuery = @"UPDATE tblDCStoreFreeze SET StockQty='" + quantity + "' WHERE DCStoreFreezeId='" + dcFreezeId.Trim() + "'   ";
            return aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }

        public DataTable LoadDepoToWHTransferInfo()
        {
            string query = @"SELECT SChalanId,ChalanDate,ChalanNo,TrackNo,DriverName,FromComUnitCode,FromComUnitName FROM tblDepotToWHChalanInfo WHERE IsTransfer IS NULL";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool DeleteDepoToWHTransfer(string masterId)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@masterId", masterId));

            return aCommonInternalDal.DeleteAction("sp_DeleteDwpotToWhChalan", aSqlParameterlist);
        }

        public DataTable LoadChallanDetailById(string areaId)
        {
            string query = @"SELECT *,CASE
                            WHEN (DPT.DCStoreId IS NOT NULL AND DPT.DCStoreFreezeId = 0) AND DPT.Quantity <= DCS.StockQty THEN 'True'
                            WHEN (DPT.DCStoreId IS NOT NULL AND DPT.DCStoreFreezeId > 0) AND DPT.Quantity <= FZS.StockQty THEN 'True'
                            ELSE 'False'
                            END AS QuantityText FROM tblDepotToWHChalanDetail AS DPT 
                            LEFT JOIN dbo.tblDCStore AS DCS ON DCS.DCStoreId = DPT.DCStoreId
                            LEFT JOIN dbo.tblDCStoreFreeze AS FZS ON FZS.DCStoreFreezeId = DPT.DCStoreFreezeId WHERE DPT.SChalanId = '" + areaId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool UpdateChalanMasterStatus(string areaId)
        {
            string updateQuery = @"UPDATE tblDepotToWHChalanInfo SET IsTransfer ='OK' WHERE SChalanId = '" + areaId.Trim() + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }

        public void LoadPurposeDropDownList(DropDownList ddl)
        {
            string query = @"SELECT PurposeId,Purpose FROM tblPurpose";
            aCommonInternalDal.LoadDropDownValue(ddl, "Purpose", "PurposeId", query, "SSIDB");
        }

        public DataTable CheckChalanStatus(string selectedValue)
        {
            string query = @"SELECT * FROM dbo.tblDepotToWHChalanInfo WHERE IsTransfer IS NULL AND FromComUnitCode = '" + selectedValue + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DCStoreWIthTransfer(string dcstoreId)
        {
            string query = @"SELECT DCStoreId,ReceiveId FROM dbo.tblDCStore
            LEFT JOIN dbo.tblStockInTransfar ON tblStockInTransfar.StockInTransfarId = tblDCStore.StockInTransfarId WHERE DCStoreId='"+dcstoreId+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable DCStoreCentralStoreWIthTransfer(string dcstoreId)
        {
            string query = @"SELECT DCS.DCStoreId,ReceiveId FROM dbo.tblDCStore DC
            LEFT JOIN dbo.tblChalanDetail ON tblChalanDetail.ChalanDetailsId = DC.ChalanDetailsId
            LEFT JOIN dbo.tblDCStore DCS ON DCS.DCStoreId = tblChalanDetail.DCStoreId
            LEFT JOIN dbo.tblStockInTransfar ON dbo.tblStockInTransfar.StockInTransfarId=DCS.StockInTransfarId
            WHERE DC.DCStoreId='"+dcstoreId+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DCStoreCentralStore(string dcstoreId)
        {
            string query = @"SELECT tblChalanDetail.DCStoreId FROM dbo.tblDCStore DC
            LEFT JOIN dbo.tblChalanDetail ON tblChalanDetail.ChalanDetailsId = DC.ChalanDetailsId
            WHERE DC.DCStoreId='" + dcstoreId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetRcvId(DataTable aDataTable)
        {
            DataTable dtstockin = DCStoreWIthTransfer(aDataTable.Rows[0]["DCStoreId"].ToString());
            if (string.IsNullOrEmpty(dtstockin.Rows[0]["ReceiveId"].ToString()))
            {
                DataTable dtddata = DCStoreCentralStore(aDataTable.Rows[0]["DCStoreId"].ToString());
                return GetRcvId(dtddata);
            }
            
            else
            {
                return dtstockin;
            }
        }

        public DataTable ChalanReport(string id)
        {
            string query = @"SELECT CLN.ChalanNo,CLN.ChalanDate,CLN.TrackNo,CLN.DriverName,CLN.FromComUnitCode AS DCCode,CLN.FromComUnitName AS DCName,
                            CLN.FromComUnitAddress AS DCAddress,CLN.WHCode,CLN.WHName,CLN.WHAddress,CLND.ProductCode,CLND.ProductName,CLND.BatchNo,DCS.MfgDate,DCS.ExpDate,
                            CLND.Quantity,CLND.Value,CLND.Vat,CLND.ValueWVat FROM dbo.tblDepotToWHChalanInfo AS CLN 
                            INNER JOIN dbo.tblDepotToWHChalanDetail AS CLND ON CLND.SChalanId = CLN.SChalanId
                            LEFT JOIN dbo.tblDCStore AS DCS ON DCS.DCStoreId = CLND.DCStoreId
                            WHERE CLN.ChalanNo ='" + id + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        
    }
}
