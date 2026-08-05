CREATE PROCEDURE [dbo].[sp_WebAPI_Get_MioDashboardTopBarData_OrdAtt] 
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
         
            @orderCountToday NVARCHAR(50),
			  @orderTodyAmt NVARCHAR(50),
			   @Colection NVARCHAR(50),
			   @totalCustomerCoverage NVARCHAR(50)





        SELECT  @puninTime = ISNULL(PunchInTime, 0)
        FROM    dbo.tblMarketAttendance_Master_webapi
        WHERE   EmpInfoId = @empId and AttType=1
                AND convert(Date,AttendanceDate) = convert(Date,@currentDate)


				
        SELECT  @punOutTime = ISNULL(PunchInTime, 0)
        FROM    dbo.tblMarketAttendance_Master_webapi
        WHERE   EmpInfoId = @empId and AttType=2
                AND convert(Date,AttendanceDate) = convert(Date,@currentDate)


        SELECT  @orderCountToday = ISNULL(COUNT(*),0)
        FROM    dbo.tblOrder D with (nolock)
		left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
        WHERE   convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 
                


		--SELECT  @orderTodyAmt = SUM(B.DeliveryNetAmount)
  --      FROM    dbo.tblInvoice A
  --              INNER JOIN dbo.tblInvoiceDetail B ON B.InvoiceId = A.InvoiceId
  --              INNER JOIN dbo.tblOrder C ON C.OrderId = A.OrderId
  --      WHERE   C.MIOCode = @mioCode
  --              AND DelivaryInvoiceNo IS NOT NULL
  --              AND DeliveryInvoiceStatus != 'Reject'
  --              AND convert(Date,SubmissionDate) = convert(Date,@currentDate)

  	SELECT   @totalCustomerCoverage = ISNULL(COUNT( distinct D.CustomerMasterId ),0) FROM tblOrder D with (nolock)  
	 left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
	 WHERE  convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

		SELECT  @orderTodyAmt = isnull(CONVERT(decimal(18,2),SUM(D.GrossValue-D.TotalDiscount)),0)
        FROM    dbo.tblOrder D with (nolock) 
       left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
        WHERE   convert(Date,SubmissionDate) =  convert(Date,@currentDate) and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId) 

				


		  	SELECT  @Colection = ISNULL(sum(DeliveryTotalPrice),0)    from tblInvoice ID with (nolock)
  INNER JOIN (select InvoiceId, sum(DeliveryTotalPrice-DeliveryDiscountAmount) DeliveryTotalPrice   from tblInvoiceDetail  with (nolock)  group by InvoiceId) tblDtl  on   ID.InvoiceId = tblDtl.InvoiceId 
  INNER JOIN dbo.tblOrder D  (nolock)  ON ID.OrderID = D.OrderID 
  left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId
inner join View_Webapi_EmployeeFieldForceInfo fs  with (nolock)  on emp.EmpInfoId=fs.EmpInfoId
 

 where   ID.DeliveryInvoiceStatus  is not null and    	(fs.MIOEmpId=@empId or fs.ASMEMPId=@empId or fs.RSMEMPId=@empId or fs.NSMEMPId=@empId)  and   convert(Date,ID.UpdateDate)= convert(Date,@currentDate)





        SELECT  ISNULL('IN: '+ @puninTime, 'IN: No Record Yet')+ CHAR(10) +ISNULL('OUT: '+@punOutTime,'OUT: No Record Yet') AS PunchInTime ,
               
				ISNULL(ISNULL('QTY: '+ @orderCountToday, '')+ CHAR(10) +ISNULL('Amt:'+ @orderTodyAmt,''),'NO Sale Yet')  AS OrderSubmitedToday,
				ISNULL(ISNULL('QTY: '+ @orderCountToday, '')+ CHAR(10) +ISNULL('Amt:'+ @orderTodyAmt,''),'NO Sale Yet') AS OrderTodayAmt







    END