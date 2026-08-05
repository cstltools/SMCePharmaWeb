

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Product_ForTargetSetup_DDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		 
		SELECT ProductId,ProductCode+' ; '+ProductName + case when IsActive=1 then '' else ' (Inactive)' end ProductName FROM dbo.tblProduct  with (nolock) WHERE ProductGroupId = 1  --and IsActive=1

END



