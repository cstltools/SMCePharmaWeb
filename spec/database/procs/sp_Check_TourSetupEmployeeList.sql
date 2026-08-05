
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Check_TourSetupEmployeeList]
	-- Add the parameters for the stored procedure here
	@EmpInfoId int=null
AS
BEGIN

 select EmpInfoId from tblTourSetupEmployee  TSE  with (nolock)

where TSE.EmpInfoId =@EmpInfoId
 
END