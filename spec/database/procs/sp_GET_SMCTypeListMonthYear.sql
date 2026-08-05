
CREATE PROCEDURE [dbo].[sp_GET_SMCTypeListMonthYear]
	-- Add the parameters for the stored procedure here
  
      @Month int,
  @Year int
AS
    BEGIN

 SELECT SMCTypeId, SMCType SMCTypeName
	FROM dbo.tblSMCType AS GRP WITH (NOLOCK)  

	 WHERE EXISTS
    (
        SELECT 1
        FROM dbo.tblInvoice AS A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder   AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        
        WHERE       month(A.UpdateDate)=@Month  and  year(A.UpdateDate)=@Year
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND ord.SmcTypeId_Ord = GRP.SMCTypeId
    );
 END
