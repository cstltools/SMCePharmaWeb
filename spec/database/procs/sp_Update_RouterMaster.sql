
CREATE PROCEDURE [dbo].[sp_Update_RouterMaster]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @RouterName NVARCHAR(MAX) ,
    @UpdateBy INT 

AS
    BEGIN
	
	Update RouterMaster 
	       SET RouterName = @RouterName,
		       UpdateBy = @UpdateBy,
			   UpdateDate = GETDATE()

    Delete from RouterDetails where RouterMasterId= @id
		
END
