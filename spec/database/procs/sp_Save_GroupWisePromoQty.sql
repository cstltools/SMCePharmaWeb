-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_GroupWisePromoQty]
	-- Add the parameters for the stored procedure here
	 

@Year  INT,
@Month  nvarchar(max),
@PromoGroupId  INT,
@Qty  decimal(18,0),
 
@MIOId  INT,
@EmpInfoId  INT ,
@EntryBy  INT ,
@ProductId  INT ,
@TerritoryId  INT 
AS
    BEGIN



	 


	 declare @CountData int
SELECT @CountData=ISNULL(COUNT(*),0) FROM dbo.[tblGroupWisePromoQty] WHERE [Year]=@Year and Month=@Month and EmpInfoId=@EmpInfoId AND ProductId=@ProductId

print @CountData
 IF(@CountData=0)
 BEGIN 
  declare @AllocationCode nvarchar(max)
	select  @AllocationCode='AL-'+CAST( ISNULL(MAX(GWPromoQtyId),0)+1001 as nvarchar(max)) from [tblGroupWisePromoQty]

	print @AllocationCode
	INSERT INTO [dbo].[tblGroupWisePromoQty]
           ([Year]
           ,[Month]
           ,[PromoGroupId]
           ,[Qty]
           ,[Date]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[ProductId]
           ,[MIOId]
           ,[EmpInfoId]
           ,[AllocationCode]
           ,[TerritoryId]
           ,[TransactionQTY])
     VALUES
           (@Year 
           ,@Month 
           ,@PromoGroupId 
           ,@Qty
           ,GETDATE()
           ,@EntryBy
           ,GETDATE()
          
           ,@ProductId 
           ,@MIOId 
           ,@EmpInfoId 
           ,@AllocationCode
           ,@TerritoryId 
           ,@Qty )
 
 DECLARE @PromosId INT
 SELECT  @PromosId=SCOPE_IDENTITY()
 SELECT @PromosId

 --EXEC sp_I_GWPStock
 -- @PromoId=@PromosId
 

 END
END

