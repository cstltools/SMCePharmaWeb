
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Product_For_DDl]
	-- Add the parameters for the stored procedure here
@Parameter NVARCHAR(50)
AS
BEGIN
	
	SELECT CustomerMasterId, CustomerCode, CustomerName  FROM dbo.tblCustMaster j WHERE (j.CustomerCode) LIKE  '%@Parameter%'  

END


