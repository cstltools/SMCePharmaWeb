-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SalesDepositOpeningBalanceProcess]

-- EXEC sp_SalesDepositOpeningBalanceProcess
	
AS
BEGIN

Delete from tblDepositOpeningBalance where OpeningDate='8/1/2020' 
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '8/1/2020' as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='7/1/2020' )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '7/1/2020' AND '7/31/2020'  GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '7/1/2020' AND '7/31/2020'  GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '7/1/2020' AND '7/31/2020' AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '7/1/2020' AND '7/31/2020' AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '7/1/2020' AND '7/31/2020') AND InvoiceDate >= '7/1/2020'    GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '7/1/2020' AND '7/31/2020'  AND InvoiceDate >= '7/1/2020'  GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '7/1/2020'  AND UpdateDate BETWEEN '7/1/2020' AND '7/31/2020' GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '7/1/2020'  AND UpdateDate BETWEEN '7/1/2020' AND '7/31/2020'  GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '7/1/2020' and '7/31/2020' group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '7/1/2020' AND '7/31/2020' GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx



------------------------------


Delete from tblDepositOpeningBalance where OpeningDate='9/1/2020'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '9/1/2020'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='8/1/2020'  )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '8/1/2020'  AND '8/31/2020'   GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '8/1/2020'  AND '8/31/2020'   GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '8/1/2020'  AND '8/31/2020'  AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '8/1/2020'  AND '8/31/2020'  AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '8/1/2020'  AND '8/31/2020' ) AND InvoiceDate >= '8/1/2020'     GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '8/1/2020'  AND '8/31/2020'   AND InvoiceDate >= '8/1/2020'   GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '8/1/2020'   AND UpdateDate BETWEEN '8/1/2020'  AND '8/31/2020'  GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '8/1/2020'   AND UpdateDate BETWEEN '8/1/2020'  AND '8/31/2020'   GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '8/1/2020'  and '8/31/2020'  group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '8/1/2020'  AND '8/31/2020'  GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tbly

------------------------------------------------------------

Delete from tblDepositOpeningBalance where OpeningDate='10/1/2020'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '10/1/2020'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='9/1/2020'   )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '9/1/2020'   AND '9/30/2020'    GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '9/1/2020'   AND '9/30/2020'    GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '9/1/2020'   AND '9/30/2020'   AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '9/1/2020'   AND '9/30/2020'   AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '9/1/2020'   AND '9/30/2020'  ) AND InvoiceDate >= '9/1/2020'      GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '9/1/2020'   AND '9/30/2020'    AND InvoiceDate >= '9/1/2020'    GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '9/1/2020'    AND UpdateDate BETWEEN '9/1/2020'   AND '9/30/2020'   GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '9/1/2020'    AND UpdateDate BETWEEN '9/1/2020'   AND '9/30/2020'    GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '9/1/2020'   and '9/30/2020'   group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '9/1/2020'   AND '9/30/2020'   GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx



---------------------------------------------------------------------
	Delete from tblDepositOpeningBalance where OpeningDate='11/1/2020'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '11/1/2020'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='10/1/2020'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '10/1/2020'    AND '10/31/2020'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '10/1/2020'    AND '10/31/2020'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '10/1/2020'    AND '10/31/2020'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '10/1/2020'    AND '10/31/2020'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '10/1/2020'    AND '10/31/2020'   ) AND InvoiceDate >= '10/1/2020'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '10/1/2020'    AND '10/31/2020'     AND InvoiceDate >= '10/1/2020'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '10/1/2020'     AND UpdateDate BETWEEN '10/1/2020'    AND '10/31/2020'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '10/1/2020'     AND UpdateDate BETWEEN '10/1/2020'    AND '10/31/2020'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '10/1/2020'    and '10/31/2020'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '10/1/2020'    AND '10/31/2020'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx
	
------------------------------------------------------------
Delete from tblDepositOpeningBalance where OpeningDate='12/1/2020'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '12/1/2020'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='11/1/2020'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '11/1/2020'    AND '11/30/2020'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '11/1/2020'    AND '11/30/2020'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '11/1/2020'    AND '11/30/2020'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '11/1/2020'    AND '11/30/2020'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '11/1/2020'    AND '11/30/2020'   ) AND InvoiceDate >= '11/1/2020'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '11/1/2020'    AND '11/30/2020'     AND InvoiceDate >= '11/1/2020'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '11/1/2020'     AND UpdateDate BETWEEN '11/1/2020'    AND '11/30/2020'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '11/1/2020'     AND UpdateDate BETWEEN '11/1/2020'    AND '11/30/2020'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '11/1/2020'    and '11/30/2020'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '11/1/2020'    AND '11/30/2020'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx
	
--------------------------------------
Delete from tblDepositOpeningBalance where OpeningDate='1/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '1/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='12/1/2020'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '12/1/2020'    AND '12/31/2020'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '12/1/2020'    AND '12/31/2020'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '12/1/2020'    AND '12/31/2020'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '12/1/2020'    AND '12/31/2020'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '12/1/2020'    AND '12/31/2020'   ) AND InvoiceDate >= '12/1/2020'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '12/1/2020'    AND '12/31/2020'     AND InvoiceDate >= '12/1/2020'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '12/1/2020'     AND UpdateDate BETWEEN '12/1/2020'    AND '12/31/2020'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '12/1/2020'     AND UpdateDate BETWEEN '12/1/2020'    AND '12/31/2020'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '12/1/2020'    and '12/31/2020'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '12/1/2020'    AND '12/31/2020'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx
	
-----------------------------------------

Delete from tblDepositOpeningBalance where OpeningDate='2/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '2/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='1/1/2021'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '1/1/2021'    AND '1/31/2021'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '1/1/2021'    AND '1/31/2021'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '1/1/2021'    AND '1/31/2021'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '1/1/2021'    AND '1/31/2021'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '1/1/2021'    AND '1/31/2021'   ) AND InvoiceDate >= '1/1/2021'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '1/1/2021'    AND '1/31/2021'     AND InvoiceDate >= '1/1/2021'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '1/1/2021'     AND UpdateDate BETWEEN '1/1/2021'    AND '1/31/2021'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '1/1/2021'     AND UpdateDate BETWEEN '1/1/2021'    AND '1/31/2021'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '1/1/2021'    and '1/31/2021'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '1/1/2021'    AND '1/31/2021'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx
	

-------------------------------------------------

	
Delete from tblDepositOpeningBalance where OpeningDate='3/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '3/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='2/1/2021'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '2/1/2021'    AND '2/28/2021'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '2/1/2021'    AND '2/28/2021'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '2/1/2021'    AND '2/28/2021'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '2/1/2021'    AND '2/28/2021'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '2/1/2021'    AND '2/28/2021'   ) AND InvoiceDate >= '2/1/2021'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '2/1/2021'    AND '2/28/2021'     AND InvoiceDate >= '2/1/2021'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '2/1/2021'     AND UpdateDate BETWEEN '2/1/2021'    AND '2/28/2021'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '2/1/2021'     AND UpdateDate BETWEEN '2/1/2021'    AND '2/28/2021'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '2/1/2021'    and '2/28/2021'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '2/1/2021'    AND '2/28/2021'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx


---------------------------------------



Delete from tblDepositOpeningBalance where OpeningDate='4/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '4/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='3/1/2021'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '3/1/2021'    AND '3/31/2021'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '3/1/2021'    AND '3/31/2021'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '3/1/2021'    AND '3/31/2021'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '3/1/2021'    AND '3/31/2021'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '3/1/2021'    AND '3/31/2021'   ) AND InvoiceDate >= '3/1/2021'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '3/1/2021'    AND '3/31/2021'     AND InvoiceDate >= '3/1/2021'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '3/1/2021'     AND UpdateDate BETWEEN '3/1/2021'    AND '3/31/2021'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '3/1/2021'     AND UpdateDate BETWEEN '3/1/2021'    AND '3/31/2021'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '3/1/2021'    and '3/31/2021'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '3/1/2021'    AND '3/31/2021'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx


------------------------------------------

Delete from tblDepositOpeningBalance where OpeningDate='5/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '5/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='4/1/2021'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '4/1/2021'    AND '4/30/2021'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '4/1/2021'    AND '4/30/2021'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '4/1/2021'    AND '4/30/2021'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '4/1/2021'    AND '4/30/2021'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '4/1/2021'    AND '4/30/2021'   ) AND InvoiceDate >= '4/1/2021'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '4/1/2021'    AND '4/30/2021'     AND InvoiceDate >= '4/1/2021'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '4/1/2021'     AND UpdateDate BETWEEN '4/1/2021'    AND '4/30/2021'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '4/1/2021'     AND UpdateDate BETWEEN '4/1/2021'    AND '4/30/2021'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '4/1/2021'    and '4/30/2021'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '4/1/2021'    AND '4/30/2021'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx
----------------------------------------------------------------------------
	
Delete from tblDepositOpeningBalance where OpeningDate='6/1/2021'  
insert into tblDepositOpeningBalance (ComUnitID,CollectionInHand,MarketOutstanding,TotalReceivable,OpeningDate)


select ComUnitId,ClosingCashinHand,ClosingMarketOutstanding,ClosingTotalReceivable , '6/1/2021'  as OpeningDate  from (	select '' AS ComUnitCode,U.ComUnitId,

tblDps.CollectionInHand as  CashinHand ,tblDps.MarketOutstanding as MArketOutStanding, tblDps.TotalReceivable  as TotalOpeningReceivable,


((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))-ISNULL(tblAdjust.TpTotal,0) AS SalesOnTP
,(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))-ISNULL(tblAdjust.TpVat,0) AS TpVat,
((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0) as TotalSales



,(ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0) AS CurrentPeriodSales,(ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)) as tblBeforeCurrentPeriodSales, (((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))) as TotalCollection



,ISNULL(tblCurrentDpst.Amount,0) BankDeposit, 0.0 AIT ,( ISNULL(tblCurrentDpst.Amount,0) + 0.0) AS totalDeposit



,((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0)  as ClosingCashinHand ,
((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0)))))  ClosingMarketOutstanding 
,(((tblDps.CollectionInHand)+((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))))-( ISNULL(tblCurrentDpst.Amount,0) + 0.0) )+(((ISNULL(tblDps.MarketOutstanding,0.0)+(((((ISNULL(tblA.SumofNetProformaAmount,0) + ISNULL(tblAA.SumofNetProformaAmount,0)) - (ISNULL(tblD.SumofNetReturnAmount,0) + ISNULL(tblDD.SumofNetReturnAmount,0)))+(((ISNULL(tblA.ProTpVat,0) + ISNULL(tblAA.ProTpVat,0))-(ISNULL(tblD.TotalPriceVatAmount,0) + ISNULL(tblDD.TotalPriceVatAmount,0))))))-ISNULL(tblAdjust.TpGrandTotal,0))))-((((ISNULL(tblC.SumofNetSalesAmount,0)+ISNULL(tblCC.SumofNetSalesAmount,0))-ISNULL(tblAdjust.TpTotal,0)) + ((ISNULL(tblCK.SumofNetSalesAmount,0)+ISNULL(tblCCK.SumofNetSalesAmount,0))))) ) ClosingTotalReceivable  



FROM tblCompanyUnit U WITH(NOLOCK)


left join (select CollectionInHand,MarketOutstanding,TotalReceivable,ComUnitID from tblDepositOpeningBalance WITH(NOLOCK) where OpeningDate='5/1/2021'    )tblDps on U.ComUnitId= tblDps.ComUnitID




LEFT JOIN (SELECT I.ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  
AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat FROM dbo.tblInvoice I WITH (NOLOCK) INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND I.InvoiceDate BETWEEN '5/1/2021'    AND '5/31/2021'     GROUP BY I.ComUnitId)tblA ON tblA.ComUnitId=U.ComUnitId


	 LEFT JOIN (SELECT ComUnitId,count(DISTINCT I.InvoiceId) NumberofProformaInvoice,SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount)  AS SumofNetProformaAmount,SUM(ID.TotalPriceVatAmount)ProTpVat 
	 FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK)  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE I.TpGrandTotal>0 AND I.InvoiceDate
	  BETWEEN '5/1/2021'    AND '5/31/2021'     GROUP BY ComUnitId)tblAA ON tblAA.ComUnitId=U.ComUnitId 

	
   LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,COUNT(DISTINCT I.DelivaryInvoiceNo)
    NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblInvoice I WITH (NOLOCK)
	 INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  where ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate BETWEEN '5/1/2021'    AND '5/31/2021'    AND I.TpGrandTotal>0  
	 GROUP BY ComUnitId)tblD ON tblD.ComUnitId=U.ComUnitId   
	 

	 	  LEFT JOIN (SELECT ComUnitId, ((SUM(ID.NetAmount)-sum(ID.TotalPriceVatAmount))- SUM(ID.DeliveryNetAmount - ID.DeliveryTotalPriceVatAmount)) AS SumofNetReturnAmount,
	  COUNT(DISTINCT I.DelivaryInvoiceNo)  NumberofReturnInvoice,SUM(ID.TotalPriceVatAmount)-sum(DeliveryTotalPriceVatAmount) as TotalPriceVatAmount FROM dbo.tblSubInvoiceMaster I WITH (NOLOCK) 
	  INNER JOIN dbo.tblSubInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId  WHERE ID.DeliveryStatus IN ('Reject','Partial') AND I.UpdateDate  
	  BETWEEN '5/1/2021'    AND '5/31/2021'    AND I.TpGrandTotal>0  GROUP BY ComUnitId)tblDD ON tblDD.ComUnitId =U.ComUnitId






						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  ( UpdateDate BETWEEN '5/1/2021'    AND '5/31/2021'   ) AND InvoiceDate >= '5/1/2021'       GROUP BY  ComUnitId)tblc ON tblc.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND UpdateDate BETWEEN '5/1/2021'    AND '5/31/2021'     AND InvoiceDate >= '5/1/2021'     GROUP BY  ComUnitId)tblcc ON tblcc.ComUnitId=U.ComUnitId 



  
						   LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblInvoice.InvoiceId)NumberofInvoiceSold,SUM(D.DeliveryNetAmount ) SumofNetSalesAmount , 
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblInvoice  WITH (NOLOCK)  INNER JOIN dbo.tblInvoiceDetail D WITH (NOLOCK) ON tblInvoice.InvoiceId = D.InvoiceId   
 WHERE DeliveryInvoiceStatus IN  ('Partial','Full') AND TpGrandTotal>0 AND  invoicedate < '5/1/2021'     AND UpdateDate BETWEEN '5/1/2021'    AND '5/31/2021'    GROUP BY  ComUnitId)tblcK ON tblcK.ComUnitId=U.ComUnitId  
 
 
 
 LEFT JOIN   (SELECT ComUnitId,COUNT(DISTINCT tblSubInvoiceMaster.InvoiceId)NumberofInvoiceSold, SUM(D.DeliveryNetAmount) SumofNetSalesAmount ,
 SUM(D.DeliveryTotalPriceVatAmount)DelTpVat FROM dbo.tblSubInvoiceMaster  WITH (NOLOCK) INNER JOIN dbo.tblSubInvoiceDetail D WITH (NOLOCK) ON tblSubInvoiceMaster.InvoiceId = D.InvoiceId  
  WHERE DeliveryInvoiceStatus IN  ('Partial','Full')  AND TpGrandTotal>0 AND invoicedate < '5/1/2021'     AND UpdateDate BETWEEN '5/1/2021'    AND '5/31/2021'     GROUP BY  ComUnitId)tblccK ON tblccK.ComUnitId=U.ComUnitId 




left join (select sum(isnull(Amount,0))Amount,CompanyId from tblCompanyWiseDeposit WITH(NOLOCK) where isdelete=0 and DepositDate between '5/1/2021'    and '5/31/2021'    group by CompanyId )tblCurrentDpst on U.ComUnitId= tblCurrentDpst.CompanyId




		 LEFT JOIN   ( select ComUnitId,sum(TpVat)TpVat,sum(TpTotal)TpTotal,sum(TpGrandTotal)TpGrandTotal from tblReturnInvoice
		                  where ReturnInvoiceDate  BETWEEN '5/1/2021'    AND '5/31/2021'    GROUP  BY  ComUnitId  )
		                  tblAdjust ON tblAdjust.ComUnitId = U.ComUnitId 

) as tblx


END
