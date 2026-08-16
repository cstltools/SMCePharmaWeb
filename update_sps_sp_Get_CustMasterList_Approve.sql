-- Adds DoctorCode/DoctorName as separate columns to the Customer List / Excel export
-- (CustomerView.aspx), aggregated per customer via STRING_AGG so a customer tagged to
-- multiple doctors (tblCustTaggDoc is many-to-many) still comes back as one row.
-- Source of truth: spec\database\procs\sp_Get_CustMasterList_Approve.sql - keep both in sync.
-- Run against the SolutionConnectionStringSSIDB target (see runsql.ps1 for the connection pattern).

IF OBJECT_ID('dbo.sp_Get_CustMasterList_Approve', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_Get_CustMasterList_Approve;
GO

CREATE PROCEDURE [dbo].[sp_Get_CustMasterList_Approve]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
SET NOCOUNT ON;
   DECLARE @Q NVARCHAR(MAX)='
 SELECT  mas.CustomerBsPCode, tblcom.Dept, tblMIO.StationTypeName , div.DivisionName,dis.DistrictName, tha.ThanaName, St.SMCType, dbo.Remove_SpecialCharacters(Address) Address, ISNULL(mas.CustomerCode+'' : '','''') +ISNULL( + case when mas.IsActive=1 then  mas.CustomerName else mas.CustomerName +'' (Inactive) '' end ,'''') +ISNULL('' : ''+mas.CellNo,'''')   as CustomerSearch, tblEmpGeneralInfo.EmpMasterCode +'' : ''+ tblEmpGeneralInfo.EmpName EmpMasterCode,rg.RegionCode, Ar.AreaCode, Tr.TerritoryCode,case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatus, pt.ProgramTypeName, mr.MarketCode,mr.MarketName MarketName,  Chmist.CustomerType,dcMas.RouteName  DistributionRouteName,   FORMAT(mas.CreateDate,''dd MMM yyyy hh:mm tt'') EntryDate, doc.DoctorCode, doc.DoctorName, * from dbo.tblCustMaster mas WITH (NOLOCK)
 LEFT JOIN dbo.tblCustomerType Chmist  WITH (NOLOCK)  ON Chmist.CustomerTypeId = mas.CustomerTypeId
 LEFT JOIN dbo.tblProgramType pt  WITH (NOLOCK)  ON pt.ProgramTypeId = mas.ProgramTypeId
   left join tblUser  with (nolock) on tblUser.UserId=mas.CreateBy
LEFT JOIN dbo.tblEmpGeneralInfo  with (nolock) ON tblEmpGeneralInfo.EmpInfoId = tblUser.EmpInfoId
  left join  tblMarket mr  WITH (NOLOCK)  on mas.MarketId=mr.MarketId
  LEFT JOIN (select MarketId,st.StationTypeName  from tblMarketStationDetail dtl
		inner join  tblStationType st on st.StationTypeId=dtl.StationTypeId
		 where dtl.UserRoleID=1) tblMIO ON tblMIO.MarketId = mr.MarketId

		  LEFT JOIN (select dtl.MarketId,com.ComUnitCode+'' : ''+ComUnitName Dept  from tblRouteInformationMarketDetail dtl   WITH (NOLOCK)
		inner join  tblRouteInformationMaster mas   WITH (NOLOCK)  on mas.RouteInformationMasterId=dtl.RouteInformationMasterId
		inner join  tblCompanyUnit com   WITH (NOLOCK)  on mas.DCId=com.ComUnitId
		  ) tblcom ON tblcom.MarketId = mr.MarketId

  LEFT JOIN tbl_Thana tha   with (nolock) ON tha.ThanaId = mr.ThanaId
		LEFT JOIN tbl_District dis   with (nolock) ON tha.district_id = dis.DistrictId
		LEFT JOIN tbl_Division div   with (nolock) ON div.DivisionId = dis.DivisionId
	 left join  tblSubTerritory subTr  WITH (NOLOCK)   on subTr.SubTerritoryId=mr.SubTerritoryId
	 left join  tblTerritory  Tr  WITH (NOLOCK)   on subTr.TerritoryId=Tr.TerritoryId
	 left join  tblArea  Ar  WITH (NOLOCK)   on Ar.AreaId=Tr.AreaId
	 left join  tblRegion  rg  WITH (NOLOCK)    on Ar.RegionId=rg.RegionId
	 left join  tbl_Group  gr  WITH (NOLOCK)   on gr.GroupId=rg.GroupId
     left JOIN tblRouteInformationMarketDetail DCdtl  with (nolock) on mas.MarketId=DCdtl.MarketId
		left join tblRouteInformationMaster dcMas  with (nolock) on dcMas.RouteInformationMasterId=DCdtl.RouteInformationMasterId
			 left join  tblSMCType  St  WITH (NOLOCK)   on mas.SMCTypeId=St.SMCTypeId
     -- Pre-aggregated join, not OUTER APPLY: a correlated per-row APPLY here measured
     -- 10-40x slower on this table shape (14.6s to 106s on a 4.3k-row filtered search).
     LEFT JOIN (
        SELECT ctd.CustomerMasterId,
               STRING_AGG(dm.DoctorCode, '', '') WITHIN GROUP (ORDER BY dm.DoctorCode) AS DoctorCode,
               STRING_AGG(dm.DoctorName, '', '') WITHIN GROUP (ORDER BY dm.DoctorCode) AS DoctorName
        FROM dbo.tblCustTaggDoc ctd WITH (NOLOCK)
        INNER JOIN dbo.tblDoctorMaster dm WITH (NOLOCK) ON dm.DoctorId = ctd.DoctorId
        GROUP BY ctd.CustomerMasterId
     ) doc ON doc.CustomerMasterId = mas.CustomerMasterId
   where mas.CustomerMasterId is not null
  '+@Parm +'  order by CustomerCode desc '


EXEC sp_executesql @Q

END
GO
