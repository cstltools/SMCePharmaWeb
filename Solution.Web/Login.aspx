<%@ Page Title="ePharma || Login" Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>ePharma ||Login </title>
     
 <link href="VerticalAsset/plugins/simplebar/css/simplebar.css" rel="stylesheet" />
	<link href="VerticalAsset/plugins/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet" />
	<link href="VerticalAsset/plugins/metismenu/css/metisMenu.min.css" rel="stylesheet" />
	<!-- loader-->
	<link href="VerticalAsset/css/pace.min.css" rel="stylesheet" />
	<script src="VerticalAsset/js/pace.min.js"></script>
	<!-- Bootstrap CSS -->
	<link href="VerticalAsset/css/bootstrap.min.css" rel="stylesheet">
	<link href="VerticalAsset/css/bootstrap-extended.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&amp;display=swap" rel="stylesheet">
	<link href="VerticalAsset/css/app.css" rel="stylesheet">
	<link href="VerticalAsset/css/icons.css" rel="stylesheet">

    	<script src="VerticalAsset/js/bootstrap.bundle.min.js"></script>
	<!--plugins-->
	<script src="VerticalAsset/js/jquery.min.js"></script>
	<script src="VerticalAsset/plugins/simplebar/js/simplebar.min.js"></script>
	<script src="VerticalAsset/plugins/metismenu/js/metisMenu.min.js"></script>
	<script src="VerticalAsset/plugins/perfect-scrollbar/js/perfect-scrollbar.js"></script>
	<!--Password show & hide js -->
	<script>
		$(document).ready(function () {
			$("#show_hide_password a").on('click', function (event) {
				event.preventDefault();
				if ($('#show_hide_password input').attr("type") == "text") {
					$('#show_hide_password input').attr('type', 'password');
					$('#show_hide_password i').addClass("bx-hide");
					$('#show_hide_password i').removeClass("bx-show");
				} else if ($('#show_hide_password input').attr("type") == "password") {
					$('#show_hide_password input').attr('type', 'text');
					$('#show_hide_password i').removeClass("bx-hide");
					$('#show_hide_password i').addClass("bx-show");
				}
			});
		});
	</script>
	<!--app JS-->
	<script src="VerticalAsset/js/app.js"></script>

	<style>
		:root {
			--login-navy: #14213d;
			--login-blue: #1f6feb;
			--login-teal: #12b3a8;
			--login-gold: #f4b942;
			--login-ink: #1f2937;
			--login-muted: #6b7280;
			--login-border: rgba(255, 255, 255, 0.42);
		}

		body {
			min-height: 100vh;
			background:
				radial-gradient(circle at 18% 16%, rgba(244, 185, 66, 0.28), transparent 28%),
				radial-gradient(circle at 78% 18%, rgba(18, 179, 168, 0.30), transparent 30%),
				linear-gradient(135deg, #0f172a 0%, #17406f 44%, #0f766e 100%);
			color: var(--login-ink);
			overflow-x: hidden;
		}

		.authentication-header {
			display: none;
		}

		.section-authentication-signin {
			min-height: 100vh;
			position: relative;
			padding: 24px 12px;
			overflow: hidden;
		}

		.section-authentication-signin:before {
			content: "";
			position: fixed;
			inset: 0;
			background:
				linear-gradient(115deg, rgba(255,255,255,0.18), rgba(255,255,255,0.02) 42%, rgba(255,255,255,0.16)),
				repeating-linear-gradient(135deg, rgba(255,255,255,0.08) 0, rgba(255,255,255,0.08) 1px, transparent 1px, transparent 14px);
			pointer-events: none;
		}

		.login-shell {
			position: relative;
			z-index: 1;
		}

		.login-card {
			position: relative;
			border: 1px solid var(--login-border);
			border-radius: 18px;
			background:
				linear-gradient(155deg, rgba(255,255,255,0.98) 0%, rgba(246,251,255,0.92) 48%, rgba(232,245,255,0.86) 100%);
			box-shadow:
				0 34px 90px rgba(3, 12, 32, 0.42),
				0 10px 26px rgba(31, 111, 235, 0.16),
				inset 0 1px 0 rgba(255,255,255,0.98),
				inset 0 -1px 0 rgba(15, 23, 42, 0.06);
			backdrop-filter: blur(16px);
			overflow: hidden;
		}

		.login-card:before {
			content: "";
			display: block;
			height: 5px;
			background: linear-gradient(90deg, var(--login-blue), var(--login-teal), var(--login-gold));
		}

		.login-card:after {
			content: "";
			position: absolute;
			inset: 5px 1px auto 1px;
			height: 46%;
			background:
				linear-gradient(115deg, rgba(255,255,255,0.78), rgba(255,255,255,0.18) 46%, rgba(255,255,255,0.03) 70%),
				radial-gradient(circle at 28% 12%, rgba(255,255,255,0.95), transparent 34%);
			border-radius: 16px 16px 42% 42%;
			pointer-events: none;
		}

		.login-card .card-body {
			padding: 0;
		}

		.login-panel {
			position: relative;
			z-index: 1;
			padding: 34px 34px 28px;
		}

		.login-title {
			margin: 0;
			color: var(--login-navy);
			font-size: 30px;
			font-weight: 700;
			letter-spacing: 0;
		}

		.login-subtitle {
			margin-top: 6px;
			color: var(--login-muted);
			font-size: 14px;
			font-weight: 500;
		}

		.brand-logo-wrap {
			width: 118px;
			height: 118px;
			margin: 22px auto 26px;
			display: flex;
			align-items: center;
			justify-content: center;
			border-radius: 50%;
			background:
				linear-gradient(145deg, #ffffff 0%, #f3fbff 46%, #e4f4ff 100%);
			box-shadow:
				0 20px 42px rgba(31, 111, 235, 0.22),
				inset 0 2px 0 rgba(255,255,255,0.98),
				inset 0 -8px 18px rgba(31,111,235,0.08);
			border: 1px solid rgba(31, 111, 235, 0.14);
		}

		.brand-logo-wrap img {
			width: 84px;
			max-width: 84px;
		}

		.form-label {
			color: #334155;
			font-weight: 600;
			margin-bottom: 7px;
		}

		.form-control {
			min-height: 46px;
			border-radius: 10px;
			border-color: #d9e2ef;
			background: linear-gradient(180deg, rgba(255,255,255,0.98), rgba(247,251,255,0.92));
			box-shadow:
				inset 0 1px 2px rgba(15, 23, 42, 0.05),
				0 8px 18px rgba(15, 23, 42, 0.04);
		}

		.form-control:focus {
			border-color: var(--login-blue);
			box-shadow: 0 0 0 4px rgba(31, 111, 235, 0.13);
		}

		.input-group-text {
			border-radius: 0 10px 10px 0;
			border-color: #d9e2ef;
			color: var(--login-blue);
		}

		.login-button {
			min-height: 48px;
			border: 0;
			border-radius: 10px;
			font-weight: 700;
			background:
				linear-gradient(180deg, rgba(255,255,255,0.24), rgba(255,255,255,0) 38%),
				linear-gradient(135deg, #1f6feb 0%, #12b3a8 100%);
			box-shadow:
				0 16px 32px rgba(31, 111, 235, 0.34),
				inset 0 1px 0 rgba(255,255,255,0.46),
				inset 0 -8px 18px rgba(0,0,0,0.10);
		}

		.login-button:hover,
		.login-button:focus {
			background: linear-gradient(135deg, #185ac5 0%, #0f998f 100%);
			box-shadow: 0 16px 32px rgba(31, 111, 235, 0.34), inset 0 1px 0 rgba(255,255,255,0.34);
		}

		.apk-button {
			width: 100%;
			margin-top: 8px;
			border: 1px solid rgba(18, 179, 168, 0.24);
			border-radius: 10px;
			color: #0f766e;
			background: linear-gradient(145deg, rgba(236, 253, 245, 0.98), rgba(255, 255, 255, 0.86));
			font-weight: 700;
			box-shadow: inset 0 1px 0 rgba(255,255,255,0.9);
		}

		.apk-button:hover,
		.apk-button:focus {
			color: #0b5f59;
			border-color: rgba(18, 179, 168, 0.42);
			background: linear-gradient(145deg, #dcfce7, #ffffff);
		}

		#msgLabel {
			display: block;
			margin-top: 12px;
			border-radius: 10px;
			text-align: center;
		}

		@media (max-width: 575.98px) {
			.login-panel {
				padding: 28px 22px 24px;
			}

			.login-title {
				font-size: 26px;
			}
		}

		.capsule-bg {
			position: fixed;
			inset: 0;
			overflow: hidden;
			pointer-events: none;
			z-index: 0;
		}

		.capsule-bg span {
			position: absolute;
			bottom: -60px;
			display: inline-block;
			opacity: 0.55;
			animation-name: capsule-float;
			animation-timing-function: linear;
			animation-iteration-count: infinite;
			filter: drop-shadow(0 6px 10px rgba(0,0,0,0.18));
		}

		@keyframes capsule-float {
			0% {
				transform: translateY(0) rotate(0deg);
				opacity: 0;
			}
			10% {
				opacity: 0.55;
			}
			90% {
				opacity: 0.55;
			}
			100% {
				transform: translateY(-110vh) rotate(360deg);
				opacity: 0;
			}
		}
	</style>
</head>
<body  >

	<div class="capsule-bg" aria-hidden="true">
		<span style="left:4%; font-size:26px; animation-duration:16s; animation-delay:0s;">&#128138;</span>
		<span style="left:14%; font-size:18px; animation-duration:12s; animation-delay:2s;">&#128138;</span>
		<span style="left:24%; font-size:32px; animation-duration:20s; animation-delay:1s;">&#128138;</span>
		<span style="left:36%; font-size:20px; animation-duration:14s; animation-delay:4s;">&#128138;</span>
		<span style="left:48%; font-size:28px; animation-duration:18s; animation-delay:0.5s;">&#128138;</span>
		<span style="left:58%; font-size:16px; animation-duration:11s; animation-delay:3s;">&#128138;</span>
		<span style="left:68%; font-size:30px; animation-duration:19s; animation-delay:2.5s;">&#128138;</span>
		<span style="left:76%; font-size:22px; animation-duration:15s; animation-delay:5s;">&#128138;</span>
		<span style="left:86%; font-size:34px; animation-duration:22s; animation-delay:1.5s;">&#128138;</span>
		<span style="left:94%; font-size:20px; animation-duration:13s; animation-delay:3.5s;">&#128138;</span>
	</div>


	<div class="wrapper">
		<div class="authentication-header"></div>
		<div class="section-authentication-signin d-flex align-items-center justify-content-center my-5 my-lg-0">
			<div class="container-fluid">
				<div class="row row-cols-1 row-cols-lg-2 row-cols-xl-3">
					<div class="col mx-auto login-shell">
						<div class="mb-4 text-center">
						<%--	<img src="LoginAssets/images/smc.png" style="width: 180px;   " alt="Alternate Text" /> --%>
						<%--	<img src="assets/images/logo-img.png" width="180" alt="" />--%>
						</div>
						<div class="card login-card">
							<div class="card-body">
								<div class="login-panel">
									<div class="text-center">
										<h3 class="login-title">ePharma</h3>
										<div class="login-subtitle">Secure business access</div>
									</div>
									<div class="brand-logo-wrap">
											<img src="LoginAssets/images/smc.png" alt="SMC" /> 
									</div>
								 
									<div class="form-body">
										 <form id="Form1" runat="server" class="row g-3" defaultbutton="loginButton" >
									 
											<div class="col-12">
												<label for="inputEmailAddress" class="form-label">User Name</label>
												 
												   <asp:TextBox ID="userNameTextBox" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
											</div>
											<div class="col-12">
												<label for="inputChoosePassword" class="form-label">Enter Password</label>
												<div class="input-group" id="show_hide_password">

													  <asp:TextBox ID="passwordTextBox" runat="server" CssClass="form-control border-end-0" placeholder="Enter password"
            TextMode="Password"></asp:TextBox>
													 <a href="javascript:;" class="input-group-text bg-transparent"><i class='bx bx-hide'></i></a>
												</div>
											</div>
											
											<div class="col-12">
												<div class="d-grid">
													 
												 <asp:LinkButton ID="loginButton" runat="server"  CssClass="btn btn-primary login-button"
            OnClick="loginButton_Click"><i class="bx bxs-lock-open"></i>Sign in</asp:LinkButton>
													
													  <asp:Label style="padding:5px" ID="msgLabel" runat="server" Font-Size="Smaller"></asp:Label>
												</div>
											</div>
                                           
											 
												<div class="col-md-12 text-end">
												<a href="APK_File/ePharma_vr(16)_unity.apk"  download rel="noopener noreferrer" title="Click to download APK File" target="_blank" class="btn apk-button">Download ePharma Apps APK File (16)</a>

												</div>
											<div class="col-md-12 text-end">
												<a href="APK_File/sales_assitance_vr(2).apk"  download rel="noopener noreferrer" title="Click to download Sales Assistance APK File" target="_blank" class="btn apk-button">Download Sales Assistance APK File</a>

												</div>
										</form>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--end row-->
			</div>
		</div>
	</div>
   
   
</body>
</html>
