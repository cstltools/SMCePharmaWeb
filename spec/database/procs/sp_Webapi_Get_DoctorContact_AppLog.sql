-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorContact_AppLog]
	-- Add the parameters for the stored procedure here
	@doctorId INT 
AS
BEGIN
	 
	SELECT tblDoctorContactDetail.ContactTypeId  ContactTypeId , chm.ContactType  ContactType,
           tblDoctorContactDetail.Contact AS Contact 
        
             FROM dbo.tblDoctorContactDetail
			 left join tbl_ContactType chm on chm.ContactTypeId=tblDoctorContactDetail.ContactTypeId

			  WHERE DoctorId = @doctorId  
END

