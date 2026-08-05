

 CREATE PROCEDURE [dbo].[sp_GET_BAnkInfoById_ByIdAcc]
	-- Add the parameters for the stored procedure here
   @AccNo NVARCHAR(max),
   @CompanyId NVARCHAR(max)


AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  case when  bankName='Nagad' then  'N/A'  when  bankName='Bkash' then  'N/A'  else '' end chkAccNo,  * from tblBankInfoNew where IsActive=1 and BankAccountNumber = @AccNo and ComUnitId=@CompanyId
      
    END


