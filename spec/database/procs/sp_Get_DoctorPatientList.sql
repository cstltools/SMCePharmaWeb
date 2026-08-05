-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_DoctorPatientList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
   SELECT A.PatientTypeId ,
          A.PatientType ,   
          A.IsActive ,
          CONVERT(NVARCHAR(50),A.Activedate,106)AS Activedate,
          A.EntryBy,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM [dbo].[tblDoctorPatientType] A
		  Where A.IsDelate is NULL
END

