-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorDegreeList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT dt.DoctorTypeName, A.DegreeId ,
          A.DegreeName ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106) AS Activedate ,
		  CONVERT(NVARCHAR(50),A.EntryDate,106)  AS EntryDate ,
          CONVERT(NVARCHAR(50),A.UpdateDate,106) AS UpdateDate ,
          En.UserName AS EntryBy,
          Up.UserName AS UpdateBy,
		  CASE WHEN DS.S IS NULL THEN 'Yes' else 'No' END AS IsDel 	  
		  FROM dbo.tblDoctorDegree A
		  LEFT JOIN tblDoctorType dt On dt.DoctorTypeId = A.DoctorTypeId
		  LEFT JOIN tblUser En On En.UserId = A.EntryBy
          LEFT JOIN tblUser Up ON Up.UserId = A.UpdateBy
		  LEFT JOIN (SELECT DegId,COUNT(DoctorDegId) AS S FROM tblDoctorDegreeDetail GROUP BY DegId) AS DS 
		  ON DS.DegId = A.DegreeId
		  Where A.IsDelate is NULL


		  --SELECT DegId,COUNT(DoctorDegId) AS S FROM tblDoctorDegreeDetail GROUP BY DegId


END

