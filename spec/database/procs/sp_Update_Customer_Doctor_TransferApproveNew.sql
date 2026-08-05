CREATE PROCEDURE [dbo].[sp_Update_Customer_Doctor_TransferApproveNew]
	-- Add the parameters for the stored procedure here
   
    @MasterId NVARCHAR(MAX) , 
    @ApprovedBy NVARCHAR(50) ,
	@Type NVARCHAR(50) 

  

AS
    BEGIN

	declare @MarketId int=0
 
 if(@Type='0')
    BEGIN


	  

	select  @MarketId=mas.MarketId  from tblCustMaster_TranferLog mas with (nolock)
		 
		  where  mas.MasterId=@MasterId

 
		UPDATE tblCustMaster SET MarketId=@MarketId,
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 

	    WHERE  CustomerMasterId in (select CustomerMasterId from  tblCustMaster_TranferLog where  MasterId=@MasterId )

			UPDATE 	tblCustMaster_TranferLog Set IsApprove = 1  , UpdateDate=GETDATE() WHERE   MasterId=@MasterId

		END
		else
    BEGIN


	select  @MarketId=mas.MarketId  from tblDoctorMaster_TranferLog mas with (nolock)
		 
		  where  mas.MasterId=@MasterId

 
		UPDATE tblDoctorMaster SET MarketId=@MarketId,
	        UpdateBy = @ApprovedBy , UpdateDate=GETDATE() 

	    WHERE  DoctorId in (select DoctorId from  tblDoctorMaster_TranferLog where  MasterId=@MasterId )

			UPDATE 	tblDoctorMaster_TranferLog Set IsApprove = 1  , UpdateDate=GETDATE() WHERE   MasterId=@MasterId

	 
	 	 

 
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
	
