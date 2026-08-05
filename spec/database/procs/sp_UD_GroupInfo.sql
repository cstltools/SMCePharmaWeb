
CREATE PROCEDURE [dbo].[sp_UD_GroupInfo]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @GroupName NVARCHAR(MAX),
	 @NationalId INT = 0 ,
    @CodeStr NVARCHAR(MAX),
    @UpdateBy INT ,
    @IsActive BIT 

AS
    BEGIN

	UPDATE tbl_Group
	SET  NationalId=@NationalId, GroupName = @GroupName
      ,IsActive = @IsActive
      ,UpdateBy = @UpdateBy
      ,UpdateDate = GETDATE(), GroupCode=@CodeStr
     
	WHERE GroupId = @id

 END
