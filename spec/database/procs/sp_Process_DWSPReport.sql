
CREATE PROCEDURE [dbo].[sp_Process_DWSPReport] --exec sp_GetHourlySweingOutput '20-sep-2020' 
	 
	@Month nvarchar(max),
	@MonthValue int ,
	@Year nvarchar(max),
	@ApprovalStatus  nvarchar(Max),
	@RegionId  nvarchar(Max),
	@AreaId  nvarchar(Max),
	@TrId  nvarchar(Max)


	-- @Date nvarchar(max) 
AS
BEGIN
declare @DateNew date 
 
SELECT @DateNew=CONVERT(date, DATEFROMPARTS(@Year,@MonthValue,'01'))


 
 
 --delete from tblFoodRateReport where FORMAT(ReportDate,'MMM-yy')=@Date
DECLARE @MasterTable TABLE (
     TerritoryId int NULL,
	 EmpMasterCode VARCHAR(MAX) NULL,
	 EmpName VARCHAR(MAX) NULL , 
   TerritoryCode NVARCHAR(MAX),
   DesigName NVARCHAR(MAX),
   RoleName NVARCHAR(MAX) 
   ,
 TargetSetof decimal (18,2),

	[1_Gen] decimal (18,2),
	[1_FCB] decimal (18,2),
	[1_Cam] decimal (18,2),
	[1_Total] decimal (18,2),

	[2_Gen] decimal (18,2),
	[2_FCB] decimal (18,2),
	[2_Cam] decimal (18,2),
	[2_Total] decimal (18,2),

	[3_Gen] decimal (18,2),
	[3_FCB] decimal (18,2),
	[3_Cam] decimal (18,2),
	[3_Total] decimal (18,2),

	[4_Gen] decimal (18,2),
	[4_FCB] decimal (18,2),
	[4_Cam] decimal (18,2),
	[4_Total] decimal (18,2),

	[5_Gen] decimal (18,2),
	[5_FCB] decimal (18,2),
	[5_Cam] decimal (18,2),
	[5_Total] decimal (18,2),

	[6_Gen] decimal (18,2),
	[6_FCB] decimal (18,2),
	[6_Cam] decimal (18,2),
	[6_Total] decimal (18,2),

	[7_Gen] decimal (18,2),
	[7_FCB] decimal (18,2),
	[7_Cam] decimal (18,2),
	[7_Total] decimal (18,2),

	[8_Gen] decimal (18,2),
	[8_FCB] decimal (18,2),
	[8_Cam] decimal (18,2),
	[8_Total] decimal (18,2),

	[9_Gen] decimal (18,2),
	[9_FCB] decimal (18,2),
	[9_Cam] decimal (18,2),
	[9_Total] decimal (18,2),

	[10_Gen] decimal (18,2),
	[10_FCB] decimal (18,2),
	[10_Cam] decimal (18,2),
	[10_Total] decimal (18,2),

	[11_Gen] decimal (18,2),
	[11_FCB] decimal (18,2),
	[11_Cam] decimal (18,2),
	[11_Total] decimal (18,2),

	[12_Gen] decimal (18,2),
	[12_FCB] decimal (18,2),
	[12_Cam] decimal (18,2),
	[12_Total] decimal (18,2),

	[13_Gen] decimal (18,2),
	[13_FCB] decimal (18,2),
	[13_Cam] decimal (18,2),
	[13_Total] decimal (18,2),

	[14_Gen] decimal (18,2),
	[14_FCB] decimal (18,2),
	[14_Cam] decimal (18,2),
	[14_Total] decimal (18,2),

	[15_Gen] decimal (18,2),
	[15_FCB] decimal (18,2),
	[15_Cam] decimal (18,2),
	[15_Total] decimal (18,2),

	[16_Gen] decimal (18,2),
	[16_FCB] decimal (18,2),
	[16_Cam] decimal (18,2),
	[16_Total] decimal (18,2),

	[17_Gen] decimal (18,2),
	[17_FCB] decimal (18,2),
	[17_Cam] decimal (18,2),
	[17_Total] decimal (18,2),

	[18_Gen] decimal (18,2),
	[18_FCB] decimal (18,2),
	[18_Cam] decimal (18,2),
	[18_Total] decimal (18,2),

	[19_Gen] decimal (18,2),
	[19_FCB] decimal (18,2),
	[19_Cam] decimal (18,2),
	[19_Total] decimal (18,2),

	[20_Gen] decimal (18,2),
	[20_FCB] decimal (18,2),
	[20_Cam] decimal (18,2),
	[20_Total] decimal (18,2),

	[21_Gen] decimal (18,2),
	[21_FCB] decimal (18,2),
	[21_Cam] decimal (18,2),
	[21_Total] decimal (18,2),

	[22_Gen] decimal (18,2),
	[22_FCB] decimal (18,2),
	[22_Cam] decimal (18,2),
	[22_Total] decimal (18,2),

	[23_Gen] decimal (18,2),
	[23_FCB] decimal (18,2),
	[23_Cam] decimal (18,2),
	[23_Total] decimal (18,2),

	[24_Gen] decimal (18,2),
	[24_FCB] decimal (18,2),
	[24_Cam] decimal (18,2),
	[24_Total] decimal (18,2),

	[25_Gen] decimal (18,2),
	[25_FCB] decimal (18,2),
	[25_Cam] decimal (18,2),
	[25_Total] decimal (18,2),

	[26_Gen] decimal (18,2),
	[26_FCB] decimal (18,2),
	[26_Cam] decimal (18,2),
	[26_Total] decimal (18,2),

	[27_Gen] decimal (18,2),
	[27_FCB] decimal (18,2),
	[27_Cam] decimal (18,2),
	[27_Total] decimal (18,2),

	[28_Gen] decimal (18,2),
	[28_FCB] decimal (18,2),
	[28_Cam] decimal (18,2),
	[28_Total] decimal (18,2),

	[29_Gen] decimal (18,2),
	[29_FCB] decimal (18,2),
	[29_Cam] decimal (18,2),
	[29_Total] decimal (18,2),

	[30_Gen] decimal (18,2),
	[30_FCB] decimal (18,2),
	[30_Cam] decimal (18,2),
	[30_Total] decimal (18,2),

	[31_Gen] decimal (18,2),
	[31_FCB] decimal (18,2),
	[31_Cam] decimal (18,2),
	[31_Total] decimal (18,2) ,
[Total_Gen] decimal (18,2),
	[Total_FCB] decimal (18,2),
	[Total_Cam] decimal (18,2),
	[Grand_Total] decimal (18,2) 
)
 
   
DECLARE @TerritoryId int=null
 
DECLARE @EmpMasterCode NVARCHAR(MAX)
DECLARE @EmpName NVARCHAR(MAX) 
DECLARE @TerritoryCode NVARCHAR(MAX)
DECLARE @DesigName NVARCHAR(MAX) 
DECLARE @RoleName NVARCHAR(MAX) 
Declare @TargetSetof decimal (18,2) 


 
---select * from tblProductionBarCodeScanOutputMaster

DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR


  select distinct tr.TerritoryId,  Emp.EmpMasterCode, tr.TerritoryCode ,ISNULL(Emp.EmpName,'Vaccant') EmpName,  dgs.DesigName , ur.RoleName ,isnull(twt.Amount,0) TargetSetof  
   from tblTerritory tr  with (nolock)
left join tblMIOInfo mio   with (nolock) on tr.TerritoryId=mio.TerritoryId   and mio.IsActive=1 
 
left join tblTerritoryWiseTargetSetup twt   with (nolock) on twt.TerritoryId=tr.TerritoryId
left join tblEmpGeneralInfo Emp   with (nolock)  on Emp.EmpInfoId=mio.EmployeeId 
left join tblDesignation dgs   with (nolock)  on Emp.DesignationId=dgs.DesignationId
left join tblUser us   with (nolock)  on Emp.EmpInfoId=us.EmpInfoId
left join tbl_UserRoleInfo ur   with (nolock)  on ur.UserRoleID=us.UserRoleID
left join tblArea ar on ar.AreaId=tr.AreaId and ar.IsActive=1
left join tblRegion rg on ar.RegionId=rg.RegionId and rg.IsActive=1

where tr.IsActive=1   and  twt.Month=@Month and twt.Year=@Year    and ((rg.RegionId= COALESCE( NULLIF(@RegionId , 0) ,rg.RegionId ))  and (ar.AreaId= COALESCE( NULLIF(@AreaId , 0) ,ar.AreaId )) and (tr.TerritoryId= COALESCE( NULLIF(@TrId , 0) ,tr.TerritoryId )) )


OPEN @MyCursor
FETCH NEXT FROM @MyCursor 
INTO      @TerritoryId ,
 
  @EmpMasterCode ,
   @TerritoryCode,
  @EmpName ,
 
  @DesigName ,
  @RoleName ,@TargetSetof 
WHILE @@FETCH_STATUS = 0
BEGIN



  
DECLARE @1_Gen decimal (18,2)   =null
DECLARE @1_FCB decimal (18,2)   =null
DECLARE @1_Cam decimal (18,2)   =null
DECLARE @1_Total decimal (18,2)   =null
  
DECLARE @2_Gen decimal (18,2)   =null
DECLARE @2_FCB decimal (18,2)   =null
DECLARE @2_Cam decimal (18,2)   =null
DECLARE @2_Total decimal (18,2)   =null
  
DECLARE @3_Gen decimal (18,2)   =null
DECLARE @3_FCB decimal (18,2)   =null
DECLARE @3_Cam decimal (18,2)   =null
DECLARE @3_Total decimal (18,2)   =null
  
DECLARE @4_Gen decimal (18,2)   =null
DECLARE @4_FCB decimal (18,2)   =null
DECLARE @4_Cam decimal (18,2)   =null
DECLARE @4_Total decimal (18,2)   =null
  
DECLARE @5_Gen decimal (18,2)   =null
DECLARE @5_FCB decimal (18,2)   =null
DECLARE @5_Cam decimal (18,2)   =null
DECLARE @5_Total decimal (18,2)   =null
  
DECLARE @6_Gen decimal (18,2)   =null
DECLARE @6_FCB decimal (18,2)   =null
DECLARE @6_Cam decimal (18,2)   =null
DECLARE @6_Total decimal (18,2)   =null
  
DECLARE @7_Gen decimal (18,2)   =null
DECLARE @7_FCB decimal (18,2)   =null
DECLARE @7_Cam decimal (18,2)   =null
DECLARE @7_Total decimal (18,2)   =null
  
DECLARE @8_Gen decimal (18,2)   =null
DECLARE @8_FCB decimal (18,2)   =null
DECLARE @8_Cam decimal (18,2)   =null
DECLARE @8_Total decimal (18,2)   =null
  
DECLARE @9_Gen decimal (18,2)   =null
DECLARE @9_FCB decimal (18,2)   =null
DECLARE @9_Cam decimal (18,2)   =null
DECLARE @9_Total decimal (18,2)   =null
  
DECLARE @10_Gen decimal (18,2)   =null
DECLARE @10_FCB decimal (18,2)   =null
DECLARE @10_Cam decimal (18,2)   =null
DECLARE @10_Total decimal (18,2)   =null
  
DECLARE @11_Gen decimal (18,2)   =null
DECLARE @11_FCB decimal (18,2)   =null
DECLARE @11_Cam decimal (18,2)   =null
DECLARE @11_Total decimal (18,2)   =null
  
DECLARE @12_Gen decimal (18,2)   =null
DECLARE @12_FCB decimal (18,2)   =null
DECLARE @12_Cam decimal (18,2)   =null
DECLARE @12_Total decimal (18,2)   =null
  
DECLARE @13_Gen decimal (18,2)   =null
DECLARE @13_FCB decimal (18,2)   =null
DECLARE @13_Cam decimal (18,2)   =null
DECLARE @13_Total decimal (18,2)   =null
  
DECLARE @14_Gen decimal (18,2)   =null
DECLARE @14_FCB decimal (18,2)   =null
DECLARE @14_Cam decimal (18,2)   =null
DECLARE @14_Total decimal (18,2)   =null
  
DECLARE @15_Gen decimal (18,2)   =null
DECLARE @15_FCB decimal (18,2)   =null
DECLARE @15_Cam decimal (18,2)   =null
DECLARE @15_Total decimal (18,2)   =null

DECLARE @16_Gen decimal (18,2)   =null
DECLARE @16_FCB decimal (18,2)   =null
DECLARE @16_Cam decimal (18,2)   =null
DECLARE @16_Total decimal (18,2)   =null
  
DECLARE @17_Gen decimal (18,2)   =null
DECLARE @17_FCB decimal (18,2)   =null
DECLARE @17_Cam decimal (18,2)   =null
DECLARE @17_Total decimal (18,2)   =null
  
DECLARE @18_Gen decimal (18,2)   =null
DECLARE @18_FCB decimal (18,2)   =null
DECLARE @18_Cam decimal (18,2)   =null
DECLARE @18_Total decimal (18,2)   =null
  
DECLARE @19_Gen decimal (18,2)   =null
DECLARE @19_FCB decimal (18,2)   =null
DECLARE @19_Cam decimal (18,2)   =null
DECLARE @19_Total decimal (18,2)   =null
  
DECLARE @20_Gen decimal (18,2)   =null
DECLARE @20_FCB decimal (18,2)   =null
DECLARE @20_Cam decimal (18,2)   =null
DECLARE @20_Total decimal (18,2)   =null
  
DECLARE @21_Gen decimal (18,2)   =null
DECLARE @21_FCB decimal (18,2)   =null
DECLARE @21_Cam decimal (18,2)   =null
DECLARE @21_Total decimal (18,2)   =null
  
DECLARE @22_Gen decimal (18,2)   =null
DECLARE @22_FCB decimal (18,2)   =null
DECLARE @22_Cam decimal (18,2)   =null
DECLARE @22_Total decimal (18,2)   =null
  
DECLARE @23_Gen decimal (18,2)   =null
DECLARE @23_FCB decimal (18,2)   =null
DECLARE @23_Cam decimal (18,2)   =null
DECLARE @23_Total decimal (18,2)   =null
  
DECLARE @24_Gen decimal (18,2)   =null
DECLARE @24_FCB decimal (18,2)   =null
DECLARE @24_Cam decimal (18,2)   =null
DECLARE @24_Total decimal (18,2)   =null
  
DECLARE @25_Gen decimal (18,2)   =null
DECLARE @25_FCB decimal (18,2)   =null
DECLARE @25_Cam decimal (18,2)   =null
DECLARE @25_Total decimal (18,2)   =null
  
DECLARE @26_Gen decimal (18,2)   =null
DECLARE @26_FCB decimal (18,2)   =null
DECLARE @26_Cam decimal (18,2)   =null
DECLARE @26_Total decimal (18,2)   =null
  
DECLARE @27_Gen decimal (18,2)   =null
DECLARE @27_FCB decimal (18,2)   =null
DECLARE @27_Cam decimal (18,2)   =null
DECLARE @27_Total decimal (18,2)   =null
  
DECLARE @28_Gen decimal (18,2)   =null
DECLARE @28_FCB decimal (18,2)   =null
DECLARE @28_Cam decimal (18,2)   =null
DECLARE @28_Total decimal (18,2)   =null
  
DECLARE @29_Gen decimal (18,2)   =null
DECLARE @29_FCB decimal (18,2)   =null
DECLARE @29_Cam decimal (18,2)   =null
DECLARE @29_Total decimal (18,2)   =null
  
DECLARE @30_Gen decimal (18,2)   =null
DECLARE @30_FCB decimal (18,2)   =null
DECLARE @30_Cam decimal (18,2)   =null
DECLARE @30_Total decimal (18,2)   =null
  
DECLARE @31_Gen decimal (18,2)   =null
DECLARE @31_FCB decimal (18,2)   =null
DECLARE @31_Cam decimal (18,2)   =null
DECLARE @31_Total decimal (18,2)   =null
   
 DECLARE @Total_Gen decimal (18,2) =null
	DECLARE @Total_FCB decimal (18,2) =null
	DECLARE @Total_Cam decimal (18,2) =null
	DECLARE @Grand_Total decimal (18,2) =null 
	

	if(@ApprovalStatus='Select')
	begin 
	---1
  select @1_Gen= ISNULL(dtl.GeneralAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId   
 

  select @1_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @1_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @1_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

---2
  select @2_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @2_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @2_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @2_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---3
  select @3_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @3_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @3_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @3_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---4
  select @4_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @4_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @4_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @4_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---5
  select @5_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @5_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @5_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @5_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---6
  select @6_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @6_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @6_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @6_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---7
  select @7_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @7_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @7_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @7_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---8
  select @8_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @8_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @8_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @8_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---9
  select @9_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @9_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @9_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @9_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---10
  select @10_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @10_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @10_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @10_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---11
  select @11_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @11_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @11_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @11_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---12
  select @12_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @12_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @12_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @12_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
 


---13
  select @13_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @13_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @13_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @13_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---14
  select @14_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @14_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @14_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @14_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---15
  select @15_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @15_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @15_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @15_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---16
  select @16_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @16_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @16_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @16_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---17
  select @17_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @17_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @17_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @17_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---18
  select @18_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @18_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @18_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @18_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---19
  select @19_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @19_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @19_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @19_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  


---20
  select @20_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @20_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @20_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @20_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  




---21
  select @21_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @21_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @21_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @21_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---22
  select @22_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @22_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @22_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @22_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---23
  select @23_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @23_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @23_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @23_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---24
  select @24_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @24_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @24_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @24_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  



---25
  select @25_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @25_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @25_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @25_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  





---26
  select @26_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @26_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @26_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @26_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  





---27
  select @27_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @27_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @27_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @27_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  




---28
  select @28_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @28_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @28_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @28_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  





---29
  select @29_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @29_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @29_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @29_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  




---30
  select @30_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @30_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @30_Cam=   ISNULL(dtl.CampaignAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @30_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  






---31
  select @31_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @31_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  
  select @31_Cam=   ISNULL(dtl.CampaignAmount,0)     from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  

  select @31_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  
  

	end

	else
	begin 
	---1
  select @1_Gen= ISNULL(dtl.GeneralAmount,0)   from  tbl_DWSPMaster mas   with (nolock) 
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId and   mas.ApprovalStatus= @ApprovalStatus
 

  select @1_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @1_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @1_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=1 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

---2
  select @2_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @2_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @2_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @2_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=2 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---3
  select @3_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @3_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @3_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @3_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=3 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---4
  select @4_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @4_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @4_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @4_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=4 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---5
  select @5_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @5_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @5_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @5_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=5 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---6
  select @6_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @6_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @6_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @6_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=6 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---7
  select @7_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @7_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @7_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @7_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=7 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---8
  select @8_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @8_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @8_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @8_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=8 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---9
  select @9_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @9_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @9_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @9_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=9 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---10
  select @10_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @10_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @10_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @10_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=10 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---11
  select @11_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @11_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @11_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @11_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=11 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---12
  select @12_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @12_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @12_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @12_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=12 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
 


---13
  select @13_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @13_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @13_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @13_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=13 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---14
  select @14_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @14_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @14_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @14_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=14 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---15
  select @15_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @15_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @15_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @15_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=15 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---16
  select @16_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @16_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @16_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @16_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=16 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---17
  select @17_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @17_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @17_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @17_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=17 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---18
  select @18_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @18_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @18_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @18_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=18 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---19
  select @19_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @19_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @19_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @19_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=19 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus


---20
  select @20_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @20_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @20_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @20_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=20 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus




---21
  select @21_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @21_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @21_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @21_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=21 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---22
  select @22_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @22_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @22_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @22_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=22 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---23
  select @23_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @23_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @23_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @23_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=23 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---24
  select @24_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @24_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @24_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @24_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=24 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus



---25
  select @25_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @25_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @25_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @25_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=25 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus





---26
  select @26_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @26_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @26_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @26_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=26 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus





---27
  select @27_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @27_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @27_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @27_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=27 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus




---28
  select @28_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @28_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @28_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @28_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=28 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus





---29
  select @29_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @29_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @29_Cam=ISNULL(dtl.CampaignAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @29_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=29 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus




---30
  select @30_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @30_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @30_Cam=   ISNULL(dtl.CampaignAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @30_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=30 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus






---31
  select @31_Gen= ISNULL(dtl.GeneralAmount,0)   from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @31_FCB=ISNULL(dtl.FCBAmount,0) from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
  select @31_Cam=   ISNULL(dtl.CampaignAmount,0)     from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus

  select @31_Total=    ISNULL(dtl.GeneralAmount+dtl.CampaignAmount+dtl.FCBAmount,0)    from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  DAY(dtl.DWSPDate)=31 and Month(dtl.DWSPDate)=Month(@DateNew) and Year(dtl.DWSPDate)=year(@DateNew)  and mas.TerritoryId=@TerritoryId  and   mas.ApprovalStatus= @ApprovalStatus
  
	end

SET @Total_Gen=
ISNULL(@1_Gen,0)+
ISNULL(@2_Gen,0)+
ISNULL(@3_Gen,0)+
ISNULL(@4_Gen,0)+
ISNULL(@5_Gen,0)+
ISNULL(@6_Gen,0)+
ISNULL(@7_Gen,0)+
ISNULL(@8_Gen,0)+
ISNULL(@9_Gen,0)+
ISNULL(@10_Gen,0)+
ISNULL(@11_Gen,0)+
ISNULL(@12_Gen,0)+
ISNULL(@13_Gen,0)+
ISNULL(@14_Gen,0)+
ISNULL(@15_Gen,0)+
ISNULL(@16_Gen,0)+
ISNULL(@17_Gen,0)+
ISNULL(@18_Gen,0)+
ISNULL(@19_Gen,0)+
ISNULL(@20_Gen,0)+
ISNULL(@21_Gen,0)+
ISNULL(@22_Gen,0)+
ISNULL(@23_Gen,0)+
ISNULL(@24_Gen,0)+
ISNULL(@25_Gen,0)+
ISNULL(@26_Gen,0)+
ISNULL(@27_Gen,0)+
ISNULL(@28_Gen,0)+
ISNULL(@29_Gen,0)+
ISNULL(@30_Gen,0)+
ISNULL(@31_Gen,0)




SET @Total_FCB=
ISNULL(@1_FCB,0)+
ISNULL(@2_FCB,0)+
ISNULL(@3_FCB,0)+
ISNULL(@4_FCB,0)+
ISNULL(@5_FCB,0)+
ISNULL(@6_FCB,0)+
ISNULL(@7_FCB,0)+
ISNULL(@8_FCB,0)+
ISNULL(@9_FCB,0)+
ISNULL(@10_FCB,0)+
ISNULL(@11_FCB,0)+
ISNULL(@12_FCB,0)+
ISNULL(@13_FCB,0)+
ISNULL(@14_FCB,0)+
ISNULL(@15_FCB,0)+
ISNULL(@16_FCB,0)+
ISNULL(@17_FCB,0)+
ISNULL(@18_FCB,0)+
ISNULL(@19_FCB,0)+
ISNULL(@20_FCB,0)+
ISNULL(@21_FCB,0)+
ISNULL(@22_FCB,0)+
ISNULL(@23_FCB,0)+
ISNULL(@24_FCB,0)+
ISNULL(@25_FCB,0)+
ISNULL(@26_FCB,0)+
ISNULL(@27_FCB,0)+
ISNULL(@28_FCB,0)+
ISNULL(@29_FCB,0)+
ISNULL(@30_FCB,0)+
ISNULL(@31_FCB,0)




SET @Total_Cam=
ISNULL(@1_Cam,0)+
ISNULL(@2_Cam,0)+
ISNULL(@3_Cam,0)+
ISNULL(@4_Cam,0)+
ISNULL(@5_Cam,0)+
ISNULL(@6_Cam,0)+
ISNULL(@7_Cam,0)+
ISNULL(@8_Cam,0)+
ISNULL(@9_Cam,0)+
ISNULL(@10_Cam,0)+
ISNULL(@11_Cam,0)+
ISNULL(@12_Cam,0)+
ISNULL(@13_Cam,0)+
ISNULL(@14_Cam,0)+
ISNULL(@15_Cam,0)+
ISNULL(@16_Cam,0)+
ISNULL(@17_Cam,0)+
ISNULL(@18_Cam,0)+
ISNULL(@19_Cam,0)+
ISNULL(@20_Cam,0)+
ISNULL(@21_Cam,0)+
ISNULL(@22_Cam,0)+
ISNULL(@23_Cam,0)+
ISNULL(@24_Cam,0)+
ISNULL(@25_Cam,0)+
ISNULL(@26_Cam,0)+
ISNULL(@27_Cam,0)+
ISNULL(@28_Cam,0)+
ISNULL(@29_Cam,0)+
ISNULL(@30_Cam,0)+
ISNULL(@31_Cam,0)




SET @Grand_Total=
ISNULL(@1_Total,0)+
ISNULL(@2_Total,0)+
ISNULL(@3_Total,0)+
ISNULL(@4_Total,0)+
ISNULL(@5_Total,0)+
ISNULL(@6_Total,0)+
ISNULL(@7_Total,0)+
ISNULL(@8_Total,0)+
ISNULL(@9_Total,0)+
ISNULL(@10_Total,0)+
ISNULL(@11_Total,0)+
ISNULL(@12_Total,0)+
ISNULL(@13_Total,0)+
ISNULL(@14_Total,0)+
ISNULL(@15_Total,0)+
ISNULL(@16_Total,0)+
ISNULL(@17_Total,0)+
ISNULL(@18_Total,0)+
ISNULL(@19_Total,0)+
ISNULL(@20_Total,0)+
ISNULL(@21_Total,0)+
ISNULL(@22_Total,0)+
ISNULL(@23_Total,0)+
ISNULL(@24_Total,0)+
ISNULL(@25_Total,0)+
ISNULL(@26_Total,0)+
ISNULL(@27_Total,0)+
ISNULL(@28_Total,0)+
ISNULL(@29_Total,0)+
ISNULL(@30_Total,0)+
ISNULL(@31_Total,0)

INSERT INTO @MasterTable
(   TerritoryId ,
 
   EmpMasterCode ,
   
  TerritoryCode,
   EmpName ,
  DesigName ,
  RoleName  , TargetSetof,
  	[1_Gen] ,
	[1_FCB],
	[1_Cam] ,
	[1_Total] ,

	[2_Gen] ,
	[2_FCB],
	[2_Cam] ,
	[2_Total] ,

	[3_Gen] ,
	[3_FCB],
	[3_Cam] ,
	[3_Total] ,

	[4_Gen] ,
	[4_FCB],
	[4_Cam] ,
	[4_Total] ,

	[5_Gen] ,
	[5_FCB],
	[5_Cam] ,
	[5_Total] ,

	[6_Gen] ,
	[6_FCB],
	[6_Cam] ,
	[6_Total] ,

	[7_Gen] ,
	[7_FCB],
	[7_Cam] ,
	[7_Total] ,

	[8_Gen] ,
	[8_FCB],
	[8_Cam] ,
	[8_Total] ,

	[9_Gen] ,
	[9_FCB],
	[9_Cam] ,
	[9_Total] ,

	[10_Gen] ,
	[10_FCB],
	[10_Cam] ,
	[10_Total] ,

	[11_Gen] ,
	[11_FCB],
	[11_Cam] ,
	[11_Total] ,

	[12_Gen] ,
	[12_FCB],
	[12_Cam] ,
	[12_Total] ,

	[13_Gen] ,
	[13_FCB],
	[13_Cam] ,
	[13_Total] ,

	[14_Gen] ,
	[14_FCB],
	[14_Cam] ,
	[14_Total] ,

	[15_Gen] ,
	[15_FCB],
	[15_Cam] ,
	[15_Total] ,

	[16_Gen] ,
	[16_FCB],
	[16_Cam] ,
	[16_Total] ,

	[17_Gen] ,
	[17_FCB],
	[17_Cam] ,
	[17_Total] ,

	[18_Gen] ,
	[18_FCB],
	[18_Cam] ,
	[18_Total] ,

	[19_Gen] ,
	[19_FCB],
	[19_Cam] ,
	[19_Total] ,

	[20_Gen] ,
	[20_FCB],
	[20_Cam] ,
	[20_Total] ,

	[21_Gen] ,
	[21_FCB],
	[21_Cam] ,
	[21_Total] ,

	[22_Gen] ,
	[22_FCB],
	[22_Cam] ,
	[22_Total] ,

	[23_Gen] ,
	[23_FCB],
	[23_Cam] ,
	[23_Total] ,

	[24_Gen] ,
	[24_FCB],
	[24_Cam] ,
	[24_Total] ,

	[25_Gen] ,
	[25_FCB],
	[25_Cam] ,
	[25_Total] ,

	[26_Gen] ,
	[26_FCB],
	[26_Cam] ,
	[26_Total] ,

	[27_Gen] ,
	[27_FCB],
	[27_Cam] ,
	[27_Total] ,

	[28_Gen] ,
	[28_FCB],
	[28_Cam] ,
	[28_Total] ,

	[29_Gen] ,
	[29_FCB],
	[29_Cam] ,
	[29_Total] ,

	[30_Gen] ,
	[30_FCB],
	[30_Cam] ,
	[30_Total] ,

	[31_Gen] ,
	[31_FCB],
	[31_Cam] ,
	[31_Total] ,

	[Total_Gen] ,
	[Total_FCB],
	[Total_Cam] ,
	[Grand_Total] 
)
VALUES
(   @TerritoryId ,
 
  @EmpMasterCode ,
 
  @TerritoryCode,
   @EmpName ,
  @DesigName ,
  @RoleName    ,@TargetSetof,
		@1_Gen ,
	@1_FCB,
	@1_Cam ,
	@1_Total ,

	@2_Gen ,
	@2_FCB,
	@2_Cam ,
	@2_Total ,

	@3_Gen ,
	@3_FCB,
	@3_Cam ,
	@3_Total ,

	@4_Gen ,
	@4_FCB,
	@4_Cam ,
	@4_Total ,

	@5_Gen ,
	@5_FCB,
	@5_Cam ,
	@5_Total ,

	@6_Gen ,
	@6_FCB,
	@6_Cam ,
	@6_Total ,

	@7_Gen ,
	@7_FCB,
	@7_Cam ,
	@7_Total ,

	@8_Gen ,
	@8_FCB,
	@8_Cam ,
	@8_Total ,

	@9_Gen ,
	@9_FCB,
	@9_Cam ,
	@9_Total ,

	@10_Gen ,
	@10_FCB,
	@10_Cam ,
	@10_Total ,

	@11_Gen ,
	@11_FCB,
	@11_Cam ,
	@11_Total ,

	@12_Gen ,
	@12_FCB,
	@12_Cam ,
	@12_Total ,

	@13_Gen ,
	@13_FCB,
	@13_Cam ,
	@13_Total ,

	@14_Gen ,
	@14_FCB,
	@14_Cam ,
	@14_Total ,

	@15_Gen ,
	@15_FCB,
	@15_Cam ,
	@15_Total ,

	@16_Gen ,
	@16_FCB,
	@16_Cam ,
	@16_Total ,

	@17_Gen ,
	@17_FCB,
	@17_Cam ,
	@17_Total ,

	@18_Gen ,
	@18_FCB,
	@18_Cam ,
	@18_Total ,

	@19_Gen ,
	@19_FCB,
	@19_Cam ,
	@19_Total ,

	@20_Gen ,
	@20_FCB,
	@20_Cam ,
	@20_Total ,

	@21_Gen ,
	@21_FCB,
	@21_Cam ,
	@21_Total ,

	@22_Gen ,
	@22_FCB,
	@22_Cam ,
	@22_Total ,

	@23_Gen ,
	@23_FCB,
	@23_Cam ,
	@23_Total ,

	@24_Gen ,
	@24_FCB,
	@24_Cam ,
	@24_Total ,

	@25_Gen ,
	@25_FCB,
	@25_Cam ,
	@25_Total ,

	@26_Gen ,
	@26_FCB,
	@26_Cam ,
	@26_Total ,

	@27_Gen ,
	@27_FCB,
	@27_Cam ,
	@27_Total ,

	@28_Gen ,
	@28_FCB,
	@28_Cam ,
	@28_Total ,

	@29_Gen ,
	@29_FCB,
	@29_Cam ,
	@29_Total ,

	@30_Gen ,
	@30_FCB,
	@30_Cam ,
	@30_Total ,

	@31_Gen ,
	@31_FCB,
	@31_Cam ,
	@31_Total 
	 ,

	@Total_Gen,
	@Total_FCB,
	@Total_Cam ,
	@Grand_Total
   
    )






FETCH NEXT FROM @MyCursor
INTO   @TerritoryId ,
 
  @EmpMasterCode ,
  @TerritoryCode,

  @EmpName ,
  @DesigName ,
  @RoleName   ,@TargetSetof
END
CLOSE @MyCursor
DEALLOCATE @MyCursor


--INSERT INTO [dbo].[tblFoodRateReport]
--           ( EmployeeId,  CompanyId,[EmpMasterCode]
--           ,[EmpName]
--           ,[Designation]
--           ,[DepartmentName]
--           ,[Floor]
--           ,[1]
--           ,[2]
--           ,[3]
--           ,[4]
--           ,[5]
--           ,[6]
--           ,[7]
--           ,[8]
--           ,[9]
--           ,[10]
--           ,[11]
--           ,[12]
--           ,[13]
--           ,[14]
--           ,[15]
--           ,[16]
--           ,[17]
--           ,[18]
--           ,[19]
--           ,[20]
--           ,[21]
--           ,[22]
--           ,[23]
--           ,[24]
--           ,[25]
--           ,[26]
--           ,[27]
--           ,[28]
--           ,[29]
--           ,[30]
--           ,[31]
--           ,[Foodrate]
--           ,[TotalDays]
--           ,[TotalFoodrate]
--           ,[Month]
--           ,[Year]
--           ,[ReportDate] ,CategoryId )

--SELECT 

--EmployeeId,  CompanyId,
--  EmpMasterCode,
--    EmpName,
--	 Designation , 
--    DepartmentName  
--,   Floor  , 
--    ISNULL([1],0)
--           ,ISNULL([2],0)
--           ,ISNULL([3],0)
--           ,ISNULL([4],0)
--           ,ISNULL([5],0)
--           ,ISNULL([6],0)
--           ,ISNULL([7],0)
--           ,ISNULL([8],0)
--           ,ISNULL([9],0)
--           ,ISNULL([10],0)
--           ,ISNULL([11],0)
--           ,ISNULL([12],0)
--           ,ISNULL([13],0)
--           ,ISNULL([14],0)
--           ,ISNULL([15],0)
--           ,ISNULL([16],0)
--           ,ISNULL([17],0)
--           ,ISNULL([18],0)
--           ,ISNULL([19],0)
--           ,ISNULL([20],0)
--           ,ISNULL([21],0)
--           ,ISNULL([22],0)
--           ,ISNULL([23],0)
--           ,ISNULL([24],0)
--           ,ISNULL([25],0)
--           ,ISNULL([26],0)
--           ,ISNULL([27],0)
--           ,ISNULL([28],0)
--           ,ISNULL([29],0)
--           ,ISNULL([30],0)
--           ,ISNULL([31],0),
--		 Foodrate ,
--    TotalDays,
--    TotalFoodrate ,
--	FORMAT(getdate(),'MMMM') ,
--	FORMAT(getdate(),'yyyy') ,getdate(),CategoryId
	   
--	   FROM @MasterTable  


select  TerritoryId ,
 
   EmpMasterCode ,
  TerritoryCode,

   EmpName ,
  DesigName ,
  RoleName  , TargetSetof,

  	ISNULL([1_Gen],0) [1_Gen] ,
	ISNULL([1_FCB],0) [1_FCB],
	ISNULL([1_Cam],0) [1_Cam],
	ISNULL([1_Total],0) [1_Total],

		ISNULL([2_Gen],0) [2_Gen] ,
	ISNULL([2_FCB],0) [2_FCB],
	ISNULL([2_Cam],0) [2_Cam],
	ISNULL([2_Total],0) [2_Total],

		ISNULL([3_Gen],0) [3_Gen] ,
	ISNULL([3_FCB],0) [3_FCB],
	ISNULL([3_Cam],0) [3_Cam],
	ISNULL([3_Total],0) [3_Total],

		ISNULL([4_Gen],0) [4_Gen] ,
	ISNULL([4_FCB],0) [4_FCB],
	ISNULL([4_Cam],0) [4_Cam],
	ISNULL([4_Total],0) [4_Total],

		ISNULL([5_Gen],0) [5_Gen] ,
	ISNULL([5_FCB],0) [5_FCB],
	ISNULL([5_Cam],0) [5_Cam],
	ISNULL([5_Total],0) [5_Total],

		ISNULL([6_Gen],0) [6_Gen] ,
	ISNULL([6_FCB],0) [6_FCB],
	ISNULL([6_Cam],0) [6_Cam],
	ISNULL([6_Total],0) [6_Total],

		ISNULL([7_Gen],0) [7_Gen] ,
	ISNULL([7_FCB],0) [7_FCB],
	ISNULL([7_Cam],0) [7_Cam],
	ISNULL([7_Total],0) [7_Total],

		ISNULL([8_Gen],0) [8_Gen] ,
	ISNULL([8_FCB],0) [8_FCB],
	ISNULL([8_Cam],0) [8_Cam],
	ISNULL([8_Total],0) [8_Total],

		ISNULL([9_Gen],0) [9_Gen] ,
	ISNULL([9_FCB],0) [9_FCB],
	ISNULL([9_Cam],0) [9_Cam],
	ISNULL([9_Total],0) [9_Total],

		ISNULL([10_Gen],0) [10_Gen] ,
	ISNULL([10_FCB],0) [10_FCB],
	ISNULL([10_Cam],0) [10_Cam],
	ISNULL([10_Total],0) [10_Total],

		ISNULL([11_Gen],0) [11_Gen] ,
	ISNULL([11_FCB],0) [11_FCB],
	ISNULL([11_Cam],0) [11_Cam],
	ISNULL([11_Total],0) [11_Total],

		ISNULL([12_Gen],0) [12_Gen] ,
	ISNULL([12_FCB],0) [12_FCB],
	ISNULL([12_Cam],0) [12_Cam],
	ISNULL([12_Total],0) [12_Total],

		ISNULL([13_Gen],0) [13_Gen] ,
	ISNULL([13_FCB],0) [13_FCB],
	ISNULL([13_Cam],0) [13_Cam],
	ISNULL([13_Total],0) [13_Total],

		ISNULL([14_Gen],0) [14_Gen] ,
	ISNULL([14_FCB],0) [14_FCB],
	ISNULL([14_Cam],0) [14_Cam],
	ISNULL([14_Total],0) [14_Total],

		ISNULL([15_Gen],0) [15_Gen] ,
	ISNULL([15_FCB],0) [15_FCB],
	ISNULL([15_Cam],0) [15_Cam],
	ISNULL([15_Total],0) [15_Total],

		ISNULL([16_Gen],0) [16_Gen] ,
	ISNULL([16_FCB],0) [16_FCB],
	ISNULL([16_Cam],0) [16_Cam],
	ISNULL([16_Total],0) [16_Total],

		ISNULL([17_Gen],0) [17_Gen] ,
	ISNULL([17_FCB],0) [17_FCB],
	ISNULL([17_Cam],0) [17_Cam],
	ISNULL([17_Total],0) [17_Total],

		ISNULL([18_Gen],0) [18_Gen] ,
	ISNULL([18_FCB],0) [18_FCB],
	ISNULL([18_Cam],0) [18_Cam],
	ISNULL([18_Total],0) [18_Total],

		ISNULL([19_Gen],0) [19_Gen] ,
	ISNULL([19_FCB],0) [19_FCB],
	ISNULL([19_Cam],0) [19_Cam],
	ISNULL([19_Total],0) [19_Total],

		ISNULL([20_Gen],0) [20_Gen] ,
	ISNULL([20_FCB],0) [20_FCB],
	ISNULL([20_Cam],0) [20_Cam],
	ISNULL([20_Total],0) [20_Total],

		ISNULL([21_Gen],0) [21_Gen] ,
	ISNULL([21_FCB],0) [21_FCB],
	ISNULL([21_Cam],0) [21_Cam],
	ISNULL([21_Total],0) [21_Total],

		ISNULL([22_Gen],0) [22_Gen] ,
	ISNULL([22_FCB],0) [22_FCB],
	ISNULL([22_Cam],0) [22_Cam],
	ISNULL([22_Total],0) [22_Total],

		ISNULL([23_Gen],0) [23_Gen] ,
	ISNULL([23_FCB],0) [23_FCB],
	ISNULL([23_Cam],0) [23_Cam],
	ISNULL([23_Total],0) [23_Total],

ISNULL([24_Gen],0) [24_Gen] ,
	ISNULL([24_FCB],0) [24_FCB],
	ISNULL([24_Cam],0) [24_Cam],
	ISNULL([24_Total],0) [24_Total],

		ISNULL([25_Gen],0) [25_Gen] ,
	ISNULL([25_FCB],0) [25_FCB],
	ISNULL([25_Cam],0) [25_Cam],
	ISNULL([25_Total],0) [25_Total],

		ISNULL([26_Gen],0) [26_Gen] ,
	ISNULL([26_FCB],0) [26_FCB],
	ISNULL([26_Cam],0) [26_Cam],
	ISNULL([26_Total],0) [26_Total],

		ISNULL([27_Gen],0) [27_Gen] ,
	ISNULL([27_FCB],0) [27_FCB],
	ISNULL([27_Cam],0) [27_Cam],
	ISNULL([27_Total],0) [27_Total],

		ISNULL([28_Gen],0) [28_Gen] ,
	ISNULL([28_FCB],0) [28_FCB],
	ISNULL([28_Cam],0) [28_Cam],
	ISNULL([28_Total],0) [28_Total],

		ISNULL([29_Gen],0) [29_Gen] ,
	ISNULL([29_FCB],0) [29_FCB],
	ISNULL([29_Cam],0) [29_Cam],
	ISNULL([29_Total],0) [29_Total],

		ISNULL([30_Gen],0) [30_Gen] ,
	ISNULL([30_FCB],0) [30_FCB],
	ISNULL([30_Cam],0) [30_Cam],
	ISNULL([30_Total],0) [30_Total],

		ISNULL([31_Gen],0) [31_Gen] ,
	ISNULL([31_FCB],0) [31_FCB],
	ISNULL([31_Cam],0) [31_Cam],
	ISNULL([31_Total],0) [31_Total] 
	,

		ISNULL([Total_Gen],0) [Total_Gen] ,
	ISNULL([Total_FCB],0) [Total_FCB],
	ISNULL([Total_Cam],0) [Total_Cam],
	ISNULL([Grand_Total],0) [Grand_Total] 
	 
  	 from @MasterTable
	order by TerritoryCode asc
 
 end

