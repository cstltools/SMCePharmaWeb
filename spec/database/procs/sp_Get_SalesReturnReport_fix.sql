create PROCEDURE [dbo].[sp_Get_SalesReturnReport_fix]
    @Parm  NVARCHAR(MAX),
    @Parm2 NVARCHAR(MAX)
AS
BEGIN

    DECLARE @Q NVARCHAR(MAX) = N''

    -- =====================================================================
    -- FIRST QUERY
    -- =====================================================================
    SET @Q = @Q + N'SELECT
         DZSM.EmpMasterCode                                        DZSMEmpName,
         AM.EmpMasterCode                                          AMEmpCode,
         AM.EmpName                                                AMEmpName,
         MIO.EmpMasterCode                                         MIOEmpCode,
         MIO.EmpName                                               MIOEmpName,
         mas.GroupCode_Ord                                         GroupName,
         mas.RegionCode_Ord                                        RegionName,
         mas.AreaCode_Ord                                          AreaName,
         mas.TerritoryCode,
         mas.TerritoryName_Ord                                     TerritoryName,
         mas.SubTerritoryCode_Ord + '' : '' + mas.SubTerritoryName_Ord SubTerritoryName,
         mas.MarketCode_Ord                                        MarketCode,
         mas.MarketName_Ord                                        MarketName,
         mas.SAPTerritoryCode_Ord,
         MIO.SAPEmpCode                                            MIOSAPCode_Ord,
         AM.SAPEmpCode                                             AMSAPCode_Ord,
         DZSM.SAPEmpCode                                           DZSMSAPCode_Ord,
         format(ID.ExpDate,         ''dd-MMM-yyyy'')               ExpDate,
         ID.DeliveryQuantity                                       soldQty,
         tblRegion.SAP_Code                                        ZoneSAP_Code,
         tblArea.SAP_Code                                          AreaSAP_Code,
         CASE
             WHEN ID.ISGiftProduct = 1 AND ProductGroupId = 3        THEN ''C''
             WHEN ID.ISGiftProduct = 1 AND ProductGroupId IN (1,2)   THEN ''B''
         END                                                        FOCType,
         tblStockUOM.UOMSAPCode                                    UoM,
         COALESCE(NULLIF(ordSend.SAPEmpCode, ''''), mas.OrderSenderCode) OrderSenderSAPCode,
         CU.SAP_Code                                               SAPPlant,
         P.SAP_Code                                                SAPProductCode,
         sum(ISNULL(ID.DeliveryDiscountAmount    - ID.PaymentDiscountAmount,    0)) ReturnAmountDiscount,
         sum(ISNULL(ID.DeliveryTotalQuantity     - ID.PaymentTotalQuantity,     0)) ReturnQty,
         sum(ISNULL(ID.DeliveryTotalPrice        - ID.PaymentTotalPrice,        0)) ReturnAmountTP,
         sum(ISNULL(ID.DeliveryTotalPriceVatAmount - ID.PaymentTotalPriceVatAmount, 0)) ReturnAmountVat,
         (sum(ISNULL(ID.DeliveryTotalPrice - ID.PaymentTotalPrice, 0))
          + sum(ISNULL(ID.DeliveryTotalPriceVatAmount - ID.PaymentTotalPriceVatAmount, 0)))
          - sum(ISNULL(ID.DeliveryDiscountAmount - ID.PaymentDiscountAmount, 0))  ReturnGrossAmt,
         mas.SMCType_Ord,
         I.ComUnitId,
         CU.ComUnitCode,
         CU.ComUnitName,
         C.CustomerCode,
         C.CustomerName,
         pt.ProgramTypeName                                        ProgramType,
         ct.CustomerType                                           CustomerType,
         I.OrderNo,
         format(I.OrderDate,    ''dd-MMM-yyyy'')                   OrderDate,
         I.InvoiceNo,
         format(I.InvoiceDate,  ''dd-MMM-yyyy'')                   InvoiceDate,
         I.DelivaryInvoiceNo,
         Convert(varchar, I.UpdateDate, 103)                       UpdateDate,
         ID.ProductCode,
         ID.ProductName,
         ID.PackSize,
         tblDCStore.BatchNo,
         format(DS.ExpDate,     ''dd-MMM-yyyy'')                   ExpDate,
         mas.MarketCode_Ord                                        MarketCode,
         mas.MarketName_Ord                                        MarketName,
         mas.TerritoryCode                                         AreaCode,
         MIO.EmpMasterCode                                         MiaCode,
         AM.EmpMasterCode                                          DistrictCode,
         DZSM.EmpMasterCode                                        RegionCode,
         ReturnReason,
         format(I.PaymentDate,  ''dd-MMM-yyyy'')                   ReturnDate,
         mas.AreaCode_Ord                                          AreaCodeNew,
         mas.RegionCode_Ord                                        RegionCodeNew'

    SET @Q = @Q + N'
FROM dbo.tblInvoice I WITH (NOLOCK)
INNER JOIN dbo.tblOrder mas                  ON mas.OrderId            = I.OrderId
LEFT  JOIN tblArea                           ON mas.AreaId             = tblArea.AreaId
LEFT  JOIN tblRegion                         ON mas.RegionId           = tblRegion.RegionId
LEFT  JOIN dbo.tblProgramType  pt WITH (NOLOCK) ON mas.ProgramTypeId  = pt.ProgramTypeId
LEFT  JOIN dbo.tblCustomerType ct WITH (NOLOCK) ON mas.CustTypeId     = ct.CustomerTypeId
LEFT  JOIN dbo.tblEmpGeneralInfo MIO WITH (NOLOCK) ON mas.MIOId       = MIO.EmpInfoId
LEFT  JOIN dbo.tblEmpGeneralInfo AM  WITH (NOLOCK) ON mas.ASMId       = AM.EmpInfoId
LEFT  JOIN dbo.tblEmpGeneralInfo DZSM WITH (NOLOCK) ON mas.RSMId      = DZSM.EmpInfoId
INNER JOIN dbo.tblInvoiceDetail  ID          ON ID.InvoiceId           = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit    CU          ON CU.ComUnitId           = I.ComUnitId
INNER JOIN dbo.tblCustMaster     C           ON C.CustomerMasterId     = I.CustomerMasterId
INNER JOIN dbo.tblDCStore        DS          ON DS.DCStoreId           = ID.DCStoreId
LEFT  JOIN tblEmpGeneralInfo ordSend         ON ordSend.EmpMasterCode  = mas.OrderSenderCode
LEFT  JOIN dbo.tblProduct    P               ON ID.ProductCode         = P.ProductCode
LEFT  JOIN tblStockUOM WITH (NOLOCK)         ON tblStockUOM.StockUOMId = P.StockUOMId
LEFT  JOIN dbo.tblProductSQ  SQ              ON P.ProductBrandId       = SQ.ProductBrandId
LEFT  JOIN dbo.tblUnitPrice  UP              ON UP.ProductCode         = P.ProductCode
LEFT  JOIN tblDCStore                        ON tblDCStore.DCStoreId   = ID.DCStoreId
WHERE I.PaymentInvoiceNo IS NOT NULL
  AND ISNULL(PaymentTotalQuantity, 0) <> ISNULL(DeliveryTotalQuantity, 0)'

    SET @Q = @Q + N' ' + @Parm

    SET @Q = @Q + N'
GROUP BY
     DZSM.EmpMasterCode,
     AM.EmpMasterCode, AM.EmpName,
     MIO.EmpMasterCode, MIO.EmpName,
     mas.GroupCode_Ord, mas.RegionCode_Ord, mas.AreaCode_Ord,
     mas.TerritoryCode, mas.TerritoryName_Ord,
     mas.SubTerritoryCode_Ord + '' : '' + mas.SubTerritoryName_Ord,
     mas.MarketCode_Ord, mas.MarketName_Ord,
     mas.SAPTerritoryCode_Ord,
     MIO.SAPEmpCode, AM.SAPEmpCode, DZSM.SAPEmpCode,
     format(ID.ExpDate, ''dd-MMM-yyyy''),
     ID.DeliveryQuantity,
     tblRegion.SAP_Code,
     tblArea.SAP_Code,
     CASE
         WHEN ID.ISGiftProduct = 1 AND ProductGroupId = 3      THEN ''C''
         WHEN ID.ISGiftProduct = 1 AND ProductGroupId IN (1,2) THEN ''B''
     END,
     tblStockUOM.UOMSAPCode,
     COALESCE(NULLIF(ordSend.SAPEmpCode, ''''), mas.OrderSenderCode),
     CU.SAP_Code, P.SAP_Code,
     mas.SMCType_Ord,
     I.ComUnitId, CU.ComUnitCode, CU.ComUnitName,
     C.CustomerCode, C.CustomerName,
     pt.ProgramTypeName, ct.CustomerType,
     I.OrderNo, format(I.OrderDate, ''dd-MMM-yyyy''),
     I.InvoiceNo, format(I.InvoiceDate, ''dd-MMM-yyyy''),
     I.DelivaryInvoiceNo, Convert(varchar, I.UpdateDate, 103),
     ID.ProductCode, ID.ProductName, ID.PackSize,
     tblDCStore.BatchNo, format(DS.ExpDate, ''dd-MMM-yyyy''),
     format(ID.ExpDate, ''dd-MMM-yyyy''),
     mas.MarketCode_Ord, mas.MarketName_Ord,
     mas.TerritoryCode,
     MIO.EmpMasterCode, AM.EmpMasterCode, DZSM.EmpMasterCode,
     ReturnReason,
     Convert(varchar, I.UpdateDate, 103),
     format(I.PaymentDate, ''dd-MMM-yyyy''),
     mas.AreaCode_Ord, mas.RegionCode_Ord'

    -- =====================================================================
    -- SECOND QUERY (UNION ALL)
    -- =====================================================================
    SET @Q = @Q + N'

UNION ALL

SELECT
     DZSM.EmpMasterCode,
     AM.EmpMasterCode,
     AM.EmpName,
     MIO.EmpMasterCode,
     MIO.EmpName,
     O.GroupCode_Ord,
     O.RegionCode_Ord,
     O.AreaCode_Ord,
     O.TerritoryCode,
     O.TerritoryName_Ord,
     O.SubTerritoryCode_Ord + '' : '' + O.SubTerritoryName_Ord,
     O.MarketCode_Ord,
     O.MarketName_Ord,
     O.SAPTerritoryCode_Ord,
     MIO.SAPEmpCode,
     AM.SAPEmpCode,
     DZSM.SAPEmpCode,
     format(ivD.ExpDate, ''dd-MMM-yyyy''),
     ivD.DeliveryQuantity,
     tblRegion.SAP_Code,
     tblArea.SAP_Code,
     CASE
         WHEN ivD.ISGiftProduct = 1 AND p.ProductGroupId = 3      THEN ''C''
         WHEN ivD.ISGiftProduct = 1 AND p.ProductGroupId IN (1,2) THEN ''B''
     END,
     tblStockUOM.UOMSAPCode,
     COALESCE(NULLIF(tblEmpGeneralInfo.SAPEmpCode, ''''), O.OrderSenderCode),
     U.SAP_Code,
     P.SAP_Code,
     sum(ISNULL(ivD.PaymentDiscountAmount       - tblInvoiceDetailReturn.sndReturnDiscountAmount,      0)),
     sum(CAST(tblInvoiceDetailReturn.PreviousQuantity   AS decimal(18,1)))
       - sum(CAST(tblInvoiceDetailReturn.sndReturnQuantity AS decimal(18,1))),
     sum(ISNULL(ivD.PaymentTotalPrice           - tblInvoiceDetailReturn.sndReturnTotalPrice,          0)),
     sum(ISNULL(ivD.PaymentTotalPriceVatAmount  - tblInvoiceDetailReturn.sndReturnTotalPriceVatAmount, 0)),
     (sum(ISNULL(ivD.PaymentTotalPrice          - tblInvoiceDetailReturn.sndReturnTotalPrice,          0))
       - sum(ISNULL(ivD.PaymentDiscountAmount   - tblInvoiceDetailReturn.sndReturnDiscountAmount,      0)))
       + sum(ISNULL(ivD.PaymentTotalPriceVatAmount - tblInvoiceDetailReturn.sndReturnTotalPriceVatAmount, 0)),
     O.SMCType_Ord,
     U.ComUnitId,
     U.ComUnitCode,
     U.ComUnitName,
     C.CustomerCode,
     C.CustomerName,
     pt.ProgramTypeName,
     ct.CustomerType,
     iv.OrderNo,
     format(iv.OrderDate,   ''dd-MMM-yyyy''),
     iv.InvoiceNo,
     format(iv.InvoiceDate, ''dd-MMM-yyyy''),
     iv.DelivaryInvoiceNo,
     Convert(varchar, iv.UpdateDate, 103),
     ivD.ProductCode,
     ivD.ProductName,
     ivD.PackSize,
     tblDCStore.BatchNo,
     format(tblDCStore.ExpDate, ''dd-MMM-yyyy''),
     O.MarketCode_Ord,
     O.MarketName_Ord,
     O.TerritoryCode,
     MIO.EmpMasterCode,
     AM.EmpMasterCode,
     DZSM.EmpMasterCode,
     ''-'' AS ReturnReason,
     format(iv.PaymentDate, ''dd-MMM-yyyy''),
     O.AreaCode_Ord,
     O.RegionCode_Ord'

    SET @Q = @Q + N'
FROM tblInvoice iv WITH (NOLOCK)
INNER JOIN tblInvoiceDetail       ivD              WITH (NOLOCK) ON iv.InvoiceId              = ivD.InvoiceId
INNER JOIN tblInvoiceDetailReturn                               ON tblInvoiceDetailReturn.InvoiceDetailId = ivD.InvoiceDetailId
LEFT  JOIN tblProduct             P                WITH (NOLOCK) ON P.ProductCode              = ivD.ProductCode
LEFT  JOIN tblStockUOM                             WITH (NOLOCK) ON tblStockUOM.StockUOMId     = P.StockUOMId
LEFT  JOIN tblOrder               O                WITH (NOLOCK) ON O.OrderId                  = iv.OrderId
LEFT  JOIN tblEmpGeneralInfo                       WITH (NOLOCK) ON tblEmpGeneralInfo.EmpMasterCode = O.OrderSenderCode
LEFT  JOIN tblCompanyUnit         U                WITH (NOLOCK) ON O.ComUnitId                = U.ComUnitId
LEFT  JOIN tblUnitPrice                            WITH (NOLOCK) ON tblUnitPrice.ProductCode   = P.ProductCode
LEFT  JOIN tblArea                                 WITH (NOLOCK) ON O.AreaId                   = tblArea.AreaId
LEFT  JOIN tblRegion                               WITH (NOLOCK) ON O.RegionId                 = tblRegion.RegionId
LEFT  JOIN tblDCStore                              WITH (NOLOCK) ON tblDCStore.DCStoreId       = ivD.DCStoreId
LEFT  JOIN dbo.tblCustMaster      C                WITH (NOLOCK) ON C.CustomerMasterId         = iv.CustomerMasterId
LEFT  JOIN dbo.tblProgramType     pt               WITH (NOLOCK) ON O.ProgramTypeId            = pt.ProgramTypeId
LEFT  JOIN dbo.tblCustomerType    ct               WITH (NOLOCK) ON O.CustTypeId               = ct.CustomerTypeId
LEFT  JOIN dbo.tblEmpGeneralInfo  MIO              WITH (NOLOCK) ON O.MIOId                    = MIO.EmpInfoId
LEFT  JOIN dbo.tblEmpGeneralInfo  AM               WITH (NOLOCK) ON O.ASMId                    = AM.EmpInfoId
LEFT  JOIN dbo.tblEmpGeneralInfo  DZSM             WITH (NOLOCK) ON O.RSMId                    = DZSM.EmpInfoId
WHERE tblInvoiceDetailReturn.PreviousQuantity <> tblInvoiceDetailReturn.sndReturnQuantity'

    SET @Q = @Q + N' ' + @Parm2

    SET @Q = @Q + N'
GROUP BY
     DZSM.EmpMasterCode, AM.EmpMasterCode, AM.EmpName,
     MIO.EmpMasterCode, MIO.EmpName,
     O.GroupCode_Ord, O.RegionCode_Ord, O.AreaCode_Ord,
     O.TerritoryCode, O.TerritoryName_Ord,
     O.SubTerritoryCode_Ord + '' : '' + O.SubTerritoryName_Ord,
     O.MarketCode_Ord, O.MarketName_Ord,
     O.SAPTerritoryCode_Ord,
     MIO.SAPEmpCode, AM.SAPEmpCode, DZSM.SAPEmpCode,
     format(ivD.ExpDate, ''dd-MMM-yyyy''),
     ivD.DeliveryQuantity,
     tblRegion.SAP_Code, tblArea.SAP_Code,
     CASE
         WHEN ivD.ISGiftProduct = 1 AND p.ProductGroupId = 3      THEN ''C''
         WHEN ivD.ISGiftProduct = 1 AND p.ProductGroupId IN (1,2) THEN ''B''
     END,
     tblStockUOM.UOMSAPCode,
     COALESCE(NULLIF(tblEmpGeneralInfo.SAPEmpCode, ''''), O.OrderSenderCode),
     U.SAP_Code, P.SAP_Code,
     O.SMCType_Ord,
     U.ComUnitId, U.ComUnitCode, U.ComUnitName,
     C.CustomerCode, C.CustomerName,
     pt.ProgramTypeName, ct.CustomerType,
     iv.OrderNo, format(iv.OrderDate, ''dd-MMM-yyyy''),
     iv.InvoiceNo, format(iv.InvoiceDate, ''dd-MMM-yyyy''),
     iv.DelivaryInvoiceNo, Convert(varchar, iv.UpdateDate, 103),
     ivD.ProductCode, ivD.ProductName, ivD.PackSize,
     tblDCStore.BatchNo, format(tblDCStore.ExpDate, ''dd-MMM-yyyy''),
     O.MarketCode_Ord, O.MarketName_Ord,
     O.TerritoryCode,
     MIO.EmpMasterCode, AM.EmpMasterCode, DZSM.EmpMasterCode,
     format(iv.PaymentDate, ''dd-MMM-yyyy''),
     O.AreaCode_Ord, O.RegionCode_Ord'

    EXEC sp_executesql @Q

END