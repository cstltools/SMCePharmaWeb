
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_PrescriptionTypeList]
	-- Add the parameters for the stored procedure here

AS
BEGIN
   
 SELECT A.PrescriptionTypeId,A.PrescriptionType,A.IsActive, CONVERT(NVARCHAR(50),A.ActiveInactiveDate,106)AS Activedate, CONVERT(NVARCHAR(50),A.ActiveInactiveDate,106)AS ActivedateString  from tbl_PrescriptionType A

END

