



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_FinancialYear]
	-- Add the parameters for the stored procedure here
    @Id  INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblFiscalYearInfos where FiscalYearId =   @Id

	IF @Flag = 1
        UPDATE  [dbo].[tblFiscalYearInfos] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  FiscalYearId =  @Id    
    ElSE
	    UPDATE  [dbo].[tblFiscalYearInfos] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  FiscalYearId =  @Id   
    END



