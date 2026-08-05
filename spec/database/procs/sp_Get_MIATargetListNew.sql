-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_MIATargetListNew]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = ' SELECT pro.ProductCode+'' ; ''+ pro.ProductName ProductName,  CASE  WHEN  ENTR.EmpName Is Null  THEN  ENUS.UserName 
		ELSE ENTR.EmpName  
		END as EntryBy,   
		  CONVERT(NVARCHAR(20),mas.EntryDate,106) EntryDate, * FROM dbo.tblMIATargetProductWise mas WITH (NOLOCK)
LEFT JOIN tblUser AS ENUS ON ENUS.UserId = mas.EntryBy
 
		LEFT JOIN tblEmpGeneralInfo AS ENTR ON ENTR.EmpInfoId = ENUS.EmpInfoId
		LEFT JOIN dbo.tblProduct AS pro ON pro.ProductId =mas.ProductId

 
 WHERE mas.MiaTargetId IS NOT NULL  '+  @param
 
END

EXEC (@Query)
 

