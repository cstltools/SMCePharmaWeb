

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_GET_UpdateCampaignType] 


		
AS
BEGIN

DECLARE @CustomerCode NVARCHAR(500)DECLARE @TerritoryCode NVARCHAR(500)--------------------------------------------------------DECLARE @MyCursor CURSORSET @MyCursor = CURSOR FAST_FORWARDFOR---------------SELECT DISTINCT OrderId,CampaignType FROM tblOrderDetail----------OPEN @MyCursorFETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCodeWHILE @@FETCH_STATUS = 0BEGINupdate tblOrder set CampaignName=@TerritoryCode WHERE OrderId=@CustomerCodeFETCH NEXT FROM @MyCursorINTO @CustomerCode,@TerritoryCodeENDCLOSE @MyCursorDEALLOCATE @MyCursor

END



