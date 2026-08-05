

CREATE PROCEDURE [dbo].[sp_UD_FinancialYearInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    
	@YearFromDate datetime,
	@YearTodate datetime,
    @UpdateBy INT ,
    @IsActive BIT 

AS
    BEGIN
			DECLARE @FinancialYearDesc NVARCHAR(MAX)
	SELECT @FinancialYearDesc=(CONVERT(CHAR(4),YEAR(@YearFromDate)))+'-'+(CONVERT(CHAR(4),YEAR(@YearTodate))) 
		UPDATE tblFiscalYearInfos 
		SET FiscalYearDesc = @FinancialYearDesc, YearFromDate=@YearFromDate, YearTodate=@YearTodate ,UpdateBy = @UpdateBy,UpdateDate = GETDATE(),IsActive = @IsActive 
		WHERE FiscalYearId =  @id
       

    END

