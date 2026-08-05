CREATE PROCEDURE [dbo].[sp_WebAPI_Get_OrderinfoData_ById]
	-- Add the parameters for the stored procedure here
    @orderId INT
AS
    BEGIN
			
        SELECT  OrderId ,
                OrderCode ,
                MIOName ,
                CustomerCode ,
                CustomerName ,
                GrossValue ,
				1 AS IsMioApproved,
                CONVERT(NVARCHAR(50), SubmissionDate, 106) AS SubmissionDate ,
                1 AS IsPending ,

                1 AS IsConfirm ,

                CASE WHEN IsInvoice = 0 THEN 0
                     ELSE 1
                END AS IsInvoiced ,
                CASE WHEN ( SELECT  DelivaryInvoiceNo
                            FROM    dbo.tblInvoice
                            WHERE   OrderId = @orderId
                          ) IS NOT NULL THEN 1
                     ELSE 0
                END AS IsDelivered ,
                CASE WHEN ( SELECT  PaymentStatus
                            FROM    dbo.tblInvoice
                            WHERE   OrderId = @orderId
                          ) IS NOT NULL THEN 1
                     ELSE 0
                END AS IsPayment,
				'No' AS IsFromCustomer
        FROM    dbo.tblOrder
        WHERE   OrderId = @orderId

    END