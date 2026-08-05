

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_CustomerType]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
    @CustomerType   NVARCHAR(MAX) 
AS
BEGIN
		 
		SELECT * FROM dbo.tblCustomerType WHERE CustomerType=@CustomerType AND    CustomerTypeId NOT IN ( @id)

END



