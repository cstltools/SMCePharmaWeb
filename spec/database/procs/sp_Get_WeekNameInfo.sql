-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_WeekNameInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT WeekNameId  Value, WeekName TextField  	  
		  FROM  tblWeekNameInfo  	 with (nolock)
END
