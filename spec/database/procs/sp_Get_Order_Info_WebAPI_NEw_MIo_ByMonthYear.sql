CREATE PROCEDURE [dbo].[sp_Get_Order_Info_WebAPI_NEw_MIo_ByMonthYear]
	-- Add the parameters for the stored procedure here
@empId int = NULL,
@month INT = NULL,
@year INT = null
AS
BEGIN

		DECLARE @mioCode NVARCHAR(50)

        SELECT  @mioCode = A.EmpMasterCode
        FROM    dbo.tblEmpGeneralInfo A
        WHERE   A.EmpInfoId = @empId 





SELECT TOP 100  OrderId,
		OrderCode,
		MIOName,
		CustomerName,
		GrossValue,
		CONVERT(NVARCHAR(50),SubmissionDate,106) AS SubmissionDate,
		'Own'  AS OrderType,
		 CASE 
					WHEN IsInvoice = 1 THEN 'Invoiced'
					WHEN IsInvoice = 0 THEN 'Invoice Pending'
					END AS OrderStatus

FROM    dbo.tblOrder
			WHERE MIOCode = @mioCode 
			AND DATEPART(yy,SubmissionDate) = @year AND DATEPART(MM,SubmissionDate) = @month
			AND IsFromApp = 1
			ORDER BY OrderId DESC


END
