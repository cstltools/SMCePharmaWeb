

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Rpt_DCRInfo_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

      SELECT dtl.EmpMasterCode+' : '+dtl.EmpName empInfo,  dgs.DesigName,  mas.Remarks, cham.Name ChamberName, docMas.DoctorCode+' : '+docMas.DoctorName DoctorName, tt.VisitTypeName TourTypeName, CASE WHEN prodtl.Type='Product' THEN 'Commercial' ELSE  prodtl.Type END Type, pro.ProductCode+' : '+pro.ProductName ProductName, emp.EmpMasterCode+' : '+emp.EmpName EmpName, convert(varchar,mas.DcrDate, 0)  DcrDate,  * FROM dbo.tbl_DCRInfo mas WITH (NOLOCK)
LEFT JOIN tbl_DcrDetails prodtl ON  mas.DcrId=prodtl.DcrId
left JOIN dbo.tbl_DoctorVisitType tt  WITH (NOLOCK)  ON tt.DocVisitTypeId = mas.TourTypeId
LEFT JOIN dbo.tblDoctorChemberDetail cham ON  cham.ChemberId=mas.ChemberId
LEFT JOIN dbo.tblProduct pro ON pro.ProductId = prodtl.ProductId
LEFT JOIN dbo.tblDoctorMaster docMas ON docMas.DoctorId = mas.DoctorId
LEFT JOIN dbo.tbl_DcrVisitedWithDetails vis ON  vis.DcrId=mas.DcrId
LEFT JOIN dbo.tblEmpGeneralInfo emp ON  vis.EmpInfoId=emp.EmpInfoId


left JOIN dbo.tblUser us ON us.UserId = mas.Entryby
left JOIN dbo.tblEmpGeneralInfo dtl ON dtl.EmpInfoId = us.EmpInfoId
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = dtl.DesignationId

 where mas.DcrId = @id
    END


