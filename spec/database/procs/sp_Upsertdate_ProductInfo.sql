
CREATE PROCEDURE [dbo].[sp_Upsertdate_ProductInfo]
	-- Add the parameters for the stored procedure here
	@product_id nvarchar(max) ,
	@product_code nvarchar(max) ,
	@status nvarchar(max) ,
	@UpdateBy nvarchar(max)  

AS
BEGIN

declare @ProductId int=0
select @ProductId= isnull(max(ProductId),0)+1 from tblProduct   


DECLARE 
    @ProductCode NVARCHAR(50) = '',
    @ProductName NVARCHAR(100) = '',
    @Description NVARCHAR(255) = '',
    @ProductBrandId INT = 0,
    @PackSizeId INT = 0,
    @PackSize NVARCHAR(50) = '',
    @ProTypeId INT = 0,
    @CategoryId INT = 0,
    @ManufacId INT = 0,
    @StockUOMId INT = 0,
    @CaseId INT = 0,
    @GroupId INT = 0,
    @CompanyId INT = 0,
    @ProductType NVARCHAR(50) = '',
    @CategoryId1 INT = 0,
    @ShippingCartonSizeId INT = 0,
    @GenericGroupId INT = 0,
    @TherapueticGroupId INT = 0,
    @EntryBy NVARCHAR(50) = '',
    @EntryDate DATETIME = GETDATE(),
    @ProductGroupId INT = 0,
    @ProductLineID INT = 0,
    @SAP_Code NVARCHAR(50) = '';

	
  select  @ProductCode=CAST(CAST(pro.product_code AS BIGINT) AS VARCHAR(20))  ,@ProductName=  product_name ,@Description= description , @CategoryId=cat.CategoryId,  @PackSize=ps.PackSizeName, @PackSizeId= ps.PackSizeId,
  
 @ManufacId=1, @GroupId= pg.GroupId,@CompanyId=1, @StockUOMId=um.StockUOMId from SAP_API_Data..tblProduct pro with (nolock)
LEFT JOIN dbo.tblProCategory  cat  with (nolock) ON pro.category_code = cat.CategorySAPCode
 LEFT JOIN dbo.tblPackSize ps with (nolock) ON pro.pack_size_code=ps.PackSizeSAPCode 
 
 LEFT JOIN dbo.tblProductGroup pg with (nolock) ON pro.group_code=pg.GroupSAPCode
 LEFT JOIN dbo.tblStockUOM um with (nolock) ON pro.sales_uom_code=um.UOMSAPCode  

	  where  pro.product_id=@product_id	   

	    update SAP_API_Data..tblProduct set    Is_EpharmaSystemUpdate=1    

	  where  product_id=@product_id	   


INSERT INTO [dbo].[tblProduct]
           ([ProductId]
           ,[ProductCode]
           ,[ProductName]
           ,[Description]
           ,[ProductBrandId]
           ,[PackSizeId]
           ,[PackSize]
           ,[ProTypeId]
           ,[CategoryId]
           ,[ManufacId]
           ,[StockUOMId]
           ,[CaseId]
           ,[GroupId]
           ,[CompanyId]
           ,[ProductType]
           ,[CategoryId1]
           ,[ShippingCartonSizeId]
           ,[GenericGroupId]
           ,[TherapueticGroupId]
           ,[EntryBy]
           ,[EntryDate] 
           ,[ProductGroupId]
           ,[IsActive]
           ,[ProductLineID]
           ,[SAP_Code])
     VALUES
           (@ProductId 
           ,@ProductCode 
           ,@ProductName 
           ,@Description 
           ,@ProductBrandId 
           ,@PackSizeId 
           ,@PackSize 
           ,@ProTypeId 
           ,@CategoryId 
           ,@ManufacId 
           ,@StockUOMId 
           ,@CaseId 
           ,@GroupId 
           ,@CompanyId 
           ,@ProductType 
           ,@CategoryId1 
           ,@ShippingCartonSizeId 
           ,@GenericGroupId 
           ,@TherapueticGroupId 
           ,@EntryBy 
           ,@EntryDate
        
        
           ,@GroupId 
           ,1
           ,@ProductLineID 
           ,@ProductCode )


					DECLARE @Id INT
        SELECT  @Id=SCOPE_IDENTITY()


		 INSERT INTO [dbo].tblProductDCDetails
           (ProductId
           ,ComUnitId)
     select  @Id
           ,ComUnitId from tblProductDCDetails where  ProductId=261

END
             

			  