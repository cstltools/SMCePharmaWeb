CREATE PROCEDURE [dbo].[sp_SAP_Save_StockMovementDetails]
	-- Add the parameters for the stored procedure here
 
 @pk int=null,
            @product_code nvarchar(50)=null,
            @batch_no nvarchar(50)=null,
            @quantity decimal(18,0)=null,
            @unit_price decimal(18,2)=null,
            @UOM nvarchar(50)=null,
            @unit_vat decimal(18,2)=null,
            @net_amount decimal(18,2)=null,
            @expiry_date date=null,
            @manufacturer_date date=null 
  
AS
    BEGIN


	DECLARE @CurrentDate DATE;
DECLARE @NewDate DATE;

-- Get the current date
SET @CurrentDate = GETDATE();

-- Add two years to the current date
SET @NewDate = DATEADD(YEAR, 2, @CurrentDate);

	if(@batch_no is null)
	begin
	set @batch_no='N/A'
	end

		if(@batch_no ='')
	begin
	set @batch_no='N/A'
	end
		if(@expiry_date is null)
	begin
	set @expiry_date=@NewDate
	end

	if(@manufacturer_date is null)
	begin
	set @manufacturer_date=@NewDate
	end

	INSERT INTO SAP_API_Data..[tblSAP_StockMovementDetail]
           ([StockMovementMasterId]
           ,[product_code]
           ,[batch_no]
           ,[quantity]
           ,[unit_price]
           ,[UOM]
           ,[unit_vat]
           ,[net_amount]
           ,[expiry_date]
           ,[manufacturer_date],Original_SAP_Stock)
     VALUES
           (@pk 
           ,@product_code 
           ,@batch_no 
           ,@quantity 
           ,@unit_price 
           ,@UOM 
           ,@unit_vat 
           ,@net_amount 
           ,@expiry_date 
           ,@manufacturer_date,@quantity)
		
	  
    End

