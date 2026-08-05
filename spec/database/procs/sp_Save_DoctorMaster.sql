-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorMaster]
	-- Add the parameters for the stored procedure here

		 

		   @DoctorId int 
      ,@SecondaryCode  nvarchar(max)=null
      ,@DesignationId int=null
	  ,@Gender  nvarchar(max)=null
      ,@DoctorName nvarchar(max)=null
	  ,@IsActive  bit=null
      ,@Activedate   datetime=null
      ,@InactiveDate   datetime=null
      ,@EntryBy  int=null
	  ,@DivisionId  int=null
      ,@DistrictId  int=null
      ,@ThanaId  int=null
	  ,@UPCode nvarchar(max)=null
      ,@DoctorTypeId  int=null
      
      ,@MarketId  int=null
      ,@UnionName  nvarchar(max)=null
      ,@Reamrks  nvarchar(max)=null
      ,@StationTypeId   int=null,
	  @ProgramTypeId   int=null,
	  @DoctorCategoryId   int=null,
	  @SMCTypeId   int=null


AS
BEGIN
	

	  DECLARE @CustCode NVARCHAR(MAX)
	DECLARE @CustCodeint INT
SELECT  @CustCodeint=Max(CONVERT(INT,SUBSTRING(DoctorCode,2,LEN(DoctorCode)+1)))+1 FROM dbo.tblDoctorMaster WHERE ApprovalStatus='2' 
--ORDER BY DoctorId DESC
SET @CustCode='D'+CONVERT(NVARCHAR(MAX),@CustCodeint)

PRINT @CustCode
	   
 --     declare @CustomerCode nvarchar(max)
	--select @CustomerCode=MAX(ISNULL(DoctorCode,1000))+1 from tblDoctorMaster where  ApprovalStatus='2'


	INSERT INTO tblDoctorMaster
           (  DoctorName
      ,[DoctorCode]
      
      ,[SecondaryCode]
      ,[DesignationId]
    
      ,[Gender]
   
   
       
      ,[IsActive]
      ,[Activedate]
      ,[EntryBy]
      ,[EntryDate]
      
      ,[DivisionId]
      ,[DistrictId]
      ,[ThanaId]
      ,[IsFromApp]
      ,[ApprovalStatus]
       
      ,[UPCode]
      ,[DoctorTypeId]
      
      ,[MarketId]
      ,[UnionName]
      ,[Reamrks]
      ,[StationTypeId],ProgramTypeId,DoctorCategoryId,InactiveDate, SMCTypeId)
     VALUES
           (  @DoctorName 
      ,@CustCode 
      
      ,@SecondaryCode 
      ,@DesignationId 
    
      ,@Gender 
   
   
       
      ,@IsActive 
      ,@Activedate 
      ,@EntryBy 
      ,GETDATE() 
      
      ,@DivisionId 
      ,@DistrictId 
      ,@ThanaId 
      ,0 
      ,'2' 
       
      ,@UPCode 
      ,@DoctorTypeId 
     
      ,@MarketId 
      ,@UnionName 
      ,@Reamrks 
      ,@StationTypeId ,@ProgramTypeId,@DoctorCategoryId,@InactiveDate,@SMCTypeId
           )

	  SELECT SCOPE_IDENTITY()

END

