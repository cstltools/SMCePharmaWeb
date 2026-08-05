
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_PrescriptionProductDetail]
	-- Add the parameters for the stored procedure here
	 
 
    --@PresDetailId INT OUT,
	@PrescriptionId INT= null  ,
    @ProductId  INT= null
	 

AS
    BEGIN
	
	INSERT INTO [dbo].[tbl_PrescriptionProductDetail]
           ([PrescriptionId]
           ,[ProductId])
     VALUES
           (@PrescriptionId
           ,@ProductId)
 

 SELECT SCOPE_IDENTITY()
	--SET @PresDetailId = SCOPE_IDENTITY()

END


