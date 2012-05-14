<CFCOMPONENT HINT="This component authenticates a student into LDAP.">




<CFFUNCTION name="verifyCampusID">
	<CFARGUMENT name="uid" required="Yes" type="string">
    <CFARGUMENT name="returnonly" required="no" default="">
       <cfset attributes = "uid,dn,recordcount">
	   <cfset filter="(uid=#uid#)">
	   <cfset filter="(&(|(eduPersonAffiliation=Faculty) (eduPersonAffiliation=Staff) (eduPersonAffiliation=Student) ) (uid=#uid#) )">
	   
	<cftry>
	       <cfldap
			server="auth.gsu.edu"
			action="query"
			name="userSearch"
			start="ou=people,ou=primary,ou=eid,dc=gsu,dc=edu"
			scope="SUBTREE"
			filter="#filter#"
			attributes="#attributes#"
			maxrows=50
			timeout=20000
			username="cn=generic-proxy,ou=proxies,dc=gsu,dc=edu"
        	password="b43jpq93##68wx"
        	secure="CFSSL_BASIC"
        	port="636"   
   	> 
	       <cfcatch type="Any">
	               <cfset UserSearchFailed = true>
				   <cfoutput>#cfcatch.message#aa</cfoutput>
				   <cfreturn false>
	       </cfcatch>              
	</cftry>
	
	
	<cfif NOT userSearch.recordcount>
		<cfif returnonly eq ""><span class="red">ERROR: The campus ID you entered does not exist. Please look at the note below and try again.<br><br></span></cfif>
		<cfreturn false>
	</cfif>
	
	<cfreturn true>
	
</CFFUNCTION>




<CFFUNCTION name="checkExpiration">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<cfargument name="userpassword" required="Yes" type="string">
	<CFARGUMENT NAME="system" required="Yes" type="string">
	<cfif trim(form.password) eq "" or trim(form.username) eq "">
	       <h2 class="error_message">Please do not leave any fields blank.</h2>
		   <cfinvoke method="loginForm" uid="#uid#" />
	       <cfreturn false>
	  </cfif>
	<cfset root = "ou=people,ou=primary,ou=eid,dc=gsu,dc=edu">
	<cfset filter="(uid=#uid#)">
    <cfif system eq "dev">
    	<cfset servername = "malak.gsu.edu">
		<cfset port = "389">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "6b43jzcdpr98">
    <cfelse>
		<cfset servername = "auth.gsu.edu">
       	<cfset port = "636">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "b43jpq93##68wx">
	</cfif>

   
       
       <!--- Attributes must include uid and dn.  These are used within the 2 authorization queries. ---> 
       
	   	<cfset attributes = "uid, dn, cn, recordcount, passwordexpirationtime, logingraceremaining, sn, givenName, eduPersonAffiliation, gsuPersonJobCode, gsupersonhighschool, gsupersonhighschoolcode">

	   
       
       <!--- this filter will look in the objectclass for the user's ID ---> 
       

		<cftry>
				<cfif servername eq "malak.gsu.edu">
				<!---<cfoutput>attributes: #attributes#<br>
				root: #root#<br>
				servername: #servername#<br>
				port: #port#<br>
				filter: #filter#<br>
				username: #username#<br>
				password: #password#<br><br></cfoutput>--->
		       <cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"> 
				<cfelse>
					<cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"
							   secure="CFSSL_BASIC"> 
				</cfif>
		       <cfcatch type="Any">
		               <cfset UserSearchFailed = true>
					   <cfoutput>#cfcatch.message#</cfoutput>
					   <cfreturn false>
		       </cfcatch>              
		</cftry>
		<cfif NOT userSearch.recordcount>
			<h2 class="error_message">ERROR - Invalid CampusID. Please try again.</h2>
			<cfinvoke method="loginForm" />
			<cfreturn false>
		</cfif>

		
		<!---<cfoutput>#userSearch.uid#, #userSearch.dn#, #userSearch.cn#, #userSearch.recordcount#, #userSearch.passwordexpirationtime#, #userSearch.logingraceremaining#, #userSearch.sn#, #userSearch.givenName#, #userSearch.eduPersonAffiliation#, #userSearch.gsuPersonJobCode#, #userSearch.gsupersonhighschool#, #userSearch.gsupersonhighschoolcode#</cfoutput><cfexit>--->
		<cfset expdate=Left(userSearch.passwordexpirationtime, 8)>
	
		<!---<cfif uid eq "ga00600"><cfset expdate=20101212></cfif>--->
		<cfif DateCompare(CreateDate(Left(expdate,4), Mid(expdate,5,2), Right(expdate,2)), NOW()) lte 0>
			<br><br><p>Sorry, you must first reset your password before you may access this system.  To do this, you may go to:<br><br><a target="_blank" href="https://campusid.gsu.edu/form_change1.cfm">https://campusid.gsu.edu/form_change1.cfm</a><br><br>
			and use the password you were given in the "Current Password" field.  After clicking Submit, you will be able to enter your new password.  After you change your password, you may log in to the <a href="/grade_change">Registration Adjustment System</a>.</p><br><br><br><br>
			<cfexit>
		</cfif>

		<cfinvoke method="checkPassword" uid="#uid#" userpassword="#userpassword#" servername="#servername#" port="#port#" returnvariable="authorized" />
		<cfif authorized eq true>
			<!---<cfoutput>#userSearch.cn#  #userSearch.gsupersonhighschool# #userSearch.gsupersonhighschoolcode#
</cfoutput>--->
			
            
			
			<cfcookie name="login_name_gradechange" value="#userSearch.cn#">
			
			<cfcookie name="UserAuth_gradechange" value=true>
			<cfcookie name="campusid" value="#LCase(uid)#">
			
			<cfcookie name="type_gradechange" value="#userSearch.eduPersonAffiliation#">
			<cfcookie name="jobcode" value="#userSearch.gsuPersonJobCode#">
            <cfif isDefined("Form.requested_page")>
            	<cfif Form.requested_page eq "home">
                	<cflocation url="index.cfm" addtoken="no">
                <cfelseif Form.requested_page eq "contacts">
                	<cflocation url="upload_contacts.cfm" addtoken="no">
                <cfelseif Form.requested_page eq "view">
                	<cflocation url="view_contacts.cfm" addtoken="no">
                <cfelse>
                	<cflocation url="index.cfm" addtoken="no">
                </cfif>
            <cfelse>
				<cflocation url="index.cfm" addtoken="no">
            </cfif>
	
		</cfif>

	<cfreturn>
		<cfif authorized eq true>
			<cflocation url="index.cfm">
		<cfelse>
			<cfreturn false>
		</cfif>
	

	<cfreturn>
	


</CFFUNCTION>









<CFFUNCTION name="getName">
	<cfargument name="nostudents" default="">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<cfargument name="return" default="">
    <cfargument name="system" default="">

	
	<cfset root = "ou=people,ou=primary,ou=eid,dc=gsu,dc=edu">
	 <cfif system eq "dev">
    	<cfset servername = "malak.gsu.edu">
		<cfset port = "389">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "6b43jzcdpr98">
    <cfelse>
		<cfset servername = "auth.gsu.edu">
       	<cfset port = "636">
		<cfset username = "cn=generic-proxy,ou=proxies,dc=gsu,dc=edu">
		<cfset password = "b43jpq93##68wx">
	</cfif>
	<cfif nostudents eq "">
		<cfset filter="(uid=#uid#)">
	<cfelse>
		<cfset filter="(&(eduPersonAffiliation=Staff) (uid=#uid#))">
	</cfif>
       
       
       <!--- Attributes must include uid and dn.  These are used within the 2 authorization queries. ---> 
		
	   	<cfset attributes = "uid,dn,recordcount,passwordexpirationtime,logingraceremaining,sn,givenName, cn">

       
       <!--- this filter will look in the objectclass for the user's ID ---> 
       

		<cftry>
				<cfif servername eq "malak.gsu.edu">
		       <cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"> 
				<cfelse>
					<cfldap action="QUERY"
		                       name="userSearch"
		                       attributes="#attributes#"
		                       start="#root#"
		                       scope="SUBTREE"
		                       server="#servername#"
		                       port="#port#"
		                       filter="#filter#"
							   username="#username#"
							   password="#password#"
							   secure="CFSSL_BASIC"> 
				</cfif>
		       <cfcatch type="Any">
		               <cfset UserSearchFailed = true>
					   <cfoutput>#cfcatch.message#cc</cfoutput>
					   <cfreturn false>
		       </cfcatch>              
		</cftry>
		<cfif NOT userSearch.recordcount>
			Invalid Instructor CampusID.  Please try again.
			<cfreturn>
		</cfif>

		<!---<cfif return eq "true">
			<cfreturn "#userSearch.givenName# #userSearch.sn#">
		<cfelse>
			<cfset Session.insertuserfirstname="#userSearch.givenName#">
			<cfset Session.insertuserlastname="#userSearch.sn#">
		</cfif>--->
		<cfreturn "#userSearch.cn#">
		

		

</CFFUNCTION>











<CFFUNCTION name="checkPassword">
	<CFARGUMENT name="uid" required="Yes" type="string">
	<CFARGUMENT name="userpassword" required="Yes" type="string">
	<CFARGUMENT NAME="servername" required="yes" type="string">
	<CFARGUMENT NAME="port" required="yes" type="string">

	<cftry>
		<cfif servername eq "malak.gsu.edu">
	     <cfldap action="QUERY"
	                       name="auth"
	                       attributes="#attributes#"
	                       start="#root#"
	                       scope="SUBTREE"
	                       server="#servername#"
	                       port="#port#"
	                       filter="#filter#"
						   username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
						   password="#userpassword#">
		<cfelse>
			<cfldap action="QUERY"
	                       name="auth"
	                       attributes="#attributes#"
	                       start="#root#"
	                       scope="SUBTREE"
	                       server="#servername#"
	                       port="#port#"
	                       filter="#filter#"
						   username="uid=#uid#, ou=people, ou=primary, ou=eid, dc=gsu, dc=edu"
						   password="#userpassword#"
						   secure="CFSSL_BASIC">
		</cfif>
	
	<cfreturn true>
	<cfcatch type="any">
	<cfcookie name="UserAuth_gradechange" value=false>
	<cfset inval_string = "Invalid credentials">
	
	<cfif FindNoCase(inval_string, cfcatch.detail)>
		<cfoutput>
			<script>
				<h2 class="error_message">ERROR: You have supplied invalid credentials.  Please try again.</h2>
			</script>
		</cfoutput>
	<cfelse>
		<h2 class="error_message">ERROR: Invalid Password. Please try again. Hint: Passwords are case-sensitive.</h2>
		<cfinvoke method="loginForm" uid="#uid#" />
		</cfif>
		<cfreturn false>
	</cfcatch>
	</cftry>
	hola!!
	<cfreturn>****
	<cfinvoke method="sendToOrien" uid="#uid#" />
</CFFUNCTION>












<CFFUNCTION name="loginForm">
<CFARGUMENT name="uid" type="string" default="" required="No">
<CFARGUMENT NAME="system" TYPE="string" DEFAULT="">
	
    <cfset Cookie.login_name_gradechange = "">
    <cfset Cookie.UserAuth_gradechange = false>
	
	<cfoutput>
	<div id="loginform" width="80%">
	<br><br><br><h1 style="white-space:nowrap;">Welcome to the Registration Adjustment Request System</h1><br>
	<form name="login" action="login.cfm" method="post">
	<h2>Log In</h2>
	<p>You must use your <a target="_blank" href="http://campusdirectory.gsu.edu/">campus id</a> and password to log in to this system.</p>
    <table width="100%" border="0" cellspacing="0" class="matrix">
      <tr>
        <td width="28%"><strong>Campus ID:</strong></td>
        <td width="72%"><input name="username" type="text" size="20" maxlength="20" value="#uid#" />
          <img src="/applicantstatus/counselor/images/icon-help.gif" align="top" alt="Help" onclick="openHelp();" /></td>
      </tr>
      <tr>
        <td><strong>Password:</strong></td>
        <td><input name="password" type="password" size="20" maxlength="20" /></td>
      </tr>
      <tr  class="section">
        <td colspan="2"><a target="_blank" href="http://campusid.gsu.edu">Lost your log-in information?</a></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2"><input class="float-right" name="Save" type="submit" value="Log In" /></td>
      </tr>
    </table>
    <cfif isDefined("URL.requested_page")><input type="hidden" name="requested_page" value="#URL.requested_page#"></cfif>
    </form>
	</div>
	

	</cfoutput>
</CFFUNCTION>



<CFFUNCTION name="changePasswordForm">
changePasswordForm

	<h2 class="error_message">Your password has expired.  Please enter a new password below.</h2>
	Your password must consist of 8 to 32 characters, including at least one UPPER CASE letter, one lower case letter, and one number. <b>This password is case-sensitive.</b><br><br>
	<div id="loginform" width="90%">
    <FORM name=login action="login.cfm" method=post>
	<INPUT type="hidden" name="username" <cfif isDefined("Form.username")>value="<cfoutput>#Form.username#</cfoutput>"</cfif>>
	<!--<INPUT type="hidden" name="old_password" value="<cfoutput><cfif isDefined('Form.password')>#Form.password#<cfelse>#Form.old_password#</cfif></cfoutput>">-->
	<table>
		<tr>
			<td colspan="2">Old Password:<br><input type="password" name="old_password" tabindex="1"><br><br></td>
		</tr>
		<tr>
			<td>New Password:<br><input type="password" name="new_password" onkeyup="CreateRatePasswdReq('login')" tabindex="2"><br><br></td>
			<td><br><br><cfinvoke method="showPasswordStrength" /></td>
		</tr>
		<tr>
			<td colspan="2">Confirm New Password:<br>
	<INPUT type=password name="new_password_confirm" tabindex="3"></td>
		</tr>
	</table>
	<br><br><br>
	<INPUT class="button" type="submit" onclick="return validate_password();" value="Change Password" tabindex="4">
	</form></div>
	<script language="javascript">document.login.old_password.focus();</script>
</CFFUNCTION>







<CFFUNCTION name="showPasswordStrength">
showPasswordStrength
<td width="10px"></td> <td width="180" style="display:none" nowrap id="passwdBarDiv" valign="top"> <table cellpadding="0" cellspacing="0" border="0"> <tr> <td width="0" nowrap valign="top">  <a href="javascript:var popup=window.open('ldapPasswordHelp.html', 'PasswordHelp', 'width=500, height=300, location=no, menubar=no, status=no, toolbar=no, scrollbars=yes, resizable=yes');">  Password strength:</a>  </td> <td nowrap valign="top"> <b> <div id="passwdRating"> </div> </b> </td> </tr> <tr> <td height="3"></td> </tr> <tr> <td colspan="2"> <table width="180" border="0" bgcolor="#ffffff" cellpadding="0" cellspacing="0" id="passwdBar"><tr> <td width="0%" id="posBar" bgcolor="#e0e0e0" height="4"></td> <td width="100%" id="negBar" bgcolor="#e0e0e0" height="4"></td> </tr> </table> </td> </tr> </table> </td> 

<script type="text/javascript"><!--
  var hidePasswordBar = false;
  if (isBrowserCompatible && ! hidePasswordBar) {
    document.getElementById("passwdBarDiv").style.display = "block";
  } else {
    var helpLink = document.getElementById("passwordHelpLink");
    if (helpLink) {
      helpLink.style.display = "inline";
    }
  }

</script>    </tr> </tbody> </table> </td>
</CFFUNCTION>







</CFCOMPONENT>