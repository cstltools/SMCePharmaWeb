-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_UserTracking]
	-- Add the parameters for the stored procedure here
    @empId INT =NULL,
    @latv NVARCHAR(MAX) =NULL,
    @longv NVARCHAR(MAX) =NULL,
    @addressName NVARCHAR(MAX)=NULL
AS
    BEGIN
	

        INSERT  INTO dbo.tbl_UserTracking
                ( EmpInfoId ,
                  LatValue ,
                  LongValue ,
                  AddressName ,
                  Time ,
                  TrackDate
	            )
        VALUES  ( @empId ,
                  @latv ,
                  @longv ,
                  @addressName ,
                  LTRIM(RIGHT(CONVERT(VARCHAR(50), GETDATE(), 100), 7)) ,
                  GETDATE()
                )

SELECT SCOPE_IDENTITY()

    END

