-- =============================================
-- Author: <Author,JEWEL>
-- Create date: <Create Date,02/08/2016,>
-- Description:	<Description,,>
-- ============================================

CREATE PROCEDURE [dbo].[sp_upd_30daysOrderInactive] 


AS
BEGIN
	

update tblOrder set ActionStatus=4 where OrderId in 
(
SELECT OrderId
FROM tblOrder
WHERE IsInvoice = 0
  AND SubmissionDate >= '2020-01-01'
  AND SubmissionDate < DATEADD(DAY, -29, CAST(GETDATE() AS DATE)))

END


