
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetCustomerProviderTypeApproveList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
  select mas.ConvertType, case when emp.EmpInfoId is null then us.LoginName else emp.EmpMasterCode+' : '+emp.EmpName end  EmpEntryBy, FORMAT(mas.EntryDate,'dd-MMM-yyyy hh:mm tt')  EntryDate,*  from [dbo].[tblCustomerPropUpdateMaster] mas with (nolock)
  left join tbluser us on   us.UserId=mas.EntryBy
  left join tblEmpGeneralInfo emp on   emp.EmpInfoId=us.EmpInfoId
  where IsTransfer=0
   
END