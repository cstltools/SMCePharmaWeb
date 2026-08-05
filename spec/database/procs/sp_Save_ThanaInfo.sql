
 create PROCEDURE [dbo].[sp_Save_ThanaInfo]
	-- Add the parameters for the stored procedure here
    @id int ,
    @district_id INT,
	@ThanaName  NVARCHAR(MAX),
    @CreatedBy INT

AS


BEGIN
  
		If NOT EXISTS (Select ThanaName from tbl_Thana where ThanaName=@ThanaName and district_id=@district_id)
		BEGIN

		--DECLARE @LABCODE NVARCHAR(MAX)

	 --   SELECT @LABCODE = 'LAB-' + (CONVERT(NVARCHAR(MAX),(COUNT(LabId) + 1001 ))) FROM tbl_LabInfo

        INSERT  INTO [dbo].[tbl_Thana]
        (    
	    district_id,
	    ThanaName,
		IsActive,
	    CreatedBy,
	    CreatedDate
	   

	     )
        VALUES  (       
	    @district_id ,
	    @ThanaName,
	    1,
	    @CreatedBy  ,
	    GETDATE() 
	   )

   SELECT SCOPE_IDENTITY()

END
  ELSE  Return 0
END

