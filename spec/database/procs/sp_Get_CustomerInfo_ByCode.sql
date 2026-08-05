
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_CustomerInfo_ByCode]
	-- Add the parameters for the stored procedure here
@Parameter NVARCHAR(50)
AS
BEGIN
	
	SELECT CustomerMasterId, CustomerCode, CustomerName  FROM dbo.tblCustMaster j WHERE j.CustomerTypeId=2 and  j.CustomerCode = @Parameter Or J.CustomerName = @Parameter

END


