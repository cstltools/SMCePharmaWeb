-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorTourPlanDateById]
	-- Add the parameters for the stored procedure here
	@id INT
AS
BEGIN
 
SELECT DISTINCT  CONVERT(NVARCHAR(50),mas.TourPlanDate,106)AS  TourPlanDate  FROM dbo.tbl_DoctorTourPlanDetail mas
 
 


 WHERE mas.DocTPMaster=@id
	ORDER BY CONVERT(NVARCHAR(50),mas.TourPlanDate,106)
END
