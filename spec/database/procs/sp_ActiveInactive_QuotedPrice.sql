


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_QuotedPrice]
	-- Add the parameters for the stored procedure here
    @Id INT,
	@InactiveBy INT

AS
    BEGIN

      UPDATE  [dbo].[tblProductQuotedPrice] SET  IsActive = 0 , ActiveInActiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  QuotedPriceId = @Id    

    END


