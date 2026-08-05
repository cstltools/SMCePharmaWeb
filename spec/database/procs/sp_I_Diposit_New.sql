
CREATE PROCEDURE [dbo].[sp_I_Diposit_New] 
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
			  @MIOId int,
			  @CheckNumber NVARCHAR(500),
			  @CheckDate datetime,
			  @AccountName NVARCHAR(500),
			  @DepositCode NVARCHAR(500),
	              @IsExcelUpload bit 

	)
AS
BEGIN
	  
	  
	  select @DepositCode= com.ComUnitCode+ '-' + FORMAT(getdate(),'ddMMyyyy') + '-' +CONVERT( nvarchar(max) ,max(UNT.DepositId)+100   )   from tblCompanyWiseDeposit  UNT with (nolock)
		inner join tblCompanyUnit  com  with (nolock) on com.ComUnitId=UNT.CompanyId
	     where  UNT.CompanyId=@CompanyId

		 group by com.ComUnitCode
	     
	    DECLARE @CheckCount int = 0
	 --SELECT @CheckCount=COUNT(*) from tblCompanyWiseDeposit where Remarks=@Remarks and  CONVERT(date, EntryDate) =  CONVERT(date, @EntryDate)
	 
	  if	(@CheckCount=0)
	 BEGIN
	 DECLARE 
        @EmployeeId INT = 0,
        @EmpMasterCode NVARCHAR(MAX) = '', 
        @EmpName NVARCHAR(MAX) = '', 
        @TerritoryId int = 0, 
        @TerritoryCode NVARCHAR(MAX) = '', 
        @TerritoryName NVARCHAR(MAX) = '' ,
        @SAP_MIOCode_ NVARCHAR(MAX) = '' 


	SELECT @SAP_MIOCode_=   mas.SAP_MIOCode,  @EmployeeId= mas.EmployeeId, @EmpMasterCode=emp.EmpMasterCode, @EmpName=  emp.EmpName , @TerritoryId=mas.TerritoryId, @TerritoryCode=tr.TerritoryCode,@TerritoryName=tr.TerritoryName      FROM dbo.tblMIOInfo mas  with(nolock)
		INNER JOIN dbo.tblEmpGeneralInfo emp ON mas.EmployeeId=emp.EmpInfoId
		INNER JOIN dbo.tblTerritory tr ON mas.TerritoryId=tr.TerritoryId

	 
	  where mas.mioId=@MIOId

	  if(@MIOId=188888888)
	  begin
	set  @EmpMasterCode='N/A -'+@EntryBy;
	set  @EmpName='N/A -'+@EntryBy;
	set  @TerritoryCode='N/A -'+@EntryBy;
	set  @TerritoryName='N/A -'+@EntryBy;

	  end


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
				 AIT,EmployeeId, EmpMasterCode, EmpName, TerritoryId, TerritoryCode, TerritoryName,mioId, SAP_MIOCode_,DepositCode
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
				 @AIT,@EmployeeId, @EmpMasterCode, @EmpName, @TerritoryId, @TerritoryCode, @TerritoryName,@mioId,@SAP_MIOCode_,@DepositCode
	          )
	  
     set @DepositId =SCOPE_IDENTITY()     
	END
END
