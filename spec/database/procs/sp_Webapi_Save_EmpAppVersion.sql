-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Save_EmpAppVersion]
	-- Add the parameters for the stored procedure here
    @EmpInfoId int  ,
   
    @AppVersion NVARCHAR(MAX)=NULL 
AS
    BEGIN
	
	
 declare @Count int
 

 
SELECT @Count= ISNULL(COUNT(*),0)	 FROM    tblEmpAppVersion A
	WHERE   A.EmpInfoId = @EmpInfoId
                AND A.AppVersion = @AppVersion
   
  IF(@Count=0)
	BEGIN

       INSERT INTO [dbo].tblEmpAppVersion
           (EmpInfoId
           ,AppVersion
           ,AppVersionDate)
     VALUES
           (@EmpInfoId
           ,@AppVersion
           ,GETDATE())

SELECT SCOPE_IDENTITY()

    END
    END

 