-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_DoctorDesignation_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.DesignationId ,
          A.DesignationName ,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM dbo.tblDoctorDesignation A
				WHERE A.DesignationId = @id

    END

