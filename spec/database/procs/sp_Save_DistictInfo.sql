
 create PROCEDURE [dbo].[sp_Save_DistictInfo]
	-- Add the parameters for the stored procedure here
    @id int ,
    @district_id INT,
	@ThanaName  NVARCHAR(MAX),
    @CreatedBy INT

AS


BEGIN
  
		If NOT EXISTS (Select DistrictName from tbl_District where DistrictName=@ThanaName and DivisionId=@district_id)
		BEGIN

		--DECLARE @LABCODE NVARCHAR(MAX)

	 --   SELECT @LABCODE = 'LAB-' + (CONVERT(NVARCHAR(MAX),(COUNT(LabId) + 1001 ))) FROM tbl_LabInfo

       INSERT INTO [dbo].[tbl_District]
           ([DistrictName]
           ,[DivisionId]
            
           ,[EntryBy]
           ,[EntryDate]
           ,[IsActive])
     VALUES
           (@ThanaName 
           ,@district_id 
           
           ,@CreatedBy 
           ,getdate() 
           ,1)

   SELECT SCOPE_IDENTITY()

END
  ELSE  Return 0
END

