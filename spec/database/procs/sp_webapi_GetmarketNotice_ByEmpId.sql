CREATE PROCEDURE [dbo].[sp_webapi_GetmarketNotice_ByEmpId]
	-- Add the parameters for the stored procedure here
@empId INT 
AS
BEGIN
	
--	SELECT  DISTINCT TOP 20 NM.NoticeId ,
--                    NM.NoticeTitle ,
--                    NM.Announcement ,
--					CONVERT(VARCHAR(10),NM.FromDate,100) AS FromDate,
--             	CONVERT(VARCHAR(10),NM.ToDate,100) AS ToDate,
  
--                    NM.EntryDate ,
--                    NM.EntryBy ,
--                    NM.IsActive ,
--                    NM.IsReaded
--FROM    dbo.tblMIOInfo A
--        LEFT JOIN dbo.tblTerritory B ON B.TerritoryId = A.TerritoryId
--		LEFT JOIN dbo.tblMarket C ON c.TerritoryId = B.TerritoryId
--		LEFT JOIN dbo.tblArea Ar ON Ar.AreaId = B.AreaId
--		LEFT JOIN dbo.tblRegion Re ON Re.RegionId = Ar.RegionId
--		LEFT JOIN dbo.tbl_Notice_MarketDetails NB ON NB.MarketId = C.MarketId
--		LEFT JOIN dbo.tbl_Notice_MarketMaster NM ON NM.NoticeId = NB.NoticeId
--		WHERE A.EmployeeId = @empId
--		ORDER BY NM.NoticeId DESC
	

	
		SELECT case when  uemp.EmpInfoId is not null then   empU.EmpMasterCode+' : '+empU.EmpName else uemp.LoginName end CreatedBy,
		   
				(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Notice')AS ImagePreName, empnoti.IsAppCheck, NM.NoticeId ,
                    NM.NoticeTitle ,
                    NM.Announcement ,
					format(NM.FromDate,'dd MMMM, yyyy') +' To ' +format(NM.ToDate,'dd MMMM, yyyy')  AS FromDate,
             	format(NM.ToDate,'dd MMMM, yyyy') AS ToDate,
  
                    NM.EntryDate ,
                    NM.EntryBy ,
                    NM.IsActive ,
                    NM.IsReaded
		 FROM dbo.tbl_Notice_MarketMaster NM  CROSS JOIN tbl_ImagePath_Setting img
		LEFT JOIN dbo.tbl_Notice_MarketDetails NB ON NB.NoticeId = NM.NoticeId
		LEFT JOIN dbo.tblUser uemp ON uemp.UserId = NM.EntryBy
		LEFT JOIN dbo.tblEmpGeneralInfo empU ON empU.EmpInfoId = uemp.EmpInfoId


		 inner JOIN dbo.tblNotice_Employee empnoti ON empnoti.MasterId = NM.NoticeId
		 where     img.ImageType='Notice' and  empnoti.EmployeeId=@empId and CONVERT(Date, GETDATE()) between  CONVERT(Date,NM.FromDate) and CONVERT(Date,NM.ToDate)
		ORDER BY NM.EntryDate DESC

END
