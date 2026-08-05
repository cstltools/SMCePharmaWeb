
-- =============================================
-- Author: <Author,Nasa>
-- Create date: <Create Date,02/08/2016,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GET_MenuHTML] 

 @userId int
 
AS
BEGIN
 SELECT dbo.MainMenu(@userId) AS MenuHTML
END

