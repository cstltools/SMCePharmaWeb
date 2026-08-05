-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Deletenvoice]
	@OrderID int
AS
BEGIN
 --delete from tblInvoice where OrderId=@OrderID
 --update tblOrder set IsInvoice=0 where OrderId=@OrderID
 delete Invoice

END
