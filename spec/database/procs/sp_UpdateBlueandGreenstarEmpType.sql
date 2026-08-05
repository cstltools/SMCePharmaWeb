-- =============================================
-- =============================================
create PROCEDURE [dbo].[sp_UpdateBlueandGreenstarEmpType] 

	
AS
BEGIN

update tblInvoice set [GreenStarBlueStarID]=1 where Types='Blue Star' 
update tblInvoice set [GreenStarBlueStarID]=1 where Types='BSP'
update tblInvoice set [GreenStarBlueStarID]=2 where Types='Green Star'
update tblInvoice set [GreenStarBlueStarID]=3 where Types='Pink Star ' or Types='General' or Types='General' or Types is null or Types ='' or Types ='Genarel   '   or Types ='General'



--                select * from tblInvoice where [GreenStarBlueStarID] is null

	
END
