
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_tblMIATargetListNew]
	-- Add the parameters for the stored procedure here
	@MiaTargetId INT OUT,
	@MiaId INT,
	@CompanyId INT,
	@ProductId INT,
  
    @TargetQty DECIMAL =Null ,
  
 
	@MiaName NVARCHAR(max) =null,
    @Period NVARCHAR(50) =NULL,
    @Year NVARCHAR(50) =NULL,
	@EntryBy  NVARCHAR(50) =NULL
AS
    BEGIN
	
    

		   INSERT INTO [dbo].[tblMIATargetProductWise]
           ([MiaId]
           ,[MiaName]
           ,[TargetQty]
           ,[Period]
           ,[Year]
           ,[CompanyId]
           ,[ProductId],EntryBy,EntryDate)
     VALUES
           (@MiaId 
           ,@MiaName 
           ,@TargetQty 
           ,@Period 
           ,@Year 
           ,@CompanyId 
           ,@ProductId,@EntryBy,GETDATE() )

SELECT SCOPE_IDENTITY()

END


