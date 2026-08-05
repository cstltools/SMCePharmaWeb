CREATE PROCEDURE [dbo].[sp_SAP_NationalStockMaster] ---SAP Invoice
   @FrmDate nvarchar(max),
   @ToDate nvarchar(max)

AS
BEGIN

--select  top 2 isnull(O.MIOCode,'Blank') MasterId,  
--isnull(mio.SAP_MIOCode,'Blank')                        as MIOCode,	
--tr.SAP_Code                                as Territory,
--FORMAT(iv.InvoiceDate,'dd.MM.yyyy') 	       as InvoiceDt 
----,O.OrderType OrderType


--  from tblInvoice  iv with(nolock)
-- inner join tblOrder O with(nolock) on O.OrderId=  iv.OrderId
-- inner join tblMioInfo mio with(nolock) on O.MioId=  mio.MioId
-- inner join tblTerritory tr  with(nolock)  on  tr.TerritoryId=O.TerritoryId
-- --inner join tblCompanyUnit U with(nolock) on O.ComUnitId=U.ComUnitId
-- where iv.InvoiceDate between 
-- @FrmDate and @ToDate and tr.SAP_Code  is not null and mio.SAP_MIOCode  is not null
--Group by mio.SAP_MIOCode, O.MIOCode ,	tr.SAP_Code ,FORMAT(iv.InvoiceDate,'dd.MM.yyyy')  
--order by FORMAT(iv.InvoiceDate,'dd.MM.yyyy') ,isnull(O.MIOCode,'Blank') 


select distinct  0 MasterId,  
''                 as MIOCode,	
''                         as Territory,
FORMAT(iv.SalesDocDate,'dd.MM.yyyy') 	      as InvoiceDt  ,convert(date, iv.SalesDocDate )  InvoiceDtSearch 
--,O.OrderType OrderType


  from SAP_API_Data..tbl_Stock  iv with(nolock)
 
 where   FORMAT(SalesDocDate ,'dd.MM.yyyy')=FORMAT(DATEADD(DAY, -1,GETDATE()),'dd.MM.yyyy')  
order by FORMAT(iv.SalesDocDate,'dd.MM.yyyy')   


END



























 




