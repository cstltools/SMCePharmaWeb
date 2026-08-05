-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_AllowanceData_ByEmployeeId]  -- [sp_Get_ZoneData_ByZoneId] 5
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
	

	SELECT *,
	STUFF(( SELECT  ',' + CAST(AllowanceId AS NVARCHAR(50))
                FROM    dbo.EmployeeAllowance
				WHERE ZoneId = @id
              FOR
                XML PATH('')
              ), 1, 1, '') AS AllowanceId 
	 FROM dbo.tbl_Zone WHERE ZoneId = @id



END

