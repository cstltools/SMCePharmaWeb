create PROCEDURE [dbo].[sp_SAP_Save_StoInfo]
	-- Add the parameters for the stored procedure here
 @OutboundDeliveryID nvarchar(max)=null
           ,@OBDDate date=null
           ,@OBDTime nvarchar(max)=null
           ,@PO_NUMBER nvarchar(max)=null
           ,@ItemLineNo nvarchar(max)=null
           ,@ItemCode nvarchar(max)=null
           ,@Batch nvarchar(max)=null
           ,@ExpDate date=null
           ,@Unit nvarchar(max)=null
           ,@Quantity nvarchar(max)=null
           ,@IssuingOffice nvarchar(max)=null
           ,@ReceivingPlant nvarchar(max)=null
           ,@PO_ITEM nvarchar(max)=null
           ,@StorageLoc nvarchar(max)=null
  
AS
    BEGIN

INSERT INTO [dbo].[tblSAP_StoInfo]
           ([OutboundDeliveryID]
           ,[OBDDate]
           ,[OBDTime]
           ,[PO_NUMBER]
           ,[ItemLineNo]
           ,[ItemCode]
           ,[Batch]
           ,[ExpDate]
           ,[Unit]
           ,[Quantity]
           ,[IssuingOffice]
           ,[ReceivingPlant]
           ,[PO_ITEM]
           ,[StorageLoc])
     VALUES
           (@OutboundDeliveryID 
           ,@OBDDate 
           ,@OBDTime 
           ,@PO_NUMBER 
           ,@ItemLineNo 
           ,@ItemCode 
           ,@Batch 
           ,@ExpDate 
           ,@Unit 
           ,@Quantity 
           ,@IssuingOffice 
           ,@ReceivingPlant 
           ,@PO_ITEM 
           ,@StorageLoc )
    End

