
create PROCEDURE [dbo].[sp_GET_InvoiceStatusddlAll]
	-- Add the parameters for the stored procedure here
  @isForSalesConfirm bit ,
  @IsShowforPartial bit ,
  @IsShowforRejection bit ,
  @IsforReturn bit 


AS
    BEGIN
	if(@isForSalesConfirm=1)
	begin

	if(@IsShowforPartial=1)
	begin
	SELECT  Value, Text
	FROM dbo.tblInvoiceStatusddl AS GRP WITH (NOLOCK)  where  isForSalesConfirm=@isForSalesConfirm and  IsShowforPartial=@IsShowforPartial
	end

	 else if(@IsShowforRejection=1)
	begin
	SELECT  Value, Text
	FROM dbo.tblInvoiceStatusddl AS GRP WITH (NOLOCK)  where  isForSalesConfirm=@isForSalesConfirm and   IsShowforRejection=@IsShowforRejection
	end
	 
	else
	begin
	SELECT  Value, Text
	FROM dbo.tblInvoiceStatusddl AS GRP WITH (NOLOCK)  where  isForSalesConfirm=@isForSalesConfirm
	end

	if(@IsforReturn=1)
	begin
	SELECT  Value, Text
	FROM dbo.tblInvoiceStatusddl AS GRP WITH (NOLOCK)  where  IsforReturn=@IsforReturn
	end

 END
 END
