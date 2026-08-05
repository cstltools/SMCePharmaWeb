CREATE PROCEDURE [dbo].[sp_Get_DashboardTopBarData] 
	-- Add the parameters for the stored procedure here
   
   
AS
    BEGIN
	
	declare  @currentDate DATETIME

	declare  @PrviousDay DATETIME
	declare  @Prvious7Days DATETIME




set	@currentDate=getdate()
set	@PrviousDay=getdate()-1
set	@Prvious7Days=getdate()-7

 
  
	
        DECLARE @weekStartDate DATETIME ,
            @weekEndDate DATETIME
        DECLARE @month INT ,
            @year INT

        SET DATEFIRST 6
        SET @weekStartDate = DATEADD(DAY, 1 - DATEPART(dw, @currentDate),
                                     @currentDate)
        SET @weekEndDate = DATEADD(DAY, 7 - DATEPART(dw, @currentDate),
                                   @currentDate);

        SET @year = DATEPART(yy, @currentDate)
        SET @month = DATEPART(MM, @currentDate)



      


        DECLARE @puninTime NVARCHAR(50) ,
            @weeklyAmount NVARCHAR(50) ,
            @monthlyAmount NVARCHAR(50) ,
            @orderCountToday NVARCHAR(50),
			  @orderTodyAmt NVARCHAR(50),
			   @productTotal NVARCHAR(50),
			   @TotalOrder NVARCHAR(50),
			   @totalDcr NVARCHAR(50),
			   @totalDcrGMP NVARCHAR(50),
			   @totalDcrNonGMP NVARCHAR(50),
			   @totalInvoice NVARCHAR(50),
			   @totalDelivery NVARCHAR(50),
			   @totalPayment NVARCHAR(50),
			   @TotalRejection NVARCHAR(50),
			   @TotalOrderPer NVARCHAR(50),
			   @TotalInvoicerPer NVARCHAR(50),
			  
			   @TotalRX NVARCHAR(50),
			   @TotalRXGMP NVARCHAR(50),
			   @TotalRXNONGMP NVARCHAR(50),
			   @TotalAttandence NVARCHAR(50),
			   @TotalAttandenceOut NVARCHAR(50),
			   @totalCustomerCoverage NVARCHAR(50),
			   @TotalLeave NVARCHAR(50),
			   @TotalDCRNew NVARCHAR(50)
			  










        SELECT  @puninTime = ISNULL(PunchInTime, 0)
        FROM    dbo.tblMarketAttendance_Master_webapi  with (nolock)
        WHERE     convert(Date,AttendanceDate) = convert(Date,@currentDate)


        SELECT  @weeklyAmount = SUM(B.DeliveryNetAmount)
        FROM    dbo.tblInvoice A   with (nolock)
                INNER JOIN dbo.tblInvoiceDetail B   with (nolock) ON B.InvoiceId = A.InvoiceId
                INNER JOIN dbo.tblOrder C  with (nolock) ON C.OrderId = A.OrderId
        WHERE    DelivaryInvoiceNo IS NOT NULL
                AND DeliveryInvoiceStatus != 'Reject'
                AND A.UpdateDate BETWEEN @weekStartDate
                                 AND     @weekEndDate



       
        SELECT  @monthlyAmount = SUM(B.DeliveryNetAmount)
        FROM    dbo.tblInvoice A  with (nolock)
                INNER JOIN dbo.tblInvoiceDetail B  with (nolock) ON B.InvoiceId = A.InvoiceId
                INNER JOIN dbo.tblOrder C   with (nolock) ON C.OrderId = A.OrderId
        WHERE    DelivaryInvoiceNo IS NOT NULL
                AND DeliveryInvoiceStatus != 'Reject'
                AND DATEPART(yy, SubmissionDate) = @year
                AND DATEPART(MM, SubmissionDate) = @month



        SELECT  @orderCountToday = COUNT(*)
        FROM    dbo.tblOrder  with (nolock)
        WHERE tblOrder.ActionStatus<>'3' and      convert(Date,SubmissionDate) =convert(Date, @currentDate)
               


		SELECT  @orderTodyAmt = SUM(B.DeliveryNetAmount)
        FROM    dbo.tblInvoice A  with (nolock)
                INNER JOIN dbo.tblInvoiceDetail B  with (nolock) ON B.InvoiceId = A.InvoiceId
                INNER JOIN dbo.tblOrder C  with (nolock) ON C.OrderId = A.OrderId
        WHERE     DelivaryInvoiceNo IS NOT NULL
                AND DeliveryInvoiceStatus != 'Reject'
                AND convert(Date,SubmissionDate) = convert(Date,@currentDate)



		SELECT  @orderTodyAmt = SUM(A.GrossValue)
        FROM    dbo.tblOrder A    with (nolock)
        WHERE   A.ActionStatus<>'3' and convert(Date,SubmissionDate) = convert(Date,@currentDate)
                
				AND A.OrderType ='Regular'

				--select * from tblOrder
				--inner join tblOrderDetail on tblOrder.OrderId=tblOrderDetail.OrderId
				--where SubmissionDate='8-aug-2021'

		 SELECT  @productTotal = sum( B.Quantity)
        FROM    dbo.tblOrder A   with (nolock)
		INNER JOIN dbo.tblOrderDetail  B  with (nolock) ON B.OrderId = A.OrderId
        WHERE   convert(Date,A.SubmissionDate) = convert(Date,@currentDate)
               
				AND A.OrderType ='Regular'


		
		SELECT @totalDcrGMP = ISNULL(COUNT(*),0) FROM dbo.tbl_DCRInfo  with (nolock)
		inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId WHERE tblDoctorMaster.DoctorTypeId=2 and tbl_DCRInfo.ApprovalStatus<>'3' and  convert(Date,DcrDate) = convert(Date,@currentDate)  
		SELECT @totalDcr = ISNULL(COUNT(*),0) FROM dbo.tbl_DCRInfo  with (nolock)
		 where tbl_DCRInfo.ApprovalStatus<>'3' and  convert(Date,DcrDate) = convert(Date,@currentDate) 

			SELECT @totalDcrNonGMP = ISNULL(COUNT(*),0) FROM dbo.tbl_DCRInfo  with (nolock)
		inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_DCRInfo.DoctorId WHERE tblDoctorMaster.DoctorTypeId=1 and tbl_DCRInfo.ApprovalStatus<>'3' and  convert(Date,DcrDate) = convert(Date,@currentDate)  

		 

		SELECT @TotalRX = ISNULL(COUNT(*),0) FROM dbo.tbl_PrescriptionMaster  with (nolock)   WHERE  tbl_PrescriptionMaster.ApprovalStatus<>'3' and  convert(Date,PrescriptionDate) = convert(Date,@currentDate)  

		
		SELECT @TotalRXGMP = ISNULL(COUNT(*),0) FROM dbo.tbl_PrescriptionMaster  with (nolock) inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId WHERE tblDoctorMaster.DoctorTypeId=2 and tbl_PrescriptionMaster.ApprovalStatus<>'3' and  convert(Date,PrescriptionDate) = convert(Date,@currentDate)  

				SELECT @TotalRXNONGMP = ISNULL(COUNT(*),0) FROM dbo.tbl_PrescriptionMaster  with (nolock) inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=dbo.tbl_PrescriptionMaster.DoctorId WHERE tblDoctorMaster.DoctorTypeId=1 and tblDoctorMaster.ApprovalStatus<>'3' and  convert(Date,PrescriptionDate) = convert(Date,@currentDate)  


		 	SELECT @TotalAttandence = ISNULL(COUNT(*),0) FROM tblMarketAttendance_Master_webapi  with (nolock) WHERE  tblMarketAttendance_Master_webapi.AttType=1 and tblMarketAttendance_Master_webapi.ApprovalStatus<>'3' and convert(Date,AttendanceDate) = convert(Date,@currentDate) 
			
			 	SELECT @TotalAttandenceOut = ISNULL(COUNT(*),0) FROM tblMarketAttendance_Master_webapi  with (nolock) WHERE  tblMarketAttendance_Master_webapi.AttType=2 and tblMarketAttendance_Master_webapi.ApprovalStatus<>'3' and convert(Date,AttendanceDate) = convert(Date,@currentDate)  
 

			
			   

			    	SELECT   @totalCustomerCoverage = ISNULL(COUNT( distinct CustomerMasterId ),0) FROM tblOrder  with (nolock)   WHERE convert(Date,SubmissionDate) = convert(Date,@currentDate)  

			   --@totalCustomerCoverage NVARCHAR(50),
			   --@TotalLeave NVARCHAR(50),

			   SELECT   @TotalLeave = ISNULL(COUNT( * ),0) FROM Employee_LeaveApplications  with (nolock) WHERE ApprovalStatus<>'3' and   convert(Date,@currentDate) between    convert(Date,LeaveFromDate) and convert(Date,LeaveToDate)


		 SELECT  @TotalOrder =ISNULL(sum(A.GrossValue-A.TotalDiscount),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE    A.ActionStatus<>'3' and convert(Date,A.SubmissionDate) = convert(Date,@currentDate)
		      
 

			 SELECT   @totalInvoice = ISNULL(sum(ID.TotalPrice-ID.DiscountAmount),0)
        FROM    dbo.tblInvoice A  with (nolock)
		 INNER JOIN dbo.tblInvoiceDetail ID  with(nolock) ON ID.InvoiceId = A.InvoiceId
        WHERE   convert(Date,A.InvoiceDate) = convert(Date,@currentDate)

		 
		 SELECT  @totalDelivery = sum((isnull(custDtl.TPAmount,0)))   
 
  
FROM tblCustPayDetail custDtl   with(nolock)
 
--INNER JOIN dbo.tblInvoice I   ON I.InvoiceId = custDtl.InvoiceId
 
 where      	  convert(date,custDtl.custPaymentDate)= convert(Date,@currentDate)
--and ((isnull(custDtl.PaymentAmount,0))) >0  and FinalPaymentNo is not null and  I.PaymentStatus  IN ('Full','Partial')  
   
			
		 
        
               
--		select @TotalRejection=isnull(sum((ordDtl.Quantity- ord.Quantity)*ord.UnitPrice) ,0) from dbo.tblInvoiceDetail ord  with (nolock)
--left join tblOrderDetail ordDtl  with (nolock) on ord.OrderDetailsId=ordDtl.OrderDetailId
--left JOIN dbo.tblInvoice invm WITH(NOLOCK) ON invm.InvoiceId = ord.InvoiceId
--left JOIN dbo.tblOrder o WITH(NOLOCK) ON o.OrderId = ordDtl.OrderId
--where  IsInvoice=1 and convert(Date,invm.InvoiceDate) = convert(Date,@currentDate)	 
----ordDtl.Status='Undelivered'	 and 



--SELECT  @TotalRejection=isnull(sum( D.TotalTradePrice),0)    
--                        FROM dbo.tblOrder O   with (nolock)
--                        INNER JOIN dbo.tblOrderDetail D   with (nolock) ON O.OrderId = D.OrderId
--					   left JOIN dbo.tblInvoice  I  with (nolock)  ON O.OrderCode = I.OrderNo
--                        WHERE Status='Undelivered' AND I.InvoiceNo IS NOT NULL and   convert(Date,i.InvoiceDate) = convert(Date,@currentDate)

Declare @RejectGrossAmt decimal (18,2)=0
Declare @PartialRejectGrossAmt decimal (18,2)=0
Declare @TotalRejectGrossAmt decimal (18,2)=0



SELECT  @RejectGrossAmt= SUM(ISNULL(D.TotalPrice,0) - ISNULL(D.DiscountAmount,0))
 --@RejectGrossAmt= ISNULL(SUM(D.NetAmount - D.TotalPriceVatAmount) + SUM(D.TotalPriceVatAmount),0)  

FROM dbo.tblRejectionInvoiceMaster rejMas  WITH (NOLOCK)  INNER JOIN dbo.tblRejectionInvoiceDetail D WITH (NOLOCK) ON rejMas.InvoiceId = D.InvoiceId   
WHERE   convert(Date,RejectionDate) =convert(Date,@currentDate)



SELECT  @PartialRejectGrossAmt=SUM(ID.TotalPrice-ID.DeliveryTotalPrice)-SUM(ID.DiscountAmount-ID.DeliveryDiscountAmount) 
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblOrder mas   WITH (NOLOCK)  ON mas.OrderId = I.OrderId
 
INNER JOIN dbo.tblInvoiceDetail ID   WITH (NOLOCK)  ON ID.InvoiceId = I.InvoiceId 
 
where RejectionSts is null  and convert(Date,I.UpdateDate) =convert(Date,@currentDate) and DelivaryInvoiceNo is not null and ID.DeliveryStatus IN ('Reject','Partial')
set @TotalRejectGrossAmt =@RejectGrossAmt+@PartialRejectGrossAmt

set @TotalRejection =@TotalRejectGrossAmt



declare @TotalOrderAVG decimal
 SELECT  @TotalOrderAVG =ISNULL(avg(A.TotalNetPayable),0)
        FROM    dbo.tblOrder A   with (nolock)
		 
        WHERE   convert(Date,A.SubmissionDate) between  convert(Date, @Prvious7Days) and convert(Date,@PrviousDay) 

		set @TotalOrderPer=0  --cast (((@TotalOrder - @TotalOrderAVG)/((@TotalOrder + @TotalOrderAVG)/2) )*100 as decimal(18,2))

declare @totalInvoiceAVG decimal


		SELECT    @totalInvoiceAVG=ISNULL(avg(A.TpGrandTotal),0)
        FROM    dbo.tblInvoice A  with (nolock)
		 
        WHERE   convert(Date,A.InvoiceDate) between  convert(Date, @Prvious7Days) and convert(Date,@PrviousDay) 


		
		set @TotalInvoicerPer= 0 --cast (((@totalInvoiceAVG - @totalInvoice)/((@totalInvoiceAVG + @totalInvoice)/2) )*100 as decimal(18,2))



		 
		 

        SELECT  ISNULL(@puninTime, 0) AS PunchInTime ,
                ISNULL(@weeklyAmount, 0) AS WeeklySaleAmount ,
                ISNULL(@monthlyAmount, 0) AS MonthlySaleAmount ,
                ISNULL(@orderCountToday, 0) AS OrderSubmitedToday,
				ISNULL(@orderTodyAmt, 0) AS OrderTodayAmt,
				---0 AS OrderTodayAmt,
				ISNULL(@productTotal, 0) AS ProductTotalOrder,
				ISNULL(@TotalDcr, 0) AS TotalDcr,
				ISNULL('('+ISNULL('GMP: '+ @totalDcrGMP,0)+' ' + ISNULL('NGMP: '+@totalDcrNonGMP,0)+')','') AS TotalDcrType,
				ISNULL(@TotalOrder,0) AS  TotalOrder,
				---0 AS  TotalOrder,
				---0 AS  totalInvoice,
				ISNULL(@totalInvoice,0) AS  totalInvoice,
				 ISNULL(@totalDelivery,0) AS
				  totalDelivery,
				ISNULL(@orderCountToday,0) AS   totalPayment,
				ISNULL(@TotalRejection,0) AS    TotalRejection,
				ISNULL(@TotalOrderPer,0) AS     TotalOrderPer,
				ISNULL(@TotalInvoicerPer,0) AS      TotalInvoicerPer,
				ISNULL(@TotalRX,0) AS      TotalRX,
			 
			 
			 	ISNULL('('+ISNULL('GMP: '+ @TotalRXGMP,0)+' ' + ISNULL('NGMP: '+@TotalRXNONGMP,0)+')','')
				  AS       TotalRXType,
				  
			 
				 	ISNULL('IN: '+ @TotalAttandence,0)+'  ' + ISNULL('OUT: '+@TotalAttandenceOut,0)
				   TotalAttandence,
				ISNULL(@totalCustomerCoverage,0) AS        totalCustomerCoverage,
				ISNULL(@TotalLeave,0) AS        TotalLeave 

				 





			







    END