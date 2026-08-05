CREATE PROCEDURE [dbo].[sp_Get_AllDoctorVisitMonitoringApprovalList]
    @param NVARCHAR(50) = NULL,
    @frmDate date = NULL,
    @toDate date = NULL,
	@GroupId nvarchar(max)='',
	@ZonId nvarchar(max)='',
	@AreaId nvarchar(max)='',
	@TerrId nvarchar(max)=''
AS
BEGIN
SET NOCOUNT ON;
  SET @frmDate = ISNULL(@frmDate, CAST(GETDATE() AS DATE))
    SET @toDate = ISNULL(@toDate, CAST(GETDATE() AS DATE))
    SET NOCOUNT ON;
 --select distinct * from (
SELECT  distinct 
    PM.EmpInfoId,  
    usRT.RoleType, 
    usR.RoleName,  
    PM.EmpMasterCode AS ID,
    PM.EmpName AS EmpName,
    T.TerritoryName Territory, 
    T.TerritoryName TerritoryName, 
    T.TerritoryCode,   
    PM.EmpName AS EmployeeName,
    '' AS BaseHQ,
    ISNULL(tblDCP.DCPCount,0) AS DCP,
    ISNULL(tblDCR.DCRCount,0) AS DCR,    ISNULL(tblCVR.CVRCount,0) AS CVRCount,

  
   ISNULL(tblRX.RXCount,0) AS RX,
    ISNULL( tblCustCov.CustomerCoverCount,0) AS CustomerCoverage,   ISNULL( tblCustCoverage.CustCoverage,0) AS CustomerCoverageNew,
    ISNULL(tblGPSale.GPSales,0) AS GPSales,
   ISNULL(tblTotalSale.TSalesNetTP,0) AS TSalesNetTP,
    'Approved' AS ApprovalStatusWeb
FROM tblEmpGeneralInfo PM WITH (NOLOCK)
INNER JOIN tblUser us WITH (NOLOCK) ON PM.EmpInfoId = us.EmpInfoId
INNER JOIN tbl_UserRoleInfo usR WITH (NOLOCK) ON usR.UserRoleId = us.UserRoleId
INNER JOIN tblRoleType usRT WITH (NOLOCK) ON usR.RoleTypeId = usRT.RoleTypeId
INNER  JOIN  dbo.tblMIOInfo AS M on M.EmployeeId=PM.EmpInfoId and M.IsActive=1
        INNER JOIN dbo.tblTerritory AS T ON M.TerritoryId = T.TerritoryId  and T.IsActive=1

left join (select   doc.TerritoryId, count(doc.DoctorId)  DCPCount from  tbl_DoctorTourPlanMaster  mas   WITH (NOLOCK) 
 inner join tbl_DoctorTourPlanDetail doc  WITH (NOLOCK)    on mas.DocTPMaster=DOC.DocTPMaster where doc.SMCTypeId_DV=4 and mas.ApprovalStatus='2' and CONVERT(date,doc.TourPlanDate) between @frmDate and @toDate group by  doc.TerritoryId )tblDCP   ON   tblDCP.TerritoryId = T.TerritoryId   
     
     left join (select   mas.TerritoryId,   count(mas.DcrId)  CVRCount from    tbl_DCRInfo mas  WITH (NOLOCK) 
   where  mas.TypeDcr='CVR' and mas.ApprovalStatus='2' and       CONVERT(date,mas.EntryDate) between @frmDate and @toDate  group by  mas.TerritoryId )tblCVR   ON  tblCVR.TerritoryId = T.TerritoryId 
 
left join (select   mas.TerritoryId,   count(mas.DcrId)  DCRCount from    tbl_DCRInfo mas  WITH (NOLOCK) 
   where mas.ApprovalStatus='2' and mas.SmcTypeId_DCR=4 and     CONVERT(date,mas.EntryDate) between @frmDate and @toDate  group by  mas.TerritoryId )tblDCR   ON  tblDCR.TerritoryId = T.TerritoryId 

   
 
left join (select mas.TerritoryId,  count(mas.PrescriptionId)  RXCount from    tbl_PrescriptionMaster mas  WITH (NOLOCK) 
   where mas.ApprovalStatus='2'  and mas.SmcTypeId_RX=4 and CONVERT(date,mas.EntryDate) between @frmDate and @toDate group by  mas.TerritoryId )tblRX   ON  tblRX.TerritoryId = T.TerritoryId 

        
left join (select dtl.TerritoryId,   count( distinct dtl.DoctorName_DV)  CustomerCoverCount from   tbl_DoctorTourPlanDetail dtl  WITH (NOLOCK) 
        inner join tbl_DoctorTourPlanMaster mas on dtl.DocTPMaster=mas.DocTPMaster
   where mas.ApprovalStatus='2'  and dtl.Type_DV='C' and CONVERT(date,dtl.TourPlanDate) between @frmDate and @toDate group by  dtl.TerritoryId )tblCustCov   ON   tblCustCov.TerritoryId = T.TerritoryId 


        --select * from tbl_DoctorTourPlanDetail
        --        select * from tbl_DoctorTourPlanMaster


   
--left join (select ord.EntryBy, count(distinct  iv.customerMasterId ) CustomerCoverage  from tblInvoice iv   WITH (NOLOCK) 
--inner join tblOrder ord   WITH (NOLOCK)  on ord.OrderId=iv.OrderID
--where    CONVERT(date,iv.InvoiceDate) between @frmDate and @toDate 
--group by ord.EntryBy )tblCusCovrage on us.UserId=tblCusCovrage.EntryBy


LEFT JOIN 
(
   SELECT   sum(ID.PaymentTotalPrice-ID.PaymentDiscountAmount) GPSales, cc.TerritoryId
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas WITH (NOLOCK) ON I.OrderId = mas.OrderId
inner JOIN tblCustMaster C WITH (NOLOCK) ON C.CustomerMasterId = mas.CustomerMasterId
  LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
 LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1
LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId

 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail WITH (NOLOCK) group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail WITH (NOLOCK) group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where  masdtl.CampaignCategory = 'General Sales' and tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount  and     CONVERT(DATE, tblCustPay.custPaymentDate) BETWEEN @frmDate AND @toDate  group by  cc.TerritoryId
) tblGPSale   ON  tblGPSale.TerritoryId = T.TerritoryId 

	LEFT JOIN 
(
    SELECT   sum(ID.PaymentTotalPrice-ID.PaymentDiscountAmount) TSalesNetTP, cc.TerritoryId
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID WITH (NOLOCK) ON ID.InvoiceId = I.InvoiceId 
LEFT JOIN dbo.tblOrder mas WITH (NOLOCK)  ON I.OrderId = mas.OrderId
inner JOIN tblCustMaster C WITH (NOLOCK) ON C.CustomerMasterId = mas.CustomerMasterId
  LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
 LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1
LEFT JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId

 inner join (select InvoiceId,  sum(TPAmount) + sum(VATAmount) CustPayAmount, max(custPaymentDate) custPaymentDate from tblCustPayDetail WITH (NOLOCK) group by InvoiceId) tblCustPay on I.InvoiceId =tblCustPay.InvoiceId
 inner join (select InvoiceId, SUM(PaymentNetAmount) PaymentNetAmount from tblInvoiceDetail WITH (NOLOCK) group by InvoiceId) tblNetPay on I.InvoiceId =tblNetPay.InvoiceId


 where  tblNetPay.PaymentNetAmount<= tblCustPay.CustPayAmount  and     CONVERT(DATE, tblCustPay.custPaymentDate) BETWEEN @frmDate AND @toDate  group by cc.TerritoryId
) tblTotalSale 
    ON   tblTotalSale.TerritoryId = T.TerritoryId 


    left join (select cc.TerritoryId, count(Distinct mas.CustomerMasterId) CustCoverage from   tblCustPayDetail custDtl   with(nolock)
inner JOIN dbo.tblInvoice I   with (nolock)    ON I.InvoiceId = custDtl.InvoiceId
LEFT JOIN dbo.tblOrder mas  with (nolock)   ON I.OrderId = mas.OrderId  
inner JOIN tblCustMaster C WITH (NOLOCK) ON C.CustomerMasterId = mas.CustomerMasterId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1

WHERE 
        CONVERT(DATE, custDtl.custPaymentDate) BETWEEN @frmDate AND @toDate group by cc.TerritoryId
)tblCustCoverage on tblCustCoverage.TerritoryId = T.TerritoryId 

	inner join tblArea ar  with (nolock)  on  ar.AreaId=T.AreaId and ar.IsActive=1
	inner join tblRegion rg  with (nolock)  on  rg.RegionId=ar.RegionId and rg.IsActive=1




WHERE usRT.RoleType IN ('MIO')  and us.UserStatus='Active'  and  ISNULL(ISNULL(tblDCP.DCPCount,0) +
    ISNULL(tblDCR.DCRCount,0)  +
  
   ISNULL(tblRX.RXCount,0)   ,0) +  ISNULL(tblGPSale.GPSales,0) +
   ISNULL(tblTotalSale.TSalesNetTP,0)>0  -- SubTerritory (সবচেয়ে নির্দিষ্ট)
 -- optional Group filter 
 and
    (@GroupId IS NULL OR @GroupId = '' OR rg.GroupId = @GroupId)

    AND
    (
        -- 1) Territory given → only territory filters
        (NULLIF(@TerrId,'') IS NOT NULL AND T.TerritoryId = @TerrId)

        -- 2) Territory blank, Area given → only area filter
        OR (NULLIF(@TerrId,'') IS NULL
            AND NULLIF(@AreaId,'') IS NOT NULL
            AND ar.AreaId = @AreaId)

        -- 3) Territory & Area blank, Zone given → only zone filter
        OR (NULLIF(@TerrId,'') IS NULL
            AND NULLIF(@AreaId,'') IS NULL
            AND NULLIF(@ZonId,'') IS NOT NULL
            AND rg.RegionId = @ZonId)

        -- 4) সবই blank → no location filter
        OR (NULLIF(@TerrId,'') IS NULL
            AND NULLIF(@AreaId,'') IS NULL
            AND NULLIF(@ZonId,'') IS NULL)
    )
     order by TerritoryCode
 
END
 

  