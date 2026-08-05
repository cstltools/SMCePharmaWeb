CREATE PROCEDURE [dbo].[sp_GET_CampaignNameFromOrderDetailByMonthYear]

  @Month int,
  @Year int

AS
    BEGIN
  SET NOCOUNT ON;

    ------------------------------------------------------------------
    -- Sargable month/year range
    ------------------------------------------------------------------
 --   DECLARE @StartDate DATE = DATEFROMPARTS(@year, @month, 1);
 --   DECLARE @EndDate   DATE = DATEADD(MONTH, 1, @StartDate);

	--print @StartDate
	--print @EndDate



	select distinct replace(OrdDT.CampaignName,'''',' ') CampaignName   FROM dbo.tblInvoice AS A WITH (NOLOCK)
	   INNER JOIN dbo.tblOrder   AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
	   INNER JOIN tblOrderDetail AS OrdDT  WITH (NOLOCK)  ON OrdDT.OrderId=ord.OrderId
 
	
	 
	  where replace(OrdDT.CampaignName,'''',' ')<>''    and month(A.UpdateDate) = @Month
          AND year(A.UpdateDate) =  @Year
          AND A.DelivaryInvoiceNo IS NOT NULL
	 

 END