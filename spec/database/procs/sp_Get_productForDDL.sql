
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_productForDDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	

	Select  p.ProductId, p.ProductName from tblProduct P
	LEFT JOIN tblUnitPrice Up On Up.ProductId = P.ProductId
	Where Up.IsActive = 1


END
