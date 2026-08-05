CREATE PROCEDURE [dbo].[sp_Webapi_Get_TourPlanInfo_New] -- sp_Webapi_Get_TourPlanInfo 2,2021,0
	-- Add the parameters for the stored procedure here
@month INT = NULL,
@year INT = NULL,
@empId INT = NULL
AS
BEGIN
WITH CTE AS (
    SELECT
        A.TourPlanDate,
        details = STUFF(
            (
                SELECT  ', ' + CAST(InnerA.SerialNo AS VARCHAR(10)) + ', ' +
				  isnull(  case when InnerA.IsMarketVisit=1 then 'Market Visit'  when InnerA.IsOtherVisit=1 then 'Other Visit, ' else  '' end+  case when InnerA.IsMorning=1 then ' (Morning)'+  ', '   when InnerA.IsEvening=1 then ' (Evening)'+  ', ' else '' end,'') +
                    ISNULL((InnerC.CustomerCode + ' : ' + InnerC.CustomerName) + ', ', '') +
                  isnull(  st.StationTypeName + ', ' ,'')+
                    isnull(InnerF.TPName + ', ' ,'')+
                  + isnull(CHAR(13) + CHAR(10)+   InnerA.MarketCode_TP + ' : ' + InnerA.MarketName + ISNULL(' [' + st.StationTypeName + ']'  ,''),'') + isnull( isnull('  at ' + InnerA.Starttime + '','')  ,'')  +  ISNULL(CHAR(13) + CHAR(10)+'Worked With: '+workEmp.EmpName,'')   +
				  ISNULL(CHAR(13) + CHAR(10)+'Objective: '+InnerA.Objective,'') +isnull(CHAR(13)+CHAR(10) +  'Other Market Visit: '+STUFF(
    (
        SELECT   ', '  +
            
                mm.MarketName 
            
        FROM 
            tblMarket mm WITH (NOLOCK)
        INNER JOIN 
            dbo.tblTPMarketDetail mgd ON mgd.MarketId = mm.MarketId 
        WHERE 
            mgd.TourPlanId = InnerA.TourPlanId 
        ORDER BY 
            mgd.MarketId 
        FOR XML PATH ('')
    ),
    1, 2, ''
) ,'') +CHAR(13)+CHAR(10)    +CHAR(13) + CHAR(10)

                FROM dbo.tbl_TourPlanInfo AS InnerA  with(nolock)
                LEFT JOIN dbo.tblStationType st  with(nolock) ON st.StationTypeId = InnerA.TourTypeId
                LEFT JOIN dbo.tblCustMaster AS InnerC  with(nolock) ON InnerC.CustomerMasterId = InnerA.CustomerMasterId
               -- LEFT JOIN dbo.tbl_TourPlanType AS InnerE  with(nolock) ON InnerE.TourTypeId = InnerA.TourTypeId
                LEFT JOIN dbo.tbl_TourPlanPurpose AS InnerF  with(nolock) ON InnerF.TPId = InnerA.TPId
                LEFT JOIN dbo.tblEmpGeneralInfo AS workEmp  with(nolock) ON workEmp.EmpInfoId = InnerA.VisitedWithEmpInfoId
           
                LEFT JOIN dbo.tblStationType AS InnerST  with(nolock) ON InnerST.StationTypeId = InnerA.TourTypeId
                WHERE InnerA.TPMaster = A.TPMaster  AND InnerA.TourPlanDate = A.TourPlanDate
                ORDER BY InnerA.TourPlanDate, InnerA.SerialNo
                FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'), 1, 2, ''
        ),
        ROW_NUMBER() OVER (PARTITION BY A.TourPlanDate ORDER BY A.TourPlanDate) AS rn
    FROM dbo.tbl_TourPlanInfo AS A
    WHERE A.EmpInfoId = @empId AND MONTH(A.TourPlanDate) =@month AND YEAR(A.TourPlanDate) = @year
)

SELECT
    MONTH(TourPlanDate) AS MonthValue,
    YEAR(TourPlanDate) AS YearValue,
    DAY(TourPlanDate) AS DayValue,
    FORMAT(TourPlanDate, 'dddd') AS _DayName,
    TourPlanDate = CONVERT(varchar(10), TourPlanDate, 120),
    details
FROM CTE
WHERE rn = 1
ORDER BY TourPlanDate ASC;END