

 CREATE PROCEDURE [dbo].[sp_GET_BAnkInfoById_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select  case when  bankName='Nagad' then  'N/A' else '' end chkAccNo,  * from tblBankInfoNew where IsActive=1 and BankId = @id
      
    END


