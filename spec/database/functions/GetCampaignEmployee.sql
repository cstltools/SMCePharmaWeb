



-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetCampaignEmployee]
(
	
)
RETURNS 

		@MasterTable TABLE 
		(
				RowNo INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
				EmpInfoId INT NULL,
				EmpMasterCode NVARCHAR(MAX),
				CampMasId INT NULL
		)

		AS

		BEGIN
		
		DECLARE @GroupId INT=NULL
		DECLARE @RegionId INT=NULL
		DECLARE @AreaId INT=NULL
		DECLARE @TerritoryId INT=NULL
		DECLARE @SubTerritoryId INT=NULL
		DECLARE @MarketId INT=NULL
		DECLARE @CampaignMasterId INT=NULL

		
		
		DECLARE @Main CURSOR
        SET @Main = CURSOR FAST_FORWARD
        FOR
		SELECT 
       GroupId,
       RegionId,
       AreaId,
       TerritoryId,
       SubTerritoryId,
       MarketId,CampaignMasterId FROM dbo.tbl_BonusCampaignNewMaster
LEFT JOIN tbl_BonusCampaignMarketDetail ON 
dbo.tbl_BonusCampaignNewMaster.CampgainMasterId=dbo.tbl_BonusCampaignMarketDetail.CampaignMasterId
WHERE (GETDATE() BETWEEN FromDate AND Todate)
		OPEN @Main
        FETCH NEXT FROM @Main
        INTO @GroupId,
       @RegionId,
       @AreaId,
       @TerritoryId,
       @SubTerritoryId,
       @MarketId,@CampaignMasterId
         
        WHILE @@FETCH_STATUS=0
        BEGIN
		DECLARE @Skip BIT=0
		--IF(@MarketId IS NOT NULL )
		--BEGIN
		--    INSERT INTO @MasterTable
		--    (
		--        EmpInfoId,
		--        EmpMasterCode,CampMasId
		--    )
		    
		--    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_CustomerMaster WHERE MarketId=@MarketId
		--	SET @Skip=1
		--END

		--IF(@SubTerritoryId IS NOT NULL AND @Skip=0)
		--BEGIN
		--    INSERT INTO @MasterTable
		--    (
		--        EmpInfoId,
		--        EmpMasterCode,CampMasId
		--    )
		    
		--    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_CustomerMaster WHERE SubTerritoryId=@SubTerritoryId
		--	SET @Skip=1
		--END
		IF(@TerritoryId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        EmpInfoId,
		        EmpMasterCode,CampMasId
		    )
		    
		    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpTerrId=@TerritoryId
			SET @Skip=1
		END
		IF(@AreaId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        EmpInfoId,
		        EmpMasterCode,CampMasId
		    )
		    
		    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpAreaId=@AreaId
			SET @Skip=1
		END
		IF(@RegionId IS NOT NULL AND @Skip=0)
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        EmpInfoId,
		        EmpMasterCode,CampMasId
		    )
		    
		    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpRegionId=@RegionId
			SET @Skip=1
		END
		IF(@GroupId IS NOT NULL AND @Skip=0 )
		BEGIN
		    INSERT INTO @MasterTable
		    (
		        EmpInfoId,
		        EmpMasterCode,CampMasId
		    )
		    
		    SELECT EmpInfoId,EmpMasterCode,@CampaignMasterId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpGroupId=@GroupId
			SET @Skip=1
		END
		



		FETCH NEXT FROM @Main
        INTO @GroupId,
       @RegionId,
       @AreaId,
       @TerritoryId,
       @SubTerritoryId,
       @MarketId,@CampaignMasterId
		END
        
		CLOSE @Main
		DEALLOCATE @Main

		--INSERT INTO @MasterTable
		--(
		--    EmpInfoId,
		--    EmpMasterCode,CampMasId
		--)
		--SELECT tblCustMaster.EmpInfoId,EmpMasterCode,CampaignMasterId FROM tbl_BonusCampaignCustomerDetail
		--LEFT JOIN dbo.tblCustMaster ON tblCustMaster.EmpInfoId = tbl_BonusCampaignCustomerDetail.EmpInfoId
		

		RETURN
		END







