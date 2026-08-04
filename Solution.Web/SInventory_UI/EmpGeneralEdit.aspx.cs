using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_EmpGeneralEdit : System.Web.UI.Page
{
    EmpGeneralInfoBLL aInfoBll = new EmpGeneralInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DepartmentNameLoad();
            DesignationNameLoad();
            
            EmpInfoIdHiddenField.Value = Request.QueryString["ID"];
            EmpGeneralInfoLoad(EmpInfoIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (empNameTextBox.Text != "" && shortNameTextBox.Text != "" && fatherNameTextBox.Text != "" && motherNameTextBox.Text != "" && religionTextBox.Text != "" && nationalityTextBox.Text != ""
               && placeOfBirthTextBox.Text != "" && dateOfBirthTextBox.Text != "" && prtAddressTextBox.Text != "" && permAddressTextBox.Text != "" && bloodGroupTextBox.Text != "" && mobileNoTextBox.Text != ""
               && emailTextBox.Text != "" && nationalIdNoTextBox.Text != "" && sposNameTextBox.Text != "" && sposBirthDtTextBox.Text != "" && genderTextBox.Text != "" && maritalStatusTextBox.Text != "")
        {
            EmpGeneralInfo aEmpGeneralInfo = new EmpGeneralInfo()
            {
                EmpInfoId = Convert.ToInt32(EmpInfoIdHiddenField.Value),
                DesignationId= Convert.ToInt32(designationDropDownList.SelectedValue),
                DepartmentId = Convert.ToInt32(departmentDropDownList.SelectedValue),
                JoiningDate = Convert.ToDateTime(joiningDateTextBox.Text),
                EmpName = empNameTextBox.Text,
                ShortName = shortNameTextBox.Text,
                FatherName = fatherNameTextBox.Text,
                MotherName = motherNameTextBox.Text,
                Religion = religionTextBox.Text,
                Nationality = nationalityTextBox.Text,
                DateOfBirth = dateOfBirthTextBox.Text,
                PlaceOfBirth = placeOfBirthTextBox.Text,
                BloodGroup = bloodGroupTextBox.Text,
                Gender = genderTextBox.Text,
                AddressPresent = prtAddressTextBox.Text,
                AddressPermanent = permAddressTextBox.Text,
                MedicalInformation = medInfoTextBox.Text,
                PhoneNo = phoneNoTextBox.Text,
                CellNumber = mobileNoTextBox.Text,
                Email = emailTextBox.Text,
                MaritalStatus = maritalStatusTextBox.Text,
                NationalIdNo = nationalIdNoTextBox.Text,
    
                

            };
            EmpGeneralInfoBLL aEmpGeneralInfoBll = new EmpGeneralInfoBLL();

            if (!aEmpGeneralInfoBll.UpdateDataForEmpGeneralInfo(aEmpGeneralInfo))
            {
                MessageLabel.Text = "Data Not Update!!!";
                MessageLabel.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                MessageLabel.Text = "Data Update Successfully!!! Please Reload";
                MessageLabel.ForeColor = System.Drawing.Color.Green;
            }
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    private void EmpGeneralInfoLoad(string employeeId)
    {
        
        EmpGeneralInfo aInfo = new EmpGeneralInfo();

        aInfo = aInfoBll.EmpGeneralInfoEditLoad(employeeId);
        designationDropDownList.SelectedValue = Convert.ToString(aInfo.DesignationId);
        departmentDropDownList.SelectedValue = Convert.ToString(aInfo.DepartmentId);      
        empNameTextBox.Text = aInfo.EmpName;
        shortNameTextBox.Text = aInfo.ShortName;
        fatherNameTextBox.Text = aInfo.FatherName;
        motherNameTextBox.Text = aInfo.MotherName;
        religionTextBox.Text = aInfo.Religion;
        nationalityTextBox.Text = aInfo.Nationality;
        dateOfBirthTextBox.Text = aInfo.DateOfBirth;
        placeOfBirthTextBox.Text = aInfo.PlaceOfBirth;
        bloodGroupTextBox.Text = aInfo.BloodGroup;
        genderTextBox.Text = aInfo.Gender;
        prtAddressTextBox.Text = aInfo.AddressPresent;
        permAddressTextBox.Text = aInfo.AddressPermanent;
        medInfoTextBox.Text = aInfo.MedicalInformation;
        phoneNoTextBox.Text = aInfo.PhoneNo;
        mobileNoTextBox.Text = aInfo.CellNumber;
        emailTextBox.Text = aInfo.Email;
        maritalStatusTextBox.Text = aInfo.MaritalStatus;
        nationalIdNoTextBox.Text = aInfo.NationalIdNo;
        joiningDateTextBox.Text = aInfo.JoiningDate.ToString();
        empNameTextBox.Text = aInfo.EmpName;
        
    }


    public void DesignationNameLoad()
    {
        
        aInfoBll.LoadDesignationToDropDownBLL(designationDropDownList);
    }
    public void DepartmentNameLoad()
    {

        aInfoBll.LoadDepartmentToDropDownBLL(departmentDropDownList);
    }
    

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}