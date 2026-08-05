
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Delete_OrderDetail]
	-- Add the parameters for the stored procedure here
@OrderId INT
AS
BEGIN
	execute sp_Webapi_Update_OrderMaster
	@orderid=@OrderId
	DELETE FROM dbo.tblOrderDetail WHERE OrderId=@OrderId
	

END


