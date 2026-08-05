CREATE FUNCTION dbo.fn_GetTotalCountForEmployee
(
    @currentDate DATETIME,
    @EmpId INT
)
RETURNS @resultTable TABLE
(
    TotalOrder DECIMAL(18,2),
    totalDcr INT,
    TotalRX INT
)
AS
BEGIN
    DECLARE @UserId INT
    DECLARE @TotalOrder DECIMAL(18,2) = 0
    DECLARE @totalDcr INT = 0
    DECLARE @TotalRX INT = 0

    -- Get the UserId based on EmpId
    SELECT @UserId = UserId 
    FROM tbluser 
    WHERE empInfoid = @EmpId

    -- Calculate TotalOrder
    SELECT @TotalOrder = CONVERT(DECIMAL(18,2), ISNULL(SUM(GrossValue - TotalDiscount), 0))
    FROM dbo.tblOrder WITH (NOLOCK)
    WHERE EntryBy = @UserId AND CONVERT(DATE, SubmissionDate) = CONVERT(DATE, @currentDate)

    -- Calculate totalDCR
    SELECT @totalDcr = ISNULL(COUNT(*), 0)
    FROM dbo.tbl_DCRInfo WITH (NOLOCK)
    WHERE EntryBy = @UserId AND CONVERT(DATE, DcrDate) = CONVERT(DATE, @currentDate)

    -- Calculate TotalRX
    SELECT @TotalRX = ISNULL(COUNT(*), 0)
    FROM dbo.tbl_PrescriptionMaster WITH (NOLOCK)
    WHERE EntryBy = @UserId AND CONVERT(DATE, PrescriptionDate) = CONVERT(DATE, @currentDate)

    -- Insert results into the table variable
    INSERT INTO @resultTable (TotalOrder, totalDcr, TotalRX)
    VALUES (@TotalOrder, @totalDcr, @TotalRX)

    RETURN
END
