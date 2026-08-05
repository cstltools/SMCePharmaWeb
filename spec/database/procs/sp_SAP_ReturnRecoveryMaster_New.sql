CREATE PROCEDURE [dbo].[sp_SAP_ReturnRecoveryMaster_New] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

    select
	DISTINCT  CustomerCode MasterId,  
CustomerCode                      as MIOCode
,	
tblTerritory.SAP_Code                             as Territory
,tblRegion.SAP_Code [Zone],
tblArea.SAP_Code [Area] ,
--FORMAT(iv.SalesDocDate,'dd.MM.yyyy')
 '30.11.2024'	       as InvoiceDt 
,'ZSPH' OrderType

from
  SAP_API_Data..tbl_SAPRecoverySales iv with(nolock)

    left join tblEmpGeneralInfo on tblEmpGeneralInfo.SAPEmpCode = iv.CustomerCode 

left join tblMIOInfo on tblMIOInfo.EmployeeId = tblEmpGeneralInfo.EmpInfoId and tblMIOInfo.IsActive=1
left join tblTerritory on tblTerritory.TerritoryId = tblMIOInfo.TerritoryId and tblTerritory.IsActive=1
left join tblArea on tblArea.AreaId = tblTerritory.AreaId and tblArea.IsActive=1
left join tblRegion on tblRegion.RegionId = tblArea.RegionId and tblRegion.IsActive=1

where CustomerCode in ('EE00051410') 
  --order by CustomerCode asc

  --where SalesDocDate='2024-11-08'
  --CustomerCode = 'EE00051645' and SalesDocDate='2024-11-06'


--  EE00050639  Done
--EE00050801 Done
--EE00050809 done but problem
--EE00050812  done
--'EE00050821', 
--'EE00050845',
--'EE00050890', 
--'EE00050901',
--'EE00050911'
--EE00050970',
--EE00050993',
--EE00051008',
--EE00051085',
--EE00051137',
--EE00051161',
--EE00051164',
--EE00051169',
--EE00051336',
--EE00051344',
--EE00051380',
--EE00051403',
--EE00051406',
--EE00051410',
--EE00051413',
--EE00051487',
--EE00051498',
--EE00051534',
--EE00051554',
--EE00051557',
--EE00051583',
--EE00051590',
--EE00051602',
--EE00051611',
--EE00051625',
--EE00051633',
--EE00051635',
--EE00051636',
--EE00051639',
--EE00051641',
--EE00051662',
--EE00051663',   
--EE00051688',
--EE00051706',
--EE00051711',
--EE00051723',
--EE00051725',
--EE00051730',
--EE00051751',
--EE00051771',
--EE00051797',
--EE00051804',
--EE00051831',
--EE00051850',
--EE00051851',
--EE00051862',
--EE00051873',
--EE00051893',
--EE00051900',
--EE00051904',
--EE00051919',
--EE00051932',
--EE00052048',
--EE00052090',
--EE00052094',
--EE00052127',
--EE00052135',
--EE00052157',
--EE00052173',
--EE00052175',
--EE00052189',
--EE00052194',
--EE00052203', 
--EE00052258',
--EE00052264',
--EE00052272',
--EE00052280',
--EE00052281',
--EE00052283',
--EE00052289',
--EE00052302', done
--EE00052336',
--EE00052352',
--EE00052376',
--EE00052416',
--EE00052431',
--EE00052437',
--EE00052448',
--EE00052450',
--EE00052466',
--EE00052486',
--EE00052494',
--EE00052513',
--EE00052545',
--EE00052554',
--EE00052599',
--EE00052612',
--EE00052626',
--EE00052632',
--EE00052640', 
--EE00052651',
--EE00052672',
--EE00052714',
--EE00052720',
--EE00052721',
--EE00052727',
--EE00052730',
--EE00052734',
--EE00052737',
--EE00052747',
--EE00052757',
--EE00052762',
--EE00052765',
--EE00052766',
--EE00052768',
--EE00052775',
--EE00052778',
--EE00052789',
--EE00052790',
--EE00052794',
--EE00052804',
--EE00052810',
--EE00052824'    











  --where    
  --CAST(SalesDocDate AS DATE) = CAST(GETDATE() - 1 AS DATE)
 --     FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 --FORMAT(DATEADD(DAY, -1,GETDATE()),'24.10.2024')  and CustomerCode='EE00051645' and plant='2033'

   --and isDemo=1 


END



























 




