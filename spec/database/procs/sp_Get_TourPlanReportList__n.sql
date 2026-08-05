 CREATE PROCEDURE [dbo].[sp_Get_TourPlanReportList__n]
	-- Add the parameters for the stored procedure here
		@EmpInfoId int,
		@Month int,
		@Year int
AS
BEGIN
   
   declare @PostingPlace nvarchar(100)='', @PostingPlaceCode nvarchar(100)='', @Zone nvarchar(100)='', @UserType nvarchar(max)
   
    SELECT  @UserType= uType.RoleType
    FROM dbo.tblUser usr    with (nolock)
	 INNER JOIN dbo.tblEmpGeneralInfo emp    with (nolock) ON usr.EmpInfoId =emp.EmpInfoId
	 left JOIN dbo.tbl_UserRoleInfo urole    with (nolock) ON urole.UserRoleID =usr.UserRoleID
	 left JOIN dbo.tblRoleType uType    with (nolock) ON urole.RoleTypeId =uType.RoleTypeId


    WHERE usr.EmpInfoId = @EmpInfoId;

	if(@UserType='MIO')
	begin
	select @PostingPlace=dtl.TerritoryName,@PostingPlaceCode=dtl.TerritoryCode_TP,  @Zone=RegionName from tbl_TourPlanInfo dtl  where   dtl.EmpInfoId=@EmpInfoId AND month(dtl.TourPlanDate)=@Month AND year(dtl.TourPlanDate)=@Year
	end
 


 
	if(@UserType='AM')
	begin
	select @PostingPlace=dtl.AreaName,@PostingPlaceCode=dtl.AreaCode_TP,  @Zone=RegionName from tbl_TourPlanInfo dtl  where   dtl.EmpInfoId=@EmpInfoId AND month(dtl.TourPlanDate)=@Month AND year(dtl.TourPlanDate)=@Year
	end
 

 
 
	if(@UserType='DZSM')
	begin
	select @PostingPlace=dtl.RegionName,@PostingPlaceCode=dtl.RegionCode_TP,  @Zone=RegionName from tbl_TourPlanInfo dtl  where   dtl.EmpInfoId=@EmpInfoId AND month(dtl.TourPlanDate)=@Month AND year(dtl.TourPlanDate)=@Year
	end

	   declare @ApproveDate nvarchar(100)='', @ApprovalLog nvarchar(100)='', @CreateBy nvarchar(100)='', @EntryDate nvarchar(max)
   
	
SELECT  distinct  @ApproveDate= tblappDate.Info    , @ApprovalLog= tblapp.Info , @CreateBy= dtl.EmpName   , @EntryDate= format(min(dtlT.CreatedDate),'dd-MMM-yyyy hh:mm tt') 
FROM 
     dbo.tbl_TourPlanMaster mas  WITH (NOLOCK) 
    inner JOIN dbo.tblEmpGeneralInfo dtl   WITH (NOLOCK) ON dtl.EmpInfoId = mas.EmpInfoId
 
    inner JOIN tbl_TourPlanInfo  dtlT  WITH (NOLOCK)  ON dtlT.TPMaster = mas.TPMaster 

	 left join (SELECT tblt.TableId, tblt.Info Info  FROM (SELECT 
   SS.TableId, 
   (SELECT  case when US.Status='Rejected' then  empUserapp.EmpName +    ISNULL(' [Rejected Remarks: '+isnull(US.Comments,'')+']','') else  empUserapp.EmpName end
    FROM dbo.tblTourPlanApprovalLog US  with (nolock)
	 
	left JOIN dbo.tblEmpGeneralInfo empUserapp  with (nolock) ON empUserapp.EmpInfoId=US.EntryByApp



    WHERE US.TableId = SS.TableId and (US.Status='Rejected' or US.Status='Accepted')
    FOR XML PATH('')) [Info]
FROM dbo.tblTourPlanApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblapp on tblapp.TableId=mas.TPMaster


left join (SELECT tblt.TableId,  tblt.Info Info  FROM (SELECT 
   SS.TableId, 
   (SELECT  format(isnull(US.Date,US.EntryDateS),'dd-MMM-yyyy hh:mm tt')  
    FROM dbo.tblTourPlanApprovalLog US  with (nolock)
	 
	 

    WHERE US.TableId = SS.TableId and (US.Status='Rejected' or US.Status='Accepted')
    FOR XML PATH('')) [Info]
FROM dbo.tblTourPlanApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblappDate on tblappDate.TableId=mas.TPMaster
 
	
WHERE convert(date, dtlT.TourPlanDate) is not null     AND dtl.EmpInfoId=@EmpInfoId AND month(dtlT.TourPlanDate)=@Month AND year(dtlT.TourPlanDate)=@Year


group by tblappDate.Info    ,  tblapp.Info  , dtl.EmpName
 --case when  isnull(tblapp.Info,'') ='' then '' else 

SELECT  distinct  @ApproveDate  ApproveDate,  @ApprovalLog ApprovalLog, @CreateBy  CreateBy, 
@EntryDate EntryDate,'' UpdateBy,'' UpdateDate, dtl.EmpName, dtl.EmpMasterCode,    format(dtlT.TourPlanDate,'MMMM-yy') AS MonthYear, usr.RoleName, @PostingPlace 	PostingPlace, @PostingPlaceCode	PostingPlaceCode, @Zone Zone,
  format(dtlT.TourPlanDate,'dd')   AS Date,
    DATENAME(WEEKDAY, dtlT.TourPlanDate) AS Day,
       CONCAT(tblMor.SMarketName, 
           CASE 
               WHEN tblMor.SStarttime IS NOT NULL AND tblMor.SStarttime <> '' 
               THEN CONCAT(' at ', tblMor.SStarttime) 
               ELSE '' 
           END) AS MorningStartingPlaceTime,
       CONCAT(tblMor.EMarketName, 
           CASE 
               WHEN tblMor.EEndtime IS NOT NULL AND tblMor.EEndtime <> '' 
               THEN CONCAT(' at ', tblMor.EEndtime) 
               ELSE '' 
           END) AS MorningEndingPlaceTime,
		 tblMor.TourTypeNameM  WorkingTypesM,   WorkWithMIOM WorkWithMIOM,
    
	  REPLACE(REPLACE(isnull(tblMor.OtherVisitM,''), CHAR(13), ''), CHAR(10), ' ') MorningWorkingMarkets,
	 CONCAT(tblEve.SMarketNameE, 
           CASE 
               WHEN tblEve.SStarttimeE IS NOT NULL AND tblEve.SStarttimeE <> '' 
               THEN CONCAT(' at ', tblEve.SStarttimeE) 
               ELSE '' 
           END) AS EveningStartingPlaceTime,
       CONCAT(tblEve.EMarketNameE, 
           CASE 
               WHEN tblEve.EEndtimeE IS NOT NULL AND tblEve.EEndtimeE <> '' 
               THEN CONCAT(' at ', tblEve.EEndtimeE) 
               ELSE '' 
           END) AS EveningEndingPlaceTime,   tblEve.TourTypeNameE  WorkingTypesE,
	  	  REPLACE(REPLACE(isnull(tblEve.OtherVisitME,''), CHAR(13), ''), CHAR(10), ' ') EveningWorkingMarkets,  WorkWithMIOE WorkWithMIOE,
	 CONVERT(date,dtlT.TourPlanDate) TourPlanDate,SObjectiveM, SObjectiveE
FROM 
      dbo.tbl_TourPlanMaster mas  WITH (NOLOCK) 
    inner JOIN dbo.tblEmpGeneralInfo dtl   WITH (NOLOCK) ON dtl.EmpInfoId = mas.EmpInfoId
    LEFT JOIN dbo.tblUser us  WITH (NOLOCK)  ON us.EmpInfoId = mas.EmpInfoId
    LEFT JOIN dbo.tbl_UserRoleInfo usr  WITH (NOLOCK)  ON usr.UserRoleID = us.UserRoleID
    LEFT JOIN dbo.tblDesignation dgs  WITH (NOLOCK)  ON dgs.DesignationId = dtl.DesignationId
 
    inner JOIN tbl_TourPlanInfo  dtlT  WITH (NOLOCK)  ON dtlT.TPMaster = mas.TPMaster 

	 left join (SELECT tblt.TableId, tblt.Info Info  FROM (SELECT 
   SS.TableId, 
   (SELECT  case when US.Status='Rejected' then  empUserapp.EmpName +    ISNULL(' [Rejected Remarks: '+isnull(US.Comments,'')+']','') else  empUserapp.EmpName end
    FROM dbo.tblTourPlanApprovalLog US  with (nolock)
	 
	left JOIN dbo.tblEmpGeneralInfo empUserapp  with (nolock) ON empUserapp.EmpInfoId=US.EntryByApp

	
	 LEFT JOIN tblUser usapp  with (nolock)  ON usapp.EmpInfoId=US.EntryByApp
 left join tbl_UserRoleInfo usappEntry  with (nolock) on usappEntry.UserRoleID=usapp.UserRoleID




    WHERE US.TableId = SS.TableId and (US.Status='Rejected' or US.Status='Accepted')
    FOR XML PATH('')) [Info]
FROM dbo.tblTourPlanApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblapp on tblapp.TableId=mas.TPMaster


left join (SELECT tblt.TableId,  tblt.Info Info  FROM (SELECT 
   SS.TableId, 
   (SELECT  format(isnull(US.Date,US.dATE),'dd-MMM-yyyy hh:mm tt')  
    FROM dbo.tblTourPlanApprovalLog US  with (nolock)
	 
	 



    WHERE US.TableId = SS.TableId and (US.Status='Rejected' or US.Status='Accepted')
    FOR XML PATH('')) [Info]
FROM dbo.tblTourPlanApprovalLog SS
GROUP BY SS.TableId)AS tblt
)  tblappDate on tblappDate.TableId=mas.TPMaster
 
	  LEFT JOIN (
        SELECT tps.StationTypeName TourTypeNameM , 
            dtl.TPMaster TPMasterM, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateS ,
			  dtl.MarketName AS SMarketName,
			   dtl.Starttime AS SStarttime,
			     dtl.MarketNameEnd AS EMarketName,
				  dtl.Endtime AS EEndtime  , dtl.Objective SObjectiveM,  tt.TPName  AS STourPurpose ,
			STUFF(
    (
        SELECT 
           -- CHAR(13) + CHAR(10) + -- Add a new line before each item
            CONCAT(
               -- ROW_NUMBER() OVER (ORDER BY mgd.MarketId), -- Serial number
                ', ', 
                mm.MarketName
            )
        FROM 
            tblMarket mm WITH (NOLOCK)
        INNER JOIN 
            dbo.tblTPMarketDetail mgd ON mgd.MarketId = mm.MarketId 
        WHERE 
            mgd.TourPlanId = dtl.TourPlanId 
        ORDER BY 
            mgd.MarketId 
        FOR XML PATH ('')
    ),
    1, 2, ''
) AS OtherVisitM, ISNULL(TerritoryCode_TP+' : '+Emp.EmpName,'') WorkWithMIOM

              FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
			 LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
			  LEFT JOIN dbo.tblMIOInfo mio WITH (NOLOCK) ON mio.TerritoryId = dtl.TerritoryId and mio.Isactive=1
			  LEFT JOIN dbo.tblEmpGeneralInfo Emp WITH (NOLOCK) ON Emp.EmpInfoId = mio.EmployeeId
        WHERE 
            dtl.isMarketVisit = 1 
            AND IsMorning = 1
    ) tblMor ON tblMor.TPMasterM = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblMor.TourPlanDateS)



	

	  LEFT JOIN (
        SELECT  tps.StationTypeName  TourTypeNameE , 
            dtl.TPMaster TPMasterE, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateE ,
			  dtl.MarketName AS SMarketNameE,
			   dtl.Starttime AS SStarttimeE,
			     dtl.MarketNameEnd AS EMarketNameE,
				  dtl.Endtime AS EEndtimeE  , dtl.Objective SObjectiveE,  tt.TPName  AS STourPurposeE ,
			  STUFF(
    (
        SELECT 
           -- CHAR(13) + CHAR(10) + -- Add a new line before each item
            CONCAT(
            --    ROW_NUMBER() OVER (ORDER BY mgd.MarketId), -- Serial number
                ', ', 
                mm.MarketName
            )
        FROM 
            tblMarket mm WITH (NOLOCK)
        INNER JOIN 
            dbo.tblTPMarketDetail mgd ON mgd.MarketId = mm.MarketId 
        WHERE 
            mgd.TourPlanId = dtl.TourPlanId 
        ORDER BY 
            mgd.MarketId 
        FOR XML PATH ('')
    ),
    1, 1, ''
) AS OtherVisitME , ISNULL(TerritoryCode_TP+' : '+Emp.EmpName,'') WorkWithMIOE
   FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
		   	 LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
			  LEFT JOIN dbo.tblMIOInfo mio WITH (NOLOCK) ON mio.TerritoryId = dtl.TerritoryId and mio.Isactive=1
			  LEFT JOIN dbo.tblEmpGeneralInfo Emp WITH (NOLOCK) ON Emp.EmpInfoId = mio.EmployeeId
        WHERE 
            dtl.isMarketVisit = 1 
            AND IsEvening = 1
    ) tblEve ON tblEve.TPMasterE = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblEve.TourPlanDateE)

 


   LEFT JOIN (
        SELECT 
            dtl.TPMaster TPMasterO, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateO ,
		  tt.TPName  AS STourPurposeO  
			     FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
        WHERE 
            dtl.IsOtherVisit = 1 
            
    ) tblOther ON tblOther.TPMasterO = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblOther.TourPlanDateO)

 

 

WHERE convert(date, dtlT.TourPlanDate) is not null    AND dtl.EmpInfoId=@EmpInfoId AND month(dtlT.TourPlanDate)=@Month AND year(dtlT.TourPlanDate)=@Year

order by CONVERT(date,dtlT.TourPlanDate) asc

end