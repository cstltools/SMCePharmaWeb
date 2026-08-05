CREATE PROCEDURE [dbo].[spInsertTourPurposeOtherSetup]
@TourPurposeOtherSetupId int out,
    @VisitTypeId INT,
    @TourPurposeId INT,
    @EntryBy NVARCHAR(50),
	@IsActive bit
AS
BEGIN
    -- Begin transaction to ensure atomicity
    BEGIN TRY
        BEGIN TRANSACTION;

		declare @MasterId int=0




		select @MasterId=isnull (TourPurposeOtherSetupId,0) from tblTourPurposeOtherSetup where  TourPurposeId=@TourPurposeId

		if(@MasterId>0)
		begin

	  delete from tblTourPurposeOtherSetup where TourPurposeOtherSetupId= 	@MasterId
	  delete from tblTourPurposeOtherSetupDtl where TourPurposeOtherSetupId= 	@MasterId

		end
		

        -- Insert the data into tblTourPurposeOtherSetup
        INSERT INTO [dbo].[tblTourPurposeOtherSetup] 
        (
            VisitTypeId,
            TourPurposeId,
            EntryBy,
            EntryDate, IsActive
        )
        VALUES
        (
            @VisitTypeId,
            @TourPurposeId,
            @EntryBy,
            GETDATE(),@IsActive  -- Automatically set the EntryDate to the current date/time
        );

        -- Get the last inserted identity value (TourPurposeOtherSetupId)
        DECLARE @NewId INT;
        SET @NewId = SCOPE_IDENTITY();

        -- Commit transaction if everything is successful
        COMMIT TRANSACTION;

        -- Return the newly inserted ID
        SELECT @NewId AS TourPurposeOtherSetupId;

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
