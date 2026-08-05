-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
Create PROCEDURE [dbo].[sp_Get_DoctorChamber_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.ChamberId ,
          A.ChamberName ,   
          A.IsActive ,
          A.Activedate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM dbo.tblDoctorChamber A
				WHERE A.ChamberId = @id

    END


