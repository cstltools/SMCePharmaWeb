CREATE PROCEDURE [dbo].[sp_SAP_ExpiryReturn_New] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

--    select DISTINCT  CustomerCode MasterId,  
--CustomerCode                      as MIOCode,	
--Territory                             as Territory, Zone [Zone],  Area [Area] ,
--FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	       as InvoiceDt 
----,O.OrderType OrderType 
--,OrderType OrderType
--select * from tblCompanyUnit
--from
--  SAP_API_Data..tbl_ExpiryReturn iv with(nolock)
-- where     FORMAT(SalesDocDate ,'dd.MM.yyyy')=
-- FORMAT(DATEADD(DAY, -1,GETDATE()),'30.12.2025') 

  select DISTINCT   Plant                   as MasterId,  
                      Plant                   as MIOCode,	
                      '401'                   as Territory,
                      '000001'                as [Zone],  
                      '3000'                  as [Area] ,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	      as InvoiceDt, 
--'31-oct-2025'	      as InvoiceDt, 


OrderType                                    as OrderType
  
from
  SAP_API_Data..tbl_ExpiryReturn iv with(nolock)
 where     FORMAT(SalesDocDate ,'dd.MM.yyyy')=
 FORMAT(DATEADD(DAY, -1,GETDATE()),'30.06.2026')  
 and Plant='2040'

END

--  select * from tblCompanyUnit


























 




