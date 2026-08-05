CREATE PROCEDURE [dbo].[sp_SInventory_DynamicMISReportUserWise]
    @GroupName        NVARCHAR(100) = NULL,
    @ZoneName         NVARCHAR(100) = NULL,
    @AreaName         NVARCHAR(100) = NULL,
    @TerritoryName    NVARCHAR(100) = NULL,
    @FilterType       NVARCHAR(50)  = NULL,
    @CalculationType  NVARCHAR(50)  = NULL,
    @fromDate             date           = NULL,
    @toDate           date           = NULL,
    @CampaignCodes    NVARCHAR(MAX) = NULL,
    @PharmaPlatforms  NVARCHAR(MAX) = NULL,
    @CustomerTypes    NVARCHAR(MAX) = NULL,
    @ProviderTypes    NVARCHAR(MAX) = NULL,
    @reportLevel      NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
        DECLARE @CampaignFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);
    DECLARE @PharmaFilter   TABLE (Value NVARCHAR(500) PRIMARY KEY);
    DECLARE @CustomerFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);
    DECLARE @ProviderFilter TABLE (Value NVARCHAR(500) PRIMARY KEY);
    -------------------------------------------------------------------------
    -- Date range (sargable filters)
    -------------------------------------------------------------------------
    
       DECLARE 
        @FromMonth INT,
        @FromYear  INT 
        

    SET @FromMonth = MONTH(@fromDate);
    SET @FromYear  = YEAR(@fromDate);
    -------------------------------------------------------------------------
    -- Filter helpers
    -------------------------------------------------------------------------


    DECLARE @SplitXml XML;
    DECLARE @Safe NVARCHAR(MAX);

    -- Campaign codes
    IF (NULLIF(LTRIM(RTRIM(@CampaignCodes)), '') IS NOT NULL)
    BEGIN
        SET @Safe = (SELECT @CampaignCodes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);

        INSERT INTO @CampaignFilter(Value)
        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))
        FROM @SplitXml.nodes('/i') AS X(C)
        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';
    END

    -- Pharma
    IF (NULLIF(LTRIM(RTRIM(@PharmaPlatforms)), '') IS NOT NULL)
    BEGIN
        SET @Safe = (SELECT @PharmaPlatforms FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);

        INSERT INTO @PharmaFilter(Value)
        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))
        FROM @SplitXml.nodes('/i') AS X(C)
        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';
    END

    -- Customer
    IF (NULLIF(LTRIM(RTRIM(@CustomerTypes)), '') IS NOT NULL)
    BEGIN
        SET @Safe = (SELECT @CustomerTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);

        INSERT INTO @CustomerFilter(Value)
        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))
        FROM @SplitXml.nodes('/i') AS X(C)
        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';
    END

    -- Provider
    IF (NULLIF(LTRIM(RTRIM(@ProviderTypes)), '') IS NOT NULL)
    BEGIN
        SET @Safe = (SELECT @ProviderTypes FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)');
        SET @SplitXml = CAST('<i>' + REPLACE(@Safe, ',', '</i><i>') + '</i>' AS XML);

        INSERT INTO @ProviderFilter(Value)
        SELECT LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)')))
        FROM @SplitXml.nodes('/i') AS X(C)
        WHERE LTRIM(RTRIM(X.C.value('.', 'NVARCHAR(200)'))) <> '';
    END

    -------------------------------------------------------------------------
    -- Base table (territory wise KPI)
    -------------------------------------------------------------------------
    DECLARE @Base TABLE
    (
        TrrId_ int PRIMARY KEY,          -- এক Territory এক Row ধরে
        RowKey NVARCHAR(500),
        GroupName NVARCHAR(150),
        ZoneName NVARCHAR(150),
        AreaName NVARCHAR(150),
        Territory NVARCHAR(150),
        FilterType NVARCHAR(50),
        CalculationType NVARCHAR(50),
        FiscalYear INT,
        FiscalMonth INT,
        PharmaPlatform NVARCHAR(100),
        ProviderType NVARCHAR(100),
        Target DECIMAL(18,2),
        InvoiceAchievement DECIMAL(18,2),
        AchievementCollection DECIMAL(18,2),

        CampaignInvoiceValue DECIMAL(18,2),
        CampaignCollection DECIMAL(18,2),

        CampaignDoctorCoverage INT,
        ProviderTypeWiseChemistCoverage INT,
        ProviderTypeWiseInvoiceAmount DECIMAL(18,2),
        ProviderTypeWiseCollection DECIMAL(18,2),
        ProviderTypeWiseTotalChemistCoverage INT,
        ProviderTypeWiseTotalInvoiceAmount DECIMAL(18,2),
        ProviderTypeWiseTotalCollection DECIMAL(18,2),
        PharmaPlatformWiseCollection DECIMAL(18,2),


        PharmaPlatformWiseTotalChemistCoverage INT,
        PharmaPlatformWiseTotalInvoiceAmount DECIMAL(18,2),
        PharmaPlatformWiseTotalCollection DECIMAL(18,2),
        TotalGmpCount INT,
        TotalNonGmpCount INT,
        TotalCount INT,
        DCRGmpDoctorCoverage INT,
        DCRNonGmpDoctorCoverage INT,
        DCRTotalDoctorCoverage INT,
        SumOfGmpDcr INT,
        SumOfNonGmpDcr INT,
        TotalDcr INT,
        RxGmpDoctorCoverage INT,
        RxNonGmpDoctorCoverage INT,
        RxTotalDoctorCoverage INT,
        SumOfGmpRx INT,
        SumOfNonGmpRx INT,
        TotalRx INT,
        invoiceCount  INT,
        invoiceValue DECIMAL(18,2),
        invoiceCollection DECIMAL(18,2) ,
        totalDoctor INT,
        totalCustomer INT
    );

      DECLARE @SelectedCampaign TABLE
    (
        SlotNo       INT PRIMARY KEY,
        CampaignCode NVARCHAR(200)
    );

        DECLARE @SelectedCustomer TABLE
    (
        SlotNo       INT PRIMARY KEY,
        CustomerType NVARCHAR(100)
    );

    DECLARE @SelectedPharma TABLE
    (
        SlotNo        INT PRIMARY KEY,
        PharmaPlatform NVARCHAR(100)
    );

     DECLARE @Pharma TABLE
    (
        RowKey NVARCHAR(500),
        SlotNo INT,
        PharmaPlatform NVARCHAR(100),
        InvoiceCount INT,
        InvoiceValue DECIMAL(18,2),
        InvoiceCollection DECIMAL(18,2),
        PRIMARY KEY (RowKey, SlotNo)
    );

      DECLARE @Provider TABLE
    (
        RowKey NVARCHAR(500),
        SlotNo INT,
        ProviderType NVARCHAR(100),
        InvoiceCount INT,
        InvoiceValue DECIMAL(18,2),
        InvoiceCollection DECIMAL(18,2),
        PRIMARY KEY (RowKey, SlotNo)
    );



      DECLARE @SelectedProvider TABLE
    (
        SlotNo       INT PRIMARY KEY,
        ProviderType NVARCHAR(100)
    );

    DECLARE @Campaign TABLE
    (
        RowKey NVARCHAR(500),
        SlotNo INT,
        CampaignCode NVARCHAR(200),
        CampaignInvoiceValue DECIMAL(18,2),
        CampaignCollection   DECIMAL(18,2),
        PRIMARY KEY (RowKey, SlotNo)
    );

      DECLARE @CampaignAgg TABLE
    (
        RowKey NVARCHAR(500),

        Campaign1_Name NVARCHAR(200),
        Campaign1_Invoice DECIMAL(18,2),
        Campaign1_Collection DECIMAL(18,2),

        Campaign2_Name NVARCHAR(200),
        Campaign2_Invoice DECIMAL(18,2),
        Campaign2_Collection DECIMAL(18,2),

        Campaign3_Name NVARCHAR(200),
        Campaign3_Invoice DECIMAL(18,2),
        Campaign3_Collection DECIMAL(18,2),

        Campaign4_Name NVARCHAR(200),
        Campaign4_Invoice DECIMAL(18,2),
        Campaign4_Collection DECIMAL(18,2)
    );


      DECLARE @Customer TABLE
    (
        RowKey NVARCHAR(500),
        SlotNo INT,
        CustomerType NVARCHAR(100),
        InvoiceCount INT,
        InvoiceValue DECIMAL(18,2),
        InvoiceCollection DECIMAL(18,2),
        PRIMARY KEY (RowKey, SlotNo)
    );


     DECLARE @CustomerAgg TABLE
    (
        RowKey NVARCHAR(500),

        Customer1_Name NVARCHAR(100),
        Customer1_InvoiceCount INT,
        Customer1_InvoiceValue DECIMAL(18,2),
        Customer1_InvoiceCollection DECIMAL(18,2),

        Customer2_Name NVARCHAR(100),
        Customer2_InvoiceCount INT,
        Customer2_InvoiceValue DECIMAL(18,2),
        Customer2_InvoiceCollection DECIMAL(18,2),

        Customer3_Name NVARCHAR(100),
        Customer3_InvoiceCount INT,
        Customer3_InvoiceValue DECIMAL(18,2),
        Customer3_InvoiceCollection DECIMAL(18,2),

        Customer4_Name NVARCHAR(100),
        Customer4_InvoiceCount INT,
        Customer4_InvoiceValue DECIMAL(18,2),
        Customer4_InvoiceCollection DECIMAL(18,2) , 

        Customer5_Name NVARCHAR(100),
        Customer5_InvoiceCount INT,
        Customer5_InvoiceValue DECIMAL(18,2),
        Customer5_InvoiceCollection DECIMAL(18,2), 

        Customer6_Name NVARCHAR(100),
        Customer6_InvoiceCount INT,
        Customer6_InvoiceValue DECIMAL(18,2),
        Customer6_InvoiceCollection DECIMAL(18,2)
    );

    ---------------territory
        DECLARE @PharmaAgg TABLE
    (
        RowKey NVARCHAR(500),

        PharmaPlatform1_Name NVARCHAR(100),
        PharmaPlatform1_InvoiceAmount DECIMAL(18,2),
        PharmaPlatform1_ChemistCoverage INT,
        PharmaPlatform1_InvoiceCollection DECIMAL(18,2),

        PharmaPlatform2_Name NVARCHAR(100),
        PharmaPlatform2_InvoiceAmount DECIMAL(18,2),
        PharmaPlatform2_ChemistCoverage INT,
        PharmaPlatform2_InvoiceCollection DECIMAL(18,2),

        PharmaPlatform3_Name NVARCHAR(100),
        PharmaPlatform3_InvoiceAmount DECIMAL(18,2),
        PharmaPlatform3_ChemistCoverage INT,
        PharmaPlatform3_InvoiceCollection DECIMAL(18,2),

        PharmaPlatform4_Name NVARCHAR(100),
        PharmaPlatform4_InvoiceAmount DECIMAL(18,2),
        PharmaPlatform4_ChemistCoverage INT,
        PharmaPlatform4_InvoiceCollection DECIMAL(18,2)
    );

       DECLARE @ProviderAgg TABLE
    (
        RowKey NVARCHAR(500),

        ProviderType1_Name NVARCHAR(100),
        ProviderType1_InvoiceAmount DECIMAL(18,2),
        ProviderType1_ChemistCoverage INT,
        ProviderType1_InvoiceCollection DECIMAL(18,2),

        ProviderType2_Name NVARCHAR(100),
        ProviderType2_InvoiceAmount DECIMAL(18,2),
        ProviderType2_ChemistCoverage INT,
        ProviderType2_InvoiceCollection DECIMAL(18,2),

        ProviderType3_Name NVARCHAR(100),
        ProviderType3_InvoiceAmount DECIMAL(18,2),
        ProviderType3_ChemistCoverage INT,
        ProviderType3_InvoiceCollection DECIMAL(18,2),

        ProviderType4_Name NVARCHAR(100),
        ProviderType4_InvoiceAmount DECIMAL(18,2),
        ProviderType4_ChemistCoverage INT,
        ProviderType4_InvoiceCollection DECIMAL(18,2)
    );
       

         
       
          if(@reportLevel='territory')
    begin
    INSERT INTO @Base
    (
        TrrId_,
        RowKey, GroupName, ZoneName, AreaName, Territory,
        FilterType, CalculationType, FiscalYear, FiscalMonth,
        PharmaPlatform, ProviderType,
        Target, InvoiceAchievement, AchievementCollection,
        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,
        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,
        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,
        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,
        TotalGmpCount, TotalNonGmpCount, TotalCount,
        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,
        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,
        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,
        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,
        invoiceCount   ,
        invoiceValue  ,
        invoiceCollection , totalDoctor  ,
        totalCustomer    
    )
    SELECT 
      tr.TerritoryId,
        grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName + '|' + tr.TerritoryName AS RowKey,
        empNSM.EmpName GroupName,
       empRSM.EmpName RegionName,
        empASM.EmpName AreaName,
        empMio.EmpName TerritoryName,
        'Territory',
        'NetTP',
        @FromYear,
        @FromMonth,
        'general',      -- demo pharma platform
        'green-star',   -- demo provider type
        ISNULL(tm.TargetAmt,0),
         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,
        ISNULL(tblCollection.CollectionAMT, 0) ,

        -- demo campaign summary
        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,
        68, 460000, 430000, 122, 820000, 770000,
        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),
        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),
        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),
        ISNULL(tblTotalRx.TotalDoctorRXCov,0),

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
        ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),
       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),
        ISNULL(tblTotalCustomer.TotalCustomerCount,0)
  FROM dbo.tblTerritory tr  WITH (NOLOCK)
    INNER JOIN dbo.tblArea    ara WITH (NOLOCK) ON ara.AreaId   = tr.AreaId   AND ara.IsActive=1 
    INNER JOIN dbo.tblRegion  rgn WITH (NOLOCK) ON ara.RegionId = rgn.RegionId AND rgn.IsActive=1 
    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 
     
      OUTER APPLY (
    SELECT TOP (1) o.NSMId, o.RSMId, o.ASMId, o.MIOId
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.TerritoryId = tr.TerritoryId
    ORDER BY o.SubmissionDate DESC    -- তোমার table অনুযায়ী column ঠিক করো
) ord
INNER JOIN dbo.tblEmpGeneralInfo empRsm WITH (NOLOCK)
    ON empRsm.EmpInfoId = ord.RSMId
    INNER JOIN dbo.tblEmpGeneralInfo empNsm WITH (NOLOCK)
    ON empNsm.EmpInfoId = ord.NSMId

      INNER JOIN dbo.tblEmpGeneralInfo empASM WITH (NOLOCK)
    ON empASM.EmpInfoId = ord.ASMId

    left JOIN dbo.tblEmpGeneralInfo empMio WITH (NOLOCK)
    ON empMio.EmpInfoId = ord.MIOId
  
    
  

    LEFT JOIN (
        SELECT tr.TerritoryId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 
        FROM tblTerritoryDataMigration tm
        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 
        
        CROSS APPLY (
    -- MonthName + YearValue থেকে মাসের ১ তারিখের date বানাচ্ছি
    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate
) d
WHERE 
    d.MonthStartDate >= @FromDate
    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 
        GROUP BY tr.TerritoryId
    ) tm ON tm.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT ord.TerritoryId,
               CONVERT(DECIMAL(18,2),
                       ISNULL(SUM(ID.DeliveryNetAmount),0)
               ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE A.UpdateDate between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
        GROUP BY ord.TerritoryId
    ) tblInvAchiv ON tblInvAchiv.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT ord.TerritoryId,
               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE cstp.custPaymentDate between  @FromDate and @ToDate
        GROUP BY ord.TerritoryId
    ) tblCollection ON tblCollection.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalDcr ON tblTotalDcr.TerritoryId =tr.TerritoryId

    left join ( SELECT  ord.TerritoryId , 
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND isnull(ordD.CampaignName,'') <>''  AND    (
            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow
            OR ordD.CampaignName NOT IN (
                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe
               )
          ) group by ord.TerritoryId
         )tblCampInvoice on tblCampInvoice.TerritoryId=tr.TerritoryId
   


          
    left join ( SELECT  ord.TerritoryId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ord.SmcTypeId_Ord is not null group by ord.TerritoryId
         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.TerritoryId=tr.TerritoryId
         left join (SELECT ord2.TerritoryId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null
          
          group by ord2.TerritoryId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.TerritoryId=tr.TerritoryId

           
    left join ( SELECT  ord.TerritoryId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
          AND  DelivaryInvoiceNo is not null   
          AND ord.CustTypeId is not null group by ord.TerritoryId
         )tblCustTypeInvoice on tblCustTypeInvoice.TerritoryId=tr.TerritoryId
         left join (SELECT ord2.TerritoryId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null
          
          group by ord2.TerritoryId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.TerritoryId=tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalDcrGmp ON tblTotalDcrGmp.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalRxGmp ON tblTotalRxGmp.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.TerritoryId = tr.TerritoryId

    LEFT JOIN (
        SELECT C.TerritoryId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov
        FROM tbl_PrescriptionMaster C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.TerritoryId
    ) tblTotalRx ON tblTotalRx.TerritoryId = tr.TerritoryId
     
  
      
     
 

      LEFT JOIN (
        
            SELECT ord.TerritoryId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount
           
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
         
         
        GROUP BY ord.TerritoryId
    ) tblTotalCustomer  ON tblTotalCustomer.TerritoryId = tr.TerritoryId

   WHERE rgn.IsActive = 1 
      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))
  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))
   
      ----------------
      
       

    ;WITH cf AS
    (
        SELECT 
            Value,
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM @CampaignFilter
    )
    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)
    SELECT rn, Value
    FROM cf
    WHERE rn <= 4;

    

    INSERT INTO @Campaign
    (
        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection
    )
    SELECT 
        b.RowKey,
        sc.SlotNo,
        sc.CampaignCode,
        ISNULL(ci.InvoiceAMT, 0),
        ISNULL(0,0)
    FROM @Base b
    CROSS JOIN @SelectedCampaign sc
    OUTER APPLY
    (
        SELECT  
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
         
          AND ordD.CampaignName = sc.CampaignCode
          AND ord.TerritoryId   = b.TrrId_
    ) ci
   

  

    INSERT INTO @CampaignAgg
    (
        RowKey,
        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,
        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,
        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,
        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection
    )
    SELECT
        RowKey,
        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)
    FROM @Campaign
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- Customer breakdown (pivot 1–4)
    -------------------------------------------------------------------------


    IF EXISTS (SELECT 1 FROM @CustomerFilter)
    BEGIN
        ;WITH cf AS
        (
            SELECT 
                Value AS CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @CustomerFilter
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH cf AS
        (
            SELECT DISTINCT 
                ord.CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.CustomerType IS NOT NULL
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
     --   WHERE rn <= 4;
    END

  

    INSERT INTO @Customer
    (
        RowKey, SlotNo, CustomerType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sc.SlotNo,
        sc.CustomerType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedCustomer sc
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND CustT.CustomerType = sc.CustomerType
          AND ord.TerritoryId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND CustT.CustomerType = sc.CustomerType
          AND ord2.TerritoryId  = b.TrrId_
    ) cc;

   

    INSERT INTO @CustomerAgg
    (
        RowKey,
        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,
        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,
        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,
        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,
        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,
        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)
        ,

        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)
    FROM @Customer
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- PharmaPlatform breakdown (pivot 1–4)  → ord.SMCType_Ord
    -------------------------------------------------------------------------
    
    IF EXISTS (SELECT 1 FROM @PharmaFilter)
    BEGIN
        ;WITH pf AS
        (
            SELECT 
                Value AS PharmaPlatform,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @PharmaFilter
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, PharmaPlatform
        FROM pf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pf AS
        (
            SELECT DISTINCT 
                ord.SMCType_Ord,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.SMCType_Ord IS NOT NULL
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, SMCType_Ord
        FROM pf
      --  WHERE rn <= 4;
    END

   

    INSERT INTO @Pharma
    (
        RowKey, SlotNo, PharmaPlatform,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.PharmaPlatform,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        0
    FROM @Base b
    CROSS JOIN @SelectedPharma sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND ord.SMCType_Ord = sp.PharmaPlatform
          AND ord.TerritoryId  = b.TrrId_
    ) ci
  

  

    INSERT INTO @PharmaAgg
    (
        RowKey,
        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,
        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,
        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,
        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)
    FROM @Pharma
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- ProviderType breakdown (pivot 1–4) → tblProgramType.ProgramTypeName
    -------------------------------------------------------------------------
  

    IF EXISTS (SELECT 1 FROM @ProviderFilter)
    BEGIN
        ;WITH pr AS
        (
            SELECT 
                Value AS ProviderType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @ProviderFilter
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProviderType
        FROM pr
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pr AS
        (
            SELECT DISTINCT 
                ppt.ProgramTypeName,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
            INNER JOIN @Base b ON b.TrrId_ = ord.TerritoryId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ppt.ProgramTypeName IS NOT NULL
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProgramTypeName
        FROM pr
       -- WHERE rn <= 4;
    END

  

    INSERT INTO @Provider
    (
        RowKey, SlotNo, ProviderType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.ProviderType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedProvider sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord.TerritoryId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord2.TerritoryId  = b.TrrId_
    ) cc;

 

    INSERT INTO @ProviderAgg
    (
        RowKey,
        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,
        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,
        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,
        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)
    FROM @Provider
    GROUP BY RowKey;
      -----------------
      end
       ---------------area
    
      
       
          if(@reportLevel='area')
    begin
    INSERT INTO @Base
    (
        TrrId_,
        RowKey, GroupName, ZoneName, AreaName, Territory,
        FilterType, CalculationType, FiscalYear, FiscalMonth,
        PharmaPlatform, ProviderType,
        Target, InvoiceAchievement, AchievementCollection,
        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,
        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,
        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,
        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,
        TotalGmpCount, TotalNonGmpCount, TotalCount,
        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,
        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,
        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,
        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,
        invoiceCount   ,
        invoiceValue  ,
        invoiceCollection , totalDoctor  ,
        totalCustomer    
    )
    SELECT 
      ara.AreaId,
        grp.GroupName + '|' + rgn.RegionName + '|' + ara.AreaName   AS RowKey,
        empNSM.EmpName GroupName,
        empRSM.EmpName RegionName,
       empASM.EmpName  AreaName,
        '',
        'Territory',
        'NetTP',
        @FromYear,
        @FromMonth,
        'general',      -- demo pharma platform
        'green-star',   -- demo provider type
        ISNULL(tm.TargetAmt,0),
         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,
        ISNULL(tblCollection.CollectionAMT, 0) ,

        -- demo campaign summary
        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,
        68, 460000, 430000, 122, 820000, 770000,
        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),
        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),
        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),
        ISNULL(tblTotalRx.TotalDoctorRXCov,0),

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
        ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),
       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),
        ISNULL(tblTotalCustomer.TotalCustomerCount,0)
FROM dbo.tblArea    ara  WITH (NOLOCK)
     
    INNER JOIN dbo.tblRegion  rgn WITH (NOLOCK) ON ara.RegionId = rgn.RegionId AND rgn.IsActive=1 
    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 
    
  OUTER APPLY (
    SELECT TOP (1) o.NSMId, o.RSMId, o.ASMId
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.AreaId = ara.AreaId
    ORDER BY o.SubmissionDate DESC    -- তোমার table অনুযায়ী column ঠিক করো
) ord
INNER JOIN dbo.tblEmpGeneralInfo empRsm WITH (NOLOCK)
    ON empRsm.EmpInfoId = ord.RSMId
    INNER JOIN dbo.tblEmpGeneralInfo empNsm WITH (NOLOCK)
    ON empNsm.EmpInfoId = ord.NSMId

      INNER JOIN dbo.tblEmpGeneralInfo empASM WITH (NOLOCK)
    ON empASM.EmpInfoId = ord.ASMId

    LEFT JOIN (
        SELECT ar.AreaId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 
        FROM tblTerritoryDataMigration tm
        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 
        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 
       
        CROSS APPLY (
    -- MonthName + YearValue থেকে মাসের ১ তারিখের date বানাচ্ছি
   SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate
) d
WHERE 
    d.MonthStartDate >= @FromDate
    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 
        GROUP BY ar.AreaId
    ) tm ON tm.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT ord.AreaId,
               CONVERT(DECIMAL(18,2),
                       ISNULL(SUM(ID.DeliveryNetAmount),0)
               ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE A.UpdateDate between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
        GROUP BY ord.AreaId
    ) tblInvAchiv ON tblInvAchiv.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT ord.AreaId,
               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE cstp.custPaymentDate between  @FromDate and @ToDate
        GROUP BY ord.AreaId
    ) tblCollection ON tblCollection.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalDcr ON tblTotalDcr.AreaId =ara.AreaId

    left join ( SELECT  ord.AreaId , 
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND isnull(ordD.CampaignName,'') <>''  AND    (
            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow
            OR ordD.CampaignName NOT IN (
                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe
               )
          ) group by ord.AreaId
         )tblCampInvoice on tblCampInvoice.AreaId=ara.AreaId
   


          
    left join ( SELECT  ord.AreaId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ord.SmcTypeId_Ord is not null group by ord.AreaId
         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.AreaId=ara.AreaId
         left join (SELECT ord2.AreaId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null
          
          group by ord2.AreaId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.AreaId=ara.AreaId

           
    left join ( SELECT  ord.AreaId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
          AND  DelivaryInvoiceNo is not null   
          AND ord.CustTypeId is not null group by ord.AreaId
         )tblCustTypeInvoice on tblCustTypeInvoice.AreaId=ara.AreaId
         left join (SELECT ord2.AreaId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null
          
          group by ord2.AreaId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.AreaId=ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalDcrGmp ON tblTotalDcrGmp.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalRxGmp ON tblTotalRxGmp.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.AreaId = ara.AreaId

    LEFT JOIN (
        SELECT C.AreaId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov
        FROM tbl_PrescriptionMaster C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.AreaId
    ) tblTotalRx ON tblTotalRx.AreaId = ara.AreaId
     
  
      
     
 

      LEFT JOIN (
        
            SELECT ord.AreaId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount
           
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
         
         
        GROUP BY ord.AreaId
    ) tblTotalCustomer  ON tblTotalCustomer.AreaId = ara.AreaId

   WHERE rgn.IsActive = 1 
      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))
  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))
   
      ----------------
      
       

    ;WITH cf AS
    (
        SELECT 
            Value,
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM @CampaignFilter
    )
    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)
    SELECT rn, Value
    FROM cf
    WHERE rn <= 4;

    

    INSERT INTO @Campaign
    (
        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection
    )
    SELECT 
        b.RowKey,
        sc.SlotNo,
        sc.CampaignCode,
        ISNULL(ci.InvoiceAMT, 0),
        ISNULL(0,0)
    FROM @Base b
    CROSS JOIN @SelectedCampaign sc
    OUTER APPLY
    (
        SELECT  
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
         
          AND ordD.CampaignName = sc.CampaignCode
          AND ord.AreaId   = b.TrrId_
    ) ci
   

  

    INSERT INTO @CampaignAgg
    (
        RowKey,
        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,
        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,
        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,
        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection
    )
    SELECT
        RowKey,
        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)
    FROM @Campaign
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- Customer breakdown (pivot 1–4)
    -------------------------------------------------------------------------


    IF EXISTS (SELECT 1 FROM @CustomerFilter)
    BEGIN
        ;WITH cf AS
        (
            SELECT 
                Value AS CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @CustomerFilter
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH cf AS
        (
            SELECT DISTINCT 
                ord.CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.CustomerType IS NOT NULL
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
     --   WHERE rn <= 4;
    END

  

    INSERT INTO @Customer
    (
        RowKey, SlotNo, CustomerType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sc.SlotNo,
        sc.CustomerType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedCustomer sc
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND CustT.CustomerType = sc.CustomerType
          AND ord.AreaId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND CustT.CustomerType = sc.CustomerType
          AND ord2.AreaId  = b.TrrId_
    ) cc;

   

    INSERT INTO @CustomerAgg
    (
        RowKey,
        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,
        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,
        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,
        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,
        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,
        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)
        ,

        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)
    FROM @Customer
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- PharmaPlatform breakdown (pivot 1–4)  → ord.SMCType_Ord
    -------------------------------------------------------------------------
    
    IF EXISTS (SELECT 1 FROM @PharmaFilter)
    BEGIN
        ;WITH pf AS
        (
            SELECT 
                Value AS PharmaPlatform,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @PharmaFilter
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, PharmaPlatform
        FROM pf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pf AS
        (
            SELECT DISTINCT 
                ord.SMCType_Ord,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.SMCType_Ord IS NOT NULL
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, SMCType_Ord
        FROM pf
      --  WHERE rn <= 4;
    END

   

    INSERT INTO @Pharma
    (
        RowKey, SlotNo, PharmaPlatform,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.PharmaPlatform,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        0
    FROM @Base b
    CROSS JOIN @SelectedPharma sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND ord.SMCType_Ord = sp.PharmaPlatform
          AND ord.AreaId  = b.TrrId_
    ) ci
  

  

    INSERT INTO @PharmaAgg
    (
        RowKey,
        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,
        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,
        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,
        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)
    FROM @Pharma
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- ProviderType breakdown (pivot 1–4) → tblProgramType.ProgramTypeName
    -------------------------------------------------------------------------
  

    IF EXISTS (SELECT 1 FROM @ProviderFilter)
    BEGIN
        ;WITH pr AS
        (
            SELECT 
                Value AS ProviderType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @ProviderFilter
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProviderType
        FROM pr
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pr AS
        (
            SELECT DISTINCT 
                ppt.ProgramTypeName,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
            INNER JOIN @Base b ON b.TrrId_ = ord.AreaId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ppt.ProgramTypeName IS NOT NULL
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProgramTypeName
        FROM pr
       -- WHERE rn <= 4;
    END

  

    INSERT INTO @Provider
    (
        RowKey, SlotNo, ProviderType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.ProviderType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedProvider sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord.AreaId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord2.AreaId  = b.TrrId_
    ) cc;

 

    INSERT INTO @ProviderAgg
    (
        RowKey,
        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,
        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,
        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,
        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)
    FROM @Provider
    GROUP BY RowKey;
      -----------------
      end
      
       
       ---------------Zone
  

      if(@reportLevel='Zone')
    begin
    INSERT INTO @Base
    (
        TrrId_,
        RowKey, GroupName, ZoneName, AreaName, Territory,
        FilterType, CalculationType, FiscalYear, FiscalMonth,
        PharmaPlatform, ProviderType,
        Target, InvoiceAchievement, AchievementCollection,
        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,
        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,
        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,
        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,
        TotalGmpCount, TotalNonGmpCount, TotalCount,
        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,
        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,
        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,
        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,
        invoiceCount   ,
        invoiceValue  ,
        invoiceCollection , totalDoctor  ,
        totalCustomer    
    )
    SELECT 
        rgn.RegionId,
        grp.GroupName + '|' + rgn.RegionName     AS RowKey,
        empNsm.EmpName GroupName,
        emp.EmpName RegionName,
         '',
        '',
        'Territory',
        'NetTP',
        @FromYear,
        @FromMonth,
        'general',      -- demo pharma platform
        'green-star',   -- demo provider type
        ISNULL(tm.TargetAmt,0),
         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,
        ISNULL(tblCollection.CollectionAMT, 0) ,

        -- demo campaign summary
        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,
        68, 460000, 430000, 122, 820000, 770000,
        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),
        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),
        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),
        ISNULL(tblTotalRx.TotalDoctorRXCov,0),

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
        ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),
       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),
        ISNULL(tblTotalCustomer.TotalCustomerCount,0)

     FROM    dbo.tblRegion  rgn  WITH (NOLOCK)
     
    
    INNER JOIN dbo.tbl_Group  grp WITH (NOLOCK) ON grp.GroupId  = rgn.GroupId  AND grp.IsActive=1 
    OUTER APPLY (
    SELECT TOP (1) o.NSMId, o.RSMId
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.RegionId = rgn.RegionId
    ORDER BY o.SubmissionDate DESC    -- তোমার table অনুযায়ী column ঠিক করো
) ord
INNER JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK)
    ON emp.EmpInfoId = ord.RSMId
    INNER JOIN dbo.tblEmpGeneralInfo empNsm WITH (NOLOCK)
    ON empNsm.EmpInfoId = ord.NSMId
   

    LEFT JOIN (
        SELECT ar.RegionId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 
        FROM tblTerritoryDataMigration tm
        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 
        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 
       
        CROSS APPLY (
    -- MonthName + YearValue থেকে মাসের ১ তারিখের date বানাচ্ছি
    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate
) d
WHERE 
    d.MonthStartDate >= @FromDate
    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 
        GROUP BY ar.RegionId
    ) tm ON tm.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT ord.RegionId,
               CONVERT(DECIMAL(18,2),
                       ISNULL(SUM(ID.DeliveryNetAmount),0)
               ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE A.UpdateDate between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
        GROUP BY ord.RegionId
    ) tblInvAchiv ON tblInvAchiv.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT ord.RegionId,
               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE cstp.custPaymentDate between  @FromDate and @ToDate
        GROUP BY ord.RegionId
    ) tblCollection ON tblCollection.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalDcr ON tblTotalDcr.RegionId =rgn.RegionId

    left join ( SELECT  ord.RegionId , 
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND isnull(ordD.CampaignName,'') <>''  AND    (
            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow
            OR ordD.CampaignName NOT IN (
                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe
               )
          ) group by ord.RegionId
         )tblCampInvoice on tblCampInvoice.RegionId=rgn.RegionId
   


          
    left join ( SELECT  ord.RegionId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ord.SmcTypeId_Ord is not null group by ord.RegionId
         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.RegionId=rgn.RegionId
         left join (SELECT ord2.RegionId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null
          
          group by ord2.RegionId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.RegionId=rgn.RegionId

           
    left join ( SELECT  ord.RegionId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
          AND  DelivaryInvoiceNo is not null   
          AND ord.CustTypeId is not null group by ord.RegionId
         )tblCustTypeInvoice on tblCustTypeInvoice.RegionId=rgn.RegionId
         left join (SELECT ord2.RegionId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null
          
          group by ord2.RegionId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.RegionId=rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalDcrGmp ON tblTotalDcrGmp.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalRxGmp ON tblTotalRxGmp.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.RegionId = rgn.RegionId

    LEFT JOIN (
        SELECT C.RegionId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov
        FROM tbl_PrescriptionMaster C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.RegionId
    ) tblTotalRx ON tblTotalRx.RegionId = rgn.RegionId
     
  
      
     
 

      LEFT JOIN (
        
            SELECT ord.RegionId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount
           
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
         
         
        GROUP BY ord.RegionId
    ) tblTotalCustomer  ON tblTotalCustomer.RegionId = rgn.RegionId

   WHERE rgn.IsActive = 1 
      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))
  AND (ISNULL(@ZoneName,      '') = '' OR rgn.RegionId     = TRY_CONVERT(INT, @ZoneName))
   
      ----------------
      
       

    ;WITH cf AS
    (
        SELECT 
            Value,
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM @CampaignFilter
    )
    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)
    SELECT rn, Value
    FROM cf
    WHERE rn <= 4;

    

    INSERT INTO @Campaign
    (
        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection
    )
    SELECT 
        b.RowKey,
        sc.SlotNo,
        sc.CampaignCode,
        ISNULL(ci.InvoiceAMT, 0),
        ISNULL(0,0)
    FROM @Base b
    CROSS JOIN @SelectedCampaign sc
    OUTER APPLY
    (
        SELECT  
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
         
          AND ordD.CampaignName = sc.CampaignCode
          AND ord.RegionId   = b.TrrId_
    ) ci
   

  

    INSERT INTO @CampaignAgg
    (
        RowKey,
        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,
        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,
        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,
        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection
    )
    SELECT
        RowKey,
        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)
    FROM @Campaign
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- Customer breakdown (pivot 1–4)
    -------------------------------------------------------------------------


    IF EXISTS (SELECT 1 FROM @CustomerFilter)
    BEGIN
        ;WITH cf AS
        (
            SELECT 
                Value AS CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @CustomerFilter
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH cf AS
        (
            SELECT DISTINCT 
                ord.CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.CustomerType IS NOT NULL
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
     --   WHERE rn <= 4;
    END

  

    INSERT INTO @Customer
    (
        RowKey, SlotNo, CustomerType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sc.SlotNo,
        sc.CustomerType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedCustomer sc
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND CustT.CustomerType = sc.CustomerType
          AND ord.RegionId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND CustT.CustomerType = sc.CustomerType
          AND ord2.RegionId  = b.TrrId_
    ) cc;

   

    INSERT INTO @CustomerAgg
    (
        RowKey,
        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,
        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,
        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,
        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,
        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,
        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)
        ,

        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)
    FROM @Customer
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- PharmaPlatform breakdown (pivot 1–4)  → ord.SMCType_Ord
    -------------------------------------------------------------------------
    
    IF EXISTS (SELECT 1 FROM @PharmaFilter)
    BEGIN
        ;WITH pf AS
        (
            SELECT 
                Value AS PharmaPlatform,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @PharmaFilter
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, PharmaPlatform
        FROM pf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pf AS
        (
            SELECT DISTINCT 
                ord.SMCType_Ord,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.SMCType_Ord IS NOT NULL
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, SMCType_Ord
        FROM pf
      --  WHERE rn <= 4;
    END

   

    INSERT INTO @Pharma
    (
        RowKey, SlotNo, PharmaPlatform,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.PharmaPlatform,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        0
    FROM @Base b
    CROSS JOIN @SelectedPharma sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND ord.SMCType_Ord = sp.PharmaPlatform
          AND ord.RegionId  = b.TrrId_
    ) ci
  

  

    INSERT INTO @PharmaAgg
    (
        RowKey,
        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,
        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,
        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,
        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)
    FROM @Pharma
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- ProviderType breakdown (pivot 1–4) → tblProgramType.ProgramTypeName
    -------------------------------------------------------------------------
  

    IF EXISTS (SELECT 1 FROM @ProviderFilter)
    BEGIN
        ;WITH pr AS
        (
            SELECT 
                Value AS ProviderType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @ProviderFilter
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProviderType
        FROM pr
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pr AS
        (
            SELECT DISTINCT 
                ppt.ProgramTypeName,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
            INNER JOIN @Base b ON b.TrrId_ = ord.RegionId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ppt.ProgramTypeName IS NOT NULL
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProgramTypeName
        FROM pr
       -- WHERE rn <= 4;
    END

  

    INSERT INTO @Provider
    (
        RowKey, SlotNo, ProviderType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.ProviderType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedProvider sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord.RegionId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord2.RegionId  = b.TrrId_
    ) cc;

 

    INSERT INTO @ProviderAgg
    (
        RowKey,
        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,
        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,
        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,
        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)
    FROM @Provider
    GROUP BY RowKey;
      -----------------
      end
      
      
       ---------------group
    if(@reportLevel='group')
    begin
    INSERT INTO @Base
    (
        TrrId_,
        RowKey, GroupName, ZoneName, AreaName, Territory,
        FilterType, CalculationType, FiscalYear, FiscalMonth,
        PharmaPlatform, ProviderType,
        Target, InvoiceAchievement, AchievementCollection,
        CampaignInvoiceValue, CampaignCollection, CampaignDoctorCoverage,
        ProviderTypeWiseChemistCoverage, ProviderTypeWiseInvoiceAmount, ProviderTypeWiseCollection,
        ProviderTypeWiseTotalChemistCoverage, ProviderTypeWiseTotalInvoiceAmount, ProviderTypeWiseTotalCollection,
        PharmaPlatformWiseCollection, PharmaPlatformWiseTotalChemistCoverage, PharmaPlatformWiseTotalInvoiceAmount, PharmaPlatformWiseTotalCollection,
        TotalGmpCount, TotalNonGmpCount, TotalCount,
        DCRGmpDoctorCoverage, DCRNonGmpDoctorCoverage, DCRTotalDoctorCoverage,
        SumOfGmpDcr, SumOfNonGmpDcr, TotalDcr,
        RXGmpDoctorCoverage, RXNonGmpDoctorCoverage, RXTotalDoctorCoverage,
        SumOfGmpRx, SumOfNonGmpRx, TotalRx ,
        invoiceCount   ,
        invoiceValue  ,
        invoiceCollection , totalDoctor  ,
        totalCustomer    
    )
    SELECT 
        grp.GroupId,
        grp.GroupName       AS RowKey,
        emp.EmpName GroupName,
       '',
       '',
        '',
        'Territory',
        'NetTP',
        @FromYear,
        @FromMonth,
        'general',      -- demo pharma platform
        'green-star',   -- demo provider type
        ISNULL(tm.TargetAmt,0),
         ISNULL(tblInvAchiv.InvoiceAMT, 0)    ,
        ISNULL(tblCollection.CollectionAMT, 0) ,

        -- demo campaign summary
        isnull(tblCampInvoice.InvoiceAMT,0), 0,   380,
        68, 460000, 430000, 122, 820000, 770000,
        640000, isnull(tblPharmaPlatformInvoice.PlatformInvoiceTotalChemistCov,0),isnull(tblPharmaPlatformInvoice.InvoiceAMT,0), isnull(tblPharmaPlatformInvoiceCollection.CollectionAMT,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0) +ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
          ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0)+  ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
      ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMPCov,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMPCov,0),
        ISNULL(tblTotalDcr.TotalDoctorDCRCov,0), 

        ISNULL(tblTotalDcrGmp.TotalDoctorDCRGMP,0),
        ISNULL(tblTotalDcrNonGmp.TotalDoctorDCRNonGMP,0),
        ISNULL(tblTotalDcr.TotalDoctorDCR,0), 

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMPCov,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMPCov,0),
        ISNULL(tblTotalRx.TotalDoctorRXCov,0),

        ISNULL(tblTotalRxGmp.TotalDoctorRXGMP,0),
        ISNULL(tblTotalRxNonGmp.TotalDoctorRXNonGMP,0),
        ISNULL(tblTotalRx.TotalDoctorRX,0),

        ISNULL(tblCustTypeInvoice.CustTypeTotalChemistCov,0), ISNULL(tblCustTypeInvoice.InvoiceAMT,0),ISNULL(tblCustTypeformInvoiceCollection.CollectionAMT,0),
       ISNULL(tblTotalDcr.TotalDoctorDCR,0)+ ISNULL(tblTotalRx.TotalDoctorRX,0),
        ISNULL(tblTotalCustomer.TotalCustomerCount,0)

    FROM dbo.tbl_Group  grp     WITH (NOLOCK)
    OUTER APPLY (
    SELECT TOP (1) o.NSMId
    FROM dbo.tblOrder o WITH (NOLOCK)
    WHERE o.GroupId = grp.GroupId
    ORDER BY o.SubmissionDate DESC    -- তোমার table অনুযায়ী column ঠিক করো
) ord
INNER JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK)
    ON emp.EmpInfoId = ord.NSMId

      

    LEFT JOIN (
        SELECT rg.GroupId, ISNULL(SUM(CAST(Value AS DECIMAL(18,2))),0) AS TargetAmt 
        FROM tblTerritoryDataMigration tm
        INNER JOIN dbo.tblTerritory  tr WITH (NOLOCK) ON tr.TerritoryId = tm.TerritoryId AND tr.IsActive=1 
        INNER JOIN dbo.tblArea  ar WITH (NOLOCK) ON tr.AreaId = ar.AreaId AND ar.IsActive=1 
        INNER JOIN dbo.tblRegion  rg WITH (NOLOCK) ON rg.RegionId = ar.RegionId AND rg.IsActive=1 
        CROSS APPLY (
    -- MonthName + YearValue থেকে মাসের ১ তারিখের date বানাচ্ছি
    SELECT cast(  '01'+ '-' + (tm.MonthName    ) + '-' +  (tm.YearValue  )   as date ) AS MonthStartDate
) d
WHERE 
    d.MonthStartDate >= @FromDate
    AND d.MonthStartDate < DATEADD(DAY, 1, @ToDate) 
        GROUP BY rg.GroupId
    ) tm ON tm.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT ord.GroupId,
               CONVERT(DECIMAL(18,2),
                       ISNULL(SUM(ID.DeliveryNetAmount),0)
               ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE A.UpdateDate between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
        GROUP BY ord.GroupId
    ) tblInvAchiv ON tblInvAchiv.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT ord.GroupId,
               ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A ON A.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord WITH (NOLOCK) ON ord.OrderId = A.OrderId 
        WHERE cstp.custPaymentDate between  @FromDate and @ToDate
        GROUP BY ord.GroupId
    ) tblCollection ON tblCollection.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorDCR, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalDcr ON tblTotalDcr.GroupId =grp.GroupId

    left join ( SELECT  ord.GroupId , 
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND isnull(ordD.CampaignName,'') <>''  AND    (
            NOT EXISTS (SELECT 1 FROM @CampaignFilter)          -- jodi filter empty hoy, tahole sob allow
            OR ordD.CampaignName NOT IN (
                    SELECT Value FROM @CampaignFilter           -- jodi value thake, oigula bad dibe
               )
          ) group by ord.GroupId
         )tblCampInvoice on tblCampInvoice.GroupId=grp.GroupId
   


          
    left join ( SELECT  ord.GroupId , COUNT( distinct ord.CustomerMasterId) PlatformInvoiceTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ord.SmcTypeId_Ord is not null group by ord.GroupId
         )tblPharmaPlatformInvoice on tblPharmaPlatformInvoice.GroupId=grp.GroupId
         left join (SELECT ord2.GroupId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.SmcTypeId_Ord is not null
          
          group by ord2.GroupId) tblPharmaPlatformInvoiceCollection on tblPharmaPlatformInvoiceCollection.GroupId=grp.GroupId

           
    left join ( SELECT  ord.GroupId , COUNT( distinct ord.CustomerMasterId) CustTypeTotalChemistCov,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
          AND  DelivaryInvoiceNo is not null   
          AND ord.CustTypeId is not null group by ord.GroupId
         )tblCustTypeInvoice on tblCustTypeInvoice.GroupId=grp.GroupId
         left join (SELECT ord2.GroupId,  
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS CollectionAMT
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2   ON A2.InvoiceId  = cstp.InvoiceId
        INNER JOIN tblOrder  ord2  ON ord2.OrderId  = A2.OrderId
        INNER JOIN tblOrderDetail ordD2 ON ordD2.OrderId = ord2.OrderId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate AND ord2.CustTypeId is not null
          
          group by ord2.GroupId) tblCustTypeformInvoiceCollection on tblCustTypeformInvoiceCollection.GroupId=grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId,  COUNT(C.DoctorID) AS TotalDoctorDCRGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalDcrGmp ON tblTotalDcrGmp.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId, COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMP,COUNT(DISTINCT C.DoctorID) AS TotalDoctorDCRNonGMPCov
        FROM tbl_DCRInfo C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.DoctorTypeID_DCR = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalDcrNonGmp ON tblTotalDcrNonGmp.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorRXGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 2
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalRxGmp ON tblTotalRxGmp.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorRXNonGMP, COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXNonGMPCov
        FROM tbl_PrescriptionMaster C
        WHERE C.DoctorTypeId_RX = 1
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalRxNonGmp ON tblTotalRxNonGmp.GroupId = grp.GroupId

    LEFT JOIN (
        SELECT C.GroupId, COUNT(C.DoctorID) AS TotalDoctorRX,COUNT(DISTINCT C.DoctorID) AS TotalDoctorRXCov
        FROM tbl_PrescriptionMaster C
        WHERE ISNULL(C.ApprovalStatus,0) = '2'
          AND C.EntryDate  between  @FromDate and @ToDate
        GROUP BY C.GroupId
    ) tblTotalRx ON tblTotalRx.GroupId = grp.GroupId
     
  
      
     
 

      LEFT JOIN (
        
            SELECT ord.GroupId, COUNT( Distinct ord.CustomerMasterId) AS TotalCustomerCount
           
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
         
         
        GROUP BY ord.GroupId
    ) tblTotalCustomer  ON tblTotalCustomer.GroupId = grp.GroupId

    WHERE grp.IsActive = 1 and grp.GroupName <>'TestRezion'
      and (ISNULL(@GroupName,     '') = '' OR grp.GroupId      = TRY_CONVERT(INT, @GroupName))
   
      ----------------
      
       

    ;WITH cf AS
    (
        SELECT 
            Value,
            ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
        FROM @CampaignFilter
    )
    INSERT INTO @SelectedCampaign (SlotNo, CampaignCode)
    SELECT rn, Value
    FROM cf
    WHERE rn <= 4;

    

    INSERT INTO @Campaign
    (
        RowKey, SlotNo, CampaignCode, CampaignInvoiceValue, CampaignCollection
    )
    SELECT 
        b.RowKey,
        sc.SlotNo,
        sc.CampaignCode,
        ISNULL(ci.InvoiceAMT, 0),
        ISNULL(0,0)
    FROM @Base b
    CROSS JOIN @SelectedCampaign sc
    OUTER APPLY
    (
        SELECT  
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceAMT
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID   ON A.InvoiceId   = ID.InvoiceId
        INNER JOIN tblOrder         ord  ON ord.OrderId   = A.OrderId 
        INNER JOIN tblOrderDetail   ordD ON ordD.OrderDetailId = ID.OrderDetailsId 
        WHERE A.UpdateDate  between  @FromDate and @ToDate
        AND  DelivaryInvoiceNo is not null   
         
          AND ordD.CampaignName = sc.CampaignCode
          AND ord.GroupId   = b.TrrId_
    ) ci
   

  

    INSERT INTO @CampaignAgg
    (
        RowKey,
        Campaign1_Name, Campaign1_Invoice, Campaign1_Collection,
        Campaign2_Name, Campaign2_Invoice, Campaign2_Collection,
        Campaign3_Name, Campaign3_Invoice, Campaign3_Collection,
        Campaign4_Name, Campaign4_Invoice, Campaign4_Collection
    )
    SELECT
        RowKey,
        MAX(CASE WHEN SlotNo = 1 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN CampaignCollection   ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CampaignCode         END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignInvoiceValue ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN CampaignCollection   ELSE 0 END)
    FROM @Campaign
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- Customer breakdown (pivot 1–4)
    -------------------------------------------------------------------------


    IF EXISTS (SELECT 1 FROM @CustomerFilter)
    BEGIN
        ;WITH cf AS
        (
            SELECT 
                Value AS CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @CustomerFilter
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH cf AS
        (
            SELECT DISTINCT 
                ord.CustomerType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.CustomerType IS NOT NULL
        )
        INSERT INTO @SelectedCustomer (SlotNo, CustomerType)
        SELECT rn, CustomerType
        FROM cf
     --   WHERE rn <= 4;
    END

  

    INSERT INTO @Customer
    (
        RowKey, SlotNo, CustomerType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sc.SlotNo,
        sc.CustomerType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedCustomer sc
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord.CustTypeId = CustT.CustomerTypeId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND CustT.CustomerType = sc.CustomerType
          AND ord.GroupId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblCustomerType CustT WITH (NOLOCK) ON ord2.CustTypeId = CustT.CustomerTypeId 
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND CustT.CustomerType = sc.CustomerType
          AND ord2.GroupId  = b.TrrId_
    ) cc;

   

    INSERT INTO @CustomerAgg
    (
        RowKey,
        Customer1_Name, Customer1_InvoiceCount, Customer1_InvoiceValue, Customer1_InvoiceCollection,
        Customer2_Name, Customer2_InvoiceCount, Customer2_InvoiceValue, Customer2_InvoiceCollection,
        Customer3_Name, Customer3_InvoiceCount, Customer3_InvoiceValue, Customer3_InvoiceCollection,
        Customer4_Name, Customer4_InvoiceCount, Customer4_InvoiceValue, Customer4_InvoiceCollection,
        Customer5_Name, Customer5_InvoiceCount, Customer5_InvoiceValue, Customer5_InvoiceCollection,
        Customer6_Name, Customer6_InvoiceCount, Customer6_InvoiceValue, Customer6_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 5 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 5 THEN InvoiceCollection  ELSE 0 END)
        ,

        MAX(CASE WHEN SlotNo = 6 THEN CustomerType       END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 6 THEN InvoiceCollection  ELSE 0 END)
    FROM @Customer
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- PharmaPlatform breakdown (pivot 1–4)  → ord.SMCType_Ord
    -------------------------------------------------------------------------
    
    IF EXISTS (SELECT 1 FROM @PharmaFilter)
    BEGIN
        ;WITH pf AS
        (
            SELECT 
                Value AS PharmaPlatform,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @PharmaFilter
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, PharmaPlatform
        FROM pf
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pf AS
        (
            SELECT DISTINCT 
                ord.SMCType_Ord,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ord.SMCType_Ord IS NOT NULL
        )
        INSERT INTO @SelectedPharma (SlotNo, PharmaPlatform)
        SELECT rn, SMCType_Ord
        FROM pf
      --  WHERE rn <= 4;
    END

   

    INSERT INTO @Pharma
    (
        RowKey, SlotNo, PharmaPlatform,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.PharmaPlatform,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        0
    FROM @Base b
    CROSS JOIN @SelectedPharma sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId  
        WHERE A.UpdateDate  between  @FromDate and @ToDate
           AND  DelivaryInvoiceNo is not null   
          AND ord.SMCType_Ord = sp.PharmaPlatform
          AND ord.GroupId  = b.TrrId_
    ) ci
  

  

    INSERT INTO @PharmaAgg
    (
        RowKey,
        PharmaPlatform1_Name, PharmaPlatform1_InvoiceAmount, PharmaPlatform1_ChemistCoverage, PharmaPlatform1_InvoiceCollection,
        PharmaPlatform2_Name, PharmaPlatform2_InvoiceAmount, PharmaPlatform2_ChemistCoverage, PharmaPlatform2_InvoiceCollection,
        PharmaPlatform3_Name, PharmaPlatform3_InvoiceAmount, PharmaPlatform3_ChemistCoverage, PharmaPlatform3_InvoiceCollection,
        PharmaPlatform4_Name, PharmaPlatform4_InvoiceAmount, PharmaPlatform4_ChemistCoverage, PharmaPlatform4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection    ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN PharmaPlatform       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount         ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection    ELSE 0 END)
    FROM @Pharma
    GROUP BY RowKey;

    -------------------------------------------------------------------------
    -- ProviderType breakdown (pivot 1–4) → tblProgramType.ProgramTypeName
    -------------------------------------------------------------------------
  

    IF EXISTS (SELECT 1 FROM @ProviderFilter)
    BEGIN
        ;WITH pr AS
        (
            SELECT 
                Value AS ProviderType,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM @ProviderFilter
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProviderType
        FROM pr
       -- WHERE rn <= 4;
    END
    ELSE
    BEGIN
        ;WITH pr AS
        (
            SELECT DISTINCT 
                ppt.ProgramTypeName,
                ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rn
            FROM tblOrder ord WITH (NOLOCK)
            INNER JOIN tblInvoice A WITH (NOLOCK) ON A.OrderId = ord.OrderId
            INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
            INNER JOIN @Base b ON b.TrrId_ = ord.GroupId
            WHERE A.UpdateDate  between  @FromDate and @ToDate
              AND ppt.ProgramTypeName IS NOT NULL
        )
        INSERT INTO @SelectedProvider (SlotNo, ProviderType)
        SELECT rn, ProgramTypeName
        FROM pr
       -- WHERE rn <= 4;
    END

  

    INSERT INTO @Provider
    (
        RowKey, SlotNo, ProviderType,
        InvoiceCount, InvoiceValue, InvoiceCollection
    )
    SELECT
        b.RowKey,
        sp.SlotNo,
        sp.ProviderType,
        ISNULL(ci.InvoiceCount, 0),
        ISNULL(ci.InvoiceValue, 0.00),
        ISNULL(cc.InvoiceCollection,0.00)
    FROM @Base b
    CROSS JOIN @SelectedProvider sp
    OUTER APPLY
    (
        SELECT
            COUNT(DISTINCT A.InvoiceId) AS InvoiceCount,
            CONVERT(DECIMAL(18,2),
                ISNULL(SUM(ID.DeliveryNetAmount),0)
            ) AS InvoiceValue
        FROM dbo.tblInvoice A WITH (NOLOCK)
        INNER JOIN tblInvoiceDetail ID ON A.InvoiceId = ID.InvoiceId
        INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord.ProgramTypeId
        WHERE A.UpdateDate  between  @FromDate and @ToDate
         AND  DelivaryInvoiceNo is not null   
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord.GroupId  = b.TrrId_
    ) ci
    OUTER APPLY
    (
        SELECT
            ISNULL(SUM(cstp.TPAmount + cstp.VATAmount),0) AS InvoiceCollection
        FROM dbo.tblCustPayDetail cstp WITH (NOLOCK)
        INNER JOIN tblInvoice A2 ON A2.InvoiceId = cstp.InvoiceId
        INNER JOIN tblOrder  ord2 WITH (NOLOCK) ON ord2.OrderId = A2.OrderId
        INNER JOIN tblProgramType ppt WITH (NOLOCK) ON ppt.ProgramTypeId = ord2.ProgramTypeId
        WHERE cstp.custPaymentDate  between  @FromDate and @ToDate
          AND ppt.ProgramTypeName = sp.ProviderType
          AND ord2.GroupId  = b.TrrId_
    ) cc;

 

    INSERT INTO @ProviderAgg
    (
        RowKey,
        ProviderType1_Name, ProviderType1_InvoiceAmount, ProviderType1_ChemistCoverage, ProviderType1_InvoiceCollection,
        ProviderType2_Name, ProviderType2_InvoiceAmount, ProviderType2_ChemistCoverage, ProviderType2_InvoiceCollection,
        ProviderType3_Name, ProviderType3_InvoiceAmount, ProviderType3_ChemistCoverage, ProviderType3_InvoiceCollection,
        ProviderType4_Name, ProviderType4_InvoiceAmount, ProviderType4_ChemistCoverage, ProviderType4_InvoiceCollection
    )
    SELECT
        RowKey,

        MAX(CASE WHEN SlotNo = 1 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 1 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 2 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 2 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 3 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 3 THEN InvoiceCollection  ELSE 0 END),

        MAX(CASE WHEN SlotNo = 4 THEN ProviderType       END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceValue       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCount       ELSE 0 END),
        SUM(CASE WHEN SlotNo = 4 THEN InvoiceCollection  ELSE 0 END)
    FROM @Provider
    GROUP BY RowKey;
      -----------------
      end
    -------------------------------------------------------------------------
    -- Campaign selection + pivot (1–4)
    -------------------------------------------------------------------------
  




    -------------------------------------------------------------------------
    -- FINAL OUTPUT
    -------------------------------------------------------------------------
    SELECT 
        b.TrrId_,
        b.RowKey,
        b.GroupName,
        b.ZoneName,
        b.AreaName,
        b.Territory,
        b.Target,
        b.InvoiceAchievement,
        b.AchievementCollection,

          ISNULL( invoiceCount ,  0)  CampaignWiseTotalinvoiceCount ,
       ISNULL( invoiceValue ,  0) CampaignWiseTotalinvoiceValue,
       ISNULL( invoiceCollection ,  0)   CampaignWiseTotalinvoiceCollection,

       
       ISNULL( invoiceCount ,  0)  customerTypeTotalInvoiceCount ,
       ISNULL( invoiceValue ,  0) customerTypeTotalInvoiceValue,
       ISNULL( invoiceCollection ,  0)   customerTypeTotalInvoiceCollection,
       
    
        b.ProviderTypeWiseTotalChemistCoverage,
        b.ProviderTypeWiseTotalInvoiceAmount,
        b.ProviderTypeWiseTotalCollection,
         
        b.PharmaPlatformWiseTotalChemistCoverage,
        b.PharmaPlatformWiseTotalInvoiceAmount,
        b.PharmaPlatformWiseTotalCollection,

        b.TotalGmpCount,
        b.TotalNonGmpCount,
        b.TotalCount,
        b.DCRGmpDoctorCoverage,
        b.DCRNonGmpDoctorCoverage,
        b.DCRTotalDoctorCoverage,
        b.SumOfGmpDcr,
        b.SumOfNonGmpDcr,
        b.TotalDcr,
        b.RXGmpDoctorCoverage,
        b.RXNonGmpDoctorCoverage,
        b.RXTotalDoctorCoverage,
        b.SumOfGmpRx,
        b.SumOfNonGmpRx,
        b.TotalRx,

        -- Campaign slots
        ISNULL(ca.Campaign1_Name,       '') AS Campaign1_Name,
        ISNULL(ca.Campaign1_Invoice,    0)  AS Campaign1_Invoice,
        ISNULL(ca.Campaign1_Collection, 0)  AS Campaign1_Collection,

        ISNULL(ca.Campaign2_Name,       '') AS Campaign2_Name,
        ISNULL(ca.Campaign2_Invoice,    0)  AS Campaign2_Invoice,
        ISNULL(ca.Campaign2_Collection, 0)  AS Campaign2_Collection,

        ISNULL(ca.Campaign3_Name,       '') AS Campaign3_Name,
        ISNULL(ca.Campaign3_Invoice,    0)  AS Campaign3_Invoice,
        ISNULL(ca.Campaign3_Collection, 0)  AS Campaign3_Collection,

        ISNULL(ca.Campaign4_Name,       '') AS Campaign4_Name,
        ISNULL(ca.Campaign4_Invoice,    0)  AS Campaign4_Invoice,
        ISNULL(ca.Campaign4_Collection, 0)  AS Campaign4_Collection,

        -- Customer type slots
        ISNULL(cu.Customer1_Name,              '') AS Customer1_Name,
        ISNULL(cu.Customer1_InvoiceCount,      0)  AS Customer1_InvoiceCount,
        ISNULL(cu.Customer1_InvoiceValue,      0)  AS Customer1_InvoiceValue,
        ISNULL(cu.Customer1_InvoiceCollection, 0)  AS Customer1_InvoiceCollection,

        ISNULL(cu.Customer2_Name,              '') AS Customer2_Name,
        ISNULL(cu.Customer2_InvoiceCount,      0)  AS Customer2_InvoiceCount,
        ISNULL(cu.Customer2_InvoiceValue,      0)  AS Customer2_InvoiceValue,
        ISNULL(cu.Customer2_InvoiceCollection, 0)  AS Customer2_InvoiceCollection,

        ISNULL(cu.Customer3_Name,              '') AS Customer3_Name,
        ISNULL(cu.Customer3_InvoiceCount,      0)  AS Customer3_InvoiceCount,
        ISNULL(cu.Customer3_InvoiceValue,      0)  AS Customer3_InvoiceValue,
        ISNULL(cu.Customer3_InvoiceCollection, 0)  AS Customer3_InvoiceCollection,

        ISNULL(cu.Customer4_Name,              '') AS Customer4_Name,
        ISNULL(cu.Customer4_InvoiceCount,      0)  AS Customer4_InvoiceCount,
        ISNULL(cu.Customer4_InvoiceValue,      0)  AS Customer4_InvoiceValue,
        ISNULL(cu.Customer4_InvoiceCollection, 0)  AS Customer4_InvoiceCollection
        ,

        ISNULL(cu.Customer5_Name,              '') AS Customer5_Name,
        ISNULL(cu.Customer5_InvoiceCount,      0)  AS Customer5_InvoiceCount,
        ISNULL(cu.Customer5_InvoiceValue,      0)  AS Customer5_InvoiceValue,
        ISNULL(cu.Customer5_InvoiceCollection, 0)  AS Customer5_InvoiceCollection,
       

        ISNULL(cu.Customer6_Name,              '') AS Customer6_Name,
        ISNULL(cu.Customer6_InvoiceCount,      0)  AS Customer6_InvoiceCount,
        ISNULL(cu.Customer6_InvoiceValue,      0)  AS Customer6_InvoiceValue,
        ISNULL(cu.Customer6_InvoiceCollection, 0)  AS Customer6_InvoiceCollection,


        -- Pharma Platform slots
        ISNULL(ph.PharmaPlatform1_Name,              '') AS PharmaPlatform1_Name,
        ISNULL(ph.PharmaPlatform1_InvoiceAmount,      0)  AS PharmaPlatform1_InvoiceAmount,
        ISNULL(ph.PharmaPlatform1_ChemistCoverage,    0)  AS PharmaPlatform1_ChemistCoverage,
        ISNULL(ph.PharmaPlatform1_InvoiceCollection,  0)  AS PharmaPlatform1_InvoiceCollection,

        ISNULL(ph.PharmaPlatform2_Name,              '') AS PharmaPlatform2_Name,
        ISNULL(ph.PharmaPlatform2_InvoiceAmount,      0)  AS PharmaPlatform2_InvoiceAmount,
        ISNULL(ph.PharmaPlatform2_ChemistCoverage,    0)  AS PharmaPlatform2_ChemistCoverage,
        ISNULL(ph.PharmaPlatform2_InvoiceCollection,  0)  AS PharmaPlatform2_InvoiceCollection,

        ISNULL(ph.PharmaPlatform3_Name,              '') AS PharmaPlatform3_Name,
        ISNULL(ph.PharmaPlatform3_InvoiceAmount,      0)  AS PharmaPlatform3_InvoiceAmount,
        ISNULL(ph.PharmaPlatform3_ChemistCoverage,    0)  AS PharmaPlatform3_ChemistCoverage,
        ISNULL(ph.PharmaPlatform3_InvoiceCollection,  0)  AS PharmaPlatform3_InvoiceCollection,

        ISNULL(ph.PharmaPlatform4_Name,              '') AS PharmaPlatform4_Name,
        ISNULL(ph.PharmaPlatform4_InvoiceAmount,      0)  AS PharmaPlatform4_InvoiceAmount,
        ISNULL(ph.PharmaPlatform4_ChemistCoverage,    0)  AS PharmaPlatform4_ChemistCoverage,
        ISNULL(ph.PharmaPlatform4_InvoiceCollection,  0)  AS PharmaPlatform4_InvoiceCollection,

        -- Provider Type slots
        ISNULL(pr.ProviderType1_Name,              '') AS ProviderType1_Name,
        ISNULL(pr.ProviderType1_InvoiceAmount,      0)  AS ProviderType1_InvoiceAmount,
        ISNULL(pr.ProviderType1_ChemistCoverage,    0)  AS ProviderType1_ChemistCoverage,
        ISNULL(pr.ProviderType1_InvoiceCollection,  0)  AS ProviderType1_InvoiceCollection,

        ISNULL(pr.ProviderType2_Name,              '') AS ProviderType2_Name,
        ISNULL(pr.ProviderType2_InvoiceAmount,      0)  AS ProviderType2_InvoiceAmount,
        ISNULL(pr.ProviderType2_ChemistCoverage,    0)  AS ProviderType2_ChemistCoverage,
        ISNULL(pr.ProviderType2_InvoiceCollection,  0)  AS ProviderType2_InvoiceCollection,

        ISNULL(pr.ProviderType3_Name,              '') AS ProviderType3_Name,
        ISNULL(pr.ProviderType3_InvoiceAmount,      0)  AS ProviderType3_InvoiceAmount,
        ISNULL(pr.ProviderType3_ChemistCoverage,    0)  AS ProviderType3_ChemistCoverage,
        ISNULL(pr.ProviderType3_InvoiceCollection,  0)  AS ProviderType3_InvoiceCollection,

        ISNULL(pr.ProviderType4_Name,              '') AS ProviderType4_Name,
        ISNULL(pr.ProviderType4_InvoiceAmount,      0)  AS ProviderType4_InvoiceAmount,
        ISNULL(pr.ProviderType4_ChemistCoverage,    0)  AS ProviderType4_ChemistCoverage,
        ISNULL(pr.ProviderType4_InvoiceCollection,  0)  AS ProviderType4_InvoiceCollection,
         
     


        ISNULL(totalDoctor,  0) totalDoctor ,
        ISNULL(totalCustomer  ,  0)   totalCustomer


    FROM @Base b
    LEFT JOIN @CampaignAgg ca ON ca.RowKey = b.RowKey
    LEFT JOIN @CustomerAgg cu ON cu.RowKey = b.RowKey
    LEFT JOIN @PharmaAgg   ph ON ph.RowKey = b.RowKey
    LEFT JOIN @ProviderAgg pr ON pr.RowKey = b.RowKey;

    -------------------------------------------------------------------------
    -- Raw debug output (optional)
    -------------------------------------------------------------------------
    -- 1) Campaign rows
    SELECT  
        cp.RowKey,
        cp.SlotNo,
        cp.CampaignCode,
        cp.CampaignInvoiceValue,
        cp.CampaignCollection
    FROM @Campaign cp
    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = cp.RowKey)
    ORDER BY cp.RowKey, cp.SlotNo;

    -- 2) Customer rows
    SELECT
        c.RowKey,
        c.SlotNo,
        c.CustomerType,
        c.InvoiceCount,
        c.InvoiceValue,
        c.InvoiceCollection
    FROM @Customer c
    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = c.RowKey)
    ORDER BY c.RowKey, c.SlotNo;

    -- 3) Provider rows
    SELECT
        p.RowKey,
        p.SlotNo,
        p.ProviderType,
        p.InvoiceCount,
        p.InvoiceValue,
        p.InvoiceCollection
    FROM @Provider p
    WHERE EXISTS (SELECT 1 FROM @Base b WHERE b.RowKey = p.RowKey)
    ORDER BY p.RowKey, p.SlotNo;
END;
