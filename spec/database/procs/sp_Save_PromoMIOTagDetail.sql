-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_PromoMIOTagDetail]
	-- Add the parameters for the stored procedure here
	 

@MIOTagId  INT,
 
@MIOId  INT,
@EmpInfoId  INT 
AS
    BEGIN
	
    INSERT INTO dbo.tblPromoMIOTagDetail
                                (
                                    MIOTagMasterId,
                                    MIOId,EmpInfoId
                                )
                                VALUES
                                ( @MIOTagId,@MIOId,@EmpInfoId) 
 

END

