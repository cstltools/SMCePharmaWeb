
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_GetOrderInvoiceIsZero]
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN

select OrderCode,OrderId from tblorder  WITH (NOLOCK)   where IsInvoice=0

		  
END


