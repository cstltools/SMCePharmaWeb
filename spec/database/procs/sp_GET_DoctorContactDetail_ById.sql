

 CREATE PROCEDURE [dbo].[sp_GET_DoctorContactDetail_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	  SELECT mas.ContactTypeId ContactTypeId,ct.ContactType ContactType, mas.Contact Contact, * from tblDoctorContactDetail mas with (nolock)
	  INNER JOIN dbo.tbl_ContactType ct ON ct.ContactTypeId = mas.ContactTypeId


	  where mas.DoctorId = @id
      
    END


