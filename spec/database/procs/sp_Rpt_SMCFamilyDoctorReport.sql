
CREATE PROCEDURE [dbo].[sp_Rpt_SMCFamilyDoctorReport] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	
	  
AS
BEGIN
  
 
 declare @frmDate nvarchar(max),
	@toDate  nvarchar(max)  


 set @frmDate=  format(DATEADD(mm, DATEDIFF(m,0,GETDATE()),0),'dd MMMM, yyyy')
 
	set @toDate=format(cast(DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)) as date),'dd MMMM, yyyy')


 
	 




 
 
  delete from [tblProcess_SMCFamilyDoctor] where MonthValue= MONTH(CONVERT(Date, @frmDate)) and YearValue= YEAR(CONVERT(Date, @frmDate))
DECLARE @MasterTable TABLE (
     DoctorId int,
     TerritoryId int,   AreaId int,  RegionId int,
     RegionName NVARCHAR(MAX) ,
      AreaName NVARCHAR(MAX) ,
      MIOCode NVARCHAR(MAX) ,
   MIOName NVARCHAR(MAX) ,
   DoctorName NVARCHAR(MAX) ,
   DegreeName NVARCHAR(MAX) ,
   DoctorSpeciality NVARCHAR(MAX) ,
   ProgramTypeName NVARCHAR(MAX) ,
    DoctorTypeName NVARCHAR(MAX), 
	[1_DCP] int,
	[1_DCR] int,
	[1_RX] int ,
	 
	[2_DCP] int,
	[2_DCR] int,
	[2_RX] int ,
	 
	[3_DCP] int,
	[3_DCR] int,
	[3_RX] int ,
	 
	[4_DCP] int,
	[4_DCR] int,
	[4_RX] int ,
	 
	[5_DCP] int,
	[5_DCR] int,
	[5_RX] int ,
	 
	[6_DCP] int,
	[6_DCR] int,
	[6_RX] int ,
	 
	[7_DCP] int,
	[7_DCR] int,
	[7_RX] int ,
	 
	[8_DCP] int,
	[8_DCR] int,
	[8_RX] int ,
	 
	[9_DCP] int,
	[9_DCR] int,
	[9_RX] int ,
	 
	[10_DCP] int,
	[10_DCR] int,
	[10_RX] int ,
	 
	[11_DCP] int,
	[11_DCR] int,
	[11_RX] int ,
	 
	[12_DCP] int,
	[12_DCR] int,
	[12_RX] int ,
	 
	[13_DCP] int,
	[13_DCR] int,
	[13_RX] int ,
	 
	[14_DCP] int,
	[14_DCR] int,
	[14_RX] int ,
	 
	[15_DCP] int,
	[15_DCR] int,
	[15_RX] int ,
	 
	[16_DCP] int,
	[16_DCR] int,
	[16_RX] int ,
	 
	[17_DCP] int,
	[17_DCR] int,
	[17_RX] int ,
	 
	[18_DCP] int,
	[18_DCR] int,
	[18_RX] int ,
	 
	[19_DCP] int,
	[19_DCR] int,
	[19_RX] int ,
	 
	[20_DCP] int,
	[20_DCR] int,
	[20_RX] int ,
	 
	[21_DCP] int,
	[21_DCR] int,
	[21_RX] int ,
	 
	[22_DCP] int,
	[22_DCR] int,
	[22_RX] int ,
	 
	[23_DCP] int,
	[23_DCR] int,
	[23_RX] int ,
	 
	[24_DCP] int,
	[24_DCR] int,
	[24_RX] int ,
	 
	[25_DCP] int,
	[25_DCR] int,
	[25_RX] int ,
	 
	[26_DCP] int,
	[26_DCR] int,
	[26_RX] int ,
	 
	[27_DCP] int,
	[27_DCR] int,
	[27_RX] int ,
	 
	[28_DCP] int,
	[28_DCR] int,
	[28_RX] int ,
	 
	[29_DCP] int,
	[29_DCR] int,
	[29_RX] int ,
	 
	[30_DCP] int,
	[30_DCR] int,
	[30_RX] int ,
	 
	[31_DCP] int,
	[31_DCR] int,
	[31_RX] int ,
	 
	[to_DCP] int,
	[to_DCR] int,
	[to_RX] int 
 
)
 
   

DECLARE @DoctorId int
   
DECLARE @TerritoryId int  DECLARE @AreaId int   DECLARE @RegionId int 
   DECLARE @RegionName NVARCHAR(MAX) 
   DECLARE @AreaName NVARCHAR(MAX) 
   DECLARE @MIOCode NVARCHAR(MAX) 
   DECLARE @MIOName NVARCHAR(MAX) 
   DECLARE @DoctorName NVARCHAR(MAX) 
   DECLARE @DegreeName NVARCHAR(MAX) 
   DECLARE @DoctorSpeciality NVARCHAR(MAX) 
   DECLARE @ProgramTypeName NVARCHAR(MAX) 
   DECLARE @DoctorTypeName NVARCHAR(MAX) 

 


 
---select * from tblProductionBarCodeScanOutputMaster

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
select  
DOC.DoctorId,MIO.TerritoryId, AR.AreaId, RG.RegionId
, RG.RegionCode+' : '+ RG.RegionName RegionName,AR.AreaCode+' : '+AR.AreaName AreaName ,  TE.TerritoryCode+ ' : '+Te.TerritoryName  MIOCode, EMP.EmpMasterCode+' : '+ EMP.EmpName  MIOName,   (DOC.DoctorCode + ' : '+DOC.DoctorName)AS DoctorName,     STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd  with (nolock) ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') DegreeName,STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm  with (nolock) INNER JOIN dbo.tblDoctorSpecialityDetail mgd  with (nolock) ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') DoctorSpeciality  , pt.ProgramTypeName ProgramTypeName, dt.DoctorTypeName DoctorTypeName 
FROM  tblDoctorMaster DOC   with (nolock) 

INNER JOIN  dbo.tblMarket AS M  with (nolock) ON M.MarketId =  DOC.MarketId
INNER JOIN dbo.tblSubTerritory AS ST  with (nolock) ON ST.SubTerritoryId = M.SubTerritoryId 
inner JOIN tblTerritory TE  with (nolock) ON ST.TerritoryId = TE.TerritoryId
 
inner JOIN tblArea AR  with (nolock) ON Te.AreaId  = AR.AreaId
inner JOIN tblRegion  RG  with (nolock) ON  AR.RegionId = RG.RegionId
inner JOIN   tblMIOInfo MIO  with (nolock) ON  TE.TerritoryId = Mio.TerritoryId

inner JOIN tblEmpGeneralInfo EMP  with (nolock) ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN dbo.tblDoctorType  dt  with (nolock) ON DOC.DoctorTypeId=dt.DoctorTypeId
						LEFT JOIN dbo.tblProgramType pt  with (nolock) ON DOC.ProgramTypeId=pt.ProgramTypeId

 where mio.isactive=1 and DOC.SMCTypeId=1 
--and  ((RG.RegionId= COALESCE( NULLIF(@Zone , 0) ,RG.RegionId ))  and (AR.AreaId= COALESCE( NULLIF(@Area , 0) ,AR.AreaId ))  and (TE.TerritoryId= COALESCE( NULLIF(@Teritory , 0) ,TE.TerritoryId )) )   
						 
						 order by  TE.TerritoryCode asc


OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO      @DoctorId,  @TerritoryId ,  @AreaId, @RegionId,
     @RegionName,
     @AreaName,
     @MIOCode ,
     @MIOName ,
     @DoctorName ,
     @DegreeName ,
     @DoctorSpeciality,
     @ProgramTypeName,
     @DoctorTypeName
WHILE @@FETCH_STATUS = 0
BEGIN



  DECLARE @1_DCP int   =null
DECLARE @1_DCR int   =null
DECLARE @1_RX int   =null 
  
 DECLARE @2_DCP int   =null
DECLARE @2_DCR int   =null
DECLARE @2_RX int   =null 
  
 DECLARE @3_DCP int   =null
DECLARE @3_DCR int   =null
DECLARE @3_RX int   =null 
  
 DECLARE @4_DCP int   =null
DECLARE @4_DCR int   =null
DECLARE @4_RX int   =null 
  
 DECLARE @5_DCP int   =null
DECLARE @5_DCR int   =null
DECLARE @5_RX int   =null 
  
 DECLARE @6_DCP int   =null
DECLARE @6_DCR int   =null
DECLARE @6_RX int   =null 
  
 DECLARE @7_DCP int   =null
DECLARE @7_DCR int   =null
DECLARE @7_RX int   =null 
  
 DECLARE @8_DCP int   =null
DECLARE @8_DCR int   =null
DECLARE @8_RX int   =null 
  
 DECLARE @9_DCP int   =null
DECLARE @9_DCR int   =null
DECLARE @9_RX int   =null 
  
 DECLARE @10_DCP int   =null
DECLARE @10_DCR int   =null
DECLARE @10_RX int   =null 
  
 DECLARE @11_DCP int   =null
DECLARE @11_DCR int   =null
DECLARE @11_RX int   =null 
  
 DECLARE @12_DCP int   =null
DECLARE @12_DCR int   =null
DECLARE @12_RX int   =null 
  
 DECLARE @13_DCP int   =null
DECLARE @13_DCR int   =null
DECLARE @13_RX int   =null 
  
 DECLARE @14_DCP int   =null
DECLARE @14_DCR int   =null
DECLARE @14_RX int   =null 
  
 DECLARE @15_DCP int   =null
DECLARE @15_DCR int   =null
DECLARE @15_RX int   =null 
  
 DECLARE @16_DCP int   =null
DECLARE @16_DCR int   =null
DECLARE @16_RX int   =null 
  
 DECLARE @17_DCP int   =null
DECLARE @17_DCR int   =null
DECLARE @17_RX int   =null 
  
 DECLARE @18_DCP int   =null
DECLARE @18_DCR int   =null
DECLARE @18_RX int   =null 
  
 DECLARE @19_DCP int   =null
DECLARE @19_DCR int   =null
DECLARE @19_RX int   =null 
  
 DECLARE @20_DCP int   =null
DECLARE @20_DCR int   =null
DECLARE @20_RX int   =null 
  
 DECLARE @21_DCP int   =null
DECLARE @21_DCR int   =null
DECLARE @21_RX int   =null 
  
 DECLARE @22_DCP int   =null
DECLARE @22_DCR int   =null
DECLARE @22_RX int   =null 
  
 DECLARE @23_DCP int   =null
DECLARE @23_DCR int   =null
DECLARE @23_RX int   =null 
  
 DECLARE @24_DCP int   =null
DECLARE @24_DCR int   =null
DECLARE @24_RX int   =null 
  
 DECLARE @25_DCP int   =null
DECLARE @25_DCR int   =null
DECLARE @25_RX int   =null 
  
 DECLARE @26_DCP int   =null
DECLARE @26_DCR int   =null
DECLARE @26_RX int   =null 
  
 DECLARE @27_DCP int   =null
DECLARE @27_DCR int   =null
DECLARE @27_RX int   =null 
  
 DECLARE @28_DCP int   =null
DECLARE @28_DCR int   =null
DECLARE @28_RX int   =null 
  
 DECLARE @29_DCP int   =null
DECLARE @29_DCR int   =null
DECLARE @29_RX int   =null 
  
 DECLARE @30_DCP int   =null
DECLARE @30_DCR int   =null
DECLARE @30_RX int   =null 
  
 DECLARE @31_DCP int   =null
DECLARE @31_DCR int   =null
DECLARE @31_RX int   =null 

DECLARE @to_DCP int   =null
	DECLARE @to_DCR int   =null
	DECLARE @to_RX int   =null 
   
	---1
   select @1_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   
where  convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=1 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'    and
   DOC.SMCTypeId_DV=1
 

  select @1_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=1 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2' 
  
  select @1_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=1 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---2
  select @2_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1 and convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=2 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  
   
 

  select @2_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=2 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @2_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=2 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---3
  select @3_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 where
   DOC.SMCTypeId_DV=1 and  convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=3 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @3_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=3 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @3_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=3 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---4
 select @4_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1 and     convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=4 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @4_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=4 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @4_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=4 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---5
  select @5_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=5 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @5_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=5 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @5_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
 where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=5 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---6
    select @6_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=6 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @6_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=6 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @6_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=6 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---7
     select @7_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=7 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @7_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=7 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @7_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=7 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---8
  select @8_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=8 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @8_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=8 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @8_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=8 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---9
  select @9_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=9 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @9_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=9 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @9_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=9 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
---10
  
  select @10_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=10 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @10_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=10 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @10_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=10 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---11
   select @11_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=11 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @11_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=11 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @11_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=11 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---12
  select @12_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=12 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @12_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=12 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @12_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=12 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---13
   select @13_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=13 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @13_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=13 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @13_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=13 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---14
  select @14_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=14 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @14_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=14 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @14_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=14 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---15
  select @15_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=15 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @15_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=15 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @15_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=15 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---16
  select @16_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=16 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @16_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=16 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @16_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=16 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---17
  select @17_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=17 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @17_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=17 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @17_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=17 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---18
 select @18_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=18 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @18_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=18 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @18_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=18 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---19
  select @19_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=19 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @19_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
  where
   
   DOC.SmcTypeId_DCR=1  and     convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=19 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @19_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=19 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---20
   select @20_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=20 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @20_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=20 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @20_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=20 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---21
 select @21_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=21 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @21_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=21 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @21_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=21 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---22
  select @22_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=22 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @22_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=22 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @22_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=22 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---23
  select @23_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=23 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @23_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=23 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @23_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=23 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---24
 select @24_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=24 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @24_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=24 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @24_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=24 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'

---25
 select @25_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=25 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @25_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=25 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @25_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=25 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'


---26
  select @26_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=26 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @26_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=26 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @26_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=26 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'





---27
   select @27_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=27 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @27_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=27 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @27_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=27 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---28
   select @28_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=28 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @28_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=28 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @28_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=28 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'





---29
  select @29_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
  where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=29 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @29_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=29 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @29_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=29 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'




---30
 select @30_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=30 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @30_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=30 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @30_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=30 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'





---31
 select @31_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   where
   DOC.SMCTypeId_DV=1  and   convert(Date,DOC.TourPlanDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=31 ),null) and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'
 

  select @31_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
   DOC.SmcTypeId_DCR=1  and  convert(Date,DOC.DcrDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=31 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @31_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1  and  convert(Date,DOC.PrescriptionDate)=isnull((SELECT  DateString FROM dbo.DateRange_To_TableSL (@frmDate,@toDate) where sl=31 ),null) and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



---total
 select @to_DCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   

where  DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate) between  @frmDate and @toDate and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  
 

  select @to_DCR=count(*)      from tbl_DCRInfo  DOC   with (nolock)  
 where
     DOC.SMCTypeId_DCR=1 and   convert(Date,DOC.DcrDate) between  @frmDate and @toDate and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'
  
  select @to_RX=count(*)       from tbl_PrescriptionMaster   DOC   with (nolock)  
where
   DOC.SmcTypeId_RX=1    and   convert(Date,DOC.PrescriptionDate) between  @frmDate and @toDate and DOC.Doctorid=@DoctorId and   DOC.ApprovalStatus= '2'



INSERT INTO @MasterTable
(    DoctorId  ,
     TerritoryId ,   AreaId,  RegionId,
     RegionName  ,
      AreaName  ,
      MIOCode  ,
   MIOName  ,
   DoctorName  ,
   DegreeName  ,
   DoctorSpeciality  ,
   ProgramTypeName  ,
    DoctorTypeName  , 
	[1_DCP] ,
	[1_DCR] ,
	[1_RX]  ,
	 
	[2_DCP] ,
	[2_DCR] ,
	[2_RX]  ,
	 
	[3_DCP] ,
	[3_DCR] ,
	[3_RX]  ,
	 
	[4_DCP] ,
	[4_DCR] ,
	[4_RX]  ,
	 
	[5_DCP] ,
	[5_DCR] ,
	[5_RX]  ,
	 
	[6_DCP] ,
	[6_DCR] ,
	[6_RX]  ,
	 
	[7_DCP] ,
	[7_DCR] ,
	[7_RX]  ,
	 
	[8_DCP] ,
	[8_DCR] ,
	[8_RX]  ,
	 
	[9_DCP] ,
	[9_DCR] ,
	[9_RX]  ,
	 
	[10_DCP] ,
	[10_DCR] ,
	[10_RX]  ,
	 
	[11_DCP] ,
	[11_DCR] ,
	[11_RX]  ,
	 
	[12_DCP] ,
	[12_DCR] ,
	[12_RX]  ,
	 
	[13_DCP] ,
	[13_DCR] ,
	[13_RX]  ,
	 
	[14_DCP] ,
	[14_DCR] ,
	[14_RX]  ,
	 
	[15_DCP] ,
	[15_DCR] ,
	[15_RX]  ,
	 
	[16_DCP] ,
	[16_DCR] ,
	[16_RX]  ,
	 
	[17_DCP] ,
	[17_DCR] ,
	[17_RX]  ,
	 
	[18_DCP] ,
	[18_DCR] ,
	[18_RX]  ,
	 
	[19_DCP] ,
	[19_DCR] ,
	[19_RX]  ,
	 
	[20_DCP] ,
	[20_DCR] ,
	[20_RX]  ,
	 
	[21_DCP] ,
	[21_DCR] ,
	[21_RX]  ,
	 
	[22_DCP] ,
	[22_DCR] ,
	[22_RX]  ,
	 
	[23_DCP] ,
	[23_DCR] ,
	[23_RX]  ,
	 
	[24_DCP] ,
	[24_DCR] ,
	[24_RX]  ,
	 
	[25_DCP] ,
	[25_DCR] ,
	[25_RX]  ,
	 
	[26_DCP] ,
	[26_DCR] ,
	[26_RX]  ,
	 
	[27_DCP] ,
	[27_DCR] ,
	[27_RX]  ,
	 
	[28_DCP] ,
	[28_DCR] ,
	[28_RX]  ,
	 
	[29_DCP] ,
	[29_DCR] ,
	[29_RX]  ,
	 
	[30_DCP] ,
	[30_DCR] ,
	[30_RX]  ,
	 
	[31_DCP] ,
	[31_DCR] ,
	[31_RX] ,

	
 to_DCP  ,  
	 to_DCR ,
	 to_RX  
  
)
VALUES
(   @DoctorId  ,
     @TerritoryId , @AreaId,  @RegionId,
     @RegionName  ,
      @AreaName  ,
      @MIOCode  ,
   @MIOName  ,
   @DoctorName  ,
   @DegreeName  ,
   @DoctorSpeciality  ,
   @ProgramTypeName  ,
    @DoctorTypeName  , 
	@1_DCP  ,
	@1_DCR  ,
	@1_RX   ,
	 
	@2_DCP  ,
	@2_DCR  ,
	@2_RX   ,
	 
	@3_DCP  ,
	@3_DCR  ,
	@3_RX   ,
	 
	@4_DCP  ,
	@4_DCR  ,
	@4_RX   ,
	 
	@5_DCP  ,
	@5_DCR  ,
	@5_RX   ,
	 
	@6_DCP  ,
	@6_DCR  ,
	@6_RX   ,
	 
	@7_DCP  ,
	@7_DCR  ,
	@7_RX   ,
	 
	@8_DCP  ,
	@8_DCR  ,
	@8_RX   ,
	 
	@9_DCP  ,
	@9_DCR  ,
	@9_RX   ,
	 
	@10_DCP  ,
	@10_DCR  ,
	@10_RX   ,
	 
	@11_DCP  ,
	@11_DCR  ,
	@11_RX   ,
	 
	@12_DCP  ,
	@12_DCR  ,
	@12_RX   ,
	 
	@13_DCP  ,
	@13_DCR  ,
	@13_RX   ,
	 
	@14_DCP  ,
	@14_DCR  ,
	@14_RX   ,
	 
	@15_DCP  ,
	@15_DCR  ,
	@15_RX   ,
	 
	@16_DCP  ,
	@16_DCR  ,
	@16_RX   ,
	 
	@17_DCP  ,
	@17_DCR  ,
	@17_RX   ,
	 
	@18_DCP  ,
	@18_DCR  ,
	@18_RX   ,
	 
	@19_DCP  ,
	@19_DCR  ,
	@19_RX   ,
	 
	@20_DCP  ,
	@20_DCR  ,
	@20_RX   ,
	 
	@21_DCP  ,
	@21_DCR  ,
	@21_RX   ,
	 
	@22_DCP  ,
	@22_DCR  ,
	@22_RX   ,
	 
	@23_DCP  ,
	@23_DCR  ,
	@23_RX   ,
	 
	@24_DCP  ,
	@24_DCR  ,
	@24_RX   ,
	 
	@25_DCP  ,
	@25_DCR  ,
	@25_RX   ,
	 
	@26_DCP  ,
	@26_DCR  ,
	@26_RX   ,
	 
	@27_DCP  ,
	@27_DCR  ,
	@27_RX   ,
	 
	@28_DCP  ,
	@28_DCR  ,
	@28_RX   ,
	 
	@29_DCP  ,
	@29_DCR  ,
	@29_RX   ,
	 
	@30_DCP  ,
	@30_DCR  ,
	@30_RX   ,
	 
	@31_DCP  ,
	@31_DCR  ,
	@31_RX  ,
	
 @to_DCP  ,  
	 @to_DCR ,
	 @to_RX  
  
    )






FETCH NEXT FROM @MyCursor
INTO    @DoctorId,  @TerritoryId , @AreaId,  @RegionId,
     @RegionName,
     @AreaName,
     @MIOCode ,
     @MIOName ,
     @DoctorName ,
     @DegreeName ,
     @DoctorSpeciality,
     @ProgramTypeName,
     @DoctorTypeName
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


insert into tblProcess_SMCFamilyDoctor(DoctorId  ,
     TerritoryId , AreaId,  RegionId,
     RegionName  ,
      AreaName  ,
      MIOCode  ,
   MIOName  ,
   DoctorName  ,
   DegreeName  ,
   DoctorSpeciality  ,
   ProgramTypeName  ,
    DoctorTypeName  , 
	[1_DCP] ,
	[1_DCR] ,
	[1_RX]  ,
	 
	[2_DCP] ,
	[2_DCR] ,
	[2_RX]  ,
	 
	[3_DCP] ,
	[3_DCR] ,
	[3_RX]  ,
	 
	[4_DCP] ,
	[4_DCR] ,
	[4_RX]  ,
	 
	[5_DCP] ,
	[5_DCR] ,
	[5_RX]  ,
	 
	[6_DCP] ,
	[6_DCR] ,
	[6_RX]  ,
	 
	[7_DCP] ,
	[7_DCR] ,
	[7_RX]  ,
	 
	[8_DCP] ,
	[8_DCR] ,
	[8_RX]  ,
	 
	[9_DCP] ,
	[9_DCR] ,
	[9_RX]  ,
	 
	[10_DCP] ,
	[10_DCR] ,
	[10_RX]  ,
	 
	[11_DCP] ,
	[11_DCR] ,
	[11_RX]  ,
	 
	[12_DCP] ,
	[12_DCR] ,
	[12_RX]  ,
	 
	[13_DCP] ,
	[13_DCR] ,
	[13_RX]  ,
	 
	[14_DCP] ,
	[14_DCR] ,
	[14_RX]  ,
	 
	[15_DCP] ,
	[15_DCR] ,
	[15_RX]  ,
	 
	[16_DCP] ,
	[16_DCR] ,
	[16_RX]  ,
	 
	[17_DCP] ,
	[17_DCR] ,
	[17_RX]  ,
	 
	[18_DCP] ,
	[18_DCR] ,
	[18_RX]  ,
	 
	[19_DCP] ,
	[19_DCR] ,
	[19_RX]  ,
	 
	[20_DCP] ,
	[20_DCR] ,
	[20_RX]  ,
	 
	[21_DCP] ,
	[21_DCR] ,
	[21_RX]  ,
	 
	[22_DCP] ,
	[22_DCR] ,
	[22_RX]  ,
	 
	[23_DCP] ,
	[23_DCR] ,
	[23_RX]  ,
	 
	[24_DCP] ,
	[24_DCR] ,
	[24_RX]  ,
	 
	[25_DCP] ,
	[25_DCR] ,
	[25_RX]  ,
	 
	[26_DCP] ,
	[26_DCR] ,
	[26_RX]  ,
	 
	[27_DCP] ,
	[27_DCR] ,
	[27_RX]  ,
	 
	[28_DCP] ,
	[28_DCR] ,
	[28_RX]  ,
	 
	[29_DCP] ,
	[29_DCR] ,
	[29_RX]  ,
	 
	[30_DCP] ,
	[30_DCR] ,
	[30_RX]  ,
	 
	[31_DCP] ,
	[31_DCR] ,
	[31_RX] 
  , 
 to_DCP  ,  
	 to_DCR ,
	 to_RX ,MonthValue,YearValue,ProcessDate )

select   DoctorId  ,
     TerritoryId , AreaId,  RegionId,
     RegionName  ,
      AreaName  ,
      MIOCode  ,
   MIOName  ,
   DoctorName  ,
   DegreeName  ,
   DoctorSpeciality  ,
   ProgramTypeName  ,
    DoctorTypeName  , 
	[1_DCP] ,
	[1_DCR] ,
	[1_RX]  ,
	 
	[2_DCP] ,
	[2_DCR] ,
	[2_RX]  ,
	 
	[3_DCP] ,
	[3_DCR] ,
	[3_RX]  ,
	 
	[4_DCP] ,
	[4_DCR] ,
	[4_RX]  ,
	 
	[5_DCP] ,
	[5_DCR] ,
	[5_RX]  ,
	 
	[6_DCP] ,
	[6_DCR] ,
	[6_RX]  ,
	 
	[7_DCP] ,
	[7_DCR] ,
	[7_RX]  ,
	 
	[8_DCP] ,
	[8_DCR] ,
	[8_RX]  ,
	 
	[9_DCP] ,
	[9_DCR] ,
	[9_RX]  ,
	 
	[10_DCP] ,
	[10_DCR] ,
	[10_RX]  ,
	 
	[11_DCP] ,
	[11_DCR] ,
	[11_RX]  ,
	 
	[12_DCP] ,
	[12_DCR] ,
	[12_RX]  ,
	 
	[13_DCP] ,
	[13_DCR] ,
	[13_RX]  ,
	 
	[14_DCP] ,
	[14_DCR] ,
	[14_RX]  ,
	 
	[15_DCP] ,
	[15_DCR] ,
	[15_RX]  ,
	 
	[16_DCP] ,
	[16_DCR] ,
	[16_RX]  ,
	 
	[17_DCP] ,
	[17_DCR] ,
	[17_RX]  ,
	 
	[18_DCP] ,
	[18_DCR] ,
	[18_RX]  ,
	 
	[19_DCP] ,
	[19_DCR] ,
	[19_RX]  ,
	 
	[20_DCP] ,
	[20_DCR] ,
	[20_RX]  ,
	 
	[21_DCP] ,
	[21_DCR] ,
	[21_RX]  ,
	 
	[22_DCP] ,
	[22_DCR] ,
	[22_RX]  ,
	 
	[23_DCP] ,
	[23_DCR] ,
	[23_RX]  ,
	 
	[24_DCP] ,
	[24_DCR] ,
	[24_RX]  ,
	 
	[25_DCP] ,
	[25_DCR] ,
	[25_RX]  ,
	 
	[26_DCP] ,
	[26_DCR] ,
	[26_RX]  ,
	 
	[27_DCP] ,
	[27_DCR] ,
	[27_RX]  ,
	 
	[28_DCP] ,
	[28_DCR] ,
	[28_RX]  ,
	 
	[29_DCP] ,
	[29_DCR] ,
	[29_RX]  ,
	 
	[30_DCP] ,
	[30_DCR] ,
	[30_RX]  ,
	 
	[31_DCP] ,
	[31_DCR] ,
	[31_RX] 
  , 
 to_DCP  ,  
	 to_DCR ,
	 to_RX  , MONTH(CONVERT(Date, @frmDate)) , YEAR(CONVERT(Date, @frmDate)), getdate()
  	 from @MasterTable
	--order by RegionName asc
 
 end
  