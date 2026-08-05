-- =============================================
-- Author:		<Author,Liton>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_I_Diposit] 
	(
	            @DepositId INT OUT,
		        @CompanyId int,
	            @BranchName NVARCHAR(500),
	          @Amount decimal(18,2),
			    @AIT decimal(18,2),
			  @EntryBy NVARCHAR(500),
			  @EntryDate datetime,
			  @DepositDate datetime,
			  @IsDelete bit,
			  @Remarks  NVARCHAR(500),
			  @DepositType NVARCHAR(500),
			  @BankId int,
			  @CheckNumber NVARCHAR(500),
			  @CheckDate datetime,
			  @AccountName NVARCHAR(500),
	              @IsExcelUpload bit
	)
AS
BEGIN
	  

	    DECLARE @CheckCount int = 0
	 --SELECT @CheckCount=COUNT(*) from tblCompanyWiseDeposit where Remarks=@Remarks and  CONVERT(date, EntryDate) =  CONVERT(date, @EntryDate)
	 
	  if	(@CheckCount=0)
	 BEGIN


	  INSERT INTO tblCompanyWiseDeposit
	          ( 
			    CompanyId ,
	            BranchName ,
	            Amount ,
	            Remarks ,
	            EntryBy ,
	            EntryDate ,
	            DepositDate ,
	            IsDelete ,
	            DepositType ,
	            AccountName ,
	            CheckNumber ,
	            CheckDate ,
	            BankId ,
				IsExcelUpload,
				 AIT
	          )
	  VALUES  (  
	            @CompanyId ,
	            @BranchName ,
	            @Amount ,
	            @Remarks ,
	            @EntryBy ,
	            @EntryDate ,
	            @DepositDate ,
	            @IsDelete ,
	            @DepositType ,
	            @AccountName ,
	            @CheckNumber ,
	            @CheckDate ,
	            @BankId ,
				'False',
				 @AIT
	          )
	  
     set @DepositId =SCOPE_IDENTITY()     
	END
END
