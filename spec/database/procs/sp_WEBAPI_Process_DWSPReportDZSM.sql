
CREATE PROCEDURE [dbo].[sp_WEBAPI_Process_DWSPReportDZSM] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	 
	 
	@MonthValue int ,
	@Year nvarchar(max),
	@Role nvarchar(max),

	@EmpId int 

AS
BEGIN
declare @DateNew date 
 
SELECT @DateNew=CONVERT(date, DATEFROMPARTS(@Year,@MonthValue,'01'))


 
 

 
 --delete from tblFoodRateReport where FORMAT(ReportDate,'MMM-yy')=@Date
DECLARE @MasterTable TABLE (
     TerritoryId int NULL,
	 
   TerritoryCode NVARCHAR(MAX),
   TerritoryName NVARCHAR(MAX),
  
  
	[1Week] decimal (18,2),
	[2Week] decimal (18,2),
	[3Week] decimal (18,2),
	[4Week] decimal (18,2),
	 
	[1WeekPer] decimal (18,2),
	[2WeekPer] decimal (18,2),
	[3WeekPer] decimal (18,2),
	[4WeekPer] decimal (18,2)  ,
	[Total] decimal (18,2) 


  )

  DECLARE @TerritoryId int=null
 
 
DECLARE @TerritoryCode NVARCHAR(MAX)
DECLARE @TerritoryName NVARCHAR(MAX) 
 

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR






  select distinct tr.TerritoryId,   tr.TerritoryCode  , tr.TerritoryName
   from tblTerritory tr  with (nolock)   
inner join tblArea ar on ar.AreaId=tr.AreaId and ar.IsActive=1
inner join tblRegion rg on ar.RegionId=rg.RegionId and rg.IsActive=1

where tr.IsActive=1     and rg.RegionId in (@EmpId)


 

OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO      @TerritoryId ,
 
   
   @TerritoryCode,
  @TerritoryName 
WHILE @@FETCH_STATUS = 0
BEGIN
 
 declare @1Week decimal (18,2) 
	declare @2Week decimal (18,2) 
	declare @3Week decimal (18,2) 
declare 	@4Week decimal (18,2) 
declare 	@5Week decimal (18,2)  

declare 	@1WeekPer decimal (18,2) 
	declare @2WeekPer decimal (18,2) 
	declare @3WeekPer decimal (18,2) 
	declare @4WeekPer decimal (18,2) 

	declare @5WeekPer decimal (18,2) 
	declare @Total decimal (18,2) 
	

	
	---1
  select @1Week= ISNULL(dtl.GeneralAmount,0)+ISNULL(dtl.FCBAmount,0)+ISNULL(dtl.CampaignAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate) between   1 and 7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId and   mas.ApprovalStatus= '2'
 
    select @2Week= ISNULL(dtl.GeneralAmount,0)+ISNULL(dtl.FCBAmount,0)+ISNULL(dtl.CampaignAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate) between   8 and 15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId and   mas.ApprovalStatus= '2'


 select @3Week= ISNULL(dtl.GeneralAmount,0)+ISNULL(dtl.FCBAmount,0)+ISNULL(dtl.CampaignAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate) between   16 and 23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId and   mas.ApprovalStatus= '2'

 select @4Week= ISNULL(dtl.GeneralAmount,0)+ISNULL(dtl.FCBAmount,0)+ISNULL(dtl.CampaignAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate) between   24 and  31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId and   mas.ApprovalStatus= '2'

SET @Total =
ISNULL(@1Week,0)+
ISNULL(@2Week,0)+
ISNULL(@3Week,0)+
ISNULL(@4Week,0) 


 

INSERT INTO @MasterTable
(   TerritoryId ,
  
   
  TerritoryCode, TerritoryName,
  [1Week], [2Week], [3Week], [4Week],
   
	[Total] 
)
VALUES
(   @TerritoryId ,  @TerritoryCode, @TerritoryName,
  @1Week, @2Week, @3Week, @4Week,
   
	@Total
   
    )






FETCH NEXT FROM @MyCursor
INTO    @TerritoryId ,
 
   
   @TerritoryCode,
  @TerritoryName 
END
CLOSE @MyCursor
DEALLOCATE @MyCursor

select   
 
  
  TerritoryCode +' : '+ TerritoryName Territory,

   
   
  CAST(ISNULL([1Week],0) as nvarchar(max)) FirstWeek,  
  CAST(CONVERT (decimal(18,2), ISNULL( NULLIF(( ISNULL([1Week],0)/NULLIF([Total], 0))* 100,0),0)) as nvarchar(max))+'%' as FirstWeek_Percent ,  
  
  CAST( ISNULL([2Week],0)  as nvarchar(max)) SecondWeek, 
    CAST(CONVERT (decimal(18,2), ISNULL( NULLIF(( ISNULL([2Week],0)/NULLIF([Total], 0))* 100,0),0)) as nvarchar(max))+'%' as SecondWeek_Percent,
	
	  CAST(ISNULL([3Week],0) as nvarchar(max)) ThirdWeek,    CAST(CONVERT (decimal(18,2), ISNULL( NULLIF(( ISNULL([3Week],0)/NULLIF([Total], 0))* 100,0),0)) as nvarchar(max))+'%' as ThirdWeek_Percent, CAST(CONVERT (decimal(18,2),ISNULL([4Week],0)) as nvarchar(max)) RestDay,  CAST(CONVERT (decimal(18,2),ISNULL( NULLIF(( ISNULL([4Week],0)/NULLIF([Total], 0))* 100, 0),0)) as nvarchar(max))+'%' as RestDay_Percent,
   
	CAST(CONVERT (decimal(18,2),ISNULL([Total],0)) as nvarchar(max))  Total
 
  	 from @MasterTable     where ISNULL([Total],0)>0
	order by TerritoryCode asc
 
 end

