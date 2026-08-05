-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Prescription_ByPrescriptionId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        SELECT  '../Prescription' + '/' + ImagePreName
                + CAST(mas.PrescriptionId AS NVARCHAR(MAX)) + '.jpg' PrescripImage ,
				(SELECT LTRIM(RTRIM(ImagePath+'\'+ImagePreName)) FROM dbo.tbl_ImagePath_Setting WHERE ImageType='Prescription')AS ImagePreName,

                *
        FROM    tbl_PrescriptionMaster mas ,
                tbl_ImagePath_Setting img
        WHERE   img.ImagePathId = 4
                AND PrescriptionId = @id

    END

