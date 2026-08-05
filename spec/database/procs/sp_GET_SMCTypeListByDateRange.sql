
CREATE PROCEDURE [dbo].[sp_GET_SMCTypeListByDateRange]
	-- Add the parameters for the stored procedure here
  
      @FromDate date,
  @ToDate date
AS
    BEGIN

 SELECT SMCTypeId, SMCType SMCTypeName
	FROM dbo.tblSMCType AS GRP WITH (NOLOCK)  

	 WHERE EXISTS
    (
        SELECT 1
        FROM dbo.tblInvoice AS A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder   AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        
        WHERE       (A.UpdateDate)  between  @FromDate and @ToDate
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND ord.SmcTypeId_Ord = GRP.SMCTypeId
    );
 END
