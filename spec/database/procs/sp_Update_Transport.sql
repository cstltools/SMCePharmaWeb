
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Transport]
	-- Add the parameters for the stored procedure here
    @TransportId   INT = 0 ,
    @TransportName NVARCHAR(MAX) ,
	@AllowedMilagePerKM Decimal(18,2),
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT 

AS
    BEGIN
        UPDATE  [dbo].tbl_Transport
        SET     TransportName = @TransportName,
		        AllowedMilagePerKM =@AllowedMilagePerKM,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive 
        
        WHERE   TransportId = @TransportId   

    END

