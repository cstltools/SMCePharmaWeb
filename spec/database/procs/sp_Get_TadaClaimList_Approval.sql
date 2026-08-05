
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TadaClaimList_Approval]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

 SELECT DISTINCT CONVERT(NVARCHAR(50),mas.TadaDate,106)AS TadaDate, mas.TadaID, emp.EmpMasterCode,emp.EmpName,TaAmt,DaAmt,mar.MarketName,ApprovalStatus     FROM  [dbo].[tbl_TadaClaimMaster] mas
INNER JOIN [dbo].[tbl_TadaClaimDetails] dtl ON mas.TadaID=dtl.TadaID
INNER JOIN dbo.tblEmpGeneralInfo emp ON emp.EmpInfoId=mas.EmpInfoId
INNER JOIN dbo.tbl_TourPlanInfo tp ON tp.EmpInfoId = emp.EmpInfoId AND CONVERT(NVARCHAR(50),mas.TadaDate,106)= CONVERT(NVARCHAR(50),tp.TourPlanDate,106)
INNER JOIN dbo.tblMarket mar ON mar.MarketId = tp.MarketId
Where  ApprovalStatus !='Approved'

END


