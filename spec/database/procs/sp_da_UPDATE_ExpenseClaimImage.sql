
CREATE   PROCEDURE dbo.sp_da_UPDATE_ExpenseClaimImage
    @ExpenseClaimID INT,
    @ImageName NVARCHAR(50),
    @ImagePath NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.tbl_ExpenseClaim
    SET ImageName = @ImageName,
        ImagePath = @ImagePath
    WHERE ExpenseClaimID = @ExpenseClaimID;
END
