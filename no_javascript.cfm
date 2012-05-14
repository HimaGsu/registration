<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--<meta http-equiv="X-UA-Compatible" content="IE=7;FF=3;OtherUA=4" /> -->
<title>Registration Adjustment Form</title>
<link href="/ApplicationTemplateCSS/css/960.css" rel="stylesheet" type="text/css">
<link href="/ApplicationTemplateCSS/css/layout.css" rel="stylesheet" type="text/css">
<link href="/ApplicationTemplateCSS/fonts/m_plus/stylesheet.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js_funcs.js"></script>
<style type="text/css">
	.error {color:red;}
</style>
<script type="javascript"></script>
</head>

<body>
	
		
<div class="wrapper">
  <div class="container_16" id="header">
    <div class="grid_6"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University" class="logo">
      <div class="appname">Office of<br>
        the Registrar</div>
    </div>
    <div class="grid_10 toolbar"><cfif isDefined("Cookie.login_name_gradechange")>Logged in as: <cfoutput>#Cookie.login_name_gradechange#</cfoutput> | <!---<a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a> | ---><a href="index.cfm?logout=true">LOGOUT</a></cfif></div>
  </div>
  <div class="clear"></div>
 
  <div class="container_16 page">
   
  <div class="clear"></div>
  <div class="container_16 page">
    <div class="grid_16" id="app">
	
	<br>
    
    
    <br /><br />
   <h3>Sorry, you must have javascript enabled to use this page.</h3>
   <p>Please enable your javascript in your browser's settings and then <a href="index.cfm">try again</a>.  Thank you!</p>
	<br /><br /><br />
	</div>
    <div class="clear"></div>
  </div>
  <div class="clear"></div>
  <div class="container_16 footer">
    <div class="grid_16" style="width:100%;" align="center">
	
	 <cfinvoke component="gradeChange" method="showPageFooter" />
	
	</div>
  </div>
  <div class="clear"></div>
</div>	
		
		

      
 
  <!-- Footer End -->
  <script type="text/javascript">
	var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
	try {
	var pageTracker = _gat._getTracker("UA-411467-1");
	pageTracker._trackPageview();
	} catch(err) {}</script>
</div>

</body>
</html>
