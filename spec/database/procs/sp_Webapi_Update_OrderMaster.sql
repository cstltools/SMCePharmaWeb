
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_OrderMaster]
	-- Add the parameters for the stored procedure here
@orderid int



AS
BEGIN

UPDATE  dbo.tblOrder
        SET     GrossValue = 0,
		        TotalVat = 0,
		        TotalDiscount = 0,
		        TotalNetPayable = 0



        WHERE   OrderId = @orderid
END


