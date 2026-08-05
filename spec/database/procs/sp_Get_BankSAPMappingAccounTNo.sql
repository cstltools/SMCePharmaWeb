create PROCEDURE [dbo].[sp_Get_BankSAPMappingAccounTNo]
	-- Add the parameters for the stored procedure here
	@BankAccNo nvarchar(max)  

AS
BEGIN


  
  select BankAccNo BankAccNo from tblBankSAPMapping  where  BankAccNo=@BankAccNo

  end 

			  