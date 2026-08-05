

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Update_TourSetupEmployee]
    
	@TourSetupEmployeeId int,
	@CountNo int =null ,
    @UpdateBy INT =null,
	@UpdateDate DATETIME = NULL

AS
BEGIN


UPDATE tblTourSetupEmployee
   SET CountNo = @CountNo
       
      ,UpdateBy = @UpdateBy
      ,UpdateDate = @UpdateDate
 WHERE  TourSetupEmployeeId = @TourSetupEmployeeId

	

END



