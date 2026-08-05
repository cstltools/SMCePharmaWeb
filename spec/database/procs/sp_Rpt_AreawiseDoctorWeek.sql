CREATE PROCEDURE [dbo].[sp_Rpt_AreawiseDoctorWeek] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	 
	 
	 
	 
	@frmDate nvarchar(max),
	@toDate  nvarchar(max) ,
	@Zone nvarchar(max) ,
	@Area  nvarchar(max) ,
	@Parameter  nvarchar(max)
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
     
	   AreaId int,
   RegionName NVARCHAR(MAX),
    AreaName NVARCHAR(MAX),
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

  
   DECLARE  @AreaId int
   DECLARE @RegionName NVARCHAR(MAX) 
   
   DECLARE @AreaName NVARCHAR(MAX) 
  DECLARE @AssignDocCount int  
  DECLARE @DCRDocCount int 
  declare @DCRTotalCount int
     DECLARE @RepatCount int 
	     DECLARE @RXCount  int 
		 declare @NORXCount int
		 declare @DCPTotalCount int 

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR





SELECT AR.AreaId
, RG.RegionCode +' : '+RG.RegionName RegionName, AR.AreaCode+' : '+ AR.AreaName AreaName,  ISNULL(AssignDocCount,0)   AssignDocCount, ISNULL(tbDCRInfo.DCRDocCount,0)   DCRDocCount, ISNULL(tbDCRTotal.DCRTotalCount,0)   DCRTotalCount, ISNULL(tbdcrRpt.RepatCount,0)   RepatCount, ISNULL(tbRXInfo.RXCount,0)   RXCount , ISNULL(tbRXPrescriber.RXCount,0)   NORXCount ,  ISNULL(tbDCPTotal.DCPTotalCount,0)   DCPTotalCount

FROM    tblArea AR      with (nolock)   
 LEFT JOIN tblRegion  RG    with (nolock)  ON RG.RegionId  = AR.RegionId

LEFT JOIN (Select  AR.AreaId, count(DOC.DoctorId) AssignDocCount  from tblDoctorMaster DOC    with (nolock) 
inner join tblMarket MK    with (nolock)  ON  MK.MarketId = DOC.MarketId
inner JOIN tblSubTerritory ST    with (nolock)  ON MK.SubTerritoryId  = ST.SubTerritoryId
inner JOIN tblTerritory tr    with (nolock)  ON tr.TerritoryId  = ST.TerritoryId
inner JOIN tblArea AR    with (nolock)  ON tr.AreaId  = AR.AreaId 

  where SMCTypeId=1  and DOC.ApprovalStatus='2' and DOC.IsActive=1
  GROUP BY  AR.AreaId )tblAssaign ON AR.AreaId = tblAssaign.AreaId

  
    
  LEFT JOIN ( Select count( DOC.DocTPMaster)  DCPTotalCount,  DOC.AreaId
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 where dtl.ApprovalStatus='2'   
   and CONVERT(Date,DOC.TourPlanDate) between     @frmDate and @toDate   
  and
   DOC.SMCTypeId_DV=1
 
  GROUP BY DOC.AreaId    )tbDCPTotal ON AR.AreaId= tbDCPTotal.AreaId

  
  LEFT JOIN ( Select count( DOC.DCRID)  DCRTotalCount,  DOC.AreaId
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
  and CONVERT(Date,DOC.DcrDate) between     @frmDate and @toDate
  and doc.SmctypeId_Dcr=1
  GROUP BY DOC.AreaId    )tbDCRTotal ON AR.AreaId= tbDCRTotal.AreaId
  LEFT JOIN ( Select count( distinct DOC.DoctorId)  DCRDocCount,  DOC.AreaId
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @frmDate and @toDate
  and doc.SmctypeId_Dcr=1
  GROUP BY DOC.AreaId    )tbDCRInfo ON AR.AreaId= tbDCRInfo.AreaId


    LEFT JOIN (  
	
	  Select  DOC.AreaId, count(DOC.PrescriptionId) RXCount from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between  @frmDate and @toDate  and doc.SmcTypeId_RX=1
  

  GROUP BY DOC.AreaId )tbRXInfo ON AR.AreaId = tbRXInfo.AreaId

      LEFT JOIN (  select COUNT(DoctorId) RepatCount,AreaId  from (
	SELECT DoctorId, AreaId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between  @frmDate and @toDate
  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,AreaId
HAVING COUNT(DoctorId) > 1 ) rpt   group by AreaId)tbdcrRpt ON AR.AreaId = tbdcrRpt.AreaId



  LEFT JOIN ( 
	 select count( distinct DOC.DoctorId) RXCount,  DOC.AreaId 
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between     @frmDate and @toDate
  and doc.SmctypeId_RX=1
  GROUP BY DOC.AreaId   )tbRXPrescriber ON AR.AreaId = tbRXPrescriber.AreaId

 where   ((AR.AreaId= COALESCE( NULLIF(@Area , 0) ,AR.AreaId ))  and (RG.RegionId= COALESCE( NULLIF(@Zone , 0) ,RG.RegionId ))  ) and ISNULL(tbDCRInfo.DCRDocCount,0)  + ISNULL(0,0)   + ISNULL(tbRXInfo.RXCount,0)  + ISNULL(tbDCPTotal.DCPTotalCount,0)   >0 
  order by AR.AreaCode asc


--  80 dcr
--40 doct
--38 doct 2 ber othoba 2 ar basi ber dice
--repert: 38

OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO       @AreaId ,  @RegionName  , @AreaName,
    @AssignDocCount ,
    @DCRDocCount , @DCRTotalCount,
       @RepatCount , 
	       @RXCount, @NORXCount   , @DCPTotalCount
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
   mas.SMCTypeId=1   and  DOC.AreaId=@AreaId


  select @1WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @1WeekStart and @1WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.AreaId=@AreaId
   
 select @1WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId,  AreaId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between @1WeekStart and @1WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,AreaId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.AreaId=@AreaId 
  

 select @1WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   and doc.SmctypeId_RX=1 and CONVERT(Date,DOC.PrescriptionDate) between  @1WeekStart and @1WeekEnd
  
    and DOC.AreaId=@AreaId  



  

	 select   @1WeekNP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @1WeekStart and @1WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.AreaId=@AreaId


	---2   
 

 select @2WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between     @2WeekStart and @2WeekEnd   and
   mas.SMCTypeId=1   and  DOC.AreaId=@AreaId

  select @2WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @2WeekStart and @2WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.AreaId=@AreaId
    

 select @2WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, AreaId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between   @2WeekStart and @2WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,AreaId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.AreaId=@AreaId 
  

 select @2WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between    @2WeekStart and @2WeekEnd
  
    and DOC.AreaId=@AreaId  



  

	 select   @2WeekNP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @2WeekStart and @2WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.AreaId=@AreaId

---3
  

   select @3WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between     @3WeekStart and @3WeekEnd   and
   mas.SMCTypeId=1   and  DOC.AreaId=@AreaId

 select @3WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @3WeekStart and @3WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.AreaId=@AreaId
  

 select @3WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, AreaId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between   @3WeekStart and @3WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,AreaId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.AreaId=@AreaId
  

 select @3WeekP=  count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @3WeekStart and @3WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.AreaId=@AreaId




 select @3WeekNP=     count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @3WeekStart and @3WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.AreaId=@AreaId

---4 



   select @4WeekDCP=  count( DOC.DocTPMaster)    
from  tbl_DoctorTourPlanDetail  DOC   with (nolock) 
 inner join tbl_DoctorTourPlanMaster  dtl   with (nolock)  on  dtl.DocTPMaster=DOC.DocTPMaster
 inner join tblDoctorMaster mas  with (nolock)  on  DOC.DoctorId=mas.DoctorId
where dtl.ApprovalStatus='2'   
  and CONVERT(Date,DOC.TourPlanDate) between     @4WeekStart and @4WeekEnd   and
   mas.SMCTypeId=1   and  DOC.AreaId=@AreaId
 select @4WeekV= count( distinct DOC.DoctorId)
from tbl_DCRInfo DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between     @4WeekStart and @4WeekEnd
  and doc.SmctypeId_Dcr=1 and  DOC.AreaId=@AreaId 

 select @4WeekR= COUNT(DoctorId)   from (
	SELECT DoctorId, AreaId
FROM tbl_DCRInfo Doc where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.DcrDate) between    @4WeekStart and @4WeekEnd

  and doc.SmctypeId_Dcr=1   
GROUP BY DoctorId,AreaId
HAVING COUNT(DoctorId) > 1 ) rpt where     rpt.AreaId=@AreaId 
  

 select @4WeekP= count(DOC.PrescriptionId)   from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'  and CONVERT(Date,DOC.PrescriptionDate) between    @4WeekStart and @4WeekEnd
  
    and DOC.AreaId=@AreaId 




 select @4WeekNP=   count( distinct DOC.DoctorId)   
from tbl_PrescriptionMaster DOC    with (nolock) 
 
where DOC.ApprovalStatus='2'   
 and CONVERT(Date,DOC.PrescriptionDate) between    @4WeekStart and @4WeekEnd
  
  and doc.SmctypeId_RX=1 and  DOC.AreaId=@AreaId

 

  


 

INSERT INTO @MasterTable
(      AreaId ,   RegionName ,AreaName,
      
     AssignDocCount ,
     DCRDocCount , DCRTotalCount,
        RepatCount , 
	        RXCount, NORXCount, DCPTotalCount,
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
(    @AreaId ,   @RegionName , @AreaName,
     @AssignDocCount ,
     @DCRDocCount , @DCRTotalCount,
        @RepatCount , 
	        @RXCount, @NORXCount, @DCPTotalCount,
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
INTO   @AreaId ,  @RegionName  , @AreaName,
    
    @AssignDocCount ,
    @DCRDocCount , @DCRTotalCount,
       @RepatCount , 
	       @RXCount,@NORXCount,@DCPTotalCount
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


select   
    AreaId ,   RegionName , AreaName  ,
      
     AssignDocCount ,
     DCRDocCount , DCRTotalCount,
        RepatCount , 
	        RXCount, NORXCount, DCPTotalCount,
   [1WeekDCP]   ,
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