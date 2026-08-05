
CREATE PROCEDURE [dbo].[sp_GET_CustomerWiseNoSales_BI]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.CustomerMasterId,
        C.CustomerCode,
        C.CustomerName,
        C.CellNo AS CustomerMobileNo,
        CT.CustomerType,
        CC.CustomerCategory,

        MAX(I.PaymentDate) AS LastSalesDate,

        DATEDIFF(DAY, MAX(I.PaymentDate), GETDATE()) AS NoOfDaysWithoutSales

    FROM dbo.tblCustMaster C

    LEFT JOIN dbo.tblCustomerType CT
        ON CT.CustomerTypeId = C.CustomerTypeId

    LEFT JOIN dbo.tblCustomerCategory CC
        ON CC.CustomerCategoryId = C.CategoryId

    LEFT JOIN dbo.tblOrder O
        ON O.CustomerMasterId = C.CustomerMasterId

    LEFT JOIN dbo.tblInvoice I
        ON I.OrderId = O.OrderId
       AND I.PaymentInvoiceNo IS NOT NULL
       AND I.PaymentDate IS NOT NULL

    GROUP BY
        C.CustomerMasterId,
        C.CustomerCode,
        C.CustomerName,
        C.CellNo,
        CT.CustomerType,
        CC.CustomerCategory

    HAVING
        MAX(I.PaymentDate) < DATEADD(YEAR, -2, GETDATE())

    ORDER BY
        NoOfDaysWithoutSales DESC,
        C.CustomerName;
END
