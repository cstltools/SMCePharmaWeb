-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_TodaysTask]
	-- Add the parameters for the stored procedure here
    
    @empId INT
AS
    BEGIN

	DECLARE @DCPMain NVARCHAR(MAX) = ''
	DECLARE @Main NVARCHAR(MAX) = ''
DECLARE @m_mor NVARCHAR(MAX) = ''
DECLARE @m_Other NVARCHAR(MAX) = ''
DECLARE @e_Eve NVARCHAR(MAX) = ''
DECLARE @m_TPName NVARCHAR(MAX) = ''
DECLARE @e_TPName NVARCHAR(MAX) = ''
DECLARE @other_TPName NVARCHAR(MAX) = ''
-- Fetch Morning Visit
SELECT @m_mor =
    CASE 
        WHEN IsMarketWise = 1 THEN 
            'Market Visit ' 
            + CASE 
                WHEN IsMorning = 1 THEN ' (Morning)' 
                ELSE ' (Evening)' 
              END 
            + CHAR(13) + CHAR(10) 
            + 'Start: ' + ISNULL(A.MarketName, 'Unknown') + ' at ' + ISNULL(A.Starttime, 'N/A') 
            + CHAR(13) + CHAR(10) 
            + 'End: ' + ISNULL(A.MarketNameEnd, 'Unknown') + ' at ' + ISNULL(A.Endtime, 'N/A') 
          
            + CASE 
                WHEN     A.Objective IS NOT NULL AND A.Objective <> '' 
                THEN CHAR(13) + CHAR(10)+ 'Objective: ' + A.Objective 
                ELSE '' 
              END  +  ISNULL(CHAR(13) + CHAR(10)+'Worked With: '+workEmp.EmpName,'')   +  +isnull(CHAR(13)+CHAR(10) +  'Other Market Visit: '+STUFF(
    (
        SELECT   ', '  +
            
                mm.MarketName 
            
        FROM 
            tblMarket mm WITH (NOLOCK)
        INNER JOIN 
            dbo.tblTPMarketDetail mgd ON mgd.MarketId = mm.MarketId 
        WHERE 
            mgd.TourPlanId = A.TourPlanId 
        ORDER BY 
            mgd.MarketId 
        FOR XML PATH ('')
    ),
    1, 2, ''
) ,'')
        ELSE 
            'Other Visit' 
    END, @m_TPName=  ISNULL(tp.TPName, 'Unknown')
FROM dbo.tbl_TourPlanInfo A
    INNER JOIN dbo.tbl_TourPlanMaster mas ON mas.TPMaster = A.TPMaster
    LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
	 LEFT JOIN dbo.tblEmpGeneralInfo AS workEmp  with(nolock) ON workEmp.EmpInfoId = A.VisitedWithEmpInfoId
WHERE A.EmpInfoId = @empId
    AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE()) 
    AND mas.ApprovalStatus = '2' 
    AND IsMarketWise = 1 
    AND IsMorning = 1

-- Fetch Evening Visit
SELECT @e_Eve =
    CASE 
        WHEN IsMarketWise = 1 THEN 
            'Market Visit ' 
            + CASE 
                WHEN IsMorning = 1 THEN ' (Morning)' 
                ELSE ' (Evening)' 
              END 
            + CHAR(13) + CHAR(10) 
            + 'Start: ' + ISNULL(A.MarketName, 'Unknown') + ' at ' + ISNULL(A.Starttime, 'N/A') 
            + CHAR(13) + CHAR(10) 
            + 'End: ' + ISNULL(A.MarketNameEnd, 'Unknown') + ' at ' + ISNULL(A.Endtime, 'N/A') 
           
            + CASE 
                WHEN A.Objective IS NOT NULL AND A.Objective <> '' 
                THEN   CHAR(13) + CHAR(10)+ 'Objective: ' + A.Objective 
                ELSE '' 
              END  +  ISNULL(CHAR(13) + CHAR(10)+'Worked With: '+workEmp.EmpName,'')   +  +isnull(CHAR(13)+CHAR(10) +  'Other Market Visit: '+STUFF(
    (
        SELECT   ', '  +
            
                mm.MarketName 
            
        FROM 
            tblMarket mm WITH (NOLOCK)
        INNER JOIN 
            dbo.tblTPMarketDetail mgd ON mgd.MarketId = mm.MarketId 
        WHERE 
            mgd.TourPlanId = A.TourPlanId 
        ORDER BY 
            mgd.MarketId 
        FOR XML PATH ('')
    ),
    1, 2, ''
) ,'')
        ELSE 
            'Other Visit' 
    END, @e_TPName=  ISNULL(tp.TPName, 'Unknown')
FROM dbo.tbl_TourPlanInfo A
    INNER JOIN dbo.tbl_TourPlanMaster mas ON mas.TPMaster = A.TPMaster
    LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
	 LEFT JOIN dbo.tblEmpGeneralInfo AS workEmp  with(nolock) ON workEmp.EmpInfoId = A.VisitedWithEmpInfoId
WHERE A.EmpInfoId = @empId
    AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE()) 
    AND mas.ApprovalStatus = '2'  
    AND IsMarketWise = 1 
    AND IsEvening = 1

-- Fetch Other Visits
SELECT @m_Other =
       'Other Visit ' --+isnull(+'('+tp.TPName+')','')  
    , @other_TPName=  ISNULL(tp.TPName, 'Unknown')  
FROM dbo.tbl_TourPlanInfo A
    INNER JOIN dbo.tbl_TourPlanMaster mas ON mas.TPMaster = A.TPMaster
    LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
	  LEFT JOIN dbo.tblEmpGeneralInfo AS workEmp  with(nolock) ON workEmp.EmpInfoId = A.VisitedWithEmpInfoId
WHERE A.EmpInfoId = @empId
    AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE()) 
    AND mas.ApprovalStatus = '2'  
    AND A.IsOtherVisit = 1

-- Concatenate the results with a new line if they are not empty
SET @Main = 
    CASE WHEN @m_mor <> '' THEN @m_mor + CHAR(13) + CHAR(10) +isnull('Purpose: '+ @m_TPName,'')  + CHAR(13) + CHAR(10)  + CHAR(13) + CHAR(10)  ELSE '' END 
    + CASE WHEN @e_Eve <> '' THEN @e_Eve + CHAR(13) + CHAR(10) +isnull('Purpose: '+ @e_TPName,'')  + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)  ELSE '' END 
    + CASE WHEN @m_Other <> '' THEN @m_Other + CHAR(13) + CHAR(10)  +isnull('Purpose: '+ @other_TPName,'')  + CHAR(13) + CHAR(10)+ CHAR(13) + CHAR(10)   ELSE '' END

-- Print the result
PRINT @Main


SELECT  @DCPMain=  STUFF(( SELECT CHAR(13) + CHAR(10) + (B.DoctorCode + ' : ' + B.DoctorName)
                FROM dbo.tbl_DoctorTourPlanDetail A1
                LEFT JOIN dbo.tblDoctorMaster B ON B.DoctorId = A1.DoctorId
                WHERE A1.EmpInfoId = A.EmpInfoId
                AND CONVERT(Date, A1.TourPlanDate) = CONVERT(Date, GETDATE())
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') 
FROM    dbo.tbl_DoctorTourPlanDetail A
        INNER JOIN dbo.tbl_DoctorTourPlanMaster mas ON mas.DocTPMaster = A.DocTPMaster
        LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
WHERE   A.EmpInfoId = @empId and A.Type_DV='D'
        AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE())
GROUP BY tp.TPName, A.DocTPDetailsId, A.EmpInfoId



		SELECT 
   @Main MarketName,
    ISNULL('', 'Unknown') AS TerritoryName,
 COALESCE(NULLIF(@m_TPName, 'Unknown'), NULLIF(@e_TPName, 'Unknown'), @other_TPName) AS SMName  ,
    'Tour Plan' AS TPName,
    0 IsMarketWise, 
    ISNULL('', 'Unknown') AS MName,
    'mtp' AS TourType , 0 Id   where @Main<>''
   
UNION ALL
SELECT  '' AS MarketName ,
        '' AS TerritoryName ,
       ''  AS SMName ,
        'DCP' AS TPName ,
		  0 AS IsMarketWise ,
       @DCPMain AS MName ,
        'dtp' AS TourType, 0 Id  where @DCPMain<>''
 
        
	--AND mas.ApprovalStatus = '2' 
	 



	 UNION ALL
SELECT  'FCB'+' :'+ cast(ISNULL(dtl.FCBAmount,0) as nvarchar(max))+ char(10)+char(13)+ 'Campaign'+' :'+ cast(ISNULL(dtl.CampaignAmount,0) as nvarchar(max)) + char(10)+char(13) +'General'+' :'+ cast(ISNULL(dtl.GeneralAmount,0) as nvarchar(max))      AS MarketName ,
        '' AS TerritoryName ,
        '' AS SMName ,
        'DWSP' AS TPName ,
		  0 AS IsMarketWise ,
           'FCB'+' :'+ cast(ISNULL(dtl.FCBAmount,0) as nvarchar(max))+ char(10)+char(13)+ 'Campaign'+' :'+ cast(ISNULL(dtl.CampaignAmount,0) as nvarchar(max)) + char(10)+char(13) +'General'+' :'+ cast(ISNULL(dtl.GeneralAmount,0) as nvarchar(max))    MName ,
        'DWSP' AS TourType, 0 Id
 

	  from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  CONVERT(Date,dtl.DWSPDate)=CONVERT(Date,GETDATE() ) and mas.EmpInfoId=@empId  
	 
	   and  mas.ApprovalStatus = '2' 

    END

