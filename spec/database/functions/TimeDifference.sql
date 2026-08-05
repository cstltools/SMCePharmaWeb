CREATE FUNCTION dbo.TimeDifference (@FromTime TIME(7), @ToTime TIME(7))
RETURNS VARCHAR(10)
AS BEGIN
    DECLARE @Diff INT = DATEDIFF(SECOND, @FromTime, @ToTime)

    DECLARE @DiffHours INT = @Diff / 3600;
    DECLARE @DiffMinutes INT = (@Diff % 3600) / 60;
    DECLARE @DiffSeconds INT = ((@Diff % 3600) % 60);

    DECLARE @ResultString VARCHAR(10)

    SET @ResultString = RIGHT('00' + CAST(@DiffHours AS VARCHAR(2)), 2) + ':' +
                        RIGHT('00' + CAST(@DiffMinutes AS VARCHAR(2)), 2) + ':' +
                        RIGHT('00' + CAST(@DiffSeconds AS VARCHAR(2)), 2)

    RETURN @ResultString
END
