<!---<cferror type="request" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">--->

  
<cfapplication name="gradeChangeAdjustment" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
     
    
<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/registration_adjustment"></cfif>
  
<cfoutput><cfif not isDefined("URL.refresh") and isDefined("Form.username") and not isDefined("URL.error_occurred")>
	<script>
	var URL=document.location;
	if (location.search.indexOf("?")==-1) 
		URL=URL+"?";
	else URL=URL+"&";
	URL=URL+"refresh=true";
	document.location=URL;
	</script>
</cfif></cfoutput>
       
<cfif isDefined("URL.logout")>
	<cfset Session.admin_appstatus_user="">
	<cfset Session.student_id="">
	<cfset Session.studentLevel="">
    <cfset cookie.UserAuth_gradechange=false>
	<cfcache action="flush" timespan="0" directory="c:/Inetpub/wwwroot/applicantstatus/">
</cfif>

<cfif not isDefined("cookie.UserAuth_gradechange") or cookie.UserAuth_gradechange eq false or isDefined("URL.logout")>
	<cflocation url="login.cfm?requested_page=home" addtoken="no">
</cfif>

<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
	<!---<cfset Session.odatasource="hsguidanceoracle_student">--->
    <cfset Session.odatasource="B8DEVORACLE_HS">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<!---<cfset Session.odatasource="hsguidanceoracle_student">--->
    <cfset Session.odatasource="hsguidanceoracle">
</cfif>

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
<noscript><meta http-equiv="refresh" content=".1;url=no_javascript.cfm" ></noscript>
</head>

<body>
				
<!---<cfif not isDefined("Cookie.counselor_name")><cflocation addtoken="no" url="index.cfm?logout=true" /></cfif>--->
		
<div class="wrapper">
  <div class="container_16" id="header">
    <div class="grid_6"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University" class="logo">
      <div class="appname">Office of<br>
        the Registrar</div>
    </div>
    <div class="grid_10 toolbar">Logged in as: <cfoutput>#Cookie.login_name_gradechange#</cfoutput> | <!---<a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a> | ---><a href="index.cfm?logout=true">LOGOUT</a></div>
  </div>
  <div class="clear"></div>
 
  <div class="container_16 page">
   
  <div class="clear"></div>
  <div class="container_16 page">
    <div class="grid_16" id="app">
	
	<br>
    
    
    
    <cfset gsu_affiliation=LCase(Cookie.type_gradechange)>
    <cfif ListFind(gsu_affiliation, "staff", ", ") gt 0 or ListFind(gsu_affiliation, "faculty", ", ") gt 0>
		<cfif isDefined("Form.submitGradeAdjustment")>
        	<cfinvoke component="gradeChange" method="submitGradeAdjustmentForm" />
        <cfelse>
        	<cfinvoke component="gradeChange" method="showGradeAdjustmentForm" />
        </cfif>
    <cfelse>
    	<br /><cfoutput><p>#Cookie.type_gradechange#</p></cfoutput><p>Sorry, this system is only available to faculty and staff! Thank you.</p><br /><br /><br />
    </cfif>
	
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
