
-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,0@CompanyId/@CompanyId5/20@CompanyId6,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_WearhouseBinCard] 

	@FromDate DATETIME,
	@ToDate DATETIME,
	@CompanyId INT
	
AS
BEGIN
	
	SELECT CI.CompanyName,PD.ProductId,PD.ProductCode,PD.ProductName,PD.PackSize,ISNULL(CSOP.OpeningStock,0) AS OpeningStock,ISNULL(CSR.StockInQuantity,0) AS StockReceive,
(ISNULL(CSOP.OpeningStock,0) + ISNULL(CSR.StockInQuantity,0)) AS TotalReceive,ISNULL(DHK.Dhaka,0) AS Dhaka,ISNULL(BG.Bogra,0) AS Bogra,
ISNULL(CTG.Chittagong,0) AS Chittagong,ISNULL(NK.Noakhali,0) AS Noakhali,ISNULL(SYL.Sylhet,0) AS Sylhet,ISNULL(KLN.Khulna,0) AS Khulna,
ISNULL(TNS.Transit,0) AS Transit,ISNULL(WFZ.Freeze,0) AS Freeze, @FromDate AS FromDate,@ToDate AS ToDate,
(ISNULL(DHK.Dhaka,0)+ISNULL(BG.Bogra,0)+ISNULL(CTG.Chittagong,0)+ISNULL(NK.Noakhali,0)+ISNULL(SYL.Sylhet,0)+ISNULL(KLN.Khulna,0)+
ISNULL(TNS.Transit,0)+ISNULL(WFZ.Freeze,0)) AS TotalIssue,((ISNULL(CSOP.OpeningStock,0) + ISNULL(CSR.StockInQuantity,0)) - (ISNULL(DHK.Dhaka,0)+ISNULL(BG.Bogra,0)+ISNULL(CTG.Chittagong,0)+ISNULL(NK.Noakhali,0)+ISNULL(SYL.Sylhet,0)+ISNULL(KLN.Khulna,0)+
ISNULL(TNS.Transit,0)+ISNULL(WFZ.Freeze,0))) AS ClosingStock,((ISNULL(CSOP.OpeningStockValue,0)) + (ISNULL(CSR.ReceiveStockValue,0)) - (ISNULL(DHK.DhkStockValue,0)+ISNULL(BG.BgrStockValue,0)+ISNULL(CTG.CtgStockValue,0)+ISNULL(NK.NklStockValue,0)+ISNULL(SYL.Sylhet,0)+ISNULL(KLN.KlnStockValue,0)+
ISNULL(TNS.TnsStockValue,0)+ISNULL(WFZ.WfStockValue,0))) StockValue  FROM tblProduct  AS PD 
LEFT JOIN tblCompanyInfo AS CI ON CI.CompanyId = PD.CompanyId
LEFT JOIN tblUnitPrice AS UP ON UP.ProductId = PD.ProductId 
LEFT JOIN (
SELECT OP.ProductCode,SUM(OP.Quantity) AS OpeningStock,SUM(OP.Quantity*OP.UnitPrice) AS OpeningStockValue FROM tblCentralStore_OpeninigBalance OP 
WHERE OP.CSOpeninigBalanceDate BETWEEN @FromDate AND @FromDate GROUP BY OP.ProductCode ) AS CSOP ON PD.ProductCode = CSOP.ProductCode 
LEFT JOIN (
SELECT ProductCode,SUM(StockInQty) AS StockInQuantity,SUM(StockInQty*UnitPrice) AS ReceiveStockValue FROM tblCentralStore WHERE ReceiveDate BETWEEN @FromDate AND @ToDate
GROUP BY ProductCode) AS CSR ON PD.ProductCode = CSR.ProductCode 
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Dhaka,SUM(ST.Quantity*CS.UnitPrice) AS DhkStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Dhaka%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS DHK ON PD.ProductCode = DHK.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Bogra,SUM(ST.Quantity*CS.UnitPrice) AS BgrStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Bogra%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS BG ON PD.ProductCode = BG.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Chittagong,SUM(ST.Quantity*CS.UnitPrice) AS CtgStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Chittagong%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS CTG ON PD.ProductCode = CTG.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Noakhali,SUM(ST.Quantity*CS.UnitPrice) AS NklStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Noakhali%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS NK ON PD.ProductCode = NK.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Sylhet,SUM(ST.Quantity*CS.UnitPrice) AS SylStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Sylhet%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS SYL ON PD.ProductCode = SYL.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Khulna,SUM(ST.Quantity*CS.UnitPrice) AS KlnStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND ComUnitName LIKE '%Khulna%' AND ReceiveIssue = 'OK' AND RQ.ReceiveIssueDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS KLN ON PD.ProductCode = KLN.ProductCode
LEFT JOIN (
SELECT ST.ProductCode,SUM(ST.Quantity) AS Transit,SUM(ST.Quantity*CS.UnitPrice) AS TnsStockValue FROM tblStockInTransfar AS ST
LEFT JOIN tblRequisition AS RQ ON ST.ReqId = RQ.ReqId
LEFT JOIN tblCentralStore AS CS ON ST.ReceiveId = CS.ReceiveId
WHERE CompanyId = @CompanyId AND (ReceiveIssue IS NULL OR ReceiveIssue ='') AND RQ.ReqDate BETWEEN @FromDate AND @ToDate
GROUP BY ST.ProductCode) AS TNS ON PD.ProductCode = TNS.ProductCode
LEFT JOIN (
SELECT P.ProductCode,SUM(WF.StockQty) AS Freeze,SUM(WF.StockQty*CS.UnitPrice) AS WfStockValue FROM tblWhStoreFreeze AS WF
LEFT JOIN tblProduct AS P ON P.ProductId = WF.ProductId
LEFT JOIN tblCentralStore AS CS ON WF.ReceiveId = CS.ReceiveId
 WHERE WF.ReceiveDate BETWEEN @FromDate AND @ToDate GROUP BY P.ProductCode) AS WFZ ON PD.ProductCode = WFZ.ProductCode
WHERE PD.CompanyId = @CompanyId  AND UP.IsActive = 1 ORDER BY PD.ProductCode

END




