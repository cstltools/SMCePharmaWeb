create PROCEDURE [dbo].[sp_Webapi_Save_SynchronizationInfo]
	-- Add the parameters for the stored procedure here
  @EmpInfoId int = NULL  
  
AS
    BEGIN
 
    INSERT INTO [dbo].[tblSynchronizationInfo]
           ( [EmpInfoId]
           ,[SynchronizationDate])
     VALUES
           (  @EmpInfoId 
           ,GETDATE())
    End

