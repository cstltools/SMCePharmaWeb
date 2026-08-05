
create PROCEDURE [dbo].[sp_Save_OrderPermission]
	
	-- Add the parameters for the stored procedure here

@TerritoryId  INT,
            @PermittedEmpId  INT,
            @FrmDate datetime,
            @ToDate datetime,
           @EntryBy  nvarchar(50) 
            

 AS
    BEGIN
	DELETE FROM [dbo].[tblOrderPermission]
      WHERE  TerritoryId= @TerritoryId
	INSERT INTO [dbo].[tblOrderPermission]
           ([TerritoryId]
           ,[PermittedEmpId]
           ,[FrmDate]
           ,[ToDate]
           ,[EntryBy]
           ,[EntryDate])
     VALUES
           (@TerritoryId 
           ,@PermittedEmpId 
           ,@FrmDate 
           ,@ToDate 
           ,@EntryBy 
           ,GETDATE() )

		SELECT SCOPE_IDENTITY()

		END
		 
  
