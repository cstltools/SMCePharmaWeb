
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Up_BonusProducttoZero]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
  update tblInvoiceDetail set UnitPrice=0 where ISGiftProduct=1 and UnitPrice>0 

END


