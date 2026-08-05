

 CREATE PROCEDURE [dbo].[sp_GET_BAnkInfoById_ByIdExcel]
	-- Add the parameters for the stored procedure here
   @BankAccNo NVARCHAR(max),
   @ComUnitId NVARCHAR(max)


AS
    BEGIN

	
	--FORMAT(FromDate,'dd MMM, yyyy HH:mm tt') FromDate,
	 Select    * from tblBankInfoNew where IsActive=1 and BankAccountNumber = @BankAccNo and ComUnitId=@ComUnitId
      
    END


