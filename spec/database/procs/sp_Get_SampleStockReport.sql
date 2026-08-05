
CREATE PROCEDURE [dbo].[sp_Get_SampleStockReport]
	-- Add the parameters for the stored procedure here
		@EmpId NVARCHAR(max),
		@Month NVARCHAR(max),
		@Year NVARCHAR(max)
AS
BEGIN
   
 
select emp.EmpMasterCode+' : '+emp.EmpName EmpName,  pro.ProductCode+' : '+pro.ProductName ProductName,ISNULL(tblOpen.OpeningQty,0) OpeningQty,ISNULL(SUM(mas.Qty),0) as Allocate,ISNULL(tblDCR.UsedQty,0) as Used, ISNULL(((ISNULL(tblOpen.OpeningQty,0)+ISNULL(SUM(mas.Qty),0))-ISNULL(tblDCR.UsedQty,0)),0) as ClosingQty  from tblGroupWisePromoQty mas with (nolock)
left join tblProduct pro  with (nolock) on  mas.ProductId=pro.ProductId
left join tblEmpGeneralInfo emp  with (nolock) on  mas.EmpInfoId=emp.EmpInfoId

left join ( select  EmpInfoId, ProductId, SUM(TransactionQTY) OpeningQty from tblGroupWisePromoQty_OpeningBalanceProcess where  DATENAME(month,ProcessDate)=CONVERT(nvarchar(max),@Month) and  year(ProcessDate)=CONVERT(nvarchar(max),@Year) group by EmpInfoId,ProductId)tblOpen on tblOpen.EmpInfoId=mas.EmpInfoId and tblOpen.ProductId=mas.ProductId

left join ( select  dtl.EmpInfoId,  dtl.ProductId,SUM(dtl.ProductQty) UsedQty from tbl_DcrDetails dtl
inner join tbl_DCRInfo dcr on dcr.DcrId=dtl.DcrId
 where  ApprovalStatus<>3 and DATENAME(month,dcr.DcrDate)=CONVERT(nvarchar(max),@Month) and  year(dcr.DcrDate)=CONVERT(nvarchar(max),@Year) group by EmpInfoId,dtl.ProductId)tblDCR on tblDCR.EmpInfoId=mas.EmpInfoId  and tblDCR.ProductId=mas.ProductId

where Year=CONVERT(nvarchar(max),@Year) and Month=CONVERT(nvarchar(max),@Month) and mas.EmpInfoId=CONVERT(nvarchar(max),@EmpId)  --and tblDCR.ProductId=mas.ProductId

group by emp.EmpMasterCode,emp.EmpName ,  pro.ProductCode,pro.ProductName  ,tblOpen.OpeningQty,tblDCR.UsedQty


 

 end