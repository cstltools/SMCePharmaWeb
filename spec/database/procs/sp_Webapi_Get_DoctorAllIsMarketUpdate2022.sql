
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorAllIsMarketUpdate2022]
	-- Add the parameters for the stored procedure here
    @empid INT  ,
	 
@GroupId_   int=null,
@ZoneId_   int=null,
@AreaId_   int=null,
@TerritoryId   int=null,
@SubTerritoryId   int=null,
@MarketId   int=null,
@providertype   NVARCHAR(MAX)= NULL,
@pharmatype   NVARCHAR(MAX)= NULL,
@doctortype   NVARCHAR(MAX)= NULL

    
AS
    BEGIN
	DECLARE @params NVARCHAR(max)='   '
		IF(@GroupId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,G.GroupId)='''+CAST(CONVERT(Int,@GroupId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@AreaId_ <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,A.AreaId)='''+CAST(CONVERT(Int,@AreaId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@ZoneId_ <>0)
		BEGIN

		SET @params=@params+ ' AND  convert(Int,R.RegionId)='''+CAST(CONVERT(Int,@ZoneId_) AS NVARCHAR(max))+''''
		    
		END
		IF(@TerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,T.TerritoryId)='''+CAST(CONVERT(Int,@TerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@SubTerritoryId <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,ST.SubTerritoryId)='''+CAST(CONVERT(Int,@SubTerritoryId) AS NVARCHAR(max))+''''
		    
		END
		IF(@MarketId  <>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,M.MarketId)='''+CAST(CONVERT(Int,@MarketId) AS NVARCHAR(max))+''''
		    
		END


		IF(@providertype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tblDoctorMaster.ProgramTypeId)='''+CAST(CONVERT(Int,@providertype) AS NVARCHAR(max))+''''
		    
		END

			IF(@pharmatype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tblDoctorMaster.SMCTypeId)='''+CAST(CONVERT(Int,@pharmatype) AS NVARCHAR(max))+''''
		    
		END

			IF(@doctortype<>0 )
		BEGIN

		SET @params=@params+ ' AND  convert(Int,tblDoctorMaster.DoctorTypeId)='''+CAST(CONVERT(Int,@doctortype) AS NVARCHAR(max))+''''
		    
		END




	DECLARE @Q NVARCHAR(MAX)
	SET @Q=' 

	SELECT dt.DoctorTypeName, tblDoctorMaster.DoctorTypeId,  tblDoctorMaster.DoctorId,G.GroupName,R.RegionName,A.AreaName, t.TerritoryCode+'' : ''+ t.TerritoryName TerritoryName, st.SubTerritoryName,m.MarketCode, G.GroupId,R.RegionId,  A.AreaId, T .TerritoryId,  ST.SubTerritoryId, M.MarketId, FORMAT(tblDoctorMaster.EntryDate, ''MMM dd, yyyy hh:mm tt'') createdAt, ISNULL(tblDoctorMaster.DoctorCode+'' - '','''')+ tblDoctorMaster.DoctorName as DoctorCode,M.MarketName,(CASE WHEN ApprovalStatus=''0'' THEN ''Pending''  WHEN ApprovalStatus=''1'' THEN ''Verified'' WHEN ApprovalStatus=''2'' THEN ''Approved'' WHEN ApprovalStatus=''3'' THEN ''Rejected'' ELSE ApprovalStatus END)AS ActionStatus,''_'' AS WaitingRole,''_'' AS WatingEmployee FROM dbo.tblDoctorMaster  with (nolock)
	LEFT JOIN dbo.tblUser  with (nolock) ON dbo.tblUser.UserId=dbo.tblDoctorMaster.EntryBy
	---LEFT JOIN dbo.tblMarket  with (nolock) ON dbo.tblDoctorMaster.MarketId=dbo.tblMarket.MarketId
	LEFT JOIN dbo.tblMarket AS M    with (nolock)  ON M.MarketId = REPLACE(tblDoctorMaster.MarketId, '' '', '''')   INNER JOIN
             dbo.tblSubTerritory AS ST    with (nolock)  ON ST.SubTerritoryId = M.SubTerritoryId AND ST.IsActive = 1 INNER JOIN
             dbo.tblTerritory AS T    with (nolock)  ON T .TerritoryId = ST.TerritoryId AND T .IsActive = 1 INNER JOIN
             dbo.tblArea AS A    with (nolock)  ON A.AreaId = REPLACE(T .AreaId, '' '', '''') AND A.IsActive = 1 INNER JOIN
             dbo.tblRegion AS R    with (nolock)  ON R.RegionId = REPLACE(A.RegionId, '' '', '''') AND R.IsActive = 1 INNER JOIN
             dbo.tbl_Group AS G    with (nolock)  ON G.GroupId = R.GroupId AND G.IsActive = 1 LEFT OUTER JOIN
             dbo.tblMIOInfo AS MIO    with (nolock)  ON MIO.TerritoryId = T .TerritoryId AND MIO.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EMIO    with (nolock)  ON MIO.EmployeeId = EMIO.EmpInfoId LEFT OUTER JOIN
             dbo.tblASMInfo AS ASM    with (nolock)  ON ASM.AreaId = A.AreaId AND ASM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS EASM    with (nolock)  ON EASM.EmpInfoId = ASM.EmployeeId LEFT OUTER JOIN
             dbo.tblRSMInfo AS RSM    with (nolock)  ON RSM.RegionId = R.RegionId AND RSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ERSM    with (nolock) ON ERSM.EmpInfoId = RSM.EmployeeId LEFT OUTER JOIN
             dbo.tblNSMInfo AS NSM   with (nolock)  ON NSM.GroupId = G.GroupId AND NSM.IsActive = 1 LEFT OUTER JOIN
             dbo.tblEmpGeneralInfo AS ENSM    with (nolock)  ON ENSM.EmpInfoId = NSM.EmployeeId
	--LEFT JOIN dbo.tblDoctorApprovalLog_New ON dbo.tblDoctorApprovalLog_New.TableId=dbo.tblDoctorMaster.DoctorId
	--LEFT JOIN (SELECT TableId,MAX(Step)MaxStep FROM dbo.tblDoctorApprovalLog_New  GROUP BY TableId) AS LogMax ON LogMax.TableId=dbo.tblDoctorMaster.DoctorId
	--LEFT JOIN dbo.tblRoleType ON tblRoleType.RoleTypeId = tblDoctorApprovalLog_New.ToRoleTypeId
	--LEFT JOIN dbo.View_DoctorMaster CV  with (nolock) ON CV.DoctorId=dbo.tblDoctorMaster.DoctorId

	 left join tblDoctorType dt  with (nolock) on dt.DoctorTypeId=tblDoctorMaster.DoctorTypeId
where ( convert(Int,NSM.EmployeeId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,RSM.EmployeeId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,ASM.EmployeeId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''' OR convert(Int,MIO.EmployeeId)='''+CAST(CONVERT(Int,@empid) AS NVARCHAR(max))+''') and IsMarketUpdate2022=0    and tblDoctorMaster.IsActive=1 '+@params+' 

    '

	EXEC sys.sp_executesql @Q


    END