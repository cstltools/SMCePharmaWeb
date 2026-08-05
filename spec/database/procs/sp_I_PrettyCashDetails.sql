-- =============================================
-- Author: <Author,Tareq>
-- Create date: <Create Date,18/08/2010,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_PrettyCashDetails] 

 @PettyCashDetailsId int out,
 @PettyCashmasterId INT,
 @PerticulerId Int,
 @CashReason NVARCHAR(MAX),
 @Amount DECIMAL(18,2)



AS
BEGIN
	
	--Insert into Stock Out

	INSERT INTO	tblPettyCashDetails(PettyCashmasterId,PerticulerId,CashReason,Amount) 
	VALUES (@PettyCashmasterId,@PerticulerId,@CashReason,@Amount)

	  
set @PettyCashDetailsId =SCOPE_IDENTITY()     
	
	
END


