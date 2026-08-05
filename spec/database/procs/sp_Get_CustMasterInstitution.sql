-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_CustMasterInstitution]
	-- Add the parameters for the stored procedure here

AS
BEGIN

	SELECT 'Code: '+ CustomerCode  +  ', Name:' +CustomerName + ', Address: '+Address CustomerName, * FROM dbo.tblCustMaster  WHERE CustomerTypeId=2

END


