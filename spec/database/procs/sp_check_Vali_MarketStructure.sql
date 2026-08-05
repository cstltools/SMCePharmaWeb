

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Vali_MarketStructure]
	-- Add the parameters for the stored procedure here
	  @MasterId  INT ,
      @PageName     NVARCHAR(MAX) 

AS
BEGIN

if(@PageName='Group')
	BEGIN	 
	SELECT GroupId FROM dbo.tblRegion  WHERE GroupId=@MasterId and IsActive=1

union all	SELECT GroupId FROM dbo.tblNSMInfo  WHERE GroupId=@MasterId and IsActive=1


union all	SELECT GroupId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE GroupId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT GroupId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and GroupId=@MasterId  

union all	SELECT  GroupId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE GroupId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  GroupId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE GroupId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

 


	END



	if(@PageName='Zone')
	BEGIN	 
	SELECT RegionId FROM dbo.tblArea  WHERE RegionId=@MasterId and IsActive=1

union all	SELECT RegionId FROM dbo.tblRSMInfo  WHERE RegionId=@MasterId and IsActive=1


union all	SELECT RegionId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE RegionId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT RegionId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and RegionId=@MasterId  

union all	SELECT  RegionId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE RegionId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  RegionId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE RegionId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)
	END


	if(@PageName='Area')
	BEGIN	 
	SELECT AreaId FROM dbo.tblTerritory  WHERE AreaId=@MasterId and IsActive=1

union all	SELECT  AreaId FROM dbo.tblASMInfo  WHERE AreaId=@MasterId and IsActive=1


union all	SELECT AreaId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE AreaId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT AreaId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and AreaId=@MasterId  

union all	SELECT  AreaId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE AreaId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  AreaId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE AreaId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

	END


	
	if(@PageName='Territory')
	BEGIN	 
	SELECT TerritoryId FROM dbo.tblSubTerritory  WHERE TerritoryId=@MasterId and IsActive=1

union all	SELECT  TerritoryId FROM dbo.tblMIOInfo  WHERE TerritoryId=@MasterId and IsActive=1



union all	SELECT  TerritoryId FROM dbo.tblDcWiseTerritoryDetail  WHERE TerritoryId=@MasterId 



union all	SELECT TerritoryId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE TerritoryId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT TerritoryId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and TerritoryId=@MasterId  

union all	SELECT  TerritoryId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE TerritoryId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  TerritoryId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE TerritoryId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)


	END


	if(@PageName='SubTerritory')
	BEGIN	 
	SELECT SubTerritoryId FROM dbo.tblMarket  WHERE SubTerritoryId=@MasterId and IsActive=1
	 
	 

union all	SELECT SubTerritoryId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE SubTerritoryId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT SubTerritoryId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and SubTerritoryId=@MasterId  

union all	SELECT  SubTerritoryId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE SubTerritoryId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  SubTerritoryId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE SubTerritoryId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)


	END


	if(@PageName='Market')
	BEGIN	 
	SELECT MarketId FROM dbo.tblCustMaster  WHERE MarketId=@MasterId and IsActive=1

	union all SELECT MarketId FROM dbo.tblDoctorMaster  WHERE MarketId=@MasterId and IsActive=1

	

	union all SELECT MarketId FROM dbo.tblRouteInformationMarketDetail  WHERE MarketId=@MasterId  

	 
	 
	 

union all	SELECT MarketId FROM dbo.tbl_BonusCampaignMarketDetail dtl
INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
WHERE MarketId=@MasterId AND GETDATE() BETWEEN mas.FromDate AND mas.Todate


--union all	SELECT MarketId FROM dbo.tblOrder mas 
--WHERE mas.IsInvoice=0 and MarketId=@MasterId  

union all	SELECT  MarketId FROM dbo.tbl_Notice_MarketDetails dtl
INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
WHERE MarketId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

union all	SELECT  MarketId FROM dbo. tbl_TrainingMarketDetail dtl
INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
WHERE MarketId=@MasterId AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate)

	END


 if(@PageName='GenericGroup')
	BEGIN	 
	SELECT GenericGroupId FROM dbo.tblProduct  WHERE ProductId=@MasterId and IsActive=1
 
	END

	 
 if(@PageName='ExpenseType')
	BEGIN	 
	SELECT ExpenseTypDetailsId FROM dbo.tbl_ExpenseClaimDetails dtl 
	  WHERE dtl.ExpenseTypDetailsId=0  
 
	END

	if(@PageName='Designation')
	BEGIN	 
	SELECT dtl.DesignationId FROM dbo.tblEmpGeneralInfo dtl 
	  WHERE dtl.DesignationId=@MasterId  
 
	END

	if(@PageName='Dept')
	BEGIN	 
	SELECT dtl.DepartmentId FROM dbo.tblEmpGeneralInfo dtl 
	  WHERE dtl.DepartmentId=@MasterId  
 
	END

		if(@PageName='MonthlyAllowances')
	BEGIN	 
	SELECT dtl.AllowanceId FROM dbo.EmployeeAllowance dtl 
	  WHERE dtl.AllowanceId=@MasterId  
 
	END



	if(@PageName='TerritoryWiseDepotSetupUncheck')
	BEGIN	 
 SELECT mas.TerritoryId FROM dbo.tblOrder mas 
WHERE mas.IsInvoice=0 and mas.TerritoryId=@MasterId  
 
	END


	if(@PageName='CustomerTransfer')
	BEGIN	 
 SELECT mas.OrderId FROM dbo.tblOrder mas 
WHERE mas.IsInvoice=0  AND mas.CustomerMasterId=0 
 
	END

	if(@PageName='Transport')
	BEGIN	 
 SELECT mas.TransportId FROM dbo.tbl_MileageClaim mas 
WHERE   mas.TransportId=@MasterId  
 
	END


	if(@PageName='ExpenseTypeName')
	BEGIN	 
	SELECT dtl.ExpenseTypeId FROM dbo.tbl_ExpenseClaim dtl 
	  WHERE dtl.ExpenseTypeId=@MasterId  
 
	END
	
END



