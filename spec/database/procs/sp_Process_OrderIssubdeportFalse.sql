

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Process_OrderIssubdeportFalse]
	-- Add the parameters for the stored procedure here
	

AS
BEGIN

update tblOrder set IsSubDepo=0 where IsSubDepo=1

END



