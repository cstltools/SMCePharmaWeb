CREATE PROCEDURE [dbo].[sp_Rpt_ZonewiseDoctorWeek] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	 
	 
	 
	@frmDate nvarchar(max),
	@toDate  nvarchar(max) ,
	@Zone  nvarchar(max) ,
	@Parameter  nvarchar(max)
AS
BEGIN
 
 declare @monthStartValue int

set  @monthStartValue= year(convert(Date,@frmDate))
 
	
				

 


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
     
	  RegionId int,
   RegionName NVARCHAR(MAX),
  
  AssignDocCount int ,  
   DCRDocCount int, 
   DCRTotalCount int, 
     RepatCount int, 
	     RXCount  int,
	     NORXCount  int, DCPTotalCount int, 
	  [1WeekDCP]  int,
	  [1WeekV]  int,
    [1WeekR] int,
    [1WeekP]  int,
    [1WeekNP]  int,

	  [2WeekDCP]  int,
			   [2WeekV] int,
   [2WeekR] int,
    [2WeekP]  int,
	 [2WeekNP]  int,   [3WeekDCP]  int,  [3WeekV]  int,
    [3WeekR] int,
    [3WeekP]    int,  [3WeekNP] int ,   [4WeekDCP]  int, [4WeekV]   int,
    [4WeekR] int,
    [4WeekP]   int ,[4WeekNP]  int
  )

  
   DECLARE @RegionId int
   DECLARE @RegionName NVARCHAR(MAX) 
   
  DECLARE @AssignDocCount int  
  DECLARE @DCRDocCount int 
  DECLARE @DCRTotalCount int 

     DECLARE @RepatCount int 
	     DECLARE @RXCount  int 
		 declare @NORXCount int
		 declare @DCPTotalCount int

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR





SELECT RG.RegionId
, RG.RegionCode +' : '+RG.RegionName RegionName,  ISNULL(AssignDocCount,0)   AssignDocCount, ISNULL(tbDCRInfo.DCRDocCount,0)   DCRDocCount, ISNULL(tbDCRTotal.DCRTotalCount,0)   DCRTotalCount, ISNULL(tbdcrRpt.RepatCount,0)   RepatCount, ISNULL(tbRXInfo.RXCount,0)   RXCount , ISNULL(tbRXPrescriber.RXCount,0)   NORXCount ,  ISNULL(tbDCPTotal.DCPTotalCount,0)   DCPTotalCount

FROM tblRegion  RG      with (nolock)   
--LEFT JOIN tblArea AR    with (nolock)  ON Te.AreaId  = AR.AreaId


LEFT JOIN (Select  RG.RegionId, count(RG.RegionId) AssignDocCount  from tblDoctorMaster DOC    with (nolock) 
inner join tblMarket MK    with (nolock)  ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST    with (nolock)  ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr    with (nolock)  ON tr.TerritoryId  = ST.TerritoryId
inner JOIN tblArea AR    with (nolock)  ON tr.AreaId  = AR.AreaId
inner JOIN tblRegion  RG    with (nolock)  ON  AR.RegionId = RG.RegionId

  where SMCTypeId=1 and DOC.ApprovalStatus='2' and DOC.IsActive=1
  GROUP BY RG.RegionId )tblAssaign ON RG.RegionId = tblAssaign.RegionId

 

    
  LEFT JOIN ( Select count( DOC.DocTPMaster)  DCPTotalCount,  DOC.RegionId
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
   and CONVERT(Date,DOC.TourPlanDate) between     @frmDate and @toDate   
  and
   mas.SMCTypeId=1
 
  GROUP BY DOC.RegionId    )tbDCPTotal ON RG.RegionId= tbDCPTotal.RegionId

  
  LEFT JOIN ( Select count( DOC.DCRID)  DCRTotalCount,  DOC.RegionId
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
  and CONVERT(Date,DOC.DcrDate) between     @frmDate and @toDate
  and doc.SmctypeId_Dcr=1
  GROUP BY DOC.RegionId    )tbDCRTotal ON RG.RegionId= tbDCRTotal.RegionId


  LEFT JOIN ( Select count( distinct DOC.DoctorId)  DCRDocCount,  DOC.RegionId
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @frmDate and @toDate
  and doc.SmctypeId_Dcr=1
  GROUP BY DOC.RegionId    )tbDCRInfo ON RG.RegionId= tbDCRInfo.RegionId


    LEFT JOIN (  
	
	  Select  DOC.RegionId, count(DOC.PrescriptionId) RXCount from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between  @frmDate and @toDate  and doc.SmcTypeId_RX=1
  

  GROUP BY DOC.RegionId )tbRXInfo ON RG.RegionId = tbRXInfo.RegionId

      LEFT JOIN (  select COUNT(DoctorId) RepatCount,RegionId  from (
	SELECT DoctorId, RegionId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between  @frmDate and @toDate
  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,RegionId
HAVING COUNT(DoctorId) > 1 ) rpt   group by RegionId)tbdcrRpt ON RG.RegionId = tbdcrRpt.RegionId



  LEFT JOIN ( 
	 select count( distinct DOC.DoctorId) RXCount,  DOC.RegionId 
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between     @frmDate and @toDate
  and doc.SmctypeId_RX=1
  GROUP BY DOC.RegionId   )tbRXPrescriber ON RG.RegionId = tbRXPrescriber.RegionId

 where   ((RG.RegionId= COALESCE( NULLIF(@Zone , 0) ,RG.RegionId ))  ) and ISNULL(tbDCRInfo.DCRDocCount,0)  + ISNULL(0,0)   + ISNULL(tbRXInfo.RXCount,0)  + ISNULL(tbDCPTotal.DCPTotalCount,0)    >0 
  order by RG.RegionCode asc


--  80 dcr
--40 doct
--38 doct 2 ber othoba 2 ar basi ber dice
--repert: 38

OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO       @RegionId ,  @RegionName  ,
    @AssignDocCount ,
    @DCRDocCount ,
	@DCRTotalCount, 
       @RepatCount , 
	       @RXCount, @NORXCount,@DCPTotalCount   
WHILE @@FETCH_STATUS = 0
BEGIN
 
 declare @1WeekDCP int 
 declare @1WeekV int 
 declare @1WeekR int 
 declare @1WeekP int 
 declare @1WeekNP int 

 declare @2WeekDCP int 

	declare @2WeekV int 
	declare @2WeekR int 
	declare @2WeekP int 
	 declare @2WeekNP int 


	  declare @3WeekDCP int 
	declare @3WeekV int 
	declare @3WeekR int 
	declare @3WeekP int 
	 declare @3WeekNP int 


	   declare @4WeekDCP int 
declare 	@4WeekV int 
declare 	@4WeekR int 
declare 	@4WeekP int 
declare 	@4WeekNP int 



 
   
	

	 
	---1
  
  

	select @1WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between     @1WeekStart and @1WeekEnd   and
   mas.SMCTypeId=1   and  DOC.RegionId=@RegionId 

  select @1WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @1WeekStart and @1WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.RegionId=@RegionId 
   
 select @1WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, RegionId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between @1WeekStart and @1WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,RegionId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.RegionId=@RegionId 
  

 select @1WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @1WeekStart and @1WeekEnd
  
    and DOC.RegionId=@RegionId  



  

	 select   @1WeekNP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @1WeekStart and @1WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.RegionId=@RegionId


	---2   
 

 select @2WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between      @2WeekStart and @2WeekEnd   and
   mas.SMCTypeId=1   and  DOC.RegionId=@RegionId 

  select @2WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @2WeekStart and @2WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.RegionId=@RegionId 
    

 select @2WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, RegionId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between   @2WeekStart and @2WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,RegionId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.RegionId=@RegionId 
  

 select @2WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between    @2WeekStart and @2WeekEnd
  
    and DOC.RegionId=@RegionId  



  

	 select   @2WeekNP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @2WeekStart and @2WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.RegionId=@RegionId

---3
  
   select @3WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between       @3WeekStart and @3WeekEnd   and
   mas.SMCTypeId=1     and  DOC.RegionId=@RegionId 
 select @3WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @3WeekStart and @3WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.RegionId=@RegionId 
  

 select @3WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, RegionId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between   @3WeekStart and @3WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,RegionId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.RegionId=@RegionId 
  

 select @3WeekP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @3WeekStart and @3WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.RegionId=@RegionId




 select @3WeekNP=     count(DOC.RegionId)  from (Select distinct DOC.DoctorId,  DOC.RegionId 
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @3WeekStart and @3WeekEnd
  and doc.SmctypeId_RX=1
  GROUP BY DOC.RegionId,DOC.DoctorId  )DOC where
  DOC.RegionId=@RegionId

---4 



 select @4WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between       @4WeekStart and @4WeekEnd   and
   mas.SMCTypeId=1     and  DOC.RegionId=@RegionId 

 select @4WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @4WeekStart and @4WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.RegionId=@RegionId 

 select @4WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, RegionId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between    @4WeekStart and @4WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,RegionId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.RegionId=@RegionId 
  

 select @4WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between    @4WeekStart and @4WeekEnd
  
    and DOC.RegionId=@RegionId  




 select @4WeekNP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @4WeekStart and @4WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.RegionId=@RegionId

 

  


 

INSERT INTO @MasterTable
(      RegionId ,   RegionName ,
      
     AssignDocCount ,
     DCRDocCount , DCRTotalCount,
        RepatCount , 
	        RXCount, NORXCount,DCPTotalCount,
   [1WeekDCP]   ,
   [1WeekV]   ,

    [1WeekR] , 
    [1WeekP]   ,
    [1WeekNP]   ,
	 [2WeekDCP]   ,
			   [2WeekV]    ,
   [2WeekR]  , 
    [2WeekP]     , 
	[2WeekNP]   ,

	 [3WeekDCP]   ,
	 [3WeekV]    ,
    [3WeekR]  , 
    [3WeekP]     ,
	[3WeekNP]   ,

	 [4WeekDCP]   ,
	  [4WeekV]    ,
    [4WeekR]  , 
    [4WeekP]  , [4WeekNP]   
)
VALUES
(    @RegionId ,   @RegionName ,
     @AssignDocCount ,
     @DCRDocCount , @DCRTotalCount,
        @RepatCount , 
	        @RXCount, @NORXCount,@DCPTotalCount,

			  @1WeekDCP   ,

			  @1WeekV   ,
   @1WeekR , 
   @1WeekP  ,
   @1WeekNP  ,
     @2WeekDCP   ,
			  @2WeekV   ,
   @2WeekR , 
   @2WeekP    ,  @2WeekNP  ,

     @3WeekDCP   ,
 @3WeekV   ,
   @3WeekR , 
   @3WeekP    ,  @3WeekNP  ,

     @4WeekDCP   ,
 @4WeekV   ,
   @4WeekR , 
   @4WeekP  ,  @4WeekNP  
  
   
   
    )






FETCH NEXT FROM @MyCursor
INTO    @RegionId ,     @RegionName ,
    
    @AssignDocCount ,
    @DCRDocCount , @DCRTotalCount,
       @RepatCount , 
	       @RXCount,@NORXCount,@DCPTotalCount
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


select   
    RegionId ,   RegionName ,
      
     AssignDocCount ,
     DCRDocCount , DCRTotalCount,
        RepatCount , 
	        RXCount, NORXCount,DCPTotalCount, [1WeekDCP]   ,
   [1WeekV]   ,
    [1WeekR] , 
    [1WeekP]   ,
    [1WeekNP]   ,
	[2WeekDCP],
			   [2WeekV]    ,
   [2WeekR]  , 
    [2WeekP]     , 
	[2WeekNP]   ,

		[3WeekDCP],
	 [3WeekV]    ,
    [3WeekR]  , 
    [3WeekP]     ,
	[3WeekNP]   ,

	[4WeekDCP],
	  [4WeekV]    ,
    [4WeekR]  , 
    [4WeekP]  , [4WeekNP]  
	 
  	 from @MasterTable
	--order by MIOCode asc
 
 end