<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/NewMasterPage.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="UserProfile_UI_ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <style>
        

/*profile*/
.profile-sidebar {
    float: left;
    width: 300px;
    margin-right: 20px
}

.profile-content {
    overflow: hidden
}

.profile-sidebar-portlet {
    padding: 30px 0 0!important
}

.profile-userpic img {
    float: none;
    margin: 0 auto;
    width: 50%;
    height: 50%;
    -webkit-border-radius: 50%!important;
    -moz-border-radius: 50%!important;
    border-radius: 50%!important
}

.profile-usertitle {
    text-align: center;
    margin-top: 20px
}

.profile-usertitle-name {
    color: #5a7391;
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 7px
}


.profile-usertitle-nameDES {
    color: #5a7391;
    font-size: 18px;
     font-weight: 600;
    margin-bottom: 7px
}

.profile-usertitle-job {
    text-transform: uppercase;
    color: #5b9bd1;
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 7px
}

.profile-userbuttons {
    text-align: center;
    margin-top: 10px
}

.profile-userbuttons .btn {
    margin-right: 5px
}

.profile-userbuttons .btn:last-child {
    margin-right: 0
}

.profile-userbuttons button {
    text-transform: uppercase;
    font-size: 11px;
    font-weight: 600;
    padding: 6px 15px
}

.profile-usermenu {
    margin-top: 30px;
    padding-bottom: 20px
}

.profile-usermenu ul li {
    border-bottom: 1px solid #f0f4f7
}

.profile-usermenu ul li:last-child {
    border-bottom: none
}

.profile-usermenu ul li a {
    color: #93a3b5;
    font-size: 16px;
    font-weight: 400
}

.profile-usermenu ul li a i {
    margin-right: 8px;
    font-size: 16px
}

.profile-usermenu ul li a:hover {
    background-color: #fafcfd;
    color: #5b9bd1
}

.profile-usermenu ul li.active a {
    color: #5b9bd1;
    background-color: #f6f9fb;
    border-left: 2px solid #5b9bd1;
    margin-left: -2px
}

.profile-stat {
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f4f7
}

.profile-stat-title {
    color: #7f90a4;
    font-size: 25px;
    text-align: center
}

.profile-stat-text {
    color: #5b9bd1;
    font-size: 11px;
    font-weight: 800;
    text-align: center
}

.profile-desc-title {
    color: #7f90a4;
    font-size: 17px;
    font-weight: 600
}

.profile-desc-text {
    color: #7e8c9e;
    font-size: 14px
}

.profile-desc-link i {
    width: 22px;
    font-size: 19px;
    color: #abb6c4;
    margin-right: 5px
}

.profile-desc-link a {
    font-size: 14px;
    font-weight: 600;
    color: #5b9bd1
}

@media (max-width:991px) {
    .profile-sidebar {
        float: none;
        width: 100%!important;
        margin: 0
    }
    .profile-sidebar>.portlet {
        margin-bottom: 20px
    }
    .profile-content {
        overflow: visible
    }
}

.change-password-shell {
    min-height: 520px;
    padding: 28px;
    border-radius: 18px;
    background:
        radial-gradient(circle at top left, rgba(20, 184, 166, .22), transparent 34%),
        radial-gradient(circle at top right, rgba(79, 70, 229, .22), transparent 36%),
        linear-gradient(135deg, #f8fbff 0%, #eef7ff 48%, #f7fff9 100%);
    box-shadow: inset 0 1px 0 rgba(255,255,255,.8), 0 24px 70px rgba(15, 23, 42, .12);
}

.password-profile-card,
.password-form-card {
    height: 100%;
    border: 1px solid rgba(255,255,255,.75);
    border-radius: 18px;
    overflow: hidden;
    background: rgba(255,255,255,.78);
    box-shadow: 0 18px 45px rgba(15, 23, 42, .12);
    backdrop-filter: blur(12px);
}

.password-profile-card {
    padding: 28px 22px;
    color: #fff;
    background: linear-gradient(145deg, #0f766e 0%, #0ea5e9 52%, #4f46e5 100%);
}

.password-avatar {
    width: 112px;
    height: 112px;
    display: block;
    margin: 0 auto 18px;
    padding: 6px;
    border-radius: 50%;
    background: rgba(255,255,255,.28);
    box-shadow: 0 12px 35px rgba(15, 23, 42, .22);
}

.password-user-title {
    text-align: center;
    margin-bottom: 24px;
}

.password-user-title h4 {
    margin: 0;
    font-size: 20px;
    font-weight: 700;
    color: #fff;
}

.password-user-title span {
    display: block;
    margin-top: 4px;
    color: rgba(255,255,255,.82);
    font-size: 13px;
}

.password-profile-line {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    padding: 12px 0;
    border-top: 1px solid rgba(255,255,255,.22);
    font-size: 13px;
}

.password-profile-line strong {
    color: rgba(255,255,255,.72);
    font-weight: 600;
}

.password-profile-line span {
    color: #fff;
    text-align: right;
    font-weight: 700;
}

.password-form-card {
    padding: 30px;
}

.password-form-title {
    margin-bottom: 22px;
}

.password-form-title h3 {
    margin: 0 0 6px;
    color: #111827;
    font-size: 24px;
    font-weight: 800;
}

.password-form-title p {
    margin: 0;
    color: #64748b;
    font-size: 13px;
}

.password-field-label {
    color: #25364d;
    font-size: 13px;
    font-weight: 700;
}

.password-input-group {
    border: 1px solid #c8d5e8;
    border-radius: 10px;
    background: #fff;
    box-shadow: inset 0 1px 0 rgba(255,255,255,.85), 0 8px 18px rgba(15, 23, 42, .06);
    overflow: hidden;
}

.password-input-group .form-control {
    height: 44px;
    border: 0;
    box-shadow: none;
    font-size: 14px;
}

.password-input-group .input-group-text {
    border: 0;
    border-left: 1px solid #d8e3f2;
    background: linear-gradient(180deg, #ffffff 0%, #eef6ff 100%);
    color: #1e293b;
    cursor: pointer;
    min-width: 48px;
    justify-content: center;
}

.password-input-group.is-invalid {
    border-color: #ef4444;
    box-shadow: 0 0 0 3px rgba(239, 68, 68, .12);
}

.password-rule-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
    margin: 14px 0 10px;
}

.password-rule {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 12px;
    border: 1px solid #fecaca;
    border-radius: 9px;
    background: #fff1f2;
    color: #b91c1c;
    font-size: 12px;
    font-weight: 700;
}

.password-rule.is-valid {
    border-color: #bbf7d0;
    background: #ecfdf3;
    color: #047857;
}

.password-rule i {
    width: 14px;
}

.password-validation-message {
    display: block;
    min-height: 20px;
    color: #b91c1c;
    font-size: 12px;
    font-weight: 700;
}

.password-submit-btn {
    width: 100%;
    height: 46px;
    border: 0;
    border-radius: 10px;
    color: #fff !important;
    font-weight: 800;
    background: linear-gradient(135deg, #0f766e 0%, #0284c7 48%, #4f46e5 100%);
    box-shadow: 0 14px 28px rgba(37, 99, 235, .25), inset 0 1px 0 rgba(255,255,255,.38);
}

.password-submit-btn:hover,
.password-submit-btn:focus {
    color: #fff !important;
    transform: translateY(-1px);
    box-shadow: 0 18px 34px rgba(37, 99, 235, .32), inset 0 1px 0 rgba(255,255,255,.45);
}

@media (max-width: 767px) {
    .change-password-shell {
        padding: 16px;
    }

    .password-form-card {
        padding: 22px 16px;
    }

    .password-rule-grid {
        grid-template-columns: 1fr;
    }
}

    </style>
       <div class="content" id="content">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                   <asp:UpdateProgress ID="progress" runat="server" ClientIDMode="Static" DisplayAfter="0" DynamicLayout="true">
                    <ProgressTemplate>
                       
                        <div class="divWaiting">
                            <asp:Image ID="imgWait" CssClass="position-set" runat="server" ImageAlign="Middle" ImageUrl="../images/Spinner.gif" Width="180px" Height="180px" />
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <!-- PAGE HEADING -->
                
                

               
    <div class="page-wrapper">
        <div class="page-content">
            <!--breadcrumb-->
            <div class="page-breadcrumb d-none d-sm-flex align-items-center mb-3">
                <div class="breadcrumb-title pe-3"><i class="bx bx-customize"></i> Change Password </div>  

                <div class="ms-auto">
                    <div class="btn-group">
                        
                    </div>
                </div>
            </div>
            <!--end breadcrumb-->
            <div class="row">
                <div class="col">

                    <div class="card border-top border-0 border-4 border-success">
                        <div class="card-body">
                <!-- //END PAGE HEADING -->
                
             
             
       <style>
                    .imgshadow {
                      -webkit-box-shadow: 5px 5px 15px 5px #000000; 
box-shadow: 5px 5px 15px 5px #000000;
                    }
                     
                                                                                                 
                </style>
    

                 

                            <div class="change-password-shell">
                                <div class="row g-4 align-items-stretch">
                                    <div class="col-lg-4 mb-3 mb-lg-0">
                                        <div class="password-profile-card">
                                            <img src="../images/man.png" class="password-avatar" alt="">
                                            <div class="password-user-title">
                                                <h4><asp:Label runat="server" ID="lblshortName" /></h4>
                                                <span><asp:Label runat="server" ID="lblDesignation" /></span>
                                            </div>
                                            <div class="password-profile-line">
                                                <strong>ID</strong>
                                                <span><asp:Label runat="server" ID="lblID" /></span>
                                            </div>
                                            <div class="password-profile-line">
                                                <strong>Role</strong>
                                                <span><asp:Label runat="server" ID="lblRoleName" /></span>
                                            </div>
                                            <div class="password-profile-line">
                                                <strong>Status</strong>
                                                <span>Secure update</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-lg-8">
                                        <div class="password-form-card">
                                            <div class="password-form-title">
                                                <h3>Set New Password</h3>
                                                <p>Choose a strong password that is different from your current password.</p>
                                            </div>

                                            <div class="form-group">
                                                <label class="password-field-label">New Password <span style="color: #dc2626">*</span></label>
                                                <div class="input-group password-input-group" id="newPasswordGroup">
                                                    <asp:TextBox runat="server" AutoCompleteType="None" ID="txt_Password" TextMode="Password" MaxLength="20" CssClass="form-control"></asp:TextBox>
                                                    <span class="input-group-text password-toggle" data-target="<%= txt_Password.ClientID %>" title="Show password">
                                                        <i class="fa fa-eye"></i>
                                                    </span>
                                                </div>
                                                <div class="password-rule-grid">
                                                    <div class="password-rule" data-rule="length"><i class="fa fa-times"></i> 12 to 20 characters</div>
                                                    <div class="password-rule" data-rule="lower"><i class="fa fa-times"></i> At least 1 lowercase letter</div>
                                                    <div class="password-rule" data-rule="upper"><i class="fa fa-times"></i> At least 1 uppercase letter</div>
                                                    <div class="password-rule" data-rule="number"><i class="fa fa-times"></i> At least 1 numeric digit</div>
                                                    <div class="password-rule" data-rule="special"><i class="fa fa-times"></i> At least 1 special character</div>
                                                </div>
                                                <asp:RegularExpressionValidator ID="revPasswordStrength" runat="server" ErrorMessage="Password is not strong enough" CssClass="password-validation-message" Display="Dynamic" ControlToValidate="txt_Password" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$"></asp:RegularExpressionValidator>
                                                <asp:Label runat="server" ID="lblPasswordError" CssClass="password-validation-message"></asp:Label>
                                            </div>

                                            <div class="form-group">
                                                <label class="password-field-label">Confirm Password <span style="color: #dc2626">*</span></label>
                                                <div class="input-group password-input-group" id="confirmPasswordGroup">
                                                    <asp:TextBox runat="server" AutoCompleteType="None" ID="txtConfirm" TextMode="Password" MaxLength="20" CssClass="form-control"></asp:TextBox>
                                                    <span class="input-group-text password-toggle" data-target="<%= txtConfirm.ClientID %>" title="Show password">
                                                        <i class="fa fa-eye"></i>
                                                    </span>
                                                </div>
                                                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Password is not matched" CssClass="password-validation-message" Display="Dynamic" ControlToCompare="txt_Password" ControlToValidate="txtConfirm"></asp:CompareValidator>
                                            </div>

                                            <div class="form-group mt-4">
                                                <asp:LinkButton runat="server" ID="btn_Save" OnClick="btn_Save_OnClick" CssClass="btn password-submit-btn" OnClientClick="return validateChangePasswordClient() && sweetAlertConfirm_Update(this);"><i class="fa fa-refresh"></i> Update Password</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                    
                                    
                                     <div class="row">
                                <style>
                                    .tblTHColorChang{
                                        background-color: #EDF2F5!important;
                                        font-weight: bold;
                                        font-size: 13px;
                                    }


.title-widget {
	color: #898989;
	font-size: 20px;
	font-weight: 300;
	line-height: 1;
	position: relative;
	text-transform: uppercase;
	font-family: 'Fjalla One', sans-serif;
	margin-top: 0;
	margin-right: 0;
	margin-bottom: 25px;
	 
	padding-left: 12px;

}

.title-widget::before {
    background-color: #ea5644;
    content: "";
    height: 22px;
    left: 0px;
    position: absolute;
    top: -2px;
    width: 5px;
}


                                </style>
                                          

                            </div>

                        </div>
                    </div>
                </div>
                </div>
                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <script type="text/javascript">
        (function () {
            function byId(id) {
                return document.getElementById(id);
            }

            function setRule(rule, valid) {
                var item = document.querySelector('[data-rule="' + rule + '"]');
                if (!item) {
                    return;
                }

                var icon = item.querySelector('i');
                item.className = valid ? 'password-rule is-valid' : 'password-rule';
                if (icon) {
                    icon.className = valid ? 'fa fa-check' : 'fa fa-times';
                }
            }

            function updateRules() {
                var password = byId('<%= txt_Password.ClientID %>');
                var value = password ? password.value : '';

                setRule('length', value.length >= 12 && value.length <= 20);
                setRule('lower', /[a-z]/.test(value));
                setRule('upper', /[A-Z]/.test(value));
                setRule('number', /\d/.test(value));
                setRule('special', /[^A-Za-z\d]/.test(value));
            }

            function bindPasswordToggles() {
                var toggles = document.querySelectorAll('.password-toggle');
                for (var i = 0; i < toggles.length; i++) {
                    toggles[i].onclick = function () {
                        var input = byId(this.getAttribute('data-target'));
                        var icon = this.querySelector('i');
                        if (!input) {
                            return;
                        }

                        if (input.type === 'password') {
                            input.type = 'text';
                            this.title = 'Hide password';
                            if (icon) {
                                icon.className = 'fa fa-eye-slash';
                            }
                        } else {
                            input.type = 'password';
                            this.title = 'Show password';
                            if (icon) {
                                icon.className = 'fa fa-eye';
                            }
                        }
                    };
                }
            }

            function bindPasswordRules() {
                var password = byId('<%= txt_Password.ClientID %>');
                if (password) {
                    password.onkeyup = updateRules;
                    password.onchange = updateRules;
                }
                updateRules();
            }

            window.validateChangePasswordClient = function () {
                var password = byId('<%= txt_Password.ClientID %>');
                var confirm = byId('<%= txtConfirm.ClientID %>');
                var passwordGroup = byId('newPasswordGroup');
                var confirmGroup = byId('confirmPasswordGroup');
                var passwordError = byId('<%= lblPasswordError.ClientID %>');
                var valid = true;

                if (passwordGroup) {
                    passwordGroup.className = passwordGroup.className.replace(' is-invalid', '');
                }
                if (confirmGroup) {
                    confirmGroup.className = confirmGroup.className.replace(' is-invalid', '');
                }
                if (passwordError) {
                    passwordError.innerHTML = '';
                }

                if (!password || !/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$/.test(password.value)) {
                    if (passwordGroup && passwordGroup.className.indexOf('is-invalid') === -1) {
                        passwordGroup.className += ' is-invalid';
                    }
                    if (passwordError) {
                        passwordError.innerHTML = password && password.value ? 'Password is not strong enough' : 'Please enter new password';
                    }
                    valid = false;
                }

                if (!confirm || confirm.value === '' || (password && password.value !== confirm.value)) {
                    if (confirmGroup && confirmGroup.className.indexOf('is-invalid') === -1) {
                        confirmGroup.className += ' is-invalid';
                    }
                    valid = false;
                }

                if (typeof (Page_ClientValidate) === 'function') {
                    valid = Page_ClientValidate() && valid;
                }

                return valid;
            };

            function initChangePasswordUi() {
                bindPasswordToggles();
                bindPasswordRules();
            }

            if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initChangePasswordUi);
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initChangePasswordUi);
            } else {
                initChangePasswordUi();
            }
        })();
    </script>
</asp:Content>

