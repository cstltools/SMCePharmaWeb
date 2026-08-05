CREATE PROCEDURE [dbo].[sp_Save_FinancialYearInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
   
	@YearFromDate datetime,
	@YearTodate datetime,
    @EntryBy INT ,
    @IsActive BIT 

AS
    BEGIN
	
				 

  
  DECLARE @FinancialCode NVARCHAR(MAX)
	DECLARE @FinancialYearDesc NVARCHAR(MAX)
	SELECT @FinancialYearDesc=(CONVERT(CHAR(4),YEAR(@YearFromDate)))+'-'+(CONVERT(CHAR(4),YEAR(@YearTodate))) 
	
	DECLARE @CheckCount int = 0
	 SELECT @CheckCount=COUNT(*) from tblFiscalYearInfos where FiscalYearDesc=@FinancialYearDesc AND CompanyId=1
	 
	  if	(@CheckCount=0)
	 BEGIN
	
 
		SELECT @FinancialCode=(CONVERT(NVARCHAR(MAX),(COUNT(FiscalYearId)+001))) FROM dbo.tblFiscalYearInfos 
		
		insert into tblFiscalYearInfos (FinancialCode,YearFromDate,YearTodate,CompanyId,IsActive,FiscalYearDesc,EntryBy
           ,EntryDate) 
                                   values (@FinancialCode,@YearFromDate,@YearTodate,1,@IsActive,@FinancialYearDesc, @EntryBy,
		   GETDATE())
	                                   
		SELECT SCOPE_IDENTITY()
	 
End
 
    END
	 
