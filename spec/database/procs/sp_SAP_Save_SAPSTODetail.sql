CREATE PROCEDURE [dbo].[sp_SAP_Save_SAPSTODetail]
	-- Add the parameters for the stored procedure here
@pk int=null
           ,@ObdItemNo nvarchar(max)=null
           ,@ProductCode nvarchar(max)=null
           ,@Batch nvarchar(max)=null
           ,@ExpDate datetime=null
           ,@UoM nvarchar(max)=null
           ,@Quantity nvarchar(max)=null
           ,@PoItem nvarchar(max)=null
           ,@StorageLoc nvarchar(max)=null,
            @MfgDate datetime=null

 

AS
BEGIN
		
		INSERT INTO [dbo].[tblSAPSTODetail_SAP]
           ([SAPSTOMasterId]
           ,[ObdItemNo]
           ,[ProductCode]
           ,[Batch]
           ,[ExpDate]
           ,[UoM]
           ,[Quantity]
           ,[PoItem]
           ,[StorageLoc],MfgDate)
     VALUES
           (@pk 
           ,@ObdItemNo 
           ,@ProductCode 
           ,@Batch 
           ,@ExpDate 
           ,@UoM 
           ,@Quantity 
           ,@PoItem 
           ,@StorageLoc,@MfgDate )


		   declare @masId int=0

		   set @masId= SCOPE_IDENTITY()



		   
declare @massId int =0

select @massId=ReqId from  SalesDisDB_SMC_NEWDB_LoadingSumm..tblRequisition   where SAPSTOMasterId=@pk

		   insert into SalesDisDB_SMC_NEWDB_LoadingSumm..tblRequsitionChild  ([ProductCode]  ,[ProductName] ,[PackSize]  ,[ReqQty] ,[ReqId] ,[IssueQty] ,[UnitPrice] ,[PriceAmount]
      ,[VATAmount]  ,[TotalPrice] ,[IsIssue] ,[CaseQty]  ,[MusakVATAmount]  ,[MusakTotalPrice] ,[IsPicking]  ,[BatchNO] )


		   select pro.ProductCode, pro.ProductName,'30s',mas.Quantity, @massId, mas.Quantity,225.00,	31500.00,	5502.00,	37002.00,	'OK',	5,	0.00,	0.00,	'OK',null  from    SalesDisDB_SMC_NEWDB..tblSAPSTODetail_SAP mas

		   inner join  SalesDisDB_SMC_NEWDB..tblProduct pro on mas.ProductCode=pro.Sap_Code  where mas.SAPSTODetailId= @masId


		    declare @ReqChildId int=0

		   set @ReqChildId= SCOPE_IDENTITY()


		    insert into SalesDisDB_SMC_NEWDB_LoadingSumm..tblStockInTransfar  ([ReqId] ,[ReqChildId] ,[ProductCode]  ,[ProductName]  ,[PackSize]  ,[BatchNo]
           ,[Quantity]  ,[PickingQty]  ,[UnitPrice] ,[PriceAmount] ,[VATAmount] ,[TotalPriceAmount]  ,[ExpDate]
           ,[ReceiveDate] ,[IsTransfared]  ,[IsIssue] ,[ReceiveId]  ,[MfgDate]  ,[CompanyId])

		   select @massId, @ReqChildId,   pro.ProductCode, pro.ProductName,'30s',mas.Batch,mas.Quantity, mas.Quantity, 225.00,	31500.00,	5502.00,	37002.00, mas.ExpDate,GETDATE(), null, 'Ok', null, mas.MfgDate, 3	   from    SalesDisDB_SMC_NEWDB..tblSAPSTODetail_SAP mas

		   inner join  SalesDisDB_SMC_NEWDB..tblProduct pro on mas.ProductCode=pro.Sap_Code  where mas.SAPSTODetailId= @masId
		    

END

