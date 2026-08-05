-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_RouteInformationDADetail]
	-- Add the parameters for the stored procedure here
	 

@RouteInformationMasterId  INT,
@DAId  INT 
AS
    BEGIN
	
    INSERT INTO [dbo].tblRouteInformationDADetail
           (RouteInformationMasterId
           ,DAId
            )
     VALUES
           (@RouteInformationMasterId 
           ,@DAId 
          )

 

END

