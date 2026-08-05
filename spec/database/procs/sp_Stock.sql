-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Stock]
	
AS
Begin
truncate table SystemTest..Stock


	 Insert INTO SystemTest..Stock
	         ( SalesCenter ,
	           SalesCenterName ,
	           ProductCode ,
	           ProductName ,
	           PackSize ,
	           Batch ,
	           MfgDate ,
	           ExpDate ,
	           AvailableQty ,
	           BookedForDelivery ,
	           TransitQty ,
	           RestrictedQty ,
	           BlockedQty
	         )

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
                INNER JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
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
                --INNER JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
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
                --INNER JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
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
                INNER JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE I.IsDeliver IS NULL
                
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DS.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,DCS.StockQty AS RQty,0 AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                 INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left  JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left  JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left  JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
                WHERE DCS.StockQty>0 AND DCS.StockCondition='Restricted'
                UNION ALL
                SELECT p.ProductCode,p.ProductName,DCS.PackSize,DCS.
                BatchNo,DS.MfgDate,DCS.ExpDate,0 AS AvailableQty,0 AS BookFDel,0 AS Tqty,0 AS RQty,DCS.StockQty AS BQty,
                DCS.ComUnitId  FROM dbo.tblDCStoreFreeze DCS 
                INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = DCS.DCStoreId
                INNER JOIN dbo.tblProduct p ON DCS.ProductCode = p.ProductCode
                left JOIN tblStockInTransfar ST ON ST.StockInTransfarId = DS.StockInTransfarId
                left JOIN dbo.tblCentralStore CS ON CS.ReceiveId = ST.ReceiveId
                left JOIN dbo.tblMIGODetail MD ON MD.MigoDetailID = CS.MigoDetailID
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
WHERE C.IsDeliver ='False'
                
                ) AS vTblTotal
				INNER JOIN dbo.tblCompanyUnit Cu ON Cu.ComUnitId = vTblTotal.ComUnitId
                --where vTblTotal.ComUnitId='2'
                GROUP BY vTblTotal.ComUnitId,Cu.ComUnitCode,Cu.ComUnitName,vTblTotal.ProductCode, vTblTotal.ProductName ,vTblTotal.PackSize ,vTblTotal.BatchNo ,vTblTotal.MfgDate ,vTblTotal.ExpDate 
                
                  
                  
                  
                  
                  insert into SystemTest..ReportLog (ReportName,TransectionTime)
                  values ('Stock Report',GETDATE())
                  
                  
                  end
