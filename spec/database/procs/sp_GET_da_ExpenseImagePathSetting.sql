
CREATE   PROCEDURE dbo.sp_GET_da_ExpenseImagePathSetting
    @ImageType NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (1)
        ImagePreName,
        ImagePath
    FROM dbo.tbl_ImagePath_Setting WITH (NOLOCK)
    WHERE ImageType = @ImageType
      AND IsActive = 1
    ORDER BY ImagePathId;
END
