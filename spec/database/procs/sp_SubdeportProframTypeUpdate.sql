-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_SubdeportProframTypeUpdate]
	
AS
BEGIN

DECLARE @CustomerCode NVARCHAR(500)DECLARE @TerritoryCode NVARCHAR(500)--------------------------------------------------------DECLARE @MyCursor CURSORSET @MyCursor = CURSOR FAST_FORWARDFOR---------------SELECT SubmissionDate,OrderCode,tblOrderListDetail.ProgramType from  tblOrderListDetail inner join tblSubInvoiceMaster on tblOrderListDetail.OrderCode=tblSubInvoiceMaster.OrderNowhere SubmissionDate =  CONVERT(DATE, GETDATE())----------OPEN @MyCursorFETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCodeWHILE @@FETCH_STATUS = 0BEGINupdate tblSubInvoiceMaster set ProgramType=@TerritoryCodewhere OrderNo=@CustomerCode --and ProgramType=' 'FETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCodeENDCLOSE @MyCursorDEALLOCATE @MyCursor--select * from tblOrderListDetail where ProgramType=' '--SELECT DISTINCT TerritoryCode
--FROM  tblsmc2019CustomerUpdate
--WHERE TerritoryCode NOT IN (SELECT AreaCode FROM tblArea)
END
