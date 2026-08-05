-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_CampaingData]
	-- Add the parameters for the stored procedure here
@empId int
AS
BEGIN
		
--SELECT
--       A.CampaignCode ,
--       A.CampaignName ,
--       A.CampaignDesc ,
--       CONVERT(NVARCHAR(50),A.FromDate,107)AS FromDate ,
--       CONVERT(NVARCHAR(50),A.Todate,107)AS Todate,
--       A.Type  FROM dbo.tblBonusCampaignMaster A 
--INNER JOIN dbo.tblCompanyInfo B ON B.CompanyId = A.CompanyId
--INNER JOIN dbo.tblEmpGeneralInfo C ON B.CompanyId = C.CompanyId
--WHERE C.EmpInfoId = @empId
--AND A.IsActive = 1


SELECT A.CampgainMasterId ,
       A.CampaignCode AS CampaignCode,
       A.CampaignName AS CampaignDesc,
       B.Description AS  CampaignName,
      FORMAT(A.FromDate,'dd MMMM, yyyy hh:mm tt') FromDate ,
         FORMAT(A.Todate,'dd MMMM, yyyy hh:mm tt') AS Todate

	    FROM dbo.tbl_BonusCampaignNewMaster A 
	   LEFT JOIN dbo.tbl_CampaignType B ON B.CampainTypeId = A.CampainTypeId
	   inner join GetCampaignEmployee() tblj on tblj.CampMasId=A.CampgainMasterId

		WHERE A.IsActive = 1 and    GETDATE()  between FromDate and Todate  and    empinfoid=@empId

		--select GETDATE()
END

