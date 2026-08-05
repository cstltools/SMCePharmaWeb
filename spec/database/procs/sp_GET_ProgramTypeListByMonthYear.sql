
CREATE PROCEDURE [dbo].[sp_GET_ProgramTypeListByMonthYear]
	-- Add the parameters for the stored procedure here
  
   @Month int,
  @Year int
AS
    BEGIN

	SELECT ProgramTypeName, ProgramTypeId
	FROM dbo.tblProgramType AS GRP WITH (NOLOCK)    
	WHERE EXISTS
    (
        SELECT 1
        FROM dbo.tblInvoice AS A WITH (NOLOCK)
        INNER JOIN dbo.tblOrder   AS ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
        
        WHERE       month(A.UpdateDate) =@Month and  year(A.UpdateDate) =@Year
          AND A.DelivaryInvoiceNo IS NOT NULL
          AND ord.ProgramTypeId = GRP.ProgramTypeId
    );

 END
