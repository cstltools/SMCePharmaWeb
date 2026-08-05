-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_DoctorSpeciality_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.SpecialityId ,
          A.SpecialityName ,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM  [dbo].[tblDoctorSpeciality] A
				WHERE A.SpecialityId = @id

    END

