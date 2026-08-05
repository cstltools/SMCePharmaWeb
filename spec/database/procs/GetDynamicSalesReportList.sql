CREATE PROCEDURE [dbo].[GetDynamicSalesReportList]
 
@fromdate datetime,
	@todate datetime,
	@Type nvarchar(max) ,
	@Area nvarchar(max) ,
	@Terr nvarchar(max) ,
	@ZonId  nvarchar(max) ,
	@grpId  nvarchar(max) 

AS
BEGIN



select  tr.TerritoryId TerritoryId,  grp.GroupName  Region, rgn.RegionName  [Zone],ara.AreaName     Area, tr.TerritoryName  Territory, tr.TerritoryCode  TerritoryCode,
       isnull(tblInv.InvoieAmountTP,0)  InvoieAmountTP,  isnull(tblInv.InvoiceVatTp,0) InvoiceVatTp,  isnull(tblInv.InvoiceGrossAmt,0)  Invoice, 
       
  isnull(PartialCollection,0) AS       [Partial Collection],

       isnull(tblFullCollection.FullCollection,0)  [Full Collection],
       ISNULL(tblFCBInv.InvoiceGrossAmt,0)   [FCB Invoice],
       isnull(tblFCBCollection.FCBCollectionGrossAmt,0)   [FCB Collection],
       '0'   [Campaigns Invoice],
         '0' [Campaigns Collection],
          ISNULL(tblGeneralInv.InvoiceGrossAmt,0)   [General Invoice],
         isnull(tblGeneralCollection.CollectionGrossAmt,0) [General Collection],
          ISNULL(tblINSTITUTIONInv.InvoiceGrossAmt,0) [Institution Invoice],
        ISNULL(tblINSTITUTIONCollection.CollectionGrossAmt,0) [Institution Collection],
         '' HQ_Invoice,
         '' HQ_Collection,
         '' [Ex. HQ_Invoice],
         '' [Ex. HQ_Collection],
         '' OS_Invoice,
         '' OS_Collection,
         '' [ReturnTP_VAT],
         '' [#Chemist-Coverage-Invoice],
         '' [#Chemist-Coverage-Collection],
         '' [#Chemist-Coverage-Invoice-BSP],
         '' [#Chemist-Coverage-Collection-BSP],
         '' [#Chemist-Coverage-Invoice-GSP],
         '' [#Chemist-Coverage-Collection-GSP],
         '' [#Chemist-Coverage-Invoice-PSP],
         '' [#Chemist-Coverage-Collection-PSP],
         '' [#Chemist-Coverage-Invoice-FCB],
         '' [#Chemist-Coverage-Collection-FCB],
         '' [#Total-InvoiceCov-Collection],
         '' [#InvoiceCov-Collection-BSP],
         '' [#InvoiceCov-Collection-GSP],
         '' [#InvoiceCov-Collection-PSP],
         '' [Blue Star Invoice],
         '' [Blue Star Collection],
         '' [Green Star Invoice],
         '' [Green Star Collection],
         '' [Pink Star Invoice],
         '' [Pink Star Collection],
         '' [Total Customer],
         '' [No of Blue Star Customer],
         '' [No of Green Star Customer],
         '' [No of Pink Star Customer],      

		  
		 
		 '' [No of FCB Customer],
         '' [Sales Campaign Invoice],
         '' [Sales Campaign Collection],
         '' [Bonus Campaign Invoice],
         '' [Bonus Campaign Collection],
         '' [Total SMC Bondhon Customer],
         '' [SMC Bondhon Customer Sales-Invoice],
         '' [SMC Bondhon Customer Sales-Collection],
         '' [Cov. SMC Bondhon Customer-Collection],
         isnull(tblTotalDoc.TotalDoctor,0) [Total Doctor],
         isnull(tblTotalDocBsp.TotalDoctorBSP,0) [No of BSP],
         isnull(tblTotalDocGsp.TotalDoctorGSP,0) [No of GSP],
         isnull(tblTotalDocPsp.TotalDoctorPSP,0) [No of PSP],
         isnull(tblTotalDocGmp.TotalDoctorGMP,0) [No of GMP],
         isnull(tblTotalDoc.TotalDoctor,0) [No of HQ Doctor],--Shuvo vai will work on it (Used TOtal Doctor by default)--
         isnull(tblTotalDoc.TotalDoctor,0) [No of Ex HQ Doctor],--Shuvo vai will work on it (Used TOtal Doctor by default)--
         isnull(tblTotalDoc.TotalDoctor,0) [No of OS Doctor],--Shuvo vai will work on it (Used TOtal Doctor by default)--
         isnull(tblTotalDcr.TotalDoctorDCR,0) [Sum of DCR-Total],
         isnull(tblTotalDcrBsp.TotalDoctorDCRBSP,0) [Sum of DCR-BSP],
         isnull(tblTotalDcrGsp.TotalDoctorDCRGSP,0) [Sum of DCR-GSP],
         isnull(tblTotalDcrPsp.TotalDoctorDCRPSP,0) [Sum of DCR-PSP],
         isnull(tblTotalDcrGmp.TotalDoctorDCRGMP,0) [Sum of GMP-DCR],
         isnull(tblTotalDcr.TotalDoctorDCR,0) [GMP-Doctor Coverage monthly], --Shuvo vai will work on it (Used tblTotalDcr by default)--
         isnull(tblTotalDcr.TotalDoctorDCR,0) [Doctor Coverage monthly],--Shuvo vai will work on it (Used tblTotalDcr by default)--
         isnull(tblTotalRxCovered.TotalDoctorRX,0) [Sum of Rx Covered],
         isnull(tblTotalRxBsp.TotalDoctorRXBSP,0) [Sum of Rx Covered-BSP],
         isnull(tblTotalRxGsp.TotalDoctorRXGSP,0) [Sum of Rx Covered-GSP],
         isnull(tblTotalRxPsp.TotalDoctorRXPSP,0) [Sum of Rx Covered-PSP],
         isnull(tblTotalRxGmp.TotalDoctorRXGMP,0) [Sum of Rx Covered-GMP],
         isnull(tblTotalRxCovered.TotalDoctorRX,0) [No of Dr Rx Prescriber],--Shuvo vai will work on it (Used tblTotalRxCovered by default)--
         isnull(tblTotalRxCovered.TotalDoctorRX,0) [GMP Dr-Rx Prescriber],--Shuvo vai will work on it (Used tblTotalRxCovered by default)--
         '10' [No of SFD],
         '10' [No of DCR-SFD],
         '10' [No of Rx-SFD],
         '10' [SFD Visit Coverage],
         '' [SFD Rx Coverage],
         '' [Productivity Invoice-Return],
		''    [Productivity Collection]
   
FROM  dbo.tblTerritory tr with(NoLock)   
INNER JOIN dbo.tblArea ara  WITH (NOLOCK) ON ara.AreaId=tr.AreaId
INNER JOIN dbo.tblRegion rgn  WITH (NOLOCK) ON ara.RegionId = rgn.RegionId
INNER JOIN dbo.tbl_Group grp  WITH (NOLOCK) ON grp.GroupId = rgn.GroupId
--Invoice
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt  , SUM(ID.PaymentNetAmount)PaymentNetAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate  GROUP BY mas.TerritoryId 

)tblInv ON tblInv.TerritoryId=tr.TerritoryId


--FCB Invoice 
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt  , SUM(ID.PaymentNetAmount)PaymentNetAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate and   cstType.CustomerCategoryId=2  GROUP BY mas.TerritoryId 

)tblFCBInv ON tblFCBInv.TerritoryId=tr.TerritoryId
 

--General Invoice select * from tblCustomerCategory
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt  , SUM(ID.PaymentNetAmount)PaymentNetAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate and   cstType.CustomerCategoryId=1  GROUP BY mas.TerritoryId 

)tblGeneralInv ON tblGeneralInv.TerritoryId=tr.TerritoryId

--INSTITUTION Invoice
LEFT JOIN (SELECT mas.TerritoryId,count(DISTINCT I.InvoiceId) NumberofInvoice,SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))
AS InvoieAmountTP,SUM(ID.TotalPriceVatAmount)InvoiceVatTp,SUM(ID.NetAmount)InvoiceGrossAmt  , SUM(ID.PaymentNetAmount)PaymentNetAmount FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas  WITH (NOLOCK) ON mas.OrderId = I.OrderId
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
WHERE I.TpGrandTotal>0 AND InvoiceDate BETWEEN @fromdate AND @todate and   cstType.CustomerCategoryId=3  GROUP BY mas.TerritoryId 

)tblINSTITUTIONInv ON tblINSTITUTIONInv.TerritoryId=tr.TerritoryId

 
 --,  case when cstType.CustomerCategoryId=1 then  SUM(ID.NetAmount) else 0 end  GeneralInvoiceGrossAmt, case when cstType.CustomerCategoryId=3 then  SUM(ID.NetAmount) else 0 end  INSTITUTIONInvoiceGrossAmt, SUM(ID.PaymentNetAmount)PaymentNetAmount

 
 
 --Collection
LEFT JOIN   (SELECT  mas.TerritoryId ,    SUM(
        CASE 
            WHEN I.SndReturnInvoiceNo IS NOT NULL
                THEN ISNULL(sndRTN.sndReturnNetAmount,0)
                ELSE ISNULL(TD.TotalDelivery,0)
        END
        - ISNULL(P.PP,0)
    ) AS PartialCollection  FROM   dbo.tblInvoice I WITH(nolock) 

INNER JOIN ( select InvoiceId, sum(DeliveryNetAmount)NetAmount, ((Sum(DeliveryTotalPrice)+Sum(DeliveryTotalPriceVatAmount))-Sum(DeliveryDiscountAmount))DeliveryNetAmount,Sum(NetAmount)UnitVatAmount,(Sum(DeliveryDiscountAmount))TotalPriceVatAmount 

from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId 
 
LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
 

LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId


LEFT JOIN (SELECT InvoiceId,SUM(isnull(TPAmount,0)+isnull(VATAmount,0)) AS PP FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON I.InvoiceId = P.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(PaymentNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON I.InvoiceId = TD.InvoiceId  
WHERE        ISNULL(ISNULL( case when  I.SndReturnInvoiceNo is not null  then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(TD.TotalDelivery,0) end,0) -  ISNULL(P.PP,0),0)>5 and ISNULL( case when I.SndReturnInvoiceNo is not null  then  isnull(sndRTN.sndReturnNetAmount,0) else ISNULL(TD.TotalDelivery,0) end,0) <>  ISNULL(P.PP,0)  AND CONVERT(date,I.InvoiceDate) BETWEEN @fromdate AND @todate     GROUP BY   mas.TerritoryId  )tblPartialCollection ON tblPartialCollection.TerritoryId=tr.TerritoryId


left join (select  mas.TerritoryId , sum(ID.PaymentNetAmount) FullCollection FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount and convert(date,tblCustPay.custPaymentDate) between  @fromdate AND @todate group by  mas.TerritoryId)tblFullCollection on tblFullCollection.TerritoryId=tr.TerritoryId




 --FCB Collection

 
left join (select  mas.TerritoryId , sum(ID.PaymentNetAmount) FCBCollectionGrossAmt FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where cstType.CustomerCategoryId=2 and tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount and convert(date,tblCustPay.custPaymentDate) between  @fromdate AND @todate group by  mas.TerritoryId)tblFCBCollection on tblFCBCollection.TerritoryId=tr.TerritoryId
  


 --General  Collection
left join (select  mas.TerritoryId , sum(ID.PaymentNetAmount)  CollectionGrossAmt FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where cstType.CustomerCategoryId=1 and tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount and convert(date,tblCustPay.custPaymentDate) between  @fromdate AND @todate group by  mas.TerritoryId)tblGeneralCollection ON tblGeneralCollection.TerritoryId=tr.TerritoryId

 --INSTITUTION   Collection
LEFT JOIN   (select  mas.TerritoryId , sum(ID.PaymentNetAmount)  CollectionGrossAmt FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 

LEFT JOIN tblOrder mas ON mas.OrderId = I.OrderId 
left join tblCustomerType cstType WITH (NOLOCK)  on  mas.CustTypeId=cstType.CustomerTypeId
 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where cstType.CustomerCategoryId=3 and tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount and convert(date,tblCustPay.custPaymentDate) between  @fromdate AND @todate group by  mas.TerritoryId )tblINSTITUTIONCollection ON tblINSTITUTIONCollection.TerritoryId=tr.TerritoryId


left join (SELECT  I.AreaCode,  sum(isnull( tbldetails.DeliveryNetAmount- tbldetails.Vat,0)) CollectionAmtTP_B,  sum(isnull(tbldetails.Vat,0)) CollectionVat_B 

FROM SalesDisDB_SMC..tblInvoice I  with(nolock)

INNER JOIN (select InvoiceId,sum(DeliveryNetAmount)DeliveryNetAmount,sum(DeliveryNetAmount)-sum(DeliveryTotalPrice) as Vat from SalesDisDB_SMC..tblInvoiceDetail D group by InvoiceId )tbldetails 
            on tbldetails.InvoiceId=I.InvoiceId
 
where  I.UpdateDate is not null and  I.UpdateDate  BETWEEN @fromdate AND @todate group by I.AreaCode) tblColBak  ON tblColBak.AreaCode=tr.TerritoryCode
-------------Total Doctor---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctor from tblDoctorMaster  C
  where   isnull(IsActive,0)=1  and   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDoc on tblTotalDoc.TerritoryId=tr.TerritoryId

 
-------------Total Doctor BSP---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorBSP from tblDoctorMaster  C 
where   isnull(C.IsActive,0)=1  and   c.ProgramTypeId= 2 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDocBsp on tblTotalDocBsp.TerritoryId=tr.TerritoryId 

-------------Total Doctor GSP---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorGSP from tblDoctorMaster  C
  where   isnull(C.IsActive,0)=1  and    c.ProgramTypeId= 1 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDocGsp on tblTotalDocGsp.TerritoryId=tr.TerritoryId 


-------------Total Doctor PSP---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorPSP from tblDoctorMaster  C 
where   isnull(C.IsActive,0)=1  and c.ProgramTypeId= 3 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDocPsp on tblTotalDocPsp.TerritoryId=tr.TerritoryId 


-------------Total Doctor GMP---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorGMP from tblDoctorMaster  C 
where  isnull(C.IsActive,0)=1  and c.ProgramTypeId= 4 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDocGmp on tblTotalDocGmp.TerritoryId=tr.TerritoryId 


-------------Total DCR---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorDCR from tbl_DCRInfo  C
where  isnull(C.ApprovalStatus,0)='2'  and CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDcr on tblTotalDcr.TerritoryId=tr.TerritoryId 

-------------Total DCRBsp---------
left join (select c.TerritoryId, count(C.DoctorID) TotalDoctorDCRBSP from tbl_DCRInfo  C
where  isnull(C.ApprovalStatus,0)='2'  and  c.DoctorProgramypeId= 2 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by c.TerritoryId
)tblTotalDcrBsp on tblTotalDcrBsp.TerritoryId=tr.TerritoryId 

-------------Total DCRGsp---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorDCRGSP from tbl_DCRInfo  C
  where isnull(C.ApprovalStatus,0)='2'  and   c.DoctorProgramypeId= 1 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDcrGsp on tblTotalDcrGsp.TerritoryId=tr.TerritoryId 

-------------Total DCRPsp---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorDCRPSP from tbl_DCRInfo  C
where   isnull(C.ApprovalStatus,0)='2'  and  c.DoctorProgramypeId= 3 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDcrPsp on tblTotalDcrPsp.TerritoryId=tr.TerritoryId 

-------------Total DCRGmp---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorDCRGMP from tbl_DCRInfo  C
   where  isnull(C.ApprovalStatus,0)='2'  and  c.DoctorProgramypeId= 4 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalDcrGmp on tblTotalDcrGmp.TerritoryId=tr.TerritoryId 

-------------Total RX Covered---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorRX from tbl_PrescriptionMaster  C
  where  isnull(C.ApprovalStatus,0)='2'  and  CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalRxCovered on tblTotalRxCovered.TerritoryId=tr.TerritoryId 

-------------Total DCRBsp---------
left join (select C.TerritoryId, count(C.DoctorID) TotalDoctorRXBSP from tbl_PrescriptionMaster  C
  where   isnull(C.ApprovalStatus,0)='2' and  c.DoctorProgramypeId= 2 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by C.TerritoryId
)tblTotalRxBsp on tblTotalRxBsp.TerritoryId=tr.TerritoryId 

-------------Total DCRGsp---------
left join (select bb.TerritoryId, count(C.DoctorID) TotalDoctorRXGSP from tbl_PrescriptionMaster  C
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId  where   c.DoctorProgramypeId= 1 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by bb.TerritoryId
)tblTotalRxGsp on tblTotalRxGsp.TerritoryId=tr.TerritoryId

-------------Total DCRPsp---------
left join (select bb.TerritoryId, count(C.DoctorID) TotalDoctorRXPSP from tbl_PrescriptionMaster  C
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId  where   c.DoctorProgramypeId= 3 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by bb.TerritoryId
)tblTotalRxPsp on tblTotalRxPsp.TerritoryId=tr.TerritoryId

-------------Total DCRGmp---------
left join (select bb.TerritoryId, count(C.DoctorID) TotalDoctorRXGMP from tbl_PrescriptionMaster  C
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId  where   c.DoctorProgramypeId= 4 AND   CONVERT(date, C.EntryDate) BETWEEN @fromdate AND @todate  group by bb.TerritoryId
)tblTotalRxGmp on tblTotalRxGmp.TerritoryId=tr.TerritoryId

  where (ara.AreaId= COALESCE( NULLIF(@Area , 0) ,ara.AreaId))   and (tr.TerritoryId= COALESCE( NULLIF(@Terr , 0) ,tr.TerritoryId))   and     (rgn.RegionId= COALESCE( NULLIF(@ZonId , 0) ,rgn.RegionId))    and     (grp.GroupId= COALESCE( NULLIF(@grpId , 0) ,grp.GroupId))      
ORDER BY tr.TerritoryCode
    
END;
