create PROCEDURE [dbo].[sp_Get_SAP_IntrigationPointHeader]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
    select 'Product'  Title, 'N-1, Up-2' ValueName  union all

    select 'Challan WH to Branch'  Title, '2' ValueName   union all
    select 'Challan Branch to Branch'  Title, '3' ValueName   union all

    select 'DZSM Info'  Title, 'N-1, Up-2' ValueName   union all
    select 'AM Info'  Title, 'N-1, Up-2' ValueName   union all
    select 'MIO Info'  Title, 'N-1, Up-2' ValueName  




END
             

			  