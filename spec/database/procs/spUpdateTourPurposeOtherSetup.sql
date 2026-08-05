CREATE PROCEDURE [dbo].[spUpdateTourPurposeOtherSetup]
    @TourPurposeOtherSetupId INT,      -- The ID of the record to update (required)
    @VisitTypeId INT = NULL,           -- The VisitTypeId to update (optional)
    @TourPurposeId INT = NULL,         -- The TourPurposeId to update (optional)
    @UpdateBy NVARCHAR(50)             -- The user performing the update (required)
AS
BEGIN
    -- Begin transaction to ensure atomicity
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Perform the update, setting new values only if they are provided
        UPDATE [dbo].[tblTourPurposeOtherSetup]
        SET
            VisitTypeId = ISNULL(@VisitTypeId, VisitTypeId),  -- Only update if a new value is provided
            TourPurposeId = ISNULL(@TourPurposeId, TourPurposeId),  -- Only update if a new value is provided
            UpdateBy = @UpdateBy,
            UpdateDate = GETDATE()  -- Automatically set UpdateDate to the current date/time
        WHERE
            TourPurposeOtherSetupId = @TourPurposeOtherSetupId;

        -- Check if any row was affected
        IF @@ROWCOUNT = 0
        BEGIN
            -- If no row was updated, raise an error
            RAISERROR ('No record found with the provided TourPurposeOtherSetupId.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Commit transaction if everything is successful
        COMMIT TRANSACTION;

        -- Return success message
        SELECT 'Update successful' AS Message;

    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;

        -- Optionally handle the error, e.g., log it or raise an error message
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

        RETURN;
    END CATCH
END
