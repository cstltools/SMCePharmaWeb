-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorCustomer_Active]
	-- Add the parameters for the stored procedure here

AS
BEGIN

		SELECT CustomerMasterId,CustomerCode + ':' + CustomerName AS Customer 
		FROM SalesRollDB_ZAS..tblCustMaster WHERE IsActive = 1

END


