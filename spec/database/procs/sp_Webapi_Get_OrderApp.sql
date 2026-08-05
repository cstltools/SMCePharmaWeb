-- Batch submitted through debugger: SQLQuery2.sql|7|0|C:\Users\ADMINI~1.AIP\AppData\Local\Temp\1\~vs8B9F.sql






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_OrderApp]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt DATETIME =NULL,
	@ToDt DATETIME =NULL,
	@EmpId INT =NULL,
@GroupId_   int=null,
@ZoneId_   int=null,
@AreaId_   int=null,
@TerritoryId   int=null,
@SubTerritoryId   int=null,
@MarketId   int=null
AS
    BEGIN
	

	

	DECLARE @params NVARCHAR(max)='   '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	   IF(@AppStatus<>'Select' )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.ActionStatus)='''+CAST(CONVERT(Int,@AppStatus) AS NVARCHAR(max))+''''
		    
		END
	IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,mas.EntryDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,mas.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,mas.EntryDate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND CONVERT(DATE,mas.EntryDate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END


	IF(@FromDt IS  NULL AND @ToDt IS NULL)

	begin
	 SET @params=@params+ ' and (DATEDIFF(DAY,CONVERT(DATE,mas.EntryDate),CONVERT(DATE,GETDATE())))<=7  '
	end
	
	--IF(@EmpId IS NOT NULL)
	--BEGIN
	--    SET @params= @params + ' AND tblCustMaster.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	--END
	
		IF(@GroupId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.GroupId)='''+CAST(CONVERT(Int,@GroupId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@AreaId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.AreaId)='''+CAST(CONVERT(Int,@AreaId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@ZoneId_ <>0)
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.RegionId)='''+CAST(CONVERT(Int,@ZoneId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@TerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@SubTerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.SubTerritoryId)='''+CAST(CONVERT(Int,@SubTerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@MarketId  <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,mas.MarketId)='''+CAST(CONVERT(Int,@MarketId) AS NVARCHAR(max))+''''
		    
		END



	DECLARE @Q NVARCHAR(MAX)
	SET @Q='	SELECT   distinct mas.EntryDate, mas.OrderSenderCode +'' : ''+mas.OrderSenderName EntryByWeb,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatusWeb, mas.OrderCode, mas.TotalNetPayable, mas.MarketId, mr.MarketName, mas.ActionStatus   ApprovalStatus,  tblEmpGeneralInfo.EmpInfoId,mas.CustomerMasterId,
       CustomerName ,
                  CustomerCode ,
                  
          FORMAT(mas.EntryDate,''dd MMM yyyy hh:mm tt'') EntryDate,
       
       
       
       
       tblOrderApprovalLog.OrderApprovalId,
       Date,
       FromEmpId,
       ToEmpId,
       tblOrderApprovalLog.TableId,
       tblOrderApprovalLog.Status,
       Comments,
       tblOrderApprovalLog.Type,
       Step,
       0 GroupId,
       0 RegionId,
      0 AreaId,
      0 TerritoryId,
       
       RoleTypeId,ToRoleTypeId,
       
       
       tblEmpGeneralInfo.EmpMasterCode,
     mas.OrderSenderCode +'' - ''+mas.OrderSenderName  EmpName,
	 
                                
                               
                                 
                                0 TerritoryName,
                                  0 TerritoryCode,
                                  0 AreaCode,
                               0  AreaName,
                                  0 RegionCode,
                              0   RegionName,
                             0    GroupName,
                            0     MIOEmpId,
                                    0 ASMEMPId,
                                 0 RSMEMPId,
                              0   NSMEMPId,LogMax.MaxStep 
	   
	   
	   FROM dbo.tblOrder mas  with (nolock)
	 
  
LEFT JOIN dbo.tblOrderApprovalLog   with (nolock) ON dbo.tblOrderApprovalLog.TableId=mas.OrderId
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblOrderApprovalLog  with (nolock)  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblOrderApprovalLog.TableId
left join tblUser on tblUser.UserId=mas.EntryBy

left join tblMarket mr  with (nolock) on mr.MarketId=mas.MarketId
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = tblEmpGeneralInfo.EmpInfoId
WHERE  mas.OrderId is not null '+@params+'  AND Step=LogMax.MaxStep and mas.ActionStatus!=''3''  '+@param  +'  ORDER BY mas.EntryDate DESC '

EXEC sys.sp_executesql @Q


    END







