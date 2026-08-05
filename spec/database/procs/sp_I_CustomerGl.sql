-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_CustomerGl] 

 @CustomerId INT,
 @SubsidiaryLId INT

AS
BEGIN
	
	DECLARE @CstmrId INT
    Declare @CstmrCode nvarchar(250)  
    Declare @CstmrName NVARCHAR(MAX)
            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT CustomerMasterId,CustomerCode,CustomerName FROM tblCustMaster WHERE CustomerMasterId = @CustomerId
    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @CstmrId ,
       @CstmrCode ,
       @CstmrName
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    
	DECLARE @AccountCode NVARCHAR(MAX)
	DECLARE @SubsidiryLCode NVARCHAR(MAX)
	DECLARE @AccountName NVARCHAR(MAX)
	DECLARE @Description NVARCHAR(MAX)
	DECLARE @AccountId INT
	DECLARE @HasName INT = 0

	SET @AccountName = 'Code: ' + @CstmrCode + ' ' + @CstmrName
	SET @Description = 'Code: ' + @CstmrCode + ' ' + @CstmrName

	SELECT @HasName=ISNULL(COUNT(*),0) from ZAS_ACCDB..tblChartOfAccounts
	WHERE AccountName = @AccountName

	IF(@HasName =0)
	BEGIN
		SELECT @AccountCode=(CONVERT(NVARCHAR(MAX),(COUNT(AccountId)+10001))) FROM ZAS_ACCDB..tblChartOfAccounts 
		
		SELECT @SubsidiryLCode = SubsubsidiryLCode FROM ZAS_ACCDB..tblSubsubsidiaryLadger WHERE SubSubsidiaryId = @SubsidiaryLId
		SET @AccountCode=@SubsidiryLCode+@AccountCode
		
		insert into ZAS_ACCDB..tblChartOfAccounts (AccountCode,Description,AccountName,SubsidiaryLId,CompanyId,CreateBy,CreateDate,IsActive,InBalanceSheet,InIncomeStatement,CustomerId)
                                   values (@AccountCode,@Description,@AccountName,@SubsidiaryLId,0,'Auto Process',GETDATE(),'True','False','True',@CstmrId)

		SET @AccountId = SCOPE_IDENTITY()

		INSERT INTO ZAS_ACCDB..tblCOACompanyPermission (BankAccountId,CompanyId) VALUES (@AccountId, 0)
	                                   
	END
	
    FETCH NEXT FROM @MyCursor
    INTO @CstmrId ,
       @CstmrCode ,
       @CstmrName  
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END






