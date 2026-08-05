create PROCEDURE [dbo].[sp_WebAPI_Get_MioDashboardTopBarData_New_old] 
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



        DECLARE @puninTime NVARCHAR(50) ,
          @punOutTime NVARCHAR(50) ,
            @weeklyAmount NVARCHAR(50) ,
            @monthlyAmount NVARCHAR(50) ,
            @orderCountToday NVARCHAR(50),
			  @orderTodyAmt NVARCHAR(50),
			   @productTotal NVARCHAR(50),
			   @totalDcr NVARCHAR(50),
			   @totalPrescription NVARCHAR(50),
			    @TotalRXGMP NVARCHAR(50),
			   @TotalRXNONGMP NVARCHAR(50),
			    @totalDcrGMP NVARCHAR(50),
			   @totalCustomerCoverage NVARCHAR(50),

			   @totalDcrNonGMP NVARCHAR(50),

			  @Colection NVARCHAR(50),
			  @Bonus  NVARCHAR(50) ,
			  @Gift NVARCHAR(50) 




        SELECT  @puninTime = ISNULL(PunchInTime, 0)
        FROM    dbo.tblMarketAttendance_Master_webapi
        WHERE   EmpInfoId = @empId and AttType=1
                AND convert(Date,AttendanceDate) = convert(Date,@currentDate)


				
        SELECT  @punOutTime = ISNULL(PunchInTime, 0)
        FROM    dbo.tblMarketAttendance_Master_webapi
        WHERE   EmpInfoId = @empId and AttType=2
                AND convert(Date,AttendanceDate) = convert(Date,@currentDate)


--        SELECT  @weeklyAmount = SUM(B.DeliveryNetAmount)
--        FROM    dbo.tblInvoice A
--                INNER JOIN dbo.tblInvoiceDetail B ON B.InvoiceId = A.InvoiceId
--                INNER JOIN dbo.tblOrder C ON C.OrderId = A.OrderId
--        WHERE   C.MIOCode = @mioCode
--                AND DelivaryInvoiceNo IS NOT NULL
--                AND DeliveryInvoiceStatus != 'Reject'
--                AND A.UpdateDate BETWEEN @weekStartDate
--                                 AND     @weekEndDate



       
--        SELECT  @monthlyAmount = SUM(B.DeliveryNetAmount)
--        FROM    dbo.tblInvoice A
--                INNER JOIN dbo.tblInvoiceDetail B ON B.InvoiceId = A.InvoiceId
--                INNER JOIN dbo.tblOrder C ON C.OrderId = A.OrderId
--        WHERE   C.MIOCode = @mioCode
--                AND DelivaryInvoiceNo IS NOT NULL
--                AND DeliveryInvoiceStatus != 'Reject'
--                AND DATEPART(yy, SubmissionDate) = @year
--                AND DATEPART(MM, SubmissionDate) = @month



        SELECT  @orderCountToday = ISNULL(COUNT(*),0)
        FROM    dbo.tblOrder D with (nolock)
		left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
        WHERE   convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 
                


--		--SELECT  @orderTodyAmt = SUM(B.DeliveryNetAmount)
--  --      FROM    dbo.tblInvoice A
--  --              INNER JOIN dbo.tblInvoiceDetail B ON B.InvoiceId = A.InvoiceId
--  --              INNER JOIN dbo.tblOrder C ON C.OrderId = A.OrderId
--  --      WHERE   C.MIOCode = @mioCode
--  --              AND DelivaryInvoiceNo IS NOT NULL
--  --              AND DeliveryInvoiceStatus != 'Reject'
--  --              AND convert(Date,SubmissionDate) = convert(Date,@currentDate)

--  	SELECT   @totalCustomerCoverage = ISNULL(COUNT( distinct D.CustomerMasterId ),0) FROM tblOrder D with (nolock)  
--	 left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--	 WHERE  convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

		SELECT  @orderTodyAmt = isnull(CONVERT(decimal(18,2),SUM(D.GrossValue-D.TotalDiscount)),0)
        FROM    dbo.tblOrder D with (nolock) 
       left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
        WHERE   convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

--				--select * from tblOrder
--				--inner join tblOrderDetail on tblOrder.OrderId=tblOrderDetail.OrderId
--				--where SubmissionDate='8-aug-2021'

--		 SELECT  @productTotal = isnull(sum( B.Quantity),0)
--        FROM    dbo.tblOrder D with (nolock) 
--		INNER JOIN dbo.tblOrderDetail B ON B.OrderId = D.OrderId
--		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--      WHERE   convert(Date,D.SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		
--		SELECT @totalDcr = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
--		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


--	  	SELECT @totalDcrGMP = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
--		 inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId  
--		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 



--	  	SELECT @totalDcrNonGMP = isnull(COUNT(*),0) FROM dbo.tbl_DCRInfo D with (nolock) 
--		 inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId  
--		  left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
--      WHERE   convert(Date,DcrDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 


		 
--		SELECT @totalPrescription = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
--		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
--		  WHERE   convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 



--		  SELECT @TotalRXGMP = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
--		  inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId   
--		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs   with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
--		  WHERE  tblDoctorMaster.DoctorTypeId=2 and convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

--		  SELECT @TotalRXNONGMP = isnull(COUNT(*),0)  FROM dbo.tbl_PrescriptionMaster D with (nolock) 
--		  inner JOIN dbo.tblDoctorMaster  with (nolock) ON dbo.tblDoctorMaster.DoctorId=D.DoctorId   
--		 left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 
--		  WHERE   tblDoctorMaster.DoctorTypeId=1 and convert(Date,D.PrescriptionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 




--		  	SELECT  @Colection = ISNULL(sum(DeliveryTotalPrice),0)    from tblInvoice ID with (nolock)
--  INNER JOIN (select InvoiceId, sum(DeliveryTotalPrice-DeliveryDiscountAmount) DeliveryTotalPrice   from tblInvoiceDetail  with (nolock)  group by InvoiceId) tblDtl  on   ID.InvoiceId = tblDtl.InvoiceId 
--  INNER JOIN dbo.tblOrder D  (nolock)  ON ID.OrderID = D.OrderID 
--  left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
 

-- where   ID.DeliveryInvoiceStatus  is not null and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId)  and   convert(Date,ID.UpdateDate)= convert(Date,@currentDate)




-- SELECT    @Gift= ISNULL(sum(tblGift.GivtQty),0) , @Bonus = ISNULL(sum(tblB.BounsQty),0)    from dbo.tblOrder D with (nolock)
 
--  left JOIN  tblInvoice ID ON ID.OrderID = D.OrderID 
--    left join tblUser u with (nolock) on D.EntryBy=u.UserId
--left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
--inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId

--left JOIN (select OrderID, sum(Quantity) GivtQty   from tblOrderDetail m  with (nolock)
--inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
-- where    TotalTradePrice=0   and pro.ProductGroupId=3 group by OrderID) tblGift on   D.OrderID = tblGift.OrderID 

--left JOIN (select OrderID, sum(Quantity) BounsQty   from tblOrderDetail m  with (nolock)
--inner join tblProduct pro   with (nolock) on  m.ProductCode=pro.ProductCode 
-- where   TotalTradePrice=0   and pro.ProductGroupId=1 group by OrderID) tblB on   D.OrderID = tblB.OrderID 
  
 

-- where       	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId)  and   convert(Date,D.SubmissionDate)= convert(Date,@currentDate)







    --    SELECT  ISNULL('IN: '+ @puninTime, 'IN: No Record Yet')+ CHAR(10) +ISNULL('OUT: '+@punOutTime,'OUT: No Record Yet') AS PunchInTime ,
    --            ---ISNULL(@weeklyAmount, 0) AS WeeklySaleAmount ,
				--0 AS WeeklySaleAmount ,
    --            --ISNULL(@monthlyAmount, 0) AS MonthlySaleAmount ,
				--0 AS MonthlySaleAmount ,
				--ISNULL(ISNULL('QTY: '+ @orderCountToday, '')+ CHAR(10) +ISNULL('Amt:'+ @orderTodyAmt,''),'NO Sale Yet')  AS OrderSubmitedToday,
				--'Total: '+ISNULL(@totalCustomerCoverage, 0) AS OrderTodayAmt,
				--ISNULL(@productTotal, 0) AS ProductTotalOrder,
			 
				--	'Total: '+ISNULL(@totalDcr,0)+ CHAR(10) +	ISNULL(' ('+ISNULL('GMP: '+ @totalDcrGMP,0)+' ' + ISNULL('NGMP: '+@totalDcrNonGMP,0)+')','')
				-- AS TotalDcr,
				--'Total: '+ISNULL(@totalPrescription,0)+ CHAR(10) +	ISNULL(' ('+ISNULL('GMP: '+ @TotalRXGMP,0)+' ' + ISNULL('NGMP: '+@TotalRXNONGMP,0)+')','')
				-- AS TotalPrescription,     isnull(@Colection,'No Record Yet')  Colection  ,  'B: '+@Bonus + CHAR(10) +	'G: '+@Gift  BonusGift 
				
        SELECT  ISNULL('IN: '+ @puninTime, 'IN: No Record Yet')+ CHAR(10) +ISNULL('OUT: '+@punOutTime,'OUT: No Record Yet') AS PunchInTime ,
                ---ISNULL(@weeklyAmount, 0) AS WeeklySaleAmount ,
				0 AS WeeklySaleAmount ,
                --ISNULL(@monthlyAmount, 0) AS MonthlySaleAmount ,
				0 AS MonthlySaleAmount ,
				ISNULL(ISNULL('QTY: '+ @orderCountToday, '')+ CHAR(10) +ISNULL('Amt:'+ @orderTodyAmt,''),'NO Sale Yet') AS OrderSubmitedToday,
				'will be available soon' AS OrderTodayAmt,
				'will be available soon' AS ProductTotalOrder,
			 
					'will be available soon'
				 AS TotalDcr,
				'will be available soon'
				 AS TotalPrescription,     'will be available soon'  BonusGift 
			







    END