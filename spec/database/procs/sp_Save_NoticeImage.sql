
 Create PROCEDURE [dbo].[sp_Save_NoticeImage]
	-- Add the parameters for the stored procedure here
    @id INT = 0,
    @ImagePath NVARCHAR(MAX) 

AS
    BEGIN

        DECLARE @codeD NVARCHAR(MAX)

        SET @codeD = 'Notice-' 

        INSERT  INTO dbo.tbl_ImagePath_Setting
                ( ImageType ,
                  ImagePreName ,           
                  IsActive ,
                  ImagePath ,
				  Remarks                     
	            )
        VALUES  ( 'Notice',
                  @codeD ,
                  1 ,
                  @ImagePath ,
				  'Notice-PrimaryId'               
                )

				SELECT SCOPE_IDENTITY()
		
    END
