create PROCEDURE [dbo].[sp_webapi_SaveOrderDetail_Doctor]
	-- Add the parameters for the stored procedure here
    @orderid INT ,
    @productid INT ,
    @quantity DECIMAL(18, 2) 
    
AS
    BEGIN
		
       
		
      

		
        --SET @vatAmtPerUnit = ( ( @unitprice * @unitvatPercentage ) / 100 )
	 
        DECLARE @productCode NVARCHAR(max),@productName NVARCHAR(max)

        SELECT  @productCode = ProductCode,@productName=ProductName
        FROM    dbo.tblProduct
        WHERE   ProductId = @productid
	 


        INSERT  INTO dbo.tblOrderDetail_Doctorrequirement
                ( ProductId ,
                  Quantity ,
                  
                  OrderId  ,ProductName,ProductCode
		        )
        VALUES  ( @productid ,
                  @quantity ,@orderid,
                   @productName,@productCode
					
		        )

 
    END