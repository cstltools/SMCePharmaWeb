CREATE PROCEDURE [dbo].[sp_GET_TherapueticGroupActiveForDDL] 


AS
BEGIN
	

	 Select  TherapeuticGroupId, TherapeuticGroupName from tblTherapeuticGroup where IsActive = 1

END
