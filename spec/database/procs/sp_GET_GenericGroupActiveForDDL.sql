CREATE PROCEDURE [dbo].[sp_GET_GenericGroupActiveForDDL] 


AS
BEGIN
	

	 Select  GenericGroupId, GenericGroupName from tblGenericGroup where IsActive = 1

END
