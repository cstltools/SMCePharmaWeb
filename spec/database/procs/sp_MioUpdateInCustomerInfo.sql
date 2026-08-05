-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MioUpdateInCustomerInfo] --- exec sp_OrderGenerationFromUploadOrder_SingleOrder 301,'10378083828',1
	@ter NVARCHAR(500),
	@mio NVARCHAR(500),
	@name NVARCHAR(500)
	
AS
BEGIN

DECLARE @terr NVARCHAR(500)=@terDECLARE @mio0 NVARCHAR(500)=@mioDECLARE @A NVARCHAR(500)DECLARE @B NVARCHAR(500)--------------------------------------------------------DECLARE @MyCursor CURSORSET @MyCursor = CURSOR FAST_FORWARDFOR---------------SELECT CustomerMasterId FROM dbo.tblCustMaster WHERE AreaCode=@ter----------OPEN @MyCursorFETCH NEXT FROM @MyCursorINTO @AWHILE @@FETCH_STATUS = 0BEGINupdate tblCustMaster set MIACode=@mio,MIAName=@name where CustomerMasterId=@AFETCH NEXT FROM @MyCursorINTO @AENDCLOSE @MyCursorDEALLOCATE @MyCursor

END
