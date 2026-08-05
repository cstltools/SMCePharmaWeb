create PROCEDURE [dbo].[sp_GET_MainMenuRole]
	-- Add the parameters for the stored procedure here
   @RoleId INT

AS
    BEGIN
	---RoleId,tblMenuRole.[Add] AS RAdd,tblMenuRole.[View] AS RView,tblMenuRole.[Delete] AS RDelete,tblMenuRole.Edit AS REdit
	SELECT tblt.SL,
           tblt.ManuName,
           tblt.URL,
           tblt.ParantId,
           ISNULL(tblt.[Add],0)[Add],
           ISNULL(tblt.[View],0)[View],
           ISNULL(tblt.[Delete],0)[Delete],
           ISNULL(tblt.Edit,0)Edit,
           tblt.ParentName,
           SUM(CONVERT(INT,ISNULL(tblt.RoleId,0)))RoleId,
           SUM(CONVERT(INT,ISNULL(tblt.RAdd,0)))RAdd,
           SUM(CONVERT(INT,ISNULL(tblt.RView,0)))RView,
           SUM(CONVERT(INT,ISNULL(tblt.RDelete,0)))RDelete,
           SUM(CONVERT(INT,ISNULL(tblt.REdit,0)))REdit,SUM(CONVERT(INT,ISNULL(tblt.Permission,0)))Permission FROM (SELECT M.SL,M.ManuName,M.URL,M.ParantId,M.[Add],M.[View],M.[Delete],M.Edit,P.ManuName AS ParentName,
	'0'RoleId,'0' AS RAdd,'0' AS RView,'0' AS RDelete,'0' AS REdit,'0' AS  Permission
	 FROM dbo.tblMainMenu M
	LEFT JOIN dbo.tblMainMenu P ON M.ParantId=P.SL
	
	WHERE M.URL<>'#' and M.SL not in (select SL from tblMenuRole where RoleId=@RoleId)

	UNION ALL 

	SELECT M.SL,M.ManuName,M.URL,M.ParantId,M.[Add],M.[View],M.[Delete],M.Edit,P.ManuName AS ParentName,
	RoleId,tblMenuRole.[Add] AS RAdd,tblMenuRole.[View] AS RView,tblMenuRole.[Delete] AS RDelete,tblMenuRole.Edit AS REdit
	,tblMenuRole.Permission FROM dbo.tblMenuRole
	LEFT JOIN dbo.tblMainMenu M ON M.SL = tblMenuRole.SL
	LEFT JOIN dbo.tblMainMenu P ON M.ParantId=P.SL
	WHERE RoleId=@RoleId) AS tblt
	GROUP BY tblt.SL,
           tblt.ManuName,
           tblt.URL,
           tblt.ParantId,
           tblt.[Add],
           tblt.[View],
           tblt.[Delete],
           tblt.Edit,
           tblt.ParentName ORDER BY CONVERT(INT,tblt.ParantId) ASC


			
    END
