using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;


public partial class HRM_UI_EmpGeneralInfo : System.Web.UI.Page
{
    EmpGeneralInfoBLL aInfoBll=new EmpGeneralInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hidAccordionIndex.Value = "3";
            DepartmentNameLoad();
            DesignationNameLoad();
        }      
    }

    protected void previewButton_Click(object sender, EventArgs e)
    {
        hidAccordionIndex.Value = "0";
        Session["ImageBytes"] = pictureFileUpload.FileBytes;
        pictureImage.ImageUrl = "~/PictureHandler.ashx";
    }

    protected void sigpreviewButton_Click(object sender, EventArgs e)
    {
        hidAccordionIndex.Value = "1";
        Session["SigImageBytes"] = sigFileUpload.FileBytes;
        signatureImage.ImageUrl = "~/SignutreHandler.ashx";
    }

    private void Clear()
    {            
            empNameTextBox.Text = string.Empty;
            shortNameTextBox.Text = string.Empty;
            fatherNameTextBox.Text = string.Empty;
            fatherNameTextBox.Text = string.Empty;
            motherNameTextBox.Text = string.Empty;
            religionTextBox.Text = string.Empty;
            nationalityTextBox.Text = string.Empty;
            dateOfBirthTextBox.Text = string.Empty;
            placeOfBirthTextBox.Text = string.Empty;
            bloodGroupDropDown.Text = "----Select----";
            genderDropDown.Text = "----Select----";
            maritalStatusDropDown.Text = "----Select----";
            permAddressTextBox.Text = string.Empty;
            prtAddressTextBox.Text = string.Empty;
            emailTextBox.Text = string.Empty;
            phoneNoTextBox.Text = string.Empty;
            mobileNoTextBox.Text = string.Empty;
            medicalTextBox.Text = string.Empty;
            pictureImage.ImageUrl = null;
            signatureImage.ImageUrl = null;
            nationalIdNoTextBox.Text = string.Empty;
            referanceNameTextBox.Text = string.Empty;
            refranceAddressTextBox.Text = string.Empty;
            refranceCellNoTextBox.Text = string.Empty;
            joiningDateTextBox.Text = string.Empty;
            departmentDropDownList.SelectedValue = null;
            designationDropDownList.SelectedValue = null;
            
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public void DesignationNameLoad()
    {
        aInfoBll.LoadDesignationToDropDownBLL(designationDropDownList);
    }
    public void DepartmentNameLoad()
    {
        aInfoBll.LoadDepartmentToDropDownBLL(departmentDropDownList);
    }
    public void RefDetail()
    {
        if (referanceNameTextBox.Text=="N/A")
        {
            refranceAddressTextBox.Text = "N/A";
            refranceCellNoTextBox.Text = "N/A";
            hidAccordionIndex.Value = "1";
        }
        hidAccordionIndex.Value = "1";
    }

    private bool Validation()
    {
        if (empNameTextBox.Text == "")
        {
            showMessageBox("Please Input Employee Name!!");
            return false;
        }
        if (shortNameTextBox.Text == "")
        {
            showMessageBox("Please Input  Employee Short Name!!");
            return false;
        }

        if (fatherNameTextBox.Text == "")
        {
            showMessageBox("Please Input Father Name!!");
            return false;
        }
        if (motherNameTextBox.Text == "")
        {
            showMessageBox("Please Input Mother Name!!");
            return false;
        }
        if (religionTextBox.Text == "")
        {
            showMessageBox("Please Input Religion!!");
            return false;
        }

        if (nationalityTextBox.Text == "")
        {
            showMessageBox("Please Input nationality!!");
            return false;
        }
        if (dateOfBirthTextBox.Text == "")
        {
            showMessageBox("Please Input Date Of Birth!!");
            return false;
        }
        if (placeOfBirthTextBox.Text == "")
        {
            showMessageBox("Please Input Place Of Birth !!");
            return false;
        }

        if (prtAddressTextBox.Text == "")
        {
            showMessageBox("Please Input Present Address!!");
            return false;
        }
        if (permAddressTextBox.Text == "")
        {
            showMessageBox("Please Input Permanent Address!!");
            return false;
        }
        if (nationalIdNoTextBox.Text == "")
        {
            showMessageBox("Please Input National Id!!");
            return false;
        }

        if (genderDropDown.Text == "")
        {
            showMessageBox("Please Input gender!!");
            return false;
        }
        if (bloodGroupDropDown.Text == "")
        {
            showMessageBox("Please Input Blood Group!!");
            return false;
        }

        if (maritalStatusDropDown.Text == "")
        {
            showMessageBox("Please Input Marital Status!!");
            return false;
        }
        if (designationDropDownList.Text == "")
        {
            showMessageBox("Please Input Designation!!");
            return false;
        }

        if (departmentDropDownList.Text == "")
        {
            showMessageBox("Please Input Department!!");
            return false;
        }
        if (mobileNoTextBox.Text == "")
        {
            showMessageBox("Please Input Mobile No!!");
            return false;
        }

        if (emailTextBox.Text == "")
        {
            showMessageBox("Please Input Email!!");
            return false;
        }
        if (joiningDateTextBox.Text == "")
        {
            showMessageBox("Please Input joining Date!!");
            return false;
        }
        
        return true;
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        EmpGeneralInfo aInformation = new EmpGeneralInfo();
        FileUpload img = (FileUpload)pictureFileUpload;
        FileUpload sigimage = (FileUpload)sigFileUpload;
        if (img.HasFile && img.PostedFile != null && sigimage.HasFile && sigimage.PostedFile != null)
        {
            HttpPostedFile sigFile = sigFileUpload.PostedFile;
            HttpPostedFile File = pictureFileUpload.PostedFile;
            aInformation.EmpImage = new Byte[File.ContentLength];
            aInformation.SignatureImage = new Byte[sigFile.ContentLength];
            File.InputStream.Read(aInformation.SignatureImage, 0, File.ContentLength);
            File.InputStream.Read(aInformation.EmpImage, 0, sigFile.ContentLength);
        }

        if (Validation() == true)
        {
            EmpGeneralInfo employeeInformation = new EmpGeneralInfo()

            {
                EmpName = empNameTextBox.Text,
                ShortName = shortNameTextBox.Text,
                FatherName = fatherNameTextBox.Text,
                MotherName = motherNameTextBox.Text,
                Religion = religionTextBox.Text,
                Nationality = nationalityTextBox.Text,
                DateOfBirth = dateOfBirthTextBox.Text,
                PlaceOfBirth = placeOfBirthTextBox.Text,
                BloodGroup = bloodGroupDropDown.Text,
                Gender = genderDropDown.Text,
                AddressPresent = prtAddressTextBox.Text,
                AddressPermanent = permAddressTextBox.Text,
                MedicalInformation = medicalTextBox.Text,
                PhoneNo = phoneNoTextBox.Text,
                CellNumber = mobileNoTextBox.Text,
                Email = emailTextBox.Text,
                MaritalStatus = maritalStatusDropDown.SelectedItem.Text,
                NationalIdNo = nationalIdNoTextBox.Text,
                ReferanceName = referanceNameTextBox.Text,
                ReferanceAddress = refranceAddressTextBox.Text,
                ReferanceCellNo = refranceCellNoTextBox.Text,
                DepartmentId = Convert.ToInt32(departmentDropDownList.SelectedValue),
                JoiningDate = Convert.ToDateTime(joiningDateTextBox.Text),
                Designation = designationDropDownList.SelectedItem.Text,
                DesignationId = Convert.ToInt32(designationDropDownList.SelectedValue),
                DeptName = departmentDropDownList.SelectedItem.Text
               
            };
            EmpGeneralInfoBLL employeeBll = new EmpGeneralInfoBLL();

            MessageLabel.Text = employeeBll.SaveDataFoEmployeeInfo(employeeInformation);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please Input Data In All TextBox!";
        }
    }
   
    protected void empViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("EmpGenInfView.aspx");
    }


    protected void referanceNameTextBox_TextChanged(object sender, EventArgs e)
    {
        hidAccordionIndex.Value = "1";
        RefDetail();
    }
}