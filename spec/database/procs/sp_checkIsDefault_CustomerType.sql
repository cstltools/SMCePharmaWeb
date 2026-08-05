

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_checkIsDefault_CustomerType]
	-- Add the parameters for the stored procedure here
	  @id  INT  
AS
BEGIN
		 
		SELECT * FROM dbo.tblCustomerType WHERE IsDefault=1 AND    CustomerTypeId NOT IN ( @id)

END



