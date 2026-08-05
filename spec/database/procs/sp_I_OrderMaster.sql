-- =============================================
-- Author:		<Author,JEWEL>
-- Create date: <Create Date,01-04-2019,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_OrderMaster] 
	(
		 @OrderId int OUT,	
		 --@OrderNo NVARCHAR(MAX) = NULL,
         @ComUnitId INT = NULL,
         @ComUnitCode NVARCHAR(MAX) = NULL,
         @ComUnitName NVARCHAR(MAX) = NULL,
         @MIOCode NVARCHAR(MAX) = NULL,
         @MIOName NVARCHAR(MAX) = NULL,
         @ManufacId INT = NULL,
         @CustomerCode NVARCHAR(MAX) = NULL,
         @CustomerName NVARCHAR(MAX) = NULL,
         @GrossValue DECIMAL(18,2)=NULL,
         @SubmissionDate DATETIME=NULL,
         @IsManual  BIT=NULL,
         @IsInvoice  BIT=NULL,
         @RegionId INT = NULL,
         @AreaId INT = NULL,
         @TerritoryId INT = NULL,
         @MarketId INT = NULL,
         @CustomerMasterId INT = NULL,
         @RSMId INT = NULL,
         @ASMId INT = NULL,
         @MIOId INT = NULL,
         @EntryBy NVARCHAR(50) = NULL,
         @EntryDate DATETIME=NULL,
         @ActionStatus NVARCHAR(50) = NULL,
         @IsSpecialApproval  BIT=NULL,
         @ApprovedBy NVARCHAR(50) = NULL,
         @ApprovedDate DATETIME=NULL
		
	
	)
AS
BEGIN
	  

	DECLARE @yearText NVARCHAR(MAX)= SUBSTRING( CONVERT(NVARCHAR(MAX),YEAR(@SubmissionDate)), 3, 3)   
	DECLARE @monthText NVARCHAR(MAX)=(CASE WHEN  LEN(MONTH(@SubmissionDate))=1 THEN '0'+CONVERT(NVARCHAR(MAX),MONTH(@SubmissionDate)) ELSE CONVERT(NVARCHAR(MAX),MONTH(@SubmissionDate)) END)
	DECLARE @dateText NVARCHAR(MAX)=(CASE WHEN  LEN(DAY(@SubmissionDate))=1 THEN '0'+CONVERT(NVARCHAR(MAX),DAY(@SubmissionDate)) ELSE CONVERT(NVARCHAR(MAX),DAY(@SubmissionDate)) END)

	DECLARE @OrderNo NVARCHAR(MAX)
	SELECT @OrderNo ='ODR-'+(@yearText+@monthText+@dateText)+CONVERT(NVARCHAR(MAX),CONVERT(INT,ISNULL(MAX(SUBSTRING(OrderCode,11,6)),10000))+1)  FROM tblOrder 
	WHERE SubmissionDate = @SubmissionDate



	  --DECLARE @OrderNo NVARCHAR(MAX)
	  --SELECT @OrderNo='ODR-'+CONVERT(NVARCHAR(MAX),YEAR(GETDATE()))+ CONVERT(NVARCHAR(MAX),(ISNULL((MAX(CONVERT(INT,SUBSTRING(OrderCode,4,11)) )),0)+1)) FROM dbo.tblOrder WHERE YEAR(EntryDate)=YEAR(GETDATE())
	  
     INSERT INTO dbo.tblOrder
     (
         OrderCode,
         ComUnitId,
         ComUnitCode,
         ComUnitName,
         MIOCode,
         MIOName,
         ManufacId,
         CustomerCode,
         CustomerName,
         GrossValue,
         SubmissionDate,
         IsInvoice,
         IsManual,
         RegionId,
         AreaId,
         TerritoryId,
         MarketId,
         CustomerMasterId,
         RSMId,
         ASMId,
         MIOId,
         EntryBy,
         EntryDate,
		 ActionStatus,
         IsSpecialApproval,
         ApprovedBy,
         ApprovedDate       
     )
     VALUES
     (   @OrderNo ,
         @ComUnitId ,
         @ComUnitCode ,
         @ComUnitName ,
         @MIOCode ,
         @MIOName ,
         @ManufacId ,
         @CustomerCode ,
         @CustomerName ,
         @GrossValue ,
         @SubmissionDate ,
		 @IsInvoice,
         @IsManual,       
         @RegionId,
         @AreaId,
         @TerritoryId,
         @MarketId,
         @CustomerMasterId,
         @RSMId,
         @ASMId,
         @MIOId,
         @EntryBy,
         @EntryDate,
         @ActionStatus,
         @IsSpecialApproval,
         @ApprovedBy,
         @ApprovedDate
     )
           
           
           
     SET @OrderId = SCOPE_IDENTITY()     

END


