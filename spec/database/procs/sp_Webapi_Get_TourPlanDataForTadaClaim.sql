-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanDataForTadaClaim]
	-- Add the parameters for the stored procedure here
	@empId INT = NULL,
	@tourDate nvarchar(max) = NULL
AS
BEGIN
	


	SELECT  A.TPId TourPurposeId, isnull(B.MarketName,'Other Visit') MarketName ,
        isnull(C.TerritoryName,'') TerritoryName ,
       isnull(tp.TPName,'')  SMName ,
      isnull(st.StationTypeName,'') TPName ,
        A.IsMarketWise ,
         isnull(( cus.CustomerCode + ' : ' + cus.CustomerName ),'') AS MName ,
        'mtp' AS TourType,A.TourPlanId Id
FROM    dbo.tbl_TourPlanInfo A
        LEFT JOIN dbo.tbl_TourPlanMaster mas ON mas.TPMaster = A.TPMaster
        LEFT JOIN dbo.tblMarket B ON B.MarketId = A.MarketId
        LEFT JOIN dbo.tblTerritory C ON C.TerritoryId = A.TerritoryId
        LEFT JOIN dbo.tbl_SubMarket D ON D.MarketId = A.MarketId
        LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
        LEFT JOIN dbo.tblStationType st ON st.StationTypeId = A.TourTypeId
        LEFT JOIN dbo.tblCustMaster cus ON cus.CustomerMasterId = A.CustomerMasterId
WHERE A.Serialno=1 and   A.EmpInfoId = @empId
        AND CONVERT(DATE,A.TourPlanDate) = CONVERT(DATE,getdate())
        AND  mas.ApprovalStatus= '2' AND 
		CONVERT(DATE,A.TourPlanDate) NOT IN  (SELECT CONVERT(DATE, TadaDate) FROM dbo.tbl_TadaClaimMaster b WHERE b.EmpInfoId=@empId)
--UNION ALL
--SELECT  '' AS MarketName ,
--        '' AS TerritoryName ,
--        tp.TPName AS SMName ,
--        'Doctor Visit' AS TPName ,
--		  0 AS IsMarketWise ,
--        ( B.DoctorCode + ' : ' + B.DoctorName ) AS MName ,
--        'dtp' AS TourType, A.DocTPDetailsId Id
--FROM    dbo.tbl_DoctorTourPlanDetail A
--        LEFT JOIN dbo.tblDoctorMaster B ON B.DoctorId = A.DoctorId
--        LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId

--WHERE   A.EmpInfoId = @empId
--        AND A.TourPlanDate = @tourDate
--        AND A.IsApproved = 0
--				AND CONVERT(DATE,A.TourPlanDate) NOT IN  (SELECT CONVERT(DATE, TadaDate) FROM dbo.tbl_TadaClaimMaster b WHERE b.EmpInfoId=@empId)





END