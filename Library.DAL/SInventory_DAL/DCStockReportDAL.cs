using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class DCStockReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public void LoadCompanyUnit(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as ComInfo  from tblCompanyUnit ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComInfo", "ComUnitId", queryStr);
        }

        public void LoadCompanyUnit(DropDownList ddl,string userid)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as ComInfo  from tblCompanyUnit WHERE " +
                              " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComInfo", "ComUnitId", queryStr, SingleParameter("@UserId", userid.Trim()));
        }
        
        public DataTable DCReportMainDataDAL(string comUnitId)
        {
            string query = @"select * from tblCompanyUnit where ComUnitId=@ComUnitId";
            return SInventorySql.GetDataTable(query, SingleParameter("@ComUnitId", comUnitId.Trim()));
        }

        public DataTable DCReportDetailDataDAL(string comUnitId)
        {
            string query = "";
            if (comUnitId !="")
            {
                query = @"

         SELECT  
               --vTblTotal.ComUnitId,
               Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode ,
                vTblTotal.ProductName ,
                vTblTotal.PackSize ,
                vTblTotal.BatchNo ,
                vTblTotal.MfgDate ,
                vTblTotal.ExpDate ,
                SUM(vTblTotal.AvailableQty)AQty ,
                SUM(vTblTotal.BookFDel)BookFDel ,
                SUM(vTblTotal.Tqty)Tqty ,
                SUM(vTblTotal.RQty)RQty ,
                SUM(vTblTotal.BQty)BQty 
                FROM 
                (
                       SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblChalanDetail cd ON dcs.ChalanDetailsId=CD.ChalanDetailsId
                --INNER JOIN tblDCStore dc ON CD.DCStoreId=DC.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
               -- INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = dc.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'
                

  UNION ALL
  SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblSubDepotChalanDetail cd ON dcs.SChalanDetailsId=CD.SChalanDetailsId
                --INNER JOIN tblDCStore dc ON CD.DCStoreId=DC.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
               -- INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = dc.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'


                UNION ALL
                SELECT p.ProductCode,p.ProductName,ID.PackSize,
                ID.BatchNo,DCS.MfgDate,DCS.ExpDate,0 AS AvailableQty,ID.TotalQuantity AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                I.ComUnitId
                FROM dbo.tblInvoice I 
                INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
                INNER JOIN 
                dbo.tblDCStore DCS ON DCS.DCStoreId = ID.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                --INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE I.DelivaryInvoiceNo IS NULL


                UNION ALL
                  SELECT p.ProductCode,p.ProductName,P.PackSize,
                ID.BatchNo,DCS.MfgDate,DCS.ExpDate,0 AS AvailableQty,ID.Quantity AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                cu.ComUnitId
                FROM dbo.tblChalanInfo I 
                INNER JOIN dbo.tblChalanDetail ID ON ID.ChalanId = I.ChalanId 
                INNER JOIN 
                dbo.tblDCStore DCS ON DCS.DCStoreId = ID.DCStoreId
                INNER JOIN   dbo.tblCompanyUnit cu ON i.FromComUnitCode = cU.ComUnitCode
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE I.IsDeliver IS NULL
                
                
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,MD.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCS.StockQty AS RQty,0 AS BQty,
                DCS.ComUnitId FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Restricted'
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,MD.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCS.StockQty AS BQty,
                DCS.ComUnitId 
                FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Blocked'


                UNION ALL
                
                
                SELECT p.ProductCode,p.ProductName,ST.PackSize,ST.
                BatchNo,ST.MfgDate,ST.ExpDate,0 AS AvailableQty,0 AS BookFDel,ST.Quantity AS Tqty,0 AS RQty,0 AS BQty,
                R.ComUnitId FROM dbo.tblRequisition R 
                INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqId = R.ReqId
                INNER JOIN dbo.tblProduct p ON p.ProductCode = ST.ProductCode
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                WHERE  R.ReceiveIssue IS NULL
                UNION ALL

                SELECT p.ProductCode,p.ProductName,D.PackSize,D.
                                BatchNo,D.MfgDate,D.ExpDate,0 AS AvailableQty,0 AS BookFDel,CD.Quantity AS Tqty,0 AS RQty,0 AS BQty,
                                CU.ComUnitId FROM dbo.tblChalanInfo C 
                INNER JOIN dbo.tblChalanDetail CD ON CD.ChalanId = C.ChalanId
                INNER JOIN dbo.tblDCStore D ON D.DCStoreId = CD.DCStoreId
                INNER JOIN dbo.tblCompanyUnit CU ON C.ToComUnitCode=CU.ComUnitCode
                INNER JOIN dbo.tblProduct p ON p.ProductCode = CD.ProductCode
                WHERE C.IsDeliver ='False') AS vTblTotal
				
				INNER JOIN dbo.tblCompanyUnit Cu ON Cu.ComUnitId = vTblTotal.ComUnitId

                where vTblTotal.ComUnitId=@ComUnitId GROUP BY vTblTotal.ComUnitId,Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode, vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate "; 
                

            }
            else
            {
                query = @"

              SELECT  vTblTotal.ComUnitId,Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode ,
                vTblTotal.ProductName ,
                vTblTotal.PackSize ,
                vTblTotal.BatchNo ,
                vTblTotal.MfgDate ,
                vTblTotal.ExpDate ,
                SUM(vTblTotal.AvailableQty)AQty ,
                SUM(vTblTotal.BookFDel)BookFDel ,
                SUM(vTblTotal.Tqty)Tqty ,
                SUM(vTblTotal.RQty)RQty ,
                SUM(vTblTotal.BQty)BQty 
                FROM 
                (
                   SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblChalanDetail cd ON dcs.ChalanDetailsId=CD.ChalanDetailsId
                --INNER JOIN tblDCStore dc ON CD.DCStoreId=DC.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
               -- INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = dc.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'
                
                UNION ALL
                SELECT p.ProductCode,p.ProductName,ID.PackSize,
                ID.BatchNo,DCS.MfgDate,DCS.ExpDate,0 AS AvailableQty,ID.TotalQuantity AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                I.ComUnitId
                FROM dbo.tblInvoice I 
                INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
                INNER JOIN 
                dbo.tblDCStore DCS ON DCS.DCStoreId = ID.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                --INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE I.DelivaryInvoiceNo IS NULL



  UNION ALL
  SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStore DCS 
                INNER JOIN dbo.tblSubDepotChalanDetail cd ON dcs.SChalanDetailsId=CD.SChalanDetailsId
                --INNER JOIN tblDCStore dc ON CD.DCStoreId=DC.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
               -- INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = dc.StockInTransfarId
                --INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                --INNER JOIN dbo.tblWHStockInDetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'

                UNION ALL
                  SELECT p.ProductCode,p.ProductName,P.PackSize,
                ID.BatchNo,DCS.MfgDate,DCS.ExpDate,0 AS AvailableQty,ID.Quantity AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                cu.ComUnitId
                FROM dbo.tblChalanInfo I 
                INNER JOIN dbo.tblChalanDetail ID ON ID.ChalanId = I.ChalanId 
                INNER JOIN 
                dbo.tblDCStore DCS ON DCS.DCStoreId = ID.DCStoreId
                INNER JOIN   dbo.tblCompanyUnit cu ON i.FromComUnitCode = cU.ComUnitCode
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                INNER JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DCS.StockInTransfarId
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE I.IsDeliver IS NULL
                
                
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,MD.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCS.StockQty AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Restricted'
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,MD.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCS.StockQty AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Blocked'

                 UNION ALL
                
                
                SELECT p.ProductCode,p.ProductName,ST.PackSize,ST.
                BatchNo,ST.MfgDate,ST.ExpDate,0 AS AvailableQty,0 AS BookFDel,ST.Quantity AS Tqty,0 AS RQty,0 AS BQty,
                R.ComUnitId FROM dbo.tblRequisition R 
                INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqId = R.ReqId
                INNER JOIN dbo.tblProduct p ON p.ProductCode = ST.ProductCode
                INNER JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                WHERE  R.ReceiveIssue IS NULL
                UNION ALL

                SELECT p.ProductCode,p.ProductName,D.PackSize,D.
                                BatchNo,D.MfgDate,D.ExpDate,0 AS AvailableQty,0 AS BookFDel,CD.Quantity AS Tqty,0 AS RQty,0 AS BQty,
                                CU.ComUnitId FROM dbo.tblChalanInfo C 
                INNER JOIN dbo.tblChalanDetail CD ON CD.ChalanId = C.ChalanId
                INNER JOIN dbo.tblDCStore D ON D.DCStoreId = CD.DCStoreId
                INNER JOIN dbo.tblCompanyUnit CU ON C.ToComUnitCode=CU.ComUnitCode
                INNER JOIN dbo.tblProduct p ON p.ProductCode = CD.ProductCode
                WHERE C.IsDeliver ='False' ) AS vTblTotal
						                INNER JOIN dbo.tblCompanyUnit Cu ON Cu.ComUnitId = vTblTotal.ComUnitId
                 GROUP BY vTblTotal.ComUnitId,Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode, vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate
												"; 																
																		               
            }
            return comUnitId != ""
                ? SInventorySql.GetDataTable(query, SingleParameter("@ComUnitId", comUnitId))
                : aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable DCWiseCountryReportDetailDataDAL()
        {
            string query = @"select * from View_ProDCStock order by ProductCode";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable WHReportDetailDataDAL()
        {
            string query = "";
            {
                query = @"

                  SELECT

   vTblTotal.ProductCode ,
       vTblTotal.ProductName ,
       vTblTotal.PackSize ,
       vTblTotal.BatchNo ,
       vTblTotal.MfgDate ,
       vTblTotal.ExpDate 
     ,
       SUM(vTblTotal.AvailableQty)AQty ,
       SUM(vTblTotal.BookFDel)BookFDel ,
       SUM(vTblTotal.Tqty)Tqty ,
       SUM(vTblTotal.RQty)RQty ,
       SUM(vTblTotal.BQty)BQty 
    from

  (SELECT CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,CS.Quantity AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty
 FROM dbo.tblCentralStore CS 
  INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
where CS.Quantity>0
       UNION ALL
          


SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,ST.PickingQty AS Tqty,0 AS RQty,0 AS BQty FROM dbo.tblCentralStore CS 
INNER JOIN dbo.tblStockInTransfar ST ON ST.ReceiveId = CS.ReceiveId

INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE  ST.IsTransfared is null and ST.IsIssue='OK'

 UNION ALL
SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,ST.PickingQty AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty FROM dbo.tblCentralStore CS 
INNER JOIN dbo.tblStockInTransfar ST ON ST.ReceiveId = CS.ReceiveId

INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE ST.IsIssue IS NULL and ST.IsTransfared IS NULL 
UNION ALL

SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCF.StockQty AS RQty,0 AS BQty FROM 
dbo.tblWhStoreFreeze DCF 
INNER JOIN 
dbo.tblCentralStore CS ON CS.ReceiveId = DCF.ReceiveId
INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE DCF.StockCondition='Restricted' and DCF.StockQty>0


UNION ALL

SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCF.StockQty AS BQty FROM 
dbo.tblWhStoreFreeze DCF  INNER JOIN 
dbo.tblCentralStore CS ON CS.ReceiveId = DCF.ReceiveId
INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
       WHERE DCF.StockCondition='Blocked'  and DCF.StockQty>0
) AS vTblTotal
                
       GROUP BY vTblTotal.ProductCode ,
       vTblTotal.ProductName ,
       vTblTotal.PackSize ,
       vTblTotal.BatchNo ,
       vTblTotal.MfgDate ,
       vTblTotal.ExpDate "
                    ;
            }
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable WHReportDetailDataDAL(string Pcode)
        {
            string query = "";
            {
                query = @"

                SELECT

   vTblTotal.ProductCode ,
       vTblTotal.ProductName ,
       vTblTotal.PackSize ,
       vTblTotal.BatchNo ,
       vTblTotal.MfgDate ,
       vTblTotal.ExpDate 
     ,
       SUM(vTblTotal.AvailableQty)AQty ,
       SUM(vTblTotal.BookFDel)BookFDel ,
       SUM(vTblTotal.Tqty)Tqty ,
       SUM(vTblTotal.RQty)RQty ,
       SUM(vTblTotal.BQty)BQty 
    from

  (SELECT CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,CS.Quantity AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty
 FROM dbo.tblCentralStore CS 
  INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
where CS.Quantity>0
       UNION ALL
          


SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,ST.PickingQty AS Tqty,0 AS RQty,0 AS BQty FROM dbo.tblCentralStore CS 
INNER JOIN dbo.tblStockInTransfar ST ON ST.ReceiveId = CS.ReceiveId

INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE  ST.IsTransfared is null and ST.IsIssue='OK'

 UNION ALL
SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,ST.PickingQty AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty FROM dbo.tblCentralStore CS 
INNER JOIN dbo.tblStockInTransfar ST ON ST.ReceiveId = CS.ReceiveId

INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE ST.IsIssue IS NULL and ST.IsTransfared IS NULL 

UNION ALL

SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCF.StockQty AS RQty,0 AS BQty FROM 
dbo.tblWhStoreFreeze DCF 
INNER JOIN 
dbo.tblCentralStore CS ON CS.ReceiveId = DCF.ReceiveId
INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
WHERE DCF.StockCondition='Restricted' and DCF.StockQty>0


UNION ALL

SELECT  CS.ProductCode,CS.ProductName,CS.PackSize,CS.
BatchNo,MD.MfgDate,CS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCF.StockQty AS BQty FROM 
dbo.tblWhStoreFreeze DCF  INNER JOIN 
dbo.tblCentralStore CS ON CS.ReceiveId = DCF.ReceiveId
INNER JOIN dbo.tblWHStockInDetail MD ON MD.WHStockInDetailID = CS.MigoDetailID
       WHERE DCF.StockCondition='Blocked'  and DCF.StockQty>0

) AS vTblTotal

 where vTblTotal.ProductCode=@ProductCode GROUP BY vTblTotal.ProductCode ,vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate ";
            }
            return SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", Pcode));
        }


        //Subdeport Stock

        public DataTable SubDeportStockReportDetailDataDAL(string comUnitId)
        {
            string query = "";
            if (comUnitId != "")
            {
                query = @"

                SELECT  
                Cu.SubDepotCode AS ComUnitCode,Cu.SubDepotName AS ComUnitName,vTblTotal.ProductCode ,
                vTblTotal.ProductName ,
                vTblTotal.PackSize ,
                vTblTotal.BatchNo ,
                vTblTotal.MfgDate ,
                vTblTotal.ExpDate ,
                SUM(vTblTotal.AvailableQty)AQty ,
                SUM(vTblTotal.BookFDel)BookFDel ,
                SUM(vTblTotal.Tqty)Tqty ,
                SUM(vTblTotal.RQty)RQty ,
                SUM(vTblTotal.BQty)BQty 
                FROM 
                (
                       SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DCS.MfgDate,DCS.ExpDate,DCS.StockQty AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                DCS.SubDepotId  FROM dbo.tblSubDepotStore DCS 
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Available'


				UNION ALL


                SELECT p.ProductCode,p.ProductName,ID.PackSize,
                ID.BatchNo,DCS.MfgDate,DCS.ExpDate,0 AS AvailableQty,ID.TotalQuantity AS BookFDel,0 AS Tqty,0 AS RQty,0 AS BQty,
                I.SubDepotId
                FROM dbo.tblSubInvoiceMaster I 
                INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
                INNER JOIN  dbo.tblSubDepotStore DCS ON DCS.SubDCStoreId = ID.SubDCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                WHERE I.DelivaryInvoiceNo IS NULL

				UNION ALL

				SELECT p.ProductCode,p.ProductName,D.PackSize,D.
                                BatchNo,D.MfgDate,D.ExpDate,0 AS AvailableQty,0 AS BookFDel,CD.Quantity AS Tqty,0 AS RQty,0 AS BQty
                            ,   CU.SubDepotId
								
			    FROM dbo.tblSubDepotChalanInfo C 
                INNER JOIN dbo.tblSubDepotChalanDetail CD ON CD.SChalanId = C.SChalanId
                INNER JOIN dbo.tblDCStore D ON D.DCStoreId = CD.DCStoreId
                INNER JOIN dbo.tblSubDepot CU ON C.SubDepotCode=CU.SubDepotCode
                INNER JOIN dbo.tblProduct p ON p.ProductCode = CD.ProductCode
                WHERE C.IsDeliver ='False'

                UNION ALL


                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,'' AS MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCS.StockQty AS BQty,
                DS.SubDepotId 
                FROM dbo.tblSubDepotStoreFreeze DCS 
                INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = DCS.SubDCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
				INNER JOIN  dbo.tblSubDepotStore S ON S.SubDCStoreId = DS.SubDCStoreId
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Blocked'
                
                UNION ALL

			    SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,'' AS MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCS.StockQty AS RQty,0 AS BQty,
                DS.SubDepotId 
                FROM dbo.tblSubDepotStoreFreeze DCS 
                INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = DCS.SubDCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
				INNER JOIN  dbo.tblSubDepotStore S ON S.SubDCStoreId = DS.SubDCStoreId
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Restricted'

				
				) AS vTblTotal
				
				INNER JOIN dbo.tblSubDepot Cu ON Cu.SubDepotId = vTblTotal.SubDepotId

                where vTblTotal.SubDepotId=@SubDepotId GROUP BY vTblTotal.SubDepotId,Cu.SubDepotCode,Cu.SubDepotName,vTblTotal.ProductCode, vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate"; 
                
              //  where vTblTotal.ComUnitId='" + comUnitId + "'GROUP BY vTblTotal.ComUnitId,Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode, vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate ";

            }
            
            return comUnitId != ""
                ? SInventorySql.GetDataTable(query, SingleParameter("@SubDepotId", comUnitId))
                : aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        private List<SqlParameter> SingleParameter(string name, object value)
        {
            return new List<SqlParameter>
            {
                new SqlParameter(name, SInventorySql.DbValue(value))
            };
        }

    }

}
