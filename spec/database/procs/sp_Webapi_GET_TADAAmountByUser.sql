-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Webapi_GET_TADAAmountByUser
	-- Add the parameters for the stored procedure here
@userId int
AS
BEGIN
	
	SELECT CAST(A.TAAmount AS NVARCHAR(50)) AS TAAmount,
	CAST(A.DAAmount AS NVARCHAR(50)) AS DAAmount
	 FROM dbo.tbl_TADAMarketRulesConfig A 
	INNER JOIN dbo.tbl_UserRoleInfo  B ON B.UserRoleID = A.UserRoleID
	INNER JOIN dbo.tblUser C ON C.UserRoleID = B.UserRoleID
	WHERE C.UserId = @userId AND A.IsActive =1


END
