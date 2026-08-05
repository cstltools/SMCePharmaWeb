-- =============================================
-- =============================================
CREATE PROCEDURE [dbo].[sp_NumberofInvoiceandCust] 

@fromdate datetime,
@todate datetime
AS
BEGIN


--BSP ,Blue Star

--declare @fromdate  datetime='1/1/2020'
--declare	@todate datetime='1/31/2020'


declare  @A decimal=0
declare  @B decimal=0
declare  @C decimal=0
declare  @D decimal=0

declare  @E decimal=0
declare  @F decimal=0
declare  @G decimal=0
declare  @H decimal=0


select @B= Count ( distinct  tblInvoice.CustomerMasterId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where tblOrder.ProgramTypeId=2 and (InvoiceDate between @fromdate and @todate)


select  @F=Count ( InvoiceId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where tblOrder.ProgramTypeId=2 and (InvoiceDate between @fromdate and @todate)


	
--select @E+@F+@G+@H as BSPInvoice



--Green 
declare  @AG decimal=0
declare  @BG decimal=0
declare  @CG decimal=0
declare  @DG decimal=0

select @AG= Count ( distinct  tblInvoice.CustomerMasterId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where tblOrder.ProgramTypeId=1  and (InvoiceDate between @fromdate and @todate )
  


  

select  @CG=Count ( InvoiceId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where tblOrder.ProgramTypeId=1  and (InvoiceDate between @fromdate and @todate )
 




--Other 
declare  @AGO decimal=0
declare  @BGO decimal=0
declare  @CGO decimal=0
declare  @DGO decimal=0

select @AGO= Count ( distinct  tblInvoice.CustomerMasterId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where (tblOrder.ProgramTypeId=3    or tblOrder.ProgramTypeId=4  )  and (InvoiceDate between @fromdate and @todate )
  

select  @CGO=Count ( InvoiceId) 
from tblInvoice 
inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
where (tblOrder.ProgramTypeId=3    or tblOrder.ProgramTypeId=4  )  and (InvoiceDate between @fromdate and @todate )
 



 --Prescription

declare  @P_BlueStar decimal=0
declare  @P_GreenStar decimal=0
declare  @P_PinkStar decimal=0
declare  @P_OtherStar decimal=0



   select  @P_BlueStar=Count ( PrescriptionId) 
from tbl_PrescriptionMaster 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_PrescriptionMaster.DoctorId
where (DoctorProgramypeId=2   )  and (PrescriptionDate between @fromdate and @todate ) and ApprovalStatus=2

   select  @P_GreenStar=Count ( PrescriptionId) 
from tbl_PrescriptionMaster 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_PrescriptionMaster.DoctorId
where (DoctorProgramypeId=1   )  and (PrescriptionDate between @fromdate and @todate ) and ApprovalStatus=2

select  @P_PinkStar=Count ( PrescriptionId) 
from tbl_PrescriptionMaster 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_PrescriptionMaster.DoctorId
where (DoctorProgramypeId=3   )  and (PrescriptionDate between @fromdate and @todate ) and ApprovalStatus=2


select  @P_OtherStar=Count ( PrescriptionId) 
from tbl_PrescriptionMaster 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_PrescriptionMaster.DoctorId
where (DoctorProgramypeId=4   )  and (PrescriptionDate between @fromdate and @todate ) and ApprovalStatus=2




	  
----DCR
 -- select * from tbl_DCRInfo
declare  @D_BlueStar decimal=0
declare  @D_GreenStar decimal=0
declare  @D_PinkStar decimal=0
declare  @D_OtherStar decimal=0


--select * from tbl_DCRInfo

   select  @D_BlueStar=Count ( dcrid) 
from tbl_DCRInfo 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_DCRInfo.DoctorId
where (DoctorProgramypeId=2   )  and (tbl_DCRInfo.dcrdate between @fromdate and @todate ) and ApprovalStatus=2



   select  @D_GreenStar=Count ( dcrid) 
from tbl_DCRInfo 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_DCRInfo.DoctorId
where (DoctorProgramypeId=1   )  and (tbl_DCRInfo.dcrdate between @fromdate and @todate ) and ApprovalStatus=2



   select  @D_PinkStar=Count ( dcrid) 
from tbl_DCRInfo 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_DCRInfo.DoctorId
where (DoctorProgramypeId=3   )  and (tbl_DCRInfo.dcrdate between @fromdate and @todate ) and ApprovalStatus=2



   select  @D_OtherStar=Count ( dcrid) 
from tbl_DCRInfo 
--inner join tblDoctorMaster on tblDoctorMaster.DoctorId=tbl_DCRInfo.DoctorId
where (DoctorProgramypeId=4   or DoctorProgramypeId=5 )  and (tbl_DCRInfo.dcrdate between @fromdate and @todate ) and ApprovalStatus=2
  
----Total
select @A+@B+@C+@D as BSPCustomer,@E+@F+@G+@H as BSPInvoice,@AG+@BG as Greencustomer,@CG+@DG as GreenInvoice,@AGO+@BGO as 
Othercustomer,@CGO+@DGO as OtherInvoice,

@P_BlueStar as P_BlueStar, @P_GreenStar as P_GreenStar, @P_PinkStar as P_PinkStar,  @P_OtherStar as P_OtherStar ,

@D_BlueStar  as D_BlueStar, @D_GreenStar as D_GreenStar, @D_PinkStar as D_PinkStar,   @D_OtherStar as D_OtherStar
	


	--select * from tblProgramType
	--select * from tblDoctorMaster
	 --select * from tbl_PrescriptionMaster
	

--   select  @P_BlueStar=Count ( InvoiceId) 
--from tblInvoice 
--inner join tblOrder on tblInvoice.OrderId=tblOrder.OrderId
--where (tblOrder.ProgramTypeId=3    or tblOrder.ProgramTypeId=4  )  and (InvoiceDate between @fromdate and @todate )
 

	
END
