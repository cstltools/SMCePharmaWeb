
CREATE PROCEDURE [dbo].[sp_GetRXDoctorWiseRpt]  
		 @Month nvarchar(max),
	@MonthValue int ,
	@Year nvarchar(max),
	@ApprovalStatus  nvarchar(Max)
AS
BEGIN

 
 
 --delete from tblDCRRXDoctorWiseReport where  Month=@Month and Year=@Year and Type='RX'
 
DECLARE @MasterTable TABLE (
	 DoctorId INT NULL,

   DoctorName  NVARCHAR(MAX)  NULL,
    DoctorCode  NVARCHAR(MAX) NULL,
    DegreeName  NVARCHAR(MAX) NULL,
    DoctorSpeciality  NVARCHAR(MAX) NULL,
    ProgramTypeName  NVARCHAR(MAX) NULL,
    DoctorTypeName  NVARCHAR(MAX) NULL,
	  
	 GroupName NVARCHAR(MAX) NULL,
	 GroupCode NVARCHAR(MAX) NULL ,
	    RegionCode NVARCHAR(MAX) NULL,
   RegionName NVARCHAR(MAX) NULL,
   AreaCode NVARCHAR(MAX) NULL,
   AreaName NVARCHAR(MAX) NULL,
   TerritoryCode NVARCHAR(MAX) NULL ,
   TerritoryName NVARCHAR(MAX) NULL,
   SubTerritoryCode NVARCHAR(MAX) NULL,
   SubTerritoryName NVARCHAR(MAX) NULL,
   MarketCode NVARCHAR(MAX) NULL,
   MarketName NVARCHAR(MAX) NULL,
 
	[1] INT NULL,
	[2] INT NULL,
	[3] INT NULL,
	[4] INT NULL,
	[5] INT NULL,
	[6] INT NULL,
	[7] INT NULL,
	[8] INT NULL,
	[9] INT NULL,
	[10] INT NULL,
	[11] INT NULL,
	[12] INT NULL,
	[13] INT NULL,
	[14] INT NULL,
	[15] INT NULL,
	[16] INT NULL,
	[17] INT NULL,
	[18] INT NULL,
[19] INT NULL,
[20] INT NULL,
[21] INT NULL,
[22] INT NULL,
[23] INT NULL,
[24] INT NULL,
[25] INT NULL,
[26] INT NULL,
[27] INT NULL,
[28] INT NULL,
[29] INT NULL,
[30] INT NULL,
[31] INT NULL,

[TotAL] INT NULL

	

	

)
 
DECLARE @DoctorId  int= NULL
DECLARE @DoctorName  VARCHAR(MAX)= NULL
   DECLARE  @DoctorCode  VARCHAR(MAX)= NULL
  DECLARE   @DegreeName  VARCHAR(MAX)= NULL
  DECLARE   @DoctorSpeciality  VARCHAR(MAX)= NULL
   DECLARE  @ProgramTypeName  VARCHAR(MAX)= NULL
   DECLARE  @DoctorTypeName  VARCHAR(MAX) =NULL
	  
	DECLARE  @GroupName VARCHAR(MAX)= NULL
	DECLARE  @GroupCode VARCHAR(MAX)= NULL 
	   DECLARE  @RegionCode NVARCHAR(MAX)= NULL
 DECLARE   @RegionName NVARCHAR(MAX)= NULL
  DECLARE  @AreaCode NVARCHAR(MAX)= NULL
  DECLARE  @AreaName NVARCHAR(MAX)= NULL
  DECLARE  @TerritoryCode NVARCHAR(MAX) =NULL
  DECLARE  @TerritoryName NVARCHAR(MAX)= NULL
  DECLARE  @SubTerritoryCode NVARCHAR(MAX)= NULL
  DECLARE  @SubTerritoryName NVARCHAR(MAX) =NULL
  DECLARE  @MarketCode NVARCHAR(MAX)= NULL
  DECLARE  @MarketName NVARCHAR(MAX)= NULL 
  




 
---select * from tblProductionBarCodeScanOutputMaster

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
 
 select  distinct       mas.DoctorId,   doc.DoctorName,doc.DoctorCode,STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorDegreeDetail mgd   WITH (NOLOCK)  ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') AS DegreeName,ISNULL(STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm   WITH (NOLOCK)  INNER JOIN dbo.tblDoctorSpecialityDetail mgd   WITH (NOLOCK)  ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=mas.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,''),'') as DoctorSpeciality, pt.ProgramTypeName ,dt.DoctorTypeName ,mas.GroupName,mas.GroupCode_RX GroupCode, mas.RegionCode_RX RegionCode,mas.RegionName,mas.AreaCode_RX AreaCode,mas.AreaName,mas.TerritoryCode_RX TerritoryCode,mas.TerritoryName,mas.SubTerritoryCode_RX SubTerritoryCode,mas.SubTerritoryName,mas.MarketCode_RX MarketCode,mas.MarketName from tbl_PrescriptionMaster mas   WITH (NOLOCK) 
 inner join tblDoctorMaster doc  WITH (NOLOCK)    on mas.DoctorId=doc.DoctorId
 left join tblProgramType pt  WITH (NOLOCK)    on mas.DoctorProgramypeId=pt.ProgramTypeId
 left join tblDoctorType dt  WITH (NOLOCK)    on doc.DoctorTypeId=dt.DoctorTypeId

 where Month(mas.PrescriptionDate)=@Month and Year(mas.PrescriptionDate)=@Year
 

 

OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO   @DoctorId, @DoctorName   ,
    @DoctorCode   ,
    @DegreeName   ,
    @DoctorSpeciality   ,
    @ProgramTypeName   ,
    @DoctorTypeName   ,
	  
	 @GroupName  ,
	 @GroupCode   ,
	    @RegionCode  ,
   @RegionName  ,
   @AreaCode  ,
   @AreaName  ,
   @TerritoryCode  ,
   @TerritoryName  ,
   @SubTerritoryCode  ,
   @SubTerritoryName  ,
   @MarketCode  ,
   @MarketName  
WHILE @@FETCH_STATUS = 0
BEGIN



 	DECLARE @1 INT =null
 	DECLARE @2 INT  =null
 	DECLARE @3 INT  =null
 	DECLARE @4 INT  =null
 	DECLARE @5 INT  =null
 	DECLARE @6 INT  =null
 	DECLARE @7 INT  =null
 	DECLARE @8 INT  =null
 	DECLARE @9 INT  =null
 	DECLARE @10 INT  =null
 	DECLARE @11 INT  =null
 	DECLARE @12 INT  =null
 	DECLARE @13 INT  =null
 	DECLARE @14 INT  =null
 	DECLARE @15 INT  =null
 	DECLARE @16 INT  =null
 	DECLARE @17 INT  =null
 	DECLARE @18 INT  =null
DECLARE @19 INT  =null
DECLARE @20 INT  =null
DECLARE @21 INT  =null
DECLARE @22 INT  =null
DECLARE @23 INT   =null
DECLARE @24 INT   =null
DECLARE @25 INT   =null
DECLARE @26 INT   =null
DECLARE @27 INT   =null
DECLARE @28 INT   =null
DECLARE @29 INT   =null
DECLARE @30 INT   =null
DECLARE @31 INT   =null
	
	if(@ApprovalStatus='Select')
	begin 
 SELECT   @1= ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr  WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=1 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId
  
 SELECT @2=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr  WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=2 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId
  


 SELECT @3=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=3 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId
  
 SELECT @4=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=4 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

 	 
 SELECT @5=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=5 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId
 

  SELECT @6=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=6 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @7=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=7 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @8=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=8 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @9=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=9 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @10=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=10 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @11=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=11 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @12=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=12 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @13=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=13 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @14=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=14 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @15=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=15 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @16=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=16 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @17=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=17 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @18=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=18 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @19=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=19 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @20=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=20 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @21=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=21 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @22=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=22 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @23=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=23 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @24=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=24 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @25=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=25 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @26=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=26 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @27=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=27 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

  SELECT @28=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=28 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @29=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=29 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @30=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=30 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId


  SELECT @31=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=31 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId

 end 

 else
	begin 

	SELECT   @1= ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr  WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=1 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId   and   dcr.ApprovalStatus= @ApprovalStatus
  
 SELECT @2=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr  WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=2 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus
  


 SELECT @3=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=3 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus
  
 SELECT @4=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=4 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

 	 
 SELECT @5=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=5 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus
 

  SELECT @6=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=6 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @7=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=7 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @8=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=8 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @9=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=9 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @10=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=10 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @11=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=11 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @12=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=12 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @13=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=13 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @14=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=14 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @15=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=15 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @16=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=16 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @17=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=17 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @18=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=18 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @19=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=19 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @20=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=20 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @21=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=21 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @22=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=22 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @23=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=23 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @24=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=24 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @25=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=25 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @26=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=26 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @27=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=27 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus

  SELECT @28=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=28 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @29=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=29 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId  and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @30=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=30 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId   and   dcr.ApprovalStatus= @ApprovalStatus


  SELECT @31=ISNULL(COUNT(*) ,0) from tbl_PrescriptionMaster dcr   WITH (NOLOCK) 
 where   DAY(dcr.PrescriptionDate)=31 and Month(dcr.PrescriptionDate)=@Month and Year(dcr.PrescriptionDate)=@Year and dcr.DoctorId=@DoctorId   and   dcr.ApprovalStatus= @ApprovalStatus

	end

 DECLARE @Total INT=0
SET @Total=
ISNULL(@1,0)+
ISNULL(@2,0)+
ISNULL(@3,0)+
ISNULL(@4,0)+
ISNULL(@5,0)+
ISNULL(@6,0)+
ISNULL(@7,0)+
ISNULL(@8,0)+
ISNULL(@9,0)+
ISNULL(@10,0)+
ISNULL(@11,0)+
ISNULL(@12,0)+
ISNULL(@13,0)+
ISNULL(@14,0)+
ISNULL(@15,0)+
ISNULL(@16,0)+
ISNULL(@17,0)+
ISNULL(@18,0)+
ISNULL(@19,0)+
ISNULL(@20,0)+
ISNULL(@21,0)+
ISNULL(@22,0)+
ISNULL(@23,0)+
ISNULL(@24,0)+
ISNULL(@25,0)+
ISNULL(@26,0)+
ISNULL(@27,0)+
ISNULL(@28,0)+
ISNULL(@29,0)+
ISNULL(@30,0)+
ISNULL(@31,0)


INSERT INTO @MasterTable
( DoctorId, DoctorName   ,
     DoctorCode   ,
     DegreeName   ,
     DoctorSpeciality   ,
     ProgramTypeName   ,
     DoctorTypeName   ,
	  
	  GroupName  ,
	  GroupCode   ,
	     RegionCode  ,
    RegionName  ,
    AreaCode  ,
    AreaName  ,
    TerritoryCode  ,
    TerritoryName  ,
    SubTerritoryCode  ,
    SubTerritoryName  ,
    MarketCode  ,
   MarketName   ,
	[1]  ,
	[2]  ,
	[3]  ,
	[4]  ,
	[5]  ,
	[6]  ,
	[7]  ,
	[8]  ,
	[9]  ,
	[10]  ,
	[11]  ,
	[12]  ,
	[13]  ,
	[14]  ,
	[15]  ,
	[16]  ,
	[17]  ,
 
    [18],
     [19],
    [20],
    [21],
	 [22],
	 	 [23] ,
	 	 [24] ,
	 	 [25] ,
	 	 [26] ,
	 	 [27] ,
	 	 [28] ,
	 	 [29] ,
	 	 [30] ,
	 	 [31]  ,
		 TotAL
)
VALUES
( @DoctorId, @DoctorName   ,
     @DoctorCode   ,
     @DegreeName   ,
     @DoctorSpeciality   ,
     @ProgramTypeName   ,
     @DoctorTypeName   ,
	  
	  @GroupName  ,
	  @GroupCode   ,
	     @RegionCode  ,
    @RegionName  ,
    @AreaCode  ,
    @AreaName  ,
    @TerritoryCode  ,
    @TerritoryName  ,
    @SubTerritoryCode  ,
    @SubTerritoryName  ,
    @MarketCode  ,
   @MarketName    ,
		@1  ,
	@2  ,
	@3  ,
	@4  ,
	@5  ,
	@6  ,
	@7  ,
	@8  ,
	@9  ,
	@10  ,
	@11  ,
	@12  ,
	@13  ,
	@14  ,
	@15  ,
	@16  ,
	@17  ,
 
    @18 ,
     @19 ,
    @20 ,
    @21 ,
	 @22 ,
	 	 @23 ,
	 	 @24  ,
	 	 @25  ,
	 	 @26  ,
	 	 @27  ,
	 	 @28  ,
	 	 @29  ,
	 	 @30  ,
	 	 @31  ,
	  
		    ISNULL(@Total,0) 
    )






FETCH NEXT FROM @MyCursor
INTO @DoctorId,  @DoctorName   ,
     @DoctorCode   ,
     @DegreeName   ,
     @DoctorSpeciality   ,
     @ProgramTypeName   ,
     @DoctorTypeName   ,
	  
	  @GroupName  ,
	  @GroupCode   ,
	     @RegionCode  ,
    @RegionName  ,
    @AreaCode  ,
    @AreaName  ,
    @TerritoryCode  ,
    @TerritoryName  ,
    @SubTerritoryCode  ,
    @SubTerritoryName  ,
    @MarketCode  ,
   @MarketName     
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

 
  
SELECT 
DoctorId,
DoctorName   ,
     DoctorCode   ,
     DegreeName   ,
     DoctorSpeciality   ,
     ProgramTypeName   ,
     DoctorTypeName   ,
	  
	  GroupName  ,
	  GroupCode   ,
	     RegionCode  ,
    RegionName  ,
    AreaCode  ,
    AreaName  ,
    TerritoryCode  ,
    TerritoryName  ,
    SubTerritoryCode  ,
    SubTerritoryName  ,
    MarketCode  ,
   MarketName   ,
	
    ISNULL([1],0) as D1
           ,ISNULL([2],0) D2
           ,ISNULL([3],0) D3
           ,ISNULL([4],0)   D4
           ,ISNULL([5],0) D5
           ,ISNULL([6],0) D6
           ,ISNULL([7],0)  D7
           ,ISNULL([8],0)  D8
           ,ISNULL([9],0)  D9
           ,ISNULL([10],0)  D10
           ,ISNULL([11],0)  D11
           ,ISNULL([12],0)  D12
           ,ISNULL([13],0)  D13
           ,ISNULL([14],0) D14
           ,ISNULL([15],0) D15
           ,ISNULL([16],0) D16
           ,ISNULL([17],0) D17
           ,ISNULL([18],0) D18
           ,ISNULL([19],0) D19
           ,ISNULL([20],0) D20
           ,ISNULL([21],0) D21
           ,ISNULL([22],0) D22
           ,ISNULL([23],0) D23
           ,ISNULL([24],0) D24
           ,ISNULL([25],0) D25
           ,ISNULL([26],0) D26
           ,ISNULL([27],0) D27
           ,ISNULL([28],0) D28
           ,ISNULL([29],0) D29
           ,ISNULL([30],0) D30
           ,ISNULL([31],0)  D31,
		TotAL,@Month, @Year,'RX'
	   
	   FROM @MasterTable   
	
 
 end

