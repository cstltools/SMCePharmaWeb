
CREATE PROCEDURE [dbo].[sp_webapi_GetTADAAppDataById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			SELECT  DISTINCT  'ORD: '+ isnull((select cast(sum(convert(int,ISNULL(ORD,0))) as nvarchar(max)) from SalesDisDB_SMC_TrSalesRepor..tblEmpCountOrd dd where dd.EntryBy=  mas.EntryBy and CONVERT(date,dd.EntryDate)=CONVERT(date,(mas.TadaDate) )),0)+char(10)+char(13) + 'RX: '+isnull( (select cast(sum(convert(int,ISNULL(RX,0))) as nvarchar(max))  from SalesDisDB_SMC_TrSalesRepor..tblEmpCountRX dd where dd.EntryBy=  mas.EntryBy and CONVERT(date,dd.EntryDate)=CONVERT(date,(mas.TadaDate) )),0)+char(10)+char(13)+  'DCR: '+isnull( (select cast(sum(convert(int,ISNULL(DCR,0)))as nvarchar(max)) from SalesDisDB_SMC_TrSalesRepor..tblEmpCountDCR dd where dd.EntryBy=  mas.EntryBy and CONVERT(date,dd.EntryDate)=CONVERT(date,(mas.TadaDate) )),0)   TotalEmpRslt , (SELECT LTRIM(RTRIM(ImagePath+'/'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting  with (nolock)  WHERE ImageType='DAClaimMy')+CAST(mas.TadaID as nvarchar(max))+'.jpg' AS   ImageString, mas.TadaID,mas.Remarks,mas.EmpInfoId,  us.UserRoleID, format(mas.TadaDate,'dd-MMM-yyyy')AS TadaDateNewFormat, format(mas.TadaDate,'dd')AS TadaDate, emp.EmpMasterCode+' - '+emp.EmpName EmpName,0 TaAmt,mas.DAAmount DaAmt,mar.MarketName +' ['+st.StationTypeName+']' MarketName,   mas.ApprovalStatus     FROM  [dbo].[tbl_TadaClaimMaster] mas
 
left JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=mas.EmpInfoId
left JOIN dbo.tbl_TourPlanInfo tp ON tp.EmpInfoId = emp.EmpInfoId AND CONVERT(NVARCHAR(50),mas.TadaDate,106)= CONVERT(NVARCHAR(50),tp.TourPlanDate,106)
left JOIN dbo.tblMarket mar ON mar.MarketId = tp.MarketId
left JOIN dbo.tblUser us ON us.EmpInfoId=mas.EmpInfoId
left JOIN dbo.tblStationType st ON st.StationTypeId=mas.TourTypeId

WHERE   mas.TadaID=@id
END