



 CREATE PROCEDURE [dbo].[sp_Save_MenuRole]
	-- Add the parameters for the stored procedure here
    @SL INT NULL,
	    @RoleId INT NULL,
	    @Add BIT NULL,
	    @View BIT NULL,
	    @Delete BIT NULL,
	    @Edit BIT NULL,
		@Permission BIT NULL


AS
    BEGIN
	
		
	--IF EXISTS (SELECT SL FROM dbo.tblMenuRole WHERE RoleId=@RoleId AND SL=@SL)
	--BEGIN
	--    DELETE FROM dbo.tblMenuRole WHERE RoleId=@RoleId AND SL=@SL
	--END


	INSERT INTO dbo.tblMenuRole
	(
	    SL,
	    RoleId,
	    [Add],
	    [View],
	    [Delete],
	    Edit,Permission
	)
	VALUES
	(   @SL,
	    @RoleId,
	    @Add,
	    @View,
	    @Delete,
	    @Edit,@Permission
	    )
        

		SELECT SCOPE_IDENTITY()
END
  
    

