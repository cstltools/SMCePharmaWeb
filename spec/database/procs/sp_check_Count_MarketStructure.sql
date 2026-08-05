

CREATE PROCEDURE [dbo].[sp_check_Count_MarketStructure]
	-- Add the parameters for the stored procedure here
	  @MasterId  INT ,
      @PageName     NVARCHAR(MAX) 

AS
BEGIN

if(@PageName='Market')
	BEGIN	
SELECT 'Customer' Parti, COUNT(MarketId)MarketIdCount FROM dbo.tblCustMaster  WHERE IsActive=1 and MarketId=@MasterId  

	union all SELECT 'Doctor' Parti, COUNT(MarketId)MarketIdCount  FROM dbo.tblDoctorMaster  WHERE   IsActive=1 and MarketId=@MasterId  

	union all SELECT  'Distribution Routes' Parti, COUNT(MarketId)MarketIdCount  FROM dbo.tblRouteInformationMarketDetail    WHERE  MarketId=@MasterId  

	 
	 
	 

--union all	SELECT 'Campaign' Parti, COUNT(MarketId)MarketIdCount  FROM dbo.tbl_BonusCampaignMarketDetail dtl
--INNER JOIN dbo.tbl_BonusCampaignNewMaster mas ON mas.CampgainMasterId=dtl.CampaignMasterId
--WHERE  GETDATE() BETWEEN mas.FromDate AND mas.Todate and MarketId=@MasterId  


union all	SELECT 'Order' Parti, COUNT(MarketId)MarketIdCount  FROM dbo.tblOrder mas 
WHERE mas.IsInvoice=0  and MarketId=@MasterId  

--union all	SELECT  'Notice' Parti,  COUNT(MarketId)MarketIdCount  FROM dbo.tbl_Notice_MarketDetails dtl
--INNER JOIN dbo.tbl_Notice_MarketMaster mas ON mas.NoticeId=dtl.NoticeId
--WHERE  CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate) and MarketId=@MasterId  

--union all	SELECT  'Training' Parti, COUNT(MarketId)MarketIdCount  FROM dbo. tbl_TrainingMarketDetail dtl
--INNER JOIN dbo.tblTrainning mas ON mas.TrainningId=dtl.TrainningId
--WHERE   CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,mas.FromDate) AND CONVERT(DATE,mas.Todate) and MarketId=@MasterId  
	
END
END
