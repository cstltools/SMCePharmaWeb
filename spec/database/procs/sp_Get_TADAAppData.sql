




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TADAAppData]
	-- Add the parameters for the stored procedure here
	@param NVARCHAR(MAX)= NULL,
	@Role NVARCHAR(MAX) =NULL,
	@AppStatus NVARCHAR(MAX)= NULL,
	
	@FromDt NVARCHAR(MAX) =NULL,
	@ToDt NVARCHAR(MAX)=NULL,
	@EmpId INT =NULL
AS
    BEGIN
	
	DECLARE @params NVARCHAR(max)='  '
	IF(@AppStatus IS NOT NULL)
	BEGIN
	    SET @params=' mas.ApprovalStatus='''+@AppStatus+''''
		IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,mas.TADADate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,mas.TADADate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
	END
	ELSE
    BEGIN
        IF(@FromDt IS NOT NULL AND @ToDt IS NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,mas.TADADate)='''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''''
		END
		IF(@FromDt IS NOT NULL AND @ToDt IS NOT NULL)
		BEGIN
		    SET @params=@params+ ' AND Convert(Date,mas.TADADate) between '''+CAST(CONVERT(DATE,@FromDt) AS NVARCHAR(max))+''' AND '''+ CAST(CONVERT(DATE,@ToDt) AS NVARCHAR(max))+''' '
		END
    END
	
	IF(@EmpId IS NOT NULL)
	BEGIN
	    SET @params= @params + ' AND mas.EmpInfoId='+convert(nvarchar(max),@EmpId)+' '
	END

	DECLARE @Q NVARCHAR(MAX)
	SET @Q='

	
	SELECT  distinct (SELECT LTRIM(RTRIM(ImagePath+''/''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType=''DAClaimMy'')+CAST(mas.TadaID as nvarchar(max))+''.jpg'' AS   ImageString, RT.Roletype WaitingForRole,mas.HotelName, mas.HotelPhone,
       
       mas.EmpInfoId,
                  Remarks ,
       mas.DAAmount,
      format(mas.EntryDate,''dd-MMM-yyyy hh:mm tt'')AS TadaDate, emp.EmpMasterCode,emp.EmpName, 0 TaAmt, mas.DAAmount DaAmt,mas.MarketCode_DA+'' : ''+ mas.MarketName MarketName, st.StationTypeName,   case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified'' when mas.ApprovalStatus=''2'' then ''Approved'' when mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatusWeb,
       
 
       
       
       tblTADAApprovalLog.TADAApprovalId ApprovalId ,
       Date,
       FromEmpId,
       ToEmpId,
       tblTADAApprovalLog.TableId,
       tblTADAApprovalLog.Status,
       Comments,
       Type,
       Step,
       0 GroupId,
       0 RegionId,
       0 AreaId,
       0 TerritoryId,
       
       tblTADAApprovalLog.RoleTypeId,tblTADAApprovalLog.ToRoleTypeId,
       
       
   
	   0 TerritoryId,
                                 0 AreaId,
                                 0 RegionId,
                                 0 GroupId,
                                0 TerritoryName,
                               0  TerritoryCode,
                                0 AreaCode,
                                0 AreaName,
                               0  RegionCode,
                                 0 RegionName,
                                 0 GroupName,
                                0 MIOEmpId,
                                0 ASMEMPId,
                                0 RSMEMPId,
                                 0 NSMEMPId,LogMax.MaxStep
	    FROM dbo.tbl_TadaClaimMaster mas

	   
LEFT JOIN dbo.tblTADAApprovalLog ON dbo.tblTADAApprovalLog.TableId= mas.TadaID
LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblTADAApprovalLog  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblTADAApprovalLog.TableId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblUser us ON us.EmpInfoId=mas.EmpInfoId

LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = mas.EmpInfoId
left join tblRoleType on tblRoleType.RoleTypeId=tblTADAApprovalLog.RoleTypeId
	LEFT JOIN dbo.tblRoleType RT ON RT.RoleTypeId = tblTADAApprovalLog.ToRoleTypeId
	left JOIN dbo.tblStationType st ON st.StationTypeId=mas.TourTypeId

--left JOIN dbo.tbl_TourPlanInfo tp ON tp.EmpInfoId = emp.EmpInfoId AND CONVERT(NVARCHAR(50),mas.TadaDate,106)= CONVERT(NVARCHAR(50),tp.TourPlanDate,106) AND  tp.SerialNo=1
--left JOIN dbo.tblMarket mar ON mar.MarketId = tp.MarketId
WHERE    tblTADAApprovalLog.TableId is not null    '+@params+'  and  tblRoleType.RoleType<>'''+@Role+'''  AND Step=LogMax.MaxStep '+@param

EXEC sys.sp_executesql @Q


    END






