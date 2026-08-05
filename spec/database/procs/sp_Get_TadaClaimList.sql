-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TadaClaimList]
	-- Add the parameters for the stored procedure here
	@param nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)=' SELECT DISTINCT mas.TadaID , mas.HotelName, mas.HotelPhone, (SELECT LTRIM(RTRIM(ImagePath+''\''+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType=''DAClaim'')+CAST(mas.TadaID AS NVARCHAR(max))+''.jpg''AS ImagePreName,  tblapp.Info ApprovalLog,us.UserRoleID, format(mas.TadaDate,''dd-MMM-yyyy'')AS TadaDate, emp.EmpMasterCode,emp.EmpName, 0 TaAmt, mas.DAAmount DaAmt,mar.MarketCode+'' : ''+ mar.MarketName MarketName, st.StationTypeName,   case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified'' when mas.ApprovalStatus=''2'' then ''Approved'' when mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end  ApprovalStatus     FROM  [dbo].[tbl_TadaClaimMaster] mas with (nolock)
 
left JOIN dbo.tblEmpGeneralInfo emp  with (nolock) ON emp.EmpInfoId=mas.EmpInfoId
left JOIN dbo.tblStationType st  with (nolock) ON st.StationTypeId=mas.TourTypeId

 
left JOIN dbo.tblMarket mar  with (nolock) ON mar.MarketId = mas.MarketId
left JOIN dbo.tblUser us  with (nolock) ON us.EmpInfoId=mas.EmpInfoId
left join (SELECT tblt.TableId,SUBSTRING(tblt.Info,2,LEN(tblt.Info))Info FROM (SELECT 
   SS.TableId, 
   (SELECT '', ('' +EG.EmpName +'',''+US.Status+'',''+convert(varchar, US.EntryDateApp, 105)+'')'' 
    FROM dbo.tblTADAApprovalLog US  with (nolock)
	LEFT JOIN tblEmpGeneralInfo EG  with (nolock)  ON EG.EmpInfoId=US.EntryByApp
    WHERE US.TableId = SS.TableId
    FOR XML PATH('''')) [Info]
FROM dbo.tblTADAApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblapp on tblapp.TableId=mas.TadaID

WHERE mas.TadaID IS NOT NULL 
 '+@param  


EXEC sp_executesql @Q
	
END

