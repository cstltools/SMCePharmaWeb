CREATE PROCEDURE [dbo].[sp_Get_Order_Info_WebAPI_NEw_MIo] -- sp_Get_Order_Info_WebAPI_NEw_MIo 313
	-- Add the parameters for the stored procedure here
@empId int = null,
@FromDate   NVARCHAR(max)=null,
@ToDate   NVARCHAR(max)=null


AS
BEGIN

DECLARE @TerrId INT
DECLARE @AreaId INT
DECLARE @ZoneId INT
DECLARE @GroupId INT


SELECT @AreaId=AreaId,@ZoneId=RegionId,@GroupId=GroupId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@empId




		DECLARE @mioCode NVARCHAR(50)

        SELECT  @mioCode = usr.UserId
        FROM    dbo.tblEmpGeneralInfo A with (nolock)

		inner join tblUser usr  with (nolock) on a.EmpInfoId=usr.EmpInfoId
        WHERE   A.EmpInfoId = @empId 


		--select * from tblorder

SELECT   
		D.OrderId,
		D.OrderCode,
		D.MIOName,
		D.CustomerName,
		D.TotalNetPayable as GrossValue,
		FORMAT(D.EntryDate,'dd MMM, yyyy') CreatedAt,

	case when 	emp.EmpInfoId is null then u.LoginName else emp.empmastercode +' : '+ emp.empname end  CreatedBy,
		CONVERT(NVARCHAR(50),D.SubmissionDate,106) AS SubmissionDate,
		( SELECT  PaymentStatus
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) AS dsd,
		'Own'  AS OrderType,
		 CASE		WHEN ( SELECT  PaymentStatus
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) IS NOT NULL THEN 'Payment Completed'

						  WHEN ( SELECT  DelivaryInvoiceNo
                            FROM    dbo.tblInvoice with (nolock)
                            WHERE   OrderId = D.OrderId
                          ) IS NOT NULL THEN 'Delivery Completed'

					WHEN IsInvoice = 1 THEN 'Invoiced'
					WHEN IsInvoice = 0 THEN 'Invoice Pending'
					WHEN IsInvoice IS NULL THEN 'Pending'
					END AS OrderStatus

FROM    dbo.tblOrder D
left join tblUser u with (nolock) on D.EntryBy=u.UserId
left join tblEmpGeneralInfo emp with (nolock) on emp.EmpInfoId=u.EmpInfoId

			WHERE 
			(D.EntryBy = @mioCode  OR
			D.AreaId=@AreaId OR D.RegionId=@ZoneId OR D.GroupId=@GroupId)
			
			AND convert(Date, D.SubmissionDate) between convert(Date,@FromDate )  and convert(Date,@ToDate )
			AND IsFromApp = 1
			ORDER BY OrderId DESC


END