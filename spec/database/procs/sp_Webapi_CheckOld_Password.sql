
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_CheckOld_Password]
	-- Add the parameters for the stored procedure here
    @empId INT = NULL ,
    
    @OldPass NVARCHAR(MAX) = NULL,
    @NewPass NVARCHAR(MAX) = NULL
AS
    BEGIN

		DECLARE @MasterId INT=0
	SELECT @MasterId=UserId FROM dbo.tblUser WHERE EmpInfoId = @empId

select * from tblUser    WHERE   UserId = @MasterId and Password=@OldPass

 
                
					 

    END
