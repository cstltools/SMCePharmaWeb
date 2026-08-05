CREATE PROCEDURE [dbo].[sp_SAP_Save_StockMovementMaster]
	-- Add the parameters for the stored procedure here
 
 @challan_code  nvarchar(max)= NULL ,
            @challan_date  date= NULL ,
            @is_from_wharehouse  bit= NULL ,
            @from_plant_code  nvarchar(max)= NULL ,
            @to_plant_code  nvarchar(max)= NULL ,
            @truck_no  nvarchar(max)= NULL ,
            @driver_name  nvarchar(max)= NULL 
  
AS
    BEGIN
	set @is_from_wharehouse=1

	BEGIN TRY
    IF   (@from_plant_code > 0)
    BEGIN
         set @is_from_wharehouse=0
    END
    ELSE
    BEGIN
         set @is_from_wharehouse=1
    END
END TRY
BEGIN CATCH
    -- Handle the exception
     set @is_from_wharehouse=1
END CATCH



	INSERT INTO SAP_API_Data..[tblSAP_StockMovementMaster]
           ([challan_code]
           ,[challan_date]
           ,[is_from_wharehouse]
           ,[from_plant_code]
           ,[to_plant_code]
           ,[truck_no]
           ,[driver_name]
           ,[entryDate])
     VALUES
           (@challan_code 
           ,@challan_date 
           ,@is_from_wharehouse 
           ,@from_plant_code 
           ,@to_plant_code 
           ,@truck_no 
           ,@driver_name 
           ,getdate())


			select  SCOPE_IDENTITY()

		
	  
    End

