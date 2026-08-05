-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DcrVisitedWith]
	-- Add the parameters for the stored procedure here
    @empId INT, @pk INT
AS
    BEGIN
	
        INSERT  INTO dbo.tbl_DcrVisitedWithDetails
                ( EmpInfoId, DcrId )
        VALUES  ( @empId, @pk )


    END

