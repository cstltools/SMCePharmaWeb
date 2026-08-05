CREATE PROCEDURE [dbo].[sp_WebAPI_Get_MioDashboardTopBarDataWithoutOrd_Att] 
	-- Add the parameters for the stored procedure here
    @empId INT ,
    @currentDate DATETIME
AS
    BEGIN
	set	@currentDate=getdate()
	DECLARE @userId int
	SELECT @userId = UserId FROM dbo.tblUser WHERE EmpInfoId = @empId


	
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



        DECLARE @mioCode NVARCHAR(50)
        SELECT  @mioCode = A.EmpMasterCode
        FROM    dbo.tblEmpGeneralInfo A
        WHERE   A.EmpInfoId = @empId 



        DECLARE  
			   @productTotal NVARCHAR(50),
			   @totalDcr NVARCHAR(50),
			   @totalPrescription NVARCHAR(50),		
			   @totalvsp NVARCHAR(50),

			    @TotalRXGMP NVARCHAR(50),
			   @TotalRXNONGMP NVARCHAR(50),
			    @totalDcrGMP NVARCHAR(50), 

			   @totalDcrNonGMP NVARCHAR(50),

			  @Colection NVARCHAR(50),
			  @Bonus  NVARCHAR(50) ,
			  @Gift NVARCHAR(50) ,


			  @ColectionTpVat  NVARCHAR(50)

 

		--SELECT  @orderTodyAmt = SUM(B.DeliveryNetAmount)
  --      FROM    dbo.tblInvoice A
  --              INNER JOIN dbo.tblInvoiceDetail B ON B.InvoiceId = A.InvoiceId
  --              INNER JOIN dbo.tblOrder C ON C.OrderId = A.OrderId
  --      WHERE   C.MIOCode = @mioCode
  --              AND DelivaryInvoiceNo IS NOT NULL
  --              AND DeliveryInvoiceStatus != 'Reject'
  --              AND convert(Date,SubmissionDate) = convert(Date,@currentDate)

--  	SELECT   @totalCustomerCoverage = ISNULL(COUNT( distinct D.CustomerMasterId ),0) FROM tblOrder D with (nolock)  
--	 left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--	 WHERE  convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

	 

				--select * from tblOrder
				--inner join tblOrderDetail on tblOrder.OrderId=tblOrderDetail.OrderId
				--where SubmissionDate='8-aug-2021'

		 SELECT  @productTotal = isnull(sum( B.Quantity),0)
        FROM    dbo.tblOrder D with (nolock) 
		INNER JOIN dbo.tblOrderDetail B ON B.OrderId = D.OrderId
		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
      WHERE   convert(Date,D.SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		
		SELECT @totalDcr = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


	  	SELECT @totalDcrGMP = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
		 inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId  
		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 



	  	SELECT @totalDcrNonGMP = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
		 inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId  
		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		 
		SELECT @totalPrescription = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
		  WHERE   convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		  
		SELECT @totalvsp = isnull(COUNT(distinct mas.EmpInfoId),0)  FROM dbo.tbl_DoctorTourPlanDetail D with (nolock) 
		 left join tbl_DoctorTourPlanMaster mas with (nolock) on D.DocTPMaster=mas.DocTPMaster
		 
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=D.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
		  WHERE   convert(Date,D.TourPlanDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 



		  SELECT @TotalRXGMP = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
		  inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId   
		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs   with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
		  WHERE  tblDoctorMaster.DoctorTypeId=2 and convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

		  SELECT @TotalRXNONGMP = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
		  inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId   
		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
		  WHERE   tblDoctorMaster.DoctorTypeId=1 and convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		 
		  	SELECT  @Colection =  sum((isnull(custDtl.TPAmount,0)))   , @ColectionTpVat =isnull( sum((isnull(custDtl.TPAmount,0)))+ sum((isnull(custDtl.VatAmount,0))) ,0)  
 
  
FROM tblCustPayDetail custDtl   with(nolock)
 
INNER JOIN dbo.tblInvoice I   ON I.InvoiceId = custDtl.InvoiceId
INNER JOIN dbo.tblCustMaster cusmas ON I.CustomerMasterId = cusmas.CustomerMasterId
INNER JOIN dbo.tblMarket mr ON mr.MarketId = cusmas.MarketId
INNER JOIN dbo.tblSubTerritory st ON st.SubTerritoryId = mr.SubTerritoryId
 



 
 inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on st.TerritoryId=fs.TerritoryId
 

 where      	( fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId)  and convert(date,custDtl.custPaymentDate)= convert(Date,@currentDate)
and ((isnull(custDtl.PaymentAmount,0))) >0  and FinalPaymentNo is not null 
   
			
		 --
			
			




 SELECT    @Gift= ISNULL(sum(tblGift.GivtQty),0) , @Bonus = ISNULL(sum(tblB.BounsQty),0)    from dbo.tblOrder D with (nolock)
 
  left JOIN  tblInvoice ID ON ID.OrderID = D.OrderID 
    left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId

left JOIN (select OrderID, sum(Quantity) GivtQty   from tblOrderDetail m  with (nolock)
inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
 where    TotalTradePrice=0   and pro.ProductGroupId=3 group by OrderID) tblGift on   D.OrderID = tblGift.OrderID 

left JOIN (select OrderID, sum(Quantity) BounsQty   from tblOrderDetail m  with (nolock)
inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
 where   TotalTradePrice=0   and pro.ProductGroupId=1 group by OrderID) tblB on   D.OrderID = tblB.OrderID 
  
 

 where       	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId)  and   convert(Date,D.SubmissionDate)= convert(Date,@currentDate)







        SELECT  
				 
				ISNULL(@totalvsp, 0) AS  totalvsp,				ISNULL(@productTotal, 0) AS ProductTotalOrder,

			 
					'Total: '+ISNULL(@totalDcr,0)+ CHAR(10) +	ISNULL(' ('+ISNULL('GMP: '+ @totalDcrGMP,0)+' ' + ISNULL('NGMP: '+@totalDcrNonGMP,0)+')','')
				 AS TotalDcr,
				'Total: '+ISNULL(@totalPrescription,0)+ CHAR(10) +	ISNULL(' ('+ISNULL('GMP: '+ @TotalRXGMP,0)+' ' + ISNULL('NGMP: '+@TotalRXNONGMP,0)+')','')
				 AS TotalPrescription,     isnull('TP: '+@Colection,'No Record Yet')+ CHAR(10)   +CHAR(13)   +isnull('Net Payment: '+ @ColectionTpVat,'')  Colection  ,  'B: '+@Bonus + CHAR(10) +	'G: '+@Gift  BonusGift 
				
    --    SELECT  'will be available soon' AS PunchInTime ,
    --            ---ISNULL(@weeklyAmount, 0) AS WeeklySaleAmount ,
				--0 AS WeeklySaleAmount ,
    --            --ISNULL(@monthlyAmount, 0) AS MonthlySaleAmount ,
				--0 AS MonthlySaleAmount ,
				--'will be available soon'  AS OrderSubmitedToday,
				--'will be available soon' AS OrderTodayAmt,
				--'will be available soon' AS ProductTotalOrder,
			 
				--	'will be available soon'
				-- AS TotalDcr,
				--'will be available soon'
				-- AS TotalPrescription,     'will be available soon'  BonusGift 
			







    END