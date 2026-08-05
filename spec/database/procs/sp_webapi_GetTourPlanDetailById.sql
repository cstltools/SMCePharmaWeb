CREATE PROCEDURE [dbo].[sp_webapi_GetTourPlanDetailById]
	-- Add the parameters for the stored procedure here
@id INT=null 
AS
BEGIN
			
		SELECT mas.CustomerMasterId, cus.CustomerCode+' : '+cus.CustomerName CustomerName, mas.MarketId, mr.MarketName, FORMAT(mas.TourPlanDate,'dd MMM yyyy') TourPlanDate, mas.TPId,tp.TPName,  * FROM dbo.tbl_TourPlanInfo mas
INNER JOIN dbo.tblMarket mr ON mr.MarketId = mas.MarketId
left JOIN dbo.tblCustMaster cus ON cus.CustomerMasterId = mas.CustomerMasterId
left JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = mas.TPId
WHERE mas.TPMaster=@id
END
