 
CREATE PROCEDURE [dbo].[sp_SAP_Save_SAPSTOMaster]
	-- Add the parameters for the stored procedure here
@ObdDeliveryID nvarchar(max)=null
           ,@OBDDate datetime=null
           ,@OBDTime nvarchar(max)=null
           ,@IssueingOffice nvarchar(max)=null
           ,@ReceivingPlant nvarchar(max)=null
           ,@PoNumber nvarchar(max)=null
          
AS
BEGIN
	

	INSERT INTO [dbo].[tblSAPSTOMaster_SAP]
           ([ObdDeliveryID]
           ,[OBDDate]
           ,[OBDTime]
           ,[IssueingOffice]
           ,[ReceivingPlant]
           ,[PoNumber]
           ,[EntryDate])
     VALUES
           (@ObdDeliveryID 
           ,@OBDDate 
           ,@OBDTime 
           ,@IssueingOffice 
           ,@ReceivingPlant 
           ,@PoNumber 
           ,getdate() )

		   declare @masId int =0

    set  @masId= SCOPE_IDENTITY()


	insert into SalesDisDB_SMC_NEWDB_LoadingSumm..tblRequisition  ([ReqNo] ,[ReqDate] ,[WarehouseId]  ,[WearhouseName] ,[ComUnitId]  ,[ComUnitCode]  ,[ComUnitName] ,[Submit]  ,[SubmitDate]  ,[IssueChalanNo] ,[IssuChalanDate]  ,[TruckNo] ,[DriverName] ,[TotalPrice]  ,[TotalVAT] ,[GrandTotalPrice] ,[ReceiveIssue]  ,[ReceiveIssueDate] ,[CreatePicking]
  ,[PickingNo]  ,[PickingDate] ,[ManufacId]  ,[EntryBy] ,[EntryDate] , SAPSTOMasterId)


		   select  mas.PoNumber,mas.OBDDate,1,'Central Wearhouse', 3, 'BD25','Chattogram Distribution Center','OK', mas.OBDDate, mas.PoNumber, mas.OBDDate,'', '',0,0,0,null, mas.OBDDate,0,   mas.PoNumber, mas.OBDDate,1,'Sap' , GETDATE(), @masId from   SalesDisDB_SMC_NEWDB..tblSAPSTOMaster_SAP mas  where mas.SAPSTOMasterId=  @masId

		   SELECT  @masId


END