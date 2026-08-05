
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_tblMIATargetList]
	-- Add the parameters for the stored procedure here
	@MiaTargetId INT,
    @MiaTargetAmount DECIMAL =Null ,
	@MiaCode NVARCHAR(max) =null,
	@MiaName NVARCHAR(max) =null,
    @Period NVARCHAR(50) =NULL,
    @Year NVARCHAR(50) =NULL,
	@EntryBy  NVARCHAR(50) =NULL
AS
    BEGIN
	
     INSERT INTO [dbo].[tblMIATarget]
           ([MiaTargetAmount]
           ,[MiaCode]
           ,[MiaName]
           ,[Period]
           ,[Year],EntryBy,EntryDate)
     VALUES
           (@MiaTargetAmount
           ,@MiaCode
           ,@MiaName
           ,@Period
           ,@Year,@EntryBy,GETDATE())

SELECT SCOPE_IDENTITY()

END


