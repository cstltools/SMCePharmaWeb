-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_PrescriptionType_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT A.PrescriptionTypeId ,
          A.PrescriptionType ,   
          A.IsActive ,
          A.ActiveInactiveDate ,
          A.EntryBy ,
          A.EntryDate,
		  A.UpdateBy,
		  A.UpdateDate  	  
		  FROM [dbo].[tbl_PrescriptionType] A
				WHERE A.PrescriptionTypeId = @id
    END

