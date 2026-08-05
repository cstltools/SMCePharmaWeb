CREATE PROCEDURE [dbo].[sp_Get_Order_Info_WebAPI_NEw]
	-- Add the parameters for the stored procedure here
@customerCode NVARCHAR(50) = null
AS
BEGIN


SELECT TOP 25  OrderId,
		OrderCode,
		MIOName,
		CustomerName,
		GrossValue,
		CONVERT(NVARCHAR(50),SubmissionDate,106) AS SubmissionDate,

		CASE 
			WHEN IsInvoice = 1 THEN 'Invoiced'
			WHEN IsInvoice = 0 THEN 'Pending'
			END AS OrderStatus
FROM    dbo.tblOrder
WHERE   CustomerCode = @customerCode 


END
