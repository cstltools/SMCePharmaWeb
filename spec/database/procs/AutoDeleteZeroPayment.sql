

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoDeleteZeroPayment]
	-- Add the parameters for the stored procedure here
	

AS
BEGIN
		 
	delete  from [dbo].[tblCustPayDetail] where [TPAmount]=0 and [VATAmount]=0 and [custPaymentDate] between '1-july-2024' and '1-july-2029'
END



