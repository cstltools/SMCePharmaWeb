-- =============================================
-- Author: <Author,Tareq>
-- Create date: <Create Date,18/08/2010,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_PrettyCashMaster] 


@PettyCashmasterId int out,
@ConpanyId int ,
@PostingDate DateTime ,
@CashAccId int ,
@Remark Nvarchar(Max) ,
@EntryBy NVARCHAR(50) ,
@EntryDate DateTime ,
@ActiveStatus NVARCHAR(50)




AS
BEGIN
	
	--Insert into Stock Out

	INSERT INTO	tblPettyCashMaster(ConpanyId,PostingDate,CashAccId,Remark,EntryBy,EntryDate,ActiveStatus) 
	VALUES (@ConpanyId,@PostingDate,@CashAccId,@Remark,@EntryBy,@EntryDate,@ActiveStatus)

	  
set @PettyCashmasterId =SCOPE_IDENTITY()     
	
	
END

