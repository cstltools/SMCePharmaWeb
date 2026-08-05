-- =============================================
-- Author:		<Author,Liton>
-- Create date: <Create Date,01/15/2016,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadSalesReturnReportSAP] 
	@fromdate datetime,
	@todate datetime
AS
BEGIN
	select Csapres.IdocNo,  rmas.[CustomerCode],
rmas.[Zone],
rmas.[Area],
rmas.[Territory],
rmas.[SalesDocDate] as ReturnDate,
rmas.[Plant],
rmas.[ProductCode],
rmas.[Batch],
rmas.[Quantity],
rmas.[UoM],
rmas.[UnitPrice],
rmas.[VAT],
rmas.[DiscountAmount],
rmas.[FOCFlag]

from SAP_API_Data..tbl_Return rmas
LEFT JOIN dbo.tblCompanyUnit CU ON CU.Customer_Code = rmas.Plant
LEFT JOIN SAP_API_Data..tblSalesReturnResponseData Csapres ON rmas.Plant = Csapres.Code and CONVERT(date,Csapres.SalesDocDate)=CONVERT(date,rmas.SalesDocDate)
where rmas.SalesDocDate between @fromdate and @todate
	
END


 