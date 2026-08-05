
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_NationalTargetAmount]
	-- Add the parameters for the stored procedure here

	@GroupId INT,
	@month nvarchar(max),
	@Year INT


AS
BEGIN
	
	SELECT    Amount FROM dbo.tblNationalTargetSetup   with (nolock) WHERE    GroupId = @GroupId and Year=@Year and  month=@month

END



