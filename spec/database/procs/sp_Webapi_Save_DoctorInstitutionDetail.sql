-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorInstitutionDetail]
	-- Add the parameters for the stored procedure here
    @masterId INT = NULL ,
    @itemName NVARCHAR(MAX) = NULL
AS
    BEGIN


        DECLARE @dgId INT 


        SELECT  @dgId = InstitutionId
        FROM    dbo.tblInstitutionInfo
        WHERE   Institution = @itemName


		IF(@dgId IS NOT NULL)
		BEGIN
			    INSERT  INTO dbo.tblDoctorInstitutionDetail
                ( DoctorId, InstitutionId )
        VALUES  ( @masterId, @dgId )
		END






    END

