
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CustomerAllIsMarketUpdate2022]
	-- Add the parameters for the stored procedure here
    @empid INT   ,
	 
@GroupId_   int=null,
@ZoneId_   int=null,
@AreaId_   int=null,
@TerritoryId   int=null,
@SubTerritoryId   int=null,
@MarketId   int=null 
    
AS
    BEGIN
	

	DECLARE @params NVARCHAR(max)='   '
		IF(@GroupId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.GroupId)='''+CAST(CONVERT(Int,@GroupId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@AreaId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.AreaId)='''+CAST(CONVERT(Int,@AreaId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@ZoneId_ <>0)
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.RegionId)='''+CAST(CONVERT(Int,@ZoneId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@TerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@SubTerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.SubTerritoryId)='''+CAST(CONVERT(Int,@SubTerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@MarketId  <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,CV.MarketId)='''+CAST(CONVERT(Int,@MarketId) AS NVARCHAR(max))+''''
		    
		END

	 



DECLARE @Q NVARCHAR(MAX)
	SET @Q='
	select distinct * from(


	 SELECT distinct  (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''CustomerMy'')+CAST(tblCustMaster.CustomerMasterId as nvarchar(max))+''.jpg'' AS   ImageString,   (SELECT case when GETDATE() between  FromDate and Todate then ''1'' else ''0'' end   FROM dbo.tblUserSettingPanel  with (nolock)  WHERE CriteriaRemarks=''EBtn'')  BtnupdateInfo , case when tblCustMaster.Isactive=1 then   ''Active''  else ''Inactive''  end  CustomerStatus,   CV.GroupId,CV.GroupName, CV.RegionId, CV.RegionName, CV.AreaId, CV.AreaName, CV.TerritoryId, CV.TerritoryCode+'' : ''+CV.TerritoryName TerritoryName, CV.SubterritoryId,CV.SubTerritoryName, CV.MarketId, dbo.tblCustMaster.CustomerMasterId, ISNULL(dbo.tblCustMaster.CustomerCode+'' - ''+dbo.tblCustMaster.CustomerName,dbo.tblCustMaster.CustomerName) CustomerName,(CASE WHEN dbo.tblCustMaster.ActionStatus=''0'' THEN ''Pending''  WHEN dbo.tblCustMaster.ActionStatus=''2''  
	THEN ''Approved''  WHEN dbo.tblCustMaster.ActionStatus=''1''  
	THEN ''Verified'' WHEN dbo.tblCustMaster.ActionStatus=''3'' THEN ''Rejected'' ELSE dbo.tblCustMaster.ActionStatus END)AS ActionStatus ,CV.CellNo,tblMarket.MarketName, tblCustMaster.OwnerName, tblCustMaster.Address  , pt.ProgramTypeName,'''' AS CustomerImagePreName,
	'''' AS WaitingRole,'''' AS WatingEmployee
	
	FROM tblCustMaster  with (nolock)
	LEFT JOIN dbo.tblUser  with (nolock) ON dbo.tblUser.UserId=dbo.tblCustMaster.CreateBy
	left join tblMarket  with (nolock) on tblCustMaster.MarketId=tblMarket.MarketId
	left join dbo.tblProgramType pt  with (nolock) on tblCustMaster.ProgramTypeId=pt.ProgramTypeId
	--LEFT JOIN dbo.tblCustomerApprovalLog ON dbo.tblCustomerApprovalLog.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblCustomerApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblCustMaster.CustomerMasterId
	--LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tblCustomerApprovalLog.ToRoleTypeId
	LEFT JOIN dbo.View_CustomerMaster_ActiveInactive CV  with (nolock) ON CV.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId

	WHERE   tblCustMaster.IsMarketUpdate2022=0 and tblCustMaster.ActionStatus=''2'' and
	  (convert(Int,CV.NSMEmpInfoId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,CV.RSMEmpInfoId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,CV.ASMEmpInfoId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,CV.MIOEmpInfoId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''') '+@params+'

	 )tbl
	 
	'
	EXEC sys.sp_executesql @Q


    END