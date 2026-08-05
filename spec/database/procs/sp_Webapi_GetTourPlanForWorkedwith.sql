CREATE PROCEDURE [dbo].[sp_Webapi_GetTourPlanForWorkedwith] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@tDate date = NULL ,
@empId INT = NULL
AS
BEGIN
WITH CTE AS (
    SELECT
        A.TourPlanDate,
        tpMorning = STUFF(
            (
               SELECT ', ' + CAST(InnerA.SerialNo AS VARCHAR(10)) + ', ' +
				  isnull( 'Start Place: ' +   InnerA.MarketName     ,'') +isnull(' [Time: ' + InnerA.Starttime + ']','')  ,''+ isnull(CHAR(13) + CHAR(10)+  isnull('End Place: ' + InnerA.MarketNameEnd + '','')  ,'')  +isnull(' [Time: ' + InnerA.Endtime + ']','')  ,''+ CHAR(13) + CHAR(10)+   isnull( 'Other Markets:' +STUFF( (SELECT CONCAT(', ','', mm.MarketName , '') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=InnerA.TourPlanId ORDER BY mgd.TourPlanId FOR XML PATH ('') ),1,1,''),'') +CHAR(13) + CHAR(10)
                FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock)
                       
                     
                 WHERE InnerA.IsMorning=1 and  InnerA.TPMaster = A.TPMaster  AND InnerA.TourPlanDate = A.TourPlanDate
                ORDER BY InnerA.TourPlanDate, InnerA.SerialNo
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''
        ),
		    evMorning = STUFF(
            (
                SELECT ', ' + CAST(InnerA.SerialNo AS VARCHAR(10)) + ', ' +
				  isnull( 'Start Place: ' +   InnerA.MarketName     ,'') +isnull(' [Time: ' + InnerA.Starttime + ']','')  ,''+ isnull(CHAR(13) + CHAR(10)+  isnull('End Place: ' + InnerA.MarketNameEnd + '','')  ,'')  +isnull(' [Time: ' + InnerA.Endtime + ']','')  ,''+ CHAR(13) + CHAR(10)+   isnull( 'Other Markets:' +STUFF( (SELECT CONCAT(', ','', mm.MarketName , '') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=InnerA.TourPlanId ORDER BY mgd.TourPlanId FOR XML PATH ('') ),1,1,''),'') +CHAR(13) + CHAR(10)
                FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock)
                       
                 WHERE InnerA.IsEvening=1 and InnerA.TPMaster = A.TPMaster  AND InnerA.TourPlanDate = A.TourPlanDate
                ORDER BY InnerA.TourPlanDate, InnerA.SerialNo
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''
        ),
        ROW_NUMBER() OVER (PARTITION BY A.TourPlanDate ORDER BY A.TourPlanDate) AS rn
    FROM dbo.tbl_TourPlanInfo AS A
    WHERE    A.EmpInfoId = @empId AND  convert(date,A.TourPlanDate) =convert(date,@tDate )
)

SELECT
    ISNULL(MONTH(TourPlanDate),'') AS MonthValue,
   ISNULL( YEAR(TourPlanDate),'') AS YearValue,
  ISNULL(  DAY(TourPlanDate),'') AS DayValue,
   ISNULL( FORMAT(TourPlanDate, 'dddd'),'') AS _DayName,
    TourPlanDate = ISNULL(CONVERT(varchar(10), TourPlanDate, 120),''),
  ISNULL(  tpMorning,'') tpMorning,  ISNULL(  evMorning,'') evMorning 
FROM CTE
WHERE rn = 1
ORDER BY TourPlanDate ASC

;END