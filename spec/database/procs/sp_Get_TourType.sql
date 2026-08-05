-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourType]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   

   SELECT * ,
          CONVERT(NVARCHAR(50),A.ActiveDate,106)AS ActiveInActiveDate	  
		  FROM [dbo].tbl_TourPlanType A	 with (nolock)
END
