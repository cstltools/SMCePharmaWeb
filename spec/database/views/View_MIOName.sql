CREATE VIEW dbo.View_MIOName
AS
SELECT dbo.tblEmpGeneralInfo.EmpMasterCode AS MIOCode, dbo.tblEmpGeneralInfo.ShortName AS MIOName
FROM     dbo.tblMIOInfo INNER JOIN
                  dbo.tblEmpGeneralInfo ON dbo.tblMIOInfo.EmployeeId = dbo.tblEmpGeneralInfo.EmpInfoId
