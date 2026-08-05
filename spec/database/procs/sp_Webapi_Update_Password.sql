-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_Password]
	-- Add the parameters for the stored procedure here
    @empId INT = NULL ,
    
    @OldPass NVARCHAR(MAX) = NULL,
    @NewPass NVARCHAR(MAX) = NULL
AS
    BEGIN

		DECLARE @MasterId INT=0
	SELECT @MasterId=UserId FROM dbo.tblUser WHERE EmpInfoId = @empId



        UPDATE  dbo.tblUser
        SET    Password=@NewPass, UpdateBy=@MasterId, UpdateDate=GETDATE()
        WHERE   UserId = @MasterId
                
					 

    END

