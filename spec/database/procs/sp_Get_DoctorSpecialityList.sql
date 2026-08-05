-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorSpecialityList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT A.SpecialityId ,
          A.SpecialityName ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106) AS Activedate ,
		  CONVERT(NVARCHAR(50),A.EntryDate,106)  AS EntryDate ,
          CONVERT(NVARCHAR(50),A.UpdateDate,106) AS UpdateDate ,
          En.UserName AS EntryBy,
          Up.UserName AS UpdateBy,
		  CASE WHEN DS.S IS NULL THEN 'Yes' else 'No' END AS IsDel 	 	  
		  FROM [dbo].[tblDoctorSpeciality] A  
          LEFT JOIN tblUser En On En.UserId = A.EntryBy
          LEFT JOIN tblUser Up ON Up.UserId = A.UpdateBy
		  LEFT JOIN (SELECT SpecialityId,COUNT(DoctorSpId) AS S FROM dbo.tblDoctorSpecialityDetail GROUP BY SpecialityId) AS DS 
		  ON DS.SpecialityId = A.SpecialityId
		  Where A.IsDelate is NULL
END

