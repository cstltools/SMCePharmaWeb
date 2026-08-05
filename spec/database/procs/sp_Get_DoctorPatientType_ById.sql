-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_DoctorPatientType_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.PatientTypeId ,
          A.PatientType ,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM [dbo].[tblDoctorPatientType]  A
				WHERE A.PatientTypeId = @id

    END

