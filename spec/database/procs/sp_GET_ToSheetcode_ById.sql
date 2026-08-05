

 CREATE PROCEDURE [dbo].[sp_GET_ToSheetcode_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN
	SELECT 'Code: ' +TopSheetGenCode+ isnull(', Delivery Man: '+DeliveryMan,'')  TopSheetGenCode FROM dbo.tblTopSheetGenReport mas


	  where mas.TopSheetGenReportId = @id
      
    END


