 CREATE PROCEDURE [dbo].[sp_Update_DoctorMaster]
	-- Add the parameters for the stored procedure here
   
		   @DoctorId int 
      ,@SecondaryCode  nvarchar(max)=null
      ,@DesignationId int=null
	  ,@Gender  nvarchar(max)=null
      ,@DoctorName nvarchar(max)=null
	  ,@IsActive  bit=null
      ,@Activedate   datetime=null
      ,@InactiveDate   datetime=null
      
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

	@UpdateBy int,
	  @SMCTypeId   int=null

   
AS
    BEGIN


	INSERT INTO [dbo].[tblDoctorMaster_Log]
           ([DoctorId]
           ,[DoctorCode]
           ,[DoctorName]
           ,[SecondaryCode]
           ,[DesignationId]
           ,[DegreeId]
           ,[Gender]
           ,[Speciality]
           ,[ProgramType]
           ,[Remarks]
           ,[IsActive]
           ,[Activedate]
           ,[EntryBy]
           ,[EntryDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[InactiveDate]
           ,[InactiveBy]
           ,[IsDelate]
           ,[DeleteBy]
           ,[DeleteDate]
           ,[DivisionId]
           ,[DistrictId]
           ,[ThanaId]
           ,[IsFromApp]
           ,[ApprovalStatus]
           ,[ApprovedBy]
           ,[ApprovedDate]
           ,[UPCode]
           ,[DoctorTypeId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[UnionName]
           ,[Reamrks]
           ,[StationTypeId]
           ,[ProgramTypeId]
           ,[DoctorCategoryId]
           ,[SpecialDayId]
           ,[SpeciaDateStr]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[OldCode]
           ,[LogBy]
           ,[LogDate])
SELECT [DoctorId]
           ,[DoctorCode]
           ,[DoctorName]
           ,[SecondaryCode]
           ,[DesignationId]
           ,[DegreeId]
           ,[Gender]
           ,[Speciality]
           ,[ProgramType]
           ,[Remarks]
           ,[IsActive]
           ,[Activedate]
           ,[EntryBy]
           ,[EntryDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[InactiveDate]
           ,[InactiveBy]
           ,[IsDelate]
           ,[DeleteBy]
           ,[DeleteDate]
           ,[DivisionId]
           ,[DistrictId]
           ,[ThanaId]
           ,[IsFromApp]
           ,[ApprovalStatus]
           ,[ApprovedBy]
           ,[ApprovedDate]
           ,[UPCode]
           ,[DoctorTypeId]
           ,[TerritoryId]
           ,[SubTerritoryId]
           ,[MarketId]
           ,[UnionName]
           ,[Reamrks]
           ,[StationTypeId]
           ,[ProgramTypeId]
           ,[DoctorCategoryId]
           ,[SpecialDayId]
           ,[SpeciaDateStr]
           ,[GroupId]
           ,[RegionId]
           ,[AreaId]
           ,[OldCode]
           ,@UpdateBy
           ,GETDATE()
FROM tblDoctorMaster
 WHERE   DoctorId = @DoctorId and ApprovalStatus='2'


        UPDATE  dbo.tblDoctorMaster
        SET     DoctorName=@DoctorName
       
      
      ,[SecondaryCode]=@SecondaryCode
      ,[DesignationId]=@DesignationId
    
      ,[Gender]=@Gender
   
   
       
      ,[IsActive]=@IsActive
      ,[Activedate]=@Activedate
      ,UpdateBy=@UpdateBy
      ,UpdateDate=GETDATE()
      
      ,[DivisionId]=@DivisionId
      ,[DistrictId]=@DistrictId
      ,[ThanaId]=@ThanaId
      
       
      ,[UPCode]=@UPCode
      ,[DoctorTypeId]=@DoctorTypeId
      
      ,[MarketId]=@MarketId
      ,[UnionName]=@UnionName
      ,[Reamrks]=@Reamrks
      ,[StationTypeId]=@StationTypeId,ProgramTypeId=@ProgramTypeId,DoctorCategoryId=@DoctorCategoryId,InactiveDate=@InactiveDate , SMCTypeId  =@SMCTypeId                    
        WHERE   DoctorId = @DoctorId


	 
		 Delete From dbo.tblDoctorBrandDetail where DoctorId = @DoctorId

		 Delete From dbo.tblDoctorDegreeDetail where DoctorId = @DoctorId
		 Delete From dbo.tblDoctorSpecialityDetail where DoctorId = @DoctorId

		  Delete From dbo.tblDoctorSpecialDayDetail where DoctorId = @DoctorId
		
		 Delete From dbo.tblDoctorContactDetail where DoctorId = @DoctorId


		 declare @CountPres int =0
		 declare @CountDcr int =0
		 select @CountPres=ISNULL(COUNT(*),0) from tbl_PrescriptionMaster where DoctorId=@DoctorId
		 select @CountDcr=ISNULL(COUNT(*),0)  from tbl_DCRInfo where DoctorId=@DoctorId


		 print @CountPres
		 print @CountDcr
 

		 --if(@CountPres=0 and @CountDcr=0)
		 --begin
		 delete From dbo.tblDoctorChemberDetail where 	ChemberId not in( select ChemberId from (
		  select   ChemberId from tbl_PrescriptionMaster where DoctorId=@DoctorId
		  union all
		 select ChemberId   from tbl_DCRInfo where DoctorId=@DoctorId) tbl) and  DoctorId=@DoctorId
		  --end

    END
