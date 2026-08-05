
CREATE PROCEDURE [dbo].[sp_Update_Customer_Doctor_Transfer]
	-- Add the parameters for the stored procedure here
   
    @MasterId NVARCHAR(MAX) ,
    @MarketId NVARCHAR(MAX) ,


    @ApprovedBy NVARCHAR(50) ,
	@Type NVARCHAR(50) ,
	@DCID NVARCHAR(50) ,

	@RouteId NVARCHAR(50) 

  

AS
    BEGIN
   declare @MasterIdPK int=0
 if(@Type='Cust')
    BEGIN

	INSERT INTO [dbo].[tblCusDocTran]
           ([EntryBy])
     VALUES
           (@ApprovedBy)
		 
		   set @MasterIdPK=SCOPE_IDENTITY()  
	 INSERT INTO tblCustMaster_TranferLog ([CustomerMasterId]
      ,[CustomerCode]
      ,[CategoryId]
      ,[CustomerName]
      ,[Address]
      ,[CellNo]
      ,[MarketId]
      ,[Addrees2]
      ,[City]
      ,[ConPerson]
      ,[ShippingCond]
      ,[MarketCode]
      ,[MarketName]
      ,[MIACode]
      ,[MIAName]
      ,[AreaCode]
      ,[DisCode]
      ,[FEName]
      ,[ComUnitCode]
      ,[ComUnitName]
      ,[RegionCode]
      ,[DZSMName]
      ,[TermOfPayment]
      ,[CustomerCodeOld]
      ,[UploadDate]
      ,[ExcelUpload]
      ,[FixedCustomer]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[Type]
      ,[ComUnitId]
      ,[IsActive]
      ,[InActiveDate]
      ,[CustomerStation]
      ,[Division]
      ,[District]
      ,[Thana]
      ,[Upazila]
      ,[CustomerType]
      ,[AITGLId]
      ,[CustomerTypeId]
      ,[DistrictId]
      ,[DivisionId]
      ,[ThanaId]
      ,[StationTypeId]
      ,[CreateBy]
      ,[CreateDate]
      ,[IsVatApplicable]
      ,[DistributionRouteId]
      ,[OwnerName]
      ,[VoterID]
      ,[TradeLicense]
      ,[DrugLicense]
      ,[PharmacyCouncilCertificate]
      ,[BCDS]
      ,[ProgramTypeId]
      ,[ApproveBy]
      ,[ApproveDate]
      ,[ActionStatus]
      ,[Email]
      ,[Reamrks]
      ,[TranferBy]
      ,[TranferDate],MasterId,IsApprove)
SELECT [CustomerMasterId]
      ,[CustomerCode]
      ,[CategoryId]
      ,[CustomerName]
      ,[Address]
      ,[CellNo]
      ,@MarketId
      ,[Addrees2]
      ,[City]
      ,[ConPerson]
      ,[ShippingCond]
      ,[MarketCode]
      ,[MarketName]
      ,[MIACode]
      ,[MIAName]
      ,[AreaCode]
      ,[DisCode]
      ,[FEName]
      ,[ComUnitCode]
      ,[ComUnitName]
      ,[RegionCode]
      ,[DZSMName]
      ,[TermOfPayment]
      ,[CustomerCodeOld]
      ,[UploadDate]
      ,[ExcelUpload]
      ,[FixedCustomer]
      ,[UpdateBy]
      ,[UpdateDate]
      ,[Type]
      ,[ComUnitId]
      ,[IsActive]
      ,[InActiveDate]
      ,[CustomerStation]
      ,[Division]
      ,[District]
      ,[Thana]
      ,[Upazila]
      ,[CustomerType]
      ,[AITGLId]
      ,[CustomerTypeId]
      ,[DistrictId]
      ,[DivisionId]
      ,[ThanaId]
      ,[StationTypeId]
      ,[CreateBy]
      ,[CreateDate]
      ,[IsVatApplicable]
      ,[DistributionRouteId]
      ,[OwnerName]
      ,[VoterID]
      ,[TradeLicense]
      ,[DrugLicense]
      ,[PharmacyCouncilCertificate]
      ,[BCDS]
      ,[ProgramTypeId]
      ,[ApproveBy]
      ,[ApproveDate]
      ,[ActionStatus]
      ,[Email]
      ,[Reamrks]
      ,@ApprovedBy
      ,getdate(),@MasterIdPK,0
FROM tblCustMaster
   WHERE  CustomerMasterId in (select * from fnSplit(@MasterId,',')) 

 

		--UPDATE tblCustMaster SET     MarketId =  @MarketId ,
	 --       UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 

	 --   WHERE  CustomerMasterId in (select * from fnSplit(@MasterId,','))
		END
		else
    BEGIN
	INSERT INTO [dbo].[tblCusDocTran]
           ([EntryBy])
     VALUES
           (@ApprovedBy)
		 
		   set @MasterIdPK=SCOPE_IDENTITY()  
	INSERT INTO tblDoctorMaster_TranferLog ( [DoctorId]
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
      ,[TranferBy]
      ,[TranferDate], MasterId,IsApprove)
SELECT  [DoctorId]
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
      ,@MarketId
      ,[UnionName]
      ,[Reamrks]
      ,[StationTypeId]
      ,[ProgramTypeId]
      ,[DoctorCategoryId]
   
      ,@ApprovedBy
      ,getdate(),@MasterIdPK,0
FROM tblDoctorMaster
   WHERE  DoctorId in (select * from fnSplit(@MasterId,',')) 

		--UPDATE tblDoctorMaster 
	 --   Set MarketId =  @MarketId ,
	 --       UpdateBy = @ApprovedBy , UpdateDate=GETDATE()

	 --   WHERE  DoctorId in (select * from fnSplit(@MasterId,','))

		END

    END
	