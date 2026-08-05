-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_DoctorDegree_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.DegreeId ,
          A.DegreeName ,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate ,
		  A.DoctorTypeId 	  
		  FROM dbo.tblDoctorDegree A
				WHERE A.DegreeId = @id

    END


