-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_I_ProductGl] 


AS
BEGIN
	
	DECLARE @ProductId INT
	DECLARE @CompanyId INT
    Declare @ProductCode nvarchar(250)  
    Declare @ProductName NVARCHAR(MAX)
            
    --------------------------------------------------------
    DECLARE @MyCursor CURSOR
    SET @MyCursor = CURSOR FAST_FORWARD
    FOR
    ---------------

	SELECT PD.ProductId,PD.CompanyId,PD.ProductCode,PD.ProductName FROM dbo.tblProduct AS PD
	LEFT JOIN dbo.tblUnitPrice AS UP ON UP.ProductId = PD.ProductId
	WHERE UP.IsActive = 1 AND PD.ProductId NOT IN (SELECT GL.ProductId FROM ZAS_ACCDB..tblChartOfAccounts AS GL WHERE GL.ProductId IS NOT NULL)

    ----------
    OPEN @MyCursor
    FETCH NEXT FROM @MyCursor
    INTO @ProductId,@CompanyId,@ProductCode,@ProductName
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
    
	DECLARE @SubsidiaryLId INT  
	DECLARE @AccountCode NVARCHAR(MAX)
	DECLARE @SubsidiryLCode NVARCHAR(MAX)
	DECLARE @AccountName NVARCHAR(MAX)
	DECLARE @Description NVARCHAR(MAX)
	DECLARE @AccountId INT
	DECLARE @HasName INT = 0

	SET @AccountName = 'Code: ' + @ProductCode + ' ' + @ProductName
	SET @Description = 'Code: ' + @ProductCode + ' ' + @ProductName
	SET @SubsidiaryLId = 53

	SELECT @HasName=ISNULL(COUNT(*),0) from ZAS_ACCDB..tblChartOfAccounts
	WHERE AccountName = @AccountName

	IF(@HasName =0)
	BEGIN
		SELECT @AccountCode=(CONVERT(NVARCHAR(MAX),(COUNT(AccountId)+10001))) FROM ZAS_ACCDB..tblChartOfAccounts 
		
		SELECT @SubsidiryLCode = SubsubsidiryLCode FROM ZAS_ACCDB..tblSubsubsidiaryLadger WHERE SubSubsidiaryId = @SubsidiaryLId
		SET @AccountCode=@SubsidiryLCode+@AccountCode
		
		insert into ZAS_ACCDB..tblChartOfAccounts (AccountCode,Description,AccountName,SubsidiaryLId,CompanyId,CreateBy,CreateDate,IsActive,InBalanceSheet,InIncomeStatement,ProductId)
                                   values (@AccountCode,@Description,@AccountName,@SubsidiaryLId,0,'Auto Process',GETDATE(),'True','False','True',@ProductId)

		SET @AccountId = SCOPE_IDENTITY()

	     INSERT INTO ZAS_ACCDB..tblCOACompanyPermission (BankAccountId,CompanyId) VALUES (@AccountId, @CompanyId)                              
	END
	
    FETCH NEXT FROM @MyCursor
    INTO @ProductId,@CompanyId,@ProductCode,@ProductName 
    
    END
    CLOSE @MyCursor
    DEALLOCATE @MyCursor
	
END







