CREATE PROCEDURE [dbo].[sp_Webapi_Get_TodaysTaskforDCPCCP]
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
 



		SELECT 
 0 DoctorId,  @Main   DoctorName  , 'Tour Plan' TypeName ,   'N/A'  AS DocContact,
        'N/A'  AS DoctorTypeName,
       'N/A'  AS ProgramTypeName,
        'N/A'  AS ChemberName
         where @Main<>''

    union all

SELECT    B.DoctorId,     B.DoctorName  DoctorName, 'DCP' TypeName , ISNULL(B.DocContact, 'N/A') AS DocContact,
        ISNULL(B.DoctorTypeName, 'N/A') AS DoctorTypeName,
        ISNULL(B.ProgramTypeName, 'N/A') AS ProgramTypeName,
        ISNULL(B.ChemberName, 'N/A') AS ChemberName
FROM    dbo.tbl_DoctorTourPlanDetail A
 LEFT JOIN dbo.View_DoctorMaster B ON B.DoctorId = A.DoctorId
        INNER JOIN dbo.tbl_DoctorTourPlanMaster mas ON mas.DocTPMaster = A.DocTPMaster
        LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
WHERE   A.EmpInfoId = @empId and A.Type_DV='D' and mas.ApprovalStatus='2'
        AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE())  AND NOT EXISTS (
        SELECT 1
        FROM dbo.tbl_DCRInfo AS c
        WHERE c.TypeDcr = 'DCR'
          AND c.DoctorId = A.DoctorId
          AND CONVERT(date, c.DcrDate) = CONVERT(date, A.TourPlanDate)
    )
 

union all
SELECT    B.CustomerMasterId  DoctorId,   B.CustomerCode + ' : ' + B.OwnerName  DoctorName, 'CVP' TypeName,   isnull( B.CellNo,'N/A')   AS DocContact,
        'N/A'   AS DoctorTypeName,
       'N/A'  AS ProgramTypeName,
       isnull( B.CustomerName,'N/A')  AS ChemberName
FROM    dbo.tbl_DoctorTourPlanDetail A
 LEFT JOIN dbo.tblCustMaster B ON B.CustomerMasterId = A.DoctorId
        INNER JOIN dbo.tbl_DoctorTourPlanMaster mas ON mas.DocTPMaster = A.DocTPMaster
        LEFT JOIN dbo.tbl_TourPlanPurpose tp ON tp.TPId = A.TPId
WHERE   A.EmpInfoId = @empId and A.Type_DV='C' and mas.ApprovalStatus='2'
        AND CONVERT(Date, A.TourPlanDate) = CONVERT(Date, GETDATE())  AND NOT EXISTS (
        SELECT 1
        FROM dbo.tbl_DCRInfo AS c
        WHERE c.TypeDcr = 'CVR'
          AND c.DoctorId = A.DoctorId
          AND CONVERT(date, c.DcrDate) = CONVERT(date, A.TourPlanDate)
    )

 
 

 	 UNION ALL
SELECT 0 DoctorId,  'FCB'+' :'+ cast(ISNULL(dtl.FCBAmount,0) as nvarchar(max))+ char(10)+char(13)+ 'Campaign'+' :'+ cast(ISNULL(dtl.CampaignAmount,0) as nvarchar(max)) + char(10)+char(13) +'General'+' :'+ cast(ISNULL(dtl.GeneralAmount,0) as nvarchar(max))          MName ,
        'DWSP' AS TypeName  ,   'N/A'  AS DocContact,
        'N/A'  AS DoctorTypeName,
       'N/A'  AS ProgramTypeName,
        'N/A'  AS ChemberName
 

	  from tbl_DWSPMaster mas  with (nolock)
left join tbl_DWSPDetail dtl   with (nolock) on mas.DWSPMasterId=dtl.DWSPMasterId
where  CONVERT(Date,dtl.DWSPDate)=CONVERT(Date,GETDATE() ) and mas.EmpInfoId=@empId  
	 
	   and  mas.ApprovalStatus = '2' 


end