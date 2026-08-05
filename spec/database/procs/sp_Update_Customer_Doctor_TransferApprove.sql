
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Customer_Doctor_TransferApprove]
	-- Add the parameters for the stored procedure here
   
    @MasterId NVARCHAR(MAX) ,
    @MarketId NVARCHAR(MAX) ,


    @ApprovedBy NVARCHAR(50) ,
	@Type NVARCHAR(50) ,
	@DCID NVARCHAR(50) ,

	@RouteId NVARCHAR(50) 

  

AS
    BEGIN
 
 if(@Type='Cust')
    BEGIN


	 
   DECLARE   @CustID INT 
     



	select  @MarketId=mas.MarketId, @CustID=mas.CustomerMasterId from tblCustMaster_TranferLog mas with (nolock)
		 
		  where  mas.CustMaster_TranferLogId=@MasterId

 
		UPDATE tblCustMaster SET MarketId=@MarketId,
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 

	    WHERE  CustomerMasterId =@CustID

			UPDATE 	tblCustMaster_TranferLog Set TranferBy = @ApprovedBy , UpdateDate=GETDATE() WHERE    CustMaster_TranferLogId=@MasterId 

		END
		else
    BEGIN

	 
	 	select  @MarketId=mas.MarketId, @CustID=mas.DoctorId from tblDoctorMaster_TranferLog mas with (nolock)
		 
		  where  mas.DoctorTranferLogid=@MasterId

 
	--	UPDATE tblCustMaster SET MarketId=@MarketId,
	--        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 

	--    WHERE  CustomerMasterId =@CustID

	--		UPDATE 	tblCustMaster_TranferLog Set TranferBy = @ApprovedBy , UpdateDate=GETDATE() WHERE    CustMaster_TranferLogId=@MasterId 
	-- 	select   @Div=div.DivisionId, @Dis=dis.DistrictId, @ThanaId=mr.ThanaId, @SubTerritoryId=sr.SubTerritoryId,@TerritoryId=tr.TerritoryId,@AreaId=ar.AreaId,@RegionId=rg.RegionId,@GroupId=rg.GroupId from tblmarket mr with (nolock)
	--	inner join tblSubTerritory sr  with (nolock) on sr.SubTerritoryId=mr.SubTerritoryId
	--	inner join tblTerritory tr  with (nolock) on sr.TerritoryId=tr.TerritoryId
	--	inner join tblArea ar   with (nolock)  on ar.AreaId=tr.AreaId
	--	inner join tblRegion rg  with (nolock) on ar.RegionId=rg.RegionId
	--	left join tbl_Thana tha  with (nolock) on mr.ThanaId=tha.ThanaId
	--	left join tbl_District dis  with (nolock) on dis.DistrictId=tha.district_id
	--	left join tbl_Division div  with (nolock) on dis.DivisionId=div.DivisionId
	--	  where  MarketId=@marketId
	--	UPDATE tblDoctorMaster 
	--    Set MarketId =  @MarketId ,thanaid=@ThanaId,
	--        UpdateBy = @ApprovedBy , UpdateDate=GETDATE()

	--    WHERE  DoctorId in (select * from fnSplit(@MasterId,','))


	--UPDATE 	tblDoctorMaster_TranferLog Set TranferBy = @ApprovedBy , UpdateDate=GETDATE() WHERE  DoctorId in (select * from fnSplit(@MasterId,','))
	--and TranferBy is null

		END

    END
	

