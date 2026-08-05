


CREATE VIEW [dbo].[View_Sales_BIReport]
AS

SELECT 
    pt.ProgramTypeName as Customer_Type, 
    DATENAME(month, DATEFROMPARTS(tblInv.InvoiceYear, tblInv.InvoiceMonth, 1)) AS Month , 
    tblInv.InvoiceYear Year, 
    tblInv.InvoiceQty as Invoice_Qty, 
    tblInv.InvoiceAmount as Invoice_Amount, 
    tblSales.SalesQty as Sales_Qty, 
    tblSales.SalesAmount as Sales_Amount,
	tblOrd.OrderQty as Order_Qty,
	tblOrd.OrderAmount as Order_Amount

FROM 
    dbo.tblProgramType AS pt WITH (NOLOCK)
	
	 
LEFT OUTER JOIN
    (
        SELECT 
            MONTH(dbo.tblInvoice.InvoiceDate) AS InvoiceMonth, 
            YEAR(dbo.tblInvoice.InvoiceDate) AS InvoiceYear, 
            dbo.tblOrder.ProgramTypeId, 
            SUM(dbo.tblInvoiceDetail.Quantity) AS InvoiceQty, 
            SUM(dbo.tblInvoiceDetail.NetAmount) AS InvoiceAmount
        FROM 
            dbo.tblInvoice WITH (NOLOCK) 
        INNER JOIN
            dbo.tblInvoiceDetail WITH (NOLOCK) ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId 
        LEFT OUTER JOIN
            dbo.tblOrder WITH (NOLOCK) ON dbo.tblOrder.OrderId = dbo.tblInvoice.OrderId
        GROUP BY 
            MONTH(dbo.tblInvoice.InvoiceDate), 
            YEAR(dbo.tblInvoice.InvoiceDate), 
            dbo.tblOrder.ProgramTypeId
    ) AS tblInv 
    ON tblInv.ProgramTypeId = pt.ProgramTypeId 
LEFT OUTER JOIN
    (
        SELECT 
            MONTH(tblInvoice_1.UpdateDate) AS SalesMonth, 
            YEAR(tblInvoice_1.UpdateDate) AS SalesYear, 
            tblOrder_1.ProgramTypeId, 
            SUM(tblInvoiceDetail_1.DeliveryQuantity) AS SalesQty, 
            SUM(tblInvoiceDetail_1.DeliveryNetAmount) AS SalesAmount
        FROM 
            dbo.tblInvoice AS tblInvoice_1 WITH (NOLOCK) 
        INNER JOIN
            dbo.tblInvoiceDetail AS tblInvoiceDetail_1 WITH (NOLOCK) ON tblInvoice_1.InvoiceId = tblInvoiceDetail_1.InvoiceId 
        LEFT OUTER JOIN
            dbo.tblOrder AS tblOrder_1 WITH (NOLOCK) ON tblOrder_1.OrderId = tblInvoice_1.OrderId
        GROUP BY 
            MONTH(tblInvoice_1.UpdateDate), 
            YEAR(tblInvoice_1.UpdateDate), 
            tblOrder_1.ProgramTypeId
    ) AS tblSales 
    ON tblSales.ProgramTypeId = pt.ProgramTypeId 
       AND tblInv.InvoiceMonth = tblSales.SalesMonth 
       AND tblInv.InvoiceYear = tblSales.SalesYear


	LEFT OUTER JOIN
    (
        SELECT 
            MONTH(dbo.tblOrder.SubmissionDate) AS OrderMonth, 
            YEAR(dbo.tblOrder.SubmissionDate) AS OrderYear, 
            dbo.tblOrder.ProgramTypeId, 
            SUM(dbo.tblOrderDetail.Quantity) AS OrderQty, 
            SUM(dbo.tblOrderDetail.NetAmount) AS OrderAmount
        FROM 
            dbo.tblOrder WITH (NOLOCK) 
        INNER JOIN
            dbo.tblOrderDetail WITH (NOLOCK) ON dbo.tblOrder.OrderId = dbo.tblOrderDetail.OrderId 
      
        GROUP BY 
            MONTH(dbo.tblOrder.SubmissionDate), 
            YEAR(dbo.tblOrder.SubmissionDate), 
            dbo.tblOrder.ProgramTypeId
    ) AS tblOrd 
    ON tblOrd.ProgramTypeId = pt.ProgramTypeId 
	   and tblOrd.OrderMonth=tblInv.InvoiceMonth
	   and tblOrd.OrderYear=tblInv.InvoiceYear

WHERE 
    pt.ProgramTypeId IN (1, 2, 3, 4, 6)

	--order by   tblInv.InvoiceYear,pt.ProgramTypeName asc

	--order by   tblInv.InvoiceYear,pt.ProgramTypeName asc

--SELECT pt.ProgramTypeName, DATENAME(month, tblInv.InvoiceMonth) AS InvoiceMonth, tblInv.InvoiceYear, tblInv.InvoiceQty, tblInv.InvoiceAmount, tblSales.SalesQty, tblSales.SalesAmount, 20 AS CustomerCoverage
--FROM     dbo.tblProgramType AS pt WITH (nolock) LEFT OUTER JOIN
--                      (SELECT MONTH(dbo.tblInvoice.InvoiceDate) AS InvoiceMonth, YEAR(dbo.tblInvoice.InvoiceDate) AS InvoiceYear, dbo.tblOrder.ProgramTypeId, SUM(dbo.tblInvoiceDetail.Quantity) AS InvoiceQty, SUM(dbo.tblInvoiceDetail.NetAmount) 
--                                         AS InvoiceAmount
--                       FROM      dbo.tblInvoice WITH (nolock) INNER JOIN
--                                         dbo.tblInvoiceDetail WITH (nolock) ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId LEFT OUTER JOIN
--                                         dbo.tblOrder WITH (nolock) ON dbo.tblOrder.OrderId = dbo.tblInvoice.OrderId
--                       GROUP BY MONTH(dbo.tblInvoice.InvoiceDate), YEAR(dbo.tblInvoice.InvoiceDate), dbo.tblOrder.ProgramTypeId) AS tblInv ON tblInv.ProgramTypeId = pt.ProgramTypeId LEFT OUTER JOIN
--                      (SELECT MONTH(tblInvoice_1.UpdateDate) AS SalesMonth, YEAR(tblInvoice_1.UpdateDate) AS SalesYear, tblOrder_1.ProgramTypeId, SUM(tblInvoiceDetail_1.DeliveryQuantity) AS SalesQty, SUM(tblInvoiceDetail_1.DeliveryNetAmount) 
--                                         AS SalesAmount
--                       FROM      dbo.tblInvoice AS tblInvoice_1 WITH (nolock) INNER JOIN
--                                         dbo.tblInvoiceDetail AS tblInvoiceDetail_1 WITH (nolock) ON tblInvoice_1.InvoiceId = tblInvoiceDetail_1.InvoiceId LEFT OUTER JOIN
--                                         dbo.tblOrder AS tblOrder_1 WITH (nolock) ON tblOrder_1.OrderId = tblInvoice_1.OrderId
--                       GROUP BY MONTH(tblInvoice_1.UpdateDate), YEAR(tblInvoice_1.UpdateDate), tblOrder_1.ProgramTypeId) AS tblSales ON tblSales.ProgramTypeId = pt.ProgramTypeId 
					   
--					   AND tblInv.InvoiceMonth = tblSales.SalesMonth AND 
--                tblInv.InvoiceYear = tblSales.SalesYear
--WHERE  (pt.ProgramTypeId IN (1, 2, 3, 4, 6))

