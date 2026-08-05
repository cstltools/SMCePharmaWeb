-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorTypeDetail]
	-- Add the parameters for the stored procedure here
    @masterId INT = NULL ,
    @itemName NVARCHAR(MAX) = NULL
AS
    BEGIN


        DECLARE @dgId INT 


        SELECT  @dgId = ProgramTypeId
        FROM    dbo.tblDoctorProgramType
        WHERE   ProgramType = @itemName


        INSERT  INTO dbo.tblDoctorProgramTypeDetail
                ( DoctorId, ProgramTypeId )
        VALUES  ( @masterId, @dgId )


    END

