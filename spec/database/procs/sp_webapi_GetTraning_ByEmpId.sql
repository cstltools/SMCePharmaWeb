CREATE PROCEDURE [dbo].[sp_webapi_GetTraning_ByEmpId]
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
	

		SELECT 
		 DISTINCT format(NM.EntryDate,'MMMM dd, yyyy hh:mm tt') CreateAt, case when us.EmpInfoId is  null then us.UserName else  emp.EmpName+ '-' +emp.EmpMasterCode end CreatedBy,  img.ImagePath+ '\'+img.ImagePreName+CAST(NM.TrainningId as nvarchar(max)) FileLocation, empTrn.IsAppCheck, NM.TrainningId ,
                    NM.Title ,
                    NM.Description ,
                    NM.TrainningMeterial ,
					CONVERT(VARCHAR(10),NM.FromDate,100) AS FromDate,
             	CONVERT(VARCHAR(10),NM.ToDate,100) AS ToDate,
  
                    NM.EntryDate ,
                    NM.EntryBy ,
                    NM.IsActive  
		 FROM dbo.tblTrainning NM  CROSS JOIN tbl_ImagePath_Setting img
	 
		 inner JOIN dbo.tblTraining_Employee empTrn ON empTrn.MasterId = NM.TrainningId

		 left JOIN dbo.tblUser us ON us.UserId = NM.EntryBy
		 left JOIN dbo.tblEmpGeneralInfo emp ON us.EmpInfoId = emp.EmpInfoId

		 where     img.ImageType='Training'  and  empTrn.EmployeeId=@empId 
		ORDER BY IsAppCheck asc 

END
