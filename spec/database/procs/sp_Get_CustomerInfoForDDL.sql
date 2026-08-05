
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_CustomerInfoForDDL]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	
	SELECT CustomerMasterId,  CustomerName  FROM dbo.tblCustMaster j WHERE j.CustomerTypeId=2 

END


