-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_PROMOOpeningBalanceProcess] 
	
AS
BEGIN
	

	declare @CSOpeningBalanceDate datetime

	set @CSOpeningBalanceDate = Getdate()



	

	   DECLARE @GWPromoQtyId INT
	   DECLARE @Year INT
	   DECLARE @Month nvarchar(500)
       DECLARE @PromoGroupId INT
       DECLARE @Qty decimal(18,0)
       DECLARE @Date datetime
       DECLARE @EntryBy nvarchar(500)
       DECLARE @EntryDate datetime
       DECLARE @UpdateBy nvarchar(500)
       DECLARE @UpdateDate datetime
       DECLARE @ProductId int
       DECLARE @MIOId int
       DECLARE @EmpInfoId int
       DECLARE @AllocationCode nvarchar(max)
       DECLARE @TerritoryId int
       DECLARE @TransactionQTY decimal(18,0)
     


DECLARE db_cursor CURSOR FOR 

SELECT [GWPromoQtyId]
      ,[Year]
      ,[Month]
      ,[PromoGroupId]
      ,[Qty]
      ,[Date]
      ,[EntryBy]
      ,[EntryDate]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[ProductId]
      ,[MIOId]
      ,[EmpInfoId]
      ,[AllocationCode]
      ,[TerritoryId]
      ,[TransactionQTY]
  FROM [dbo].[tblGroupWisePromoQty]

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO  @GWPromoQtyId 
      ,@Year 
      ,@Month 
      ,@PromoGroupId 
      ,@Qty 
      ,@Date 
      ,@EntryBy 
      ,@EntryDate 
      ,@UpdateBy 
      ,@UpdateDate 
      ,@ProductId 
      ,@MIOId 
      ,@EmpInfoId 
      ,@AllocationCode 
      ,@TerritoryId 
      ,@TransactionQTY 
  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      INSERT INTO dbo.tblGroupWisePromoQty_OpeningBalanceProcess
	           ( [ProcessDate]
      ,[GWPromoQtyId]
      ,[Year]
      ,[Month]
      ,[PromoGroupId]
      ,[Qty]
      ,[Date]
      ,[EntryBy]
      ,[EntryDate]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[ProductId]
      ,[MIOId]
      ,[EmpInfoId]
      ,[AllocationCode]
      ,[TerritoryId]
      ,[TransactionQTY]
	           )
	   VALUES  ( CONVERT(nvarchar(11),@CSOpeningBalanceDate,106) , -- CSOpeninigBalanceDate - datetime
	              @GWPromoQtyId 
      ,@Year 
      ,@Month 
      ,@PromoGroupId 
      ,@Qty 
      ,@Date 
      ,@EntryBy 
      ,@EntryDate 
      ,@UpdateBy 
      ,@UpdateDate 
      ,@ProductId 
      ,@MIOId 
      ,@EmpInfoId 
      ,@AllocationCode 
      ,@TerritoryId 
      ,@TransactionQTY 
   
	           )
	  
      FETCH NEXT FROM db_cursor INTO  @GWPromoQtyId 
      ,@Year 
      ,@Month 
      ,@PromoGroupId 
      ,@Qty 
      ,@Date 
      ,@EntryBy 
      ,@EntryDate 
      ,@UpdateBy 
      ,@UpdateDate 
      ,@ProductId 
      ,@MIOId 
      ,@EmpInfoId 
      ,@AllocationCode 
      ,@TerritoryId 
      ,@TransactionQTY 
  
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 




END
