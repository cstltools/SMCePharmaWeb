-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Employee_ShiftInfosList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT   CONVERT(varchar(100),CAST(ShiftInTime AS TIME),100)ShiftInTime, CONVERT(varchar(100),CAST(ShiftOutTime AS TIME),100)ShiftOutTime, 
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate ,*
         
		  FROM dbo.tbl_Shift A
		  WHERE A.IsActive=1
		  


		  --SELECT DegId,COUNT(DoctorDegId) AS S FROM tblDoctorDegreeDetail GROUP BY DegId


END

