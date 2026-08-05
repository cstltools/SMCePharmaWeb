
--------------------------------------------------
-- PROCEDURE: sp_GET_da_BankList
--------------------------------------------------
 CREATE   PROCEDURE [dbo].[sp_GET_da_BankList]
	-- Add the parameters for the stored procedure here
   @daid int=0

AS
    BEGIN


select BankId, DisplayBankName BankName from tblBankInfo

end
