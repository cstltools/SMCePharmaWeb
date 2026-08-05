CREATE PROCEDURE [dbo].[sp_Rpt_DoctorwiseDoctorWeek] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	 
	 
	 
	@frmDate nvarchar(max),
	@toDate  nvarchar(max) ,
	@Parameter  nvarchar(max),
	@Zone  nvarchar(max) ,
	@Area  nvarchar(max) ,
	@Teritory  nvarchar(max)  
AS
BEGIN
 
 --set @frmDate=convert(date,@frmDate)
 --set @toDate=convert(date,@toDate)


--where MIO.IsActive=1

declare @1WeekStart Date=null
declare @1WeekEnd Date=null

declare @2WeekStart Date=null
declare @2WeekEnd Date=null

declare @3WeekStart Date=null
declare @3WeekEnd Date=null

declare @4WeekStart Date=null
declare @4WeekEnd Date=null


--select * from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table ('01/Aug/2022',@toDate)) tblDate


--declare @DateCount int=0
--SELECT   @DateCount=COUNT(*) FROM dbo.DateRange_To_Table (@frmDate,@toDate)

--if (@DateCount>7)
--begin 
--select @1WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=1

--select @1WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=7
--end
--else
--begin
--select @1WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=1

--select top 1 @1WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where    tblDate.ItemNo>1 order by   tblDate.ItemNo desc

--end


--if (@DateCount<7 and  @DateCount>15 )
--begin 
--select @2WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=8

--select @2WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=14
--end
--else
--begin
--select @2WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=8

--select top 1 @2WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where    tblDate.ItemNo>8 order by    tblDate.ItemNo desc

--end
 

-- if (@DateCount<14 and  @DateCount> 22 )
--begin 
--select @3WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=15

--select @3WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=21
--end
--else
--begin
--select @3WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=15

--select top 1 @3WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where    tblDate.ItemNo>15 order by   tblDate.ItemNo desc

--end
 


 
-- if (@DateCount<21 and  @DateCount>=31 )
--begin 
--select @4WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=22

--select @4WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=31

--if(@4WeekEnd<>'')
--begin
--select top 1 @4WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where    tblDate.ItemNo>22  order by   tblDate.ItemNo desc
--end
 

--end
--else
--begin
--select @4WeekStart=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where  tblDate.ItemNo=22

--select top 1 @4WeekEnd=convert(date,ISNULL(DateString,null)) from (SELECT   ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS ItemNo, * FROM dbo.DateRange_To_Table (@frmDate,@toDate)) tblDate where tblDate.ItemNo>22  order by   tblDate.ItemNo desc

--end
 

 
 		   
 declare @monthStartValue int

set  @monthStartValue= year(convert(Date,@frmDate))

 select   @1WeekStart= CONVERT(Date,FromDate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-01' )
select   @1WeekEnd =CONVERT(Date,Todate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-01' )



					select   @2WeekStart= CONVERT(Date,FromDate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-02' )
select   @2WeekEnd =CONVERT(Date,Todate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-02' )



						select   @3WeekStart= CONVERT(Date,FromDate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-03' )
select   @3WeekEnd =CONVERT(Date,Todate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-03' )

						select   @4WeekStart= CONVERT(Date,FromDate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-04' )
select   @4WeekEnd =CONVERT(Date,Todate) from tblWeekSetting where WeekName=( CAST(DATENAME(month, convert(Date,@frmDate)) as nvarchar(50))
                    + CAST( @monthStartValue AS NVARCHAR(10)) +'-'+ CAST((@monthStartValue+1) aS NVARCHAR(10))   + '-Week-04' )

  
  
DECLARE @MasterTable TABLE (
     
	    DoctorId int,
	    TerritoryId int,
     RegionName NVARCHAR(MAX) ,
      AreaName NVARCHAR(MAX) ,
      MIOCode NVARCHAR(MAX) ,
   MIOName NVARCHAR(MAX) ,
   DoctorName NVARCHAR(MAX) ,
   DegreeName NVARCHAR(MAX) ,
   DoctorSpeciality NVARCHAR(MAX) ,
   ProgramTypeName NVARCHAR(MAX) ,
    DoctorTypeName NVARCHAR(MAX), 
   DCRDocCount int  ,
  RXCount int  ,   DCPTotalCount int,
	  [1WeekV]  int,
	   [1WeekDCP]  int,
   
    [1WeekP]  int,
			   [2WeekV] int,
			    [2WeekDCP]  int,
  
    [2WeekP]  int,  [3WeekV]  int,
    [3WeekDCP]  int,
    [3WeekP]    int, [4WeekV]   int,
    [4WeekDCP]  int,
    [4WeekP]   int   
  )

  
   DECLARE @DoctorId int
   DECLARE @TerritoryId int
   DECLARE @RegionName NVARCHAR(MAX) 
   DECLARE @AreaName NVARCHAR(MAX) 
   DECLARE @MIOCode NVARCHAR(MAX) 
   DECLARE @MIOName NVARCHAR(MAX) 
   DECLARE @DoctorName NVARCHAR(MAX) 
   DECLARE @DegreeName NVARCHAR(MAX) 
   DECLARE @DoctorSpeciality NVARCHAR(MAX) 
   DECLARE @ProgramTypeName NVARCHAR(MAX) 
   DECLARE @DoctorTypeName NVARCHAR(MAX) 
  DECLARE @DCRDocCount int  
  DECLARE @RXCount int 
  declare @DCPTotalCount int 

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR



SELECT  DOC.DoctorId,MIO.TerritoryId
, RG.RegionCode+' : '+ RG.RegionName RegionName,AR.AreaCode+' : '+AR.AreaName AreaName ,  TE.TerritoryCode+ ' : '+Te.TerritoryName  MIOCode, EMP.EmpMasterCode+' : '+ EMP.EmpName  MIOName,   (DOC.DoctorCode + ' : '+DOC.DoctorName)AS DoctorName,     STUFF( (SELECT CONCAT(',', mm.DegreeName , '') FROM tblDoctorDegree mm (NOLOCK) INNER JOIN dbo.tblDoctorDegreeDetail mgd  with (nolock) ON mgd.DegId=mm.DegreeId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorDegId FOR XML PATH ('') ),1,1,'') DegreeName,STUFF( (SELECT CONCAT(',', mm.SpecialityName , '') FROM tblDoctorSpeciality mm  with (nolock) INNER JOIN dbo.tblDoctorSpecialityDetail mgd  with (nolock) ON mgd.SpecialityId=mm.SpecialityId WHERE mgd.DoctorId=DOC.DoctorId ORDER BY mgd.DoctorSpId FOR XML PATH ('') ),1,1,'') DoctorSpeciality  , pt.ProgramTypeName ProgramTypeName, dt.DoctorTypeName DoctorTypeName, isnull(tbDCRInfo.DCRDocCount,0) DCRDocCount,isnull(tbRXInfo.RXCount,0) RXCount,  ISNULL(tbDCPTotal.DCPTotalCount,0)   DCPTotalCount

FROM  tblDoctorMaster DOC  with (nolock)

INNER JOIN  dbo.tblMarket AS M  with (nolock) ON M.MarketId =  DOC.MarketId
INNER JOIN dbo.tblSubTerritory AS ST  with (nolock) ON ST.SubTerritoryId = M.SubTerritoryId 
inner JOIN tblTerritory TE  with (nolock) ON ST.TerritoryId = TE.TerritoryId
 
inner JOIN tblArea AR  with (nolock) ON Te.AreaId  = AR.AreaId
inner JOIN tblRegion  RG  with (nolock) ON  AR.RegionId = RG.RegionId
inner JOIN   tblMIOInfo MIO  with (nolock) ON  TE.TerritoryId = Mio.TerritoryId

inner JOIN tblEmpGeneralInfo EMP  with (nolock) ON MIO.EmployeeId = EMP.EmpInfoId
LEFT JOIN dbo.tblDoctorType  dt  with (nolock) ON DOC.DoctorTypeId=dt.DoctorTypeId
						LEFT JOIN dbo.tblProgramType pt  with (nolock) ON DOC.ProgramTypeId=pt.ProgramTypeId


						LEFT JOIN ( Select count(DOC.DocTPDetailsId)   DCPTotalCount,  DOC.DoctorId
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 
where   
    ( CONVERT(Date,DOC.TourPlanDate) between     @frmDate and @toDate   )
  and
  ( DOC.SMCTypeId_DV=1) and (dtl.ApprovalStatus='2')   
 
  GROUP BY DOC.DoctorId    )tbDCPTotal ON DOC.DoctorId = tbDCPTotal.DoctorId


 LEFT JOIN (     SELECT DoctorId, COUNT(Doc.DcrId) DCRDocCount
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
  and CONVERT(Date,DOC.DcrDate) between  @frmDate and @toDate

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId 
--HAVING COUNT(DoctorId) > 1
 )tbDCRInfo ON DOC.DoctorId = tbDCRInfo.DoctorId

   
    LEFT JOIN (  
	
	  Select  DOC.DoctorId, count(DOC.PrescriptionId) RXCount from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between  @frmDate and @toDate  and doc.SmcTypeId_RX=1
  

  GROUP BY DOC.DoctorId )tbRXInfo ON DOC.DoctorId = tbRXInfo.DoctorId

    

 where  MIO.isactive=1 and DOC.SMCTypeId=1   and ((RG.RegionId= COALESCE( NULLIF(@Zone , 0) ,RG.RegionId ))  and (AR.AreaId= COALESCE( NULLIF(@Area , 0) ,AR.AreaId ))  and (TE.TerritoryId= COALESCE( NULLIF(@Teritory , 0) ,TE.TerritoryId )) ) 

 and  (   isnull(tbDCRInfo.DCRDocCount,0) +isnull(tbRXInfo.RXCount,0) +  ISNULL(tbDCPTotal.DCPTotalCount,0)     )  >0 

 order by  TE.TerritoryCode asc
OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO       @DoctorId,  @TerritoryId ,
     @RegionName,
     @AreaName,
     @MIOCode ,
     @MIOName ,
     @DoctorName ,
     @DegreeName ,
     @DoctorSpeciality,
     @ProgramTypeName,
     @DoctorTypeName,
    @DCRDocCount,
    @RXCount  ,   @DCPTotalCount    
WHILE @@FETCH_STATUS = 0
BEGIN
 
 declare @1WeekV int 
 declare @1WeekDCP int 
 
 declare @1WeekP int 

	declare @2WeekV int 
	 declare @2WeekDCP int 
	
	declare @2WeekP int 

	declare @3WeekV int 
	 declare @3WeekDCP int 
	
	declare @3WeekP int 

declare 	@4WeekV int 
 declare @4WeekDCP int 
declare 	@4WeekP int 


 
   
	

	
	---1

	  select @1WeekDCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   

where  DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate) between  @1WeekStart and @1WeekEnd and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  

  select @1WeekV= count( DOC.DcrId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @1WeekStart and @1WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.DoctorId=@DoctorId



 select @1WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @1WeekStart and @1WeekEnd
  
    and DOC.DoctorId=@DoctorId

	---2

	  select @2WeekDCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   

where  DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate) between  @2WeekStart and @2WeekEnd and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  

  select @2WeekV= count( DOC.DcrId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @2WeekStart and @2WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.DoctorId=@DoctorId



 select @2WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @2WeekStart and @2WeekEnd
  
    and DOC.DoctorId=@DoctorId




---3

  select @3WeekDCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   

where  DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate) between  @3WeekStart and @3WeekEnd and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  


  select @3WeekV=  count( DOC.DcrId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @3WeekStart and @3WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.DoctorId=@DoctorId



 select @3WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @3WeekStart and @3WeekEnd
  
    and DOC.DoctorId=@DoctorId




---4

 select @4WeekDCP= count(*)      from tbl_DoctorTourPlanDetail DOC   with (nolock) 
  inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
   

where  DOC.SMCTypeId_DV=1 and   convert(Date,DOC.TourPlanDate) between  @4WeekStart and @4WeekEnd and DOC.Doctorid=@DoctorId and   Dtl.ApprovalStatus= '2'  


  select @4WeekV=  count( DOC.DcrId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @4WeekStart and @4WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.DoctorId=@DoctorId



 select @4WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @4WeekStart and @4WeekEnd
  
    and DOC.DoctorId=@DoctorId



  


 

INSERT INTO @MasterTable
(    DoctorId, TerritoryId ,   RegionName ,
      AreaName, 
      MIOCode ,
      MIOName,
     DoctorName ,
     DegreeName ,
       DoctorSpeciality,
      ProgramTypeName,
      DoctorTypeName,
     DCRDocCount , 
       
	        RXCount,DCPTotalCount,
   [1WeekV]   ,
   [1WeekDCP]   ,

    
    [1WeekP]   ,
			   [2WeekV]    ,
			    [2WeekDCP]    ,
   
    [2WeekP]     ,  [3WeekV]    ,
    [3WeekDCP]    ,
    [3WeekP]     ,  [4WeekV]    ,  [4WeekDCP]    ,
 
    [4WeekP]     
)
VALUES
( @DoctorId,  @TerritoryId ,   @RegionName ,
      @AreaName, 
      @MIOCode ,
      @MIOName,
     @DoctorName ,
     @DegreeName ,
     @DoctorSpeciality,
     @ProgramTypeName,
     @DoctorTypeName,
     @DCRDocCount , 
      
	        @RXCount,  @DCPTotalCount,
			  @1WeekV   ,
			  @1WeekDCP   ,
 
   @1WeekP  ,
			  @2WeekV   ,
    @2WeekDCP   ,
   @2WeekP    , @3WeekV   ,
    @3WeekDCP   ,
   @3WeekP    , @4WeekV   ,
   @4WeekDCP   ,
   @4WeekP    
   
   
    )






FETCH NEXT FROM @MyCursor
INTO   @DoctorId,  @TerritoryId ,
     @RegionName,
     @AreaName,
     @MIOCode ,
     @MIOName ,
     @DoctorName ,
     @DegreeName ,
     @DoctorSpeciality,
     @ProgramTypeName,
     @DoctorTypeName,
    @DCRDocCount,
    @RXCount    , @DCPTotalCount
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


select   
 DoctorId, TerritoryId ,   RegionName ,
      AreaName, 
      MIOCode ,
      MIOName,
       DoctorName ,
    DegreeName ,
     DoctorSpeciality,
     ProgramTypeName,
      DoctorTypeName,
     DCRDocCount , 
     
	        RXCount,   DCPTotalCount,
   [1WeekV]   ,
   [1WeekDCP]   ,

   
    [1WeekP]   ,
			   [2WeekV]    ,
  [2WeekDCP]   ,
    [2WeekP]     ,  [3WeekV]    ,
   [3WeekDCP]   ,
    [3WeekP]     ,  [4WeekV]    ,
   [4WeekDCP]   ,
    [4WeekP]     
 
	 
  	 from @MasterTable
	--order by MIOCode asc
 
 end