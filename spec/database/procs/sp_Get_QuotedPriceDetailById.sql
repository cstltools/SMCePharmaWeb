-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_QuotedPriceDetailById]
	-- Add the parameters for the stored procedure here
	   @id NVARCHAR(max)
AS
BEGIN
   
select '' DiscountShow, * from tblQuotedPriceDetail dtl  with (nolock)  
where  dtl.QuotedPriceMasterId=@id

--where pro.IsActive=1 and un.IsActive=1
END


