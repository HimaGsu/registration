<!---This file provides the main functionality for the form--->
<CFFUNCTION NAME="showGradeAdjustmentForm">
<h3>Registration Adjustment Form</h3>
<p><span style="color: red;"><b>*</b></span> - Required</p>
<form name="courseForm" method="post" action="index.cfm" onsubmit="return validateGradeChangeForm(this);">
<cfoutput>
<table>
	<tr>
    	<td>Form Submitted By: </td>
        <td>#Cookie.login_name_gradechange# (#Cookie.campusid#)</td>
    </tr>
	<tr>
    	<td>Student Panther Number: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="student_pnum" maxlength="10" size="20" onBlur="updateStudentName(this.form, this.value);" value="<cfif isDefined("Form.student_pnum")>#Form.student_pnum#</cfif>"></td>
    </tr>
	<tr>
    	<td>Student Name: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="student_name" maxlength="100" size="80" value="<cfif isDefined("Form.student_name")>#Form.student_name#</cfif>"></td>
    </tr>
    <tr>
    	<td>Instructor Campus ID: <span style="color: red;"><b>*</b></span></td>
        <cfoutput><td><input style="margin-bottom:5px;" type="text" name="instructor_campusid" maxlength="100" size="80" onblur="changeInstructorName(this.form, this.value);changeCourseDropdown(this.form, this.value);" value="<cfif isDefined("Form.instructor_campusid")>#Form.instructor_campusid#<cfelse>#Cookie.campusid#</cfif>"></td></cfoutput>
    </tr>
    <tr>
    	<td>Instructor Name: <span style="color: red;"><b>*</b></span></td>
        <cfoutput><td><input style="margin-bottom:5px;" type="text" name="instructor_name" maxlength="100" size="80" value="<cfif isDefined("Form.instructor_name")>#Form.instructor_name#<cfelse>#Cookie.login_name_gradechange#</cfif>"></td></cfoutput>
    </tr>
    <tr>
    	<td>Semester: (Mark one box) <span style="color: red;"><b>*</b></span></td>
        <cfoutput><td><input type="radio" name="semester" value="01" onClick="changeCourseDropdown(this.form, this.form.instructor_campusid.value);" <cfif isDefined("Form.semester") and Form.semester eq 01>checked</cfif>> Spring &nbsp; <input type="radio" name="semester" value="05" onClick="changeCourseDropdown(this.form, this.form.instructor_campusid.value);" <cfif isDefined("Form.semester") and Form.semester eq 05>checked</cfif>> Summer &nbsp; <input type="radio" name="semester" value="08" onClick="changeCourseDropdown(this.form, this.form.instructor_campusid.value);" <cfif isDefined("Form.semester") and Form.semester eq 08>checked</cfif>> Fall</td></cfoutput>
    </tr>
    <cfoutput><tr>
    	<td>Year (ex: #DateFormat(NOW(), "yyyy")#) <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="year" maxlength="4" size="5" onKeyUp="if(this.value.length==4){changeCourseDropdown(this.form, this.form.instructor_campusid.value);}" value="<cfif isDefined("Form.year")>#Form.year#</cfif>"> &nbsp; </td>
    </tr></cfoutput>
    <tr>
    	<td>Select Applicable Course:</td>
        <td><cfinvoke method="showCourses" /></td>
    </tr>
    <tr>
    	<td>CRN: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="crn" id="crn" maxlength="20" size="20" value="<cfif isDefined("Form.crn")>#Form.crn#</cfif>"></td>
    </tr>
    <tr>
    	<td>Subject: (Ex: ENGL) <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="subject" id="subject" maxlength="20" size="20" value="<cfif isDefined("Form.subject")>#Form.subject#</cfif>"></td>
    </tr>
    <tr>
    	<td>Course ##: (Ex:1101) <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="course_number" id="course_number" maxlength="20" size="20" value="<cfif isDefined("Form.course_number")>#Form.course_number#</cfif>"></td>
    </tr>
    <tr>
    	<td>Course Title: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="course_title" id="course_title" maxlength="100" size="80" value="<cfif isDefined("Form.course_title")>#Form.course_title#</cfif>"></td>
    </tr>
    <tr>
    	<td>## of Credit Hours (Ex. 3.000): <span style="color: red;"><b>*</b></span></td>
       	<td><input style="margin-bottom:5px;" type="text" name="credit_hours" id="credit_hours" maxlength="100" size="80" value="<cfif isDefined("Form.credit_hours")>#Form.credit_hours#</cfif>"></td>
    </tr>
    <tr>
    	<td>Department: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="authority_name" id="authority_name" maxlength="100" size="80" value="<cfif isDefined("Form.authority_name")>#Form.authority_name#</cfif>"></td>
    </tr>
    <tr>
    	<td>Approving Authority E-mail: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="authority_email" id="authority_email" maxlength="100" size="80" value="<cfif isDefined("Form.authority_email")>#Form.authority_email#</cfif>"></td>
    </tr>
    <tr>
    	<td>Action: <span style="color: red;"><b>*</b></span></td>
        <td>
        	<select name="action" onChange="selectAction(this.value);">
            	<option value="">Select One</option>
                <option value="Add" <cfif isDefined("Form.action") and Form.action eq "Add">selected</cfif>>Add</option>
		<option value="Withdraw" <cfif isDefined("Form.action") and Form.action eq "Withdraw">selected</cfif>>Withdraw (Course remains on transcript)</option>
                <option value="Drop" <cfif isDefined("Form.action") and Form.action eq "Drop">selected</cfif>>Drop (Course is removed from transcript)</option>
                <option value="Exchange" <cfif isDefined("Form.action") and Form.action eq "Exchange">selected</cfif>>Even Exchange (DROP the course listed above and ADD the course listed below)</option>
                <option value="ChangeCreditHours" <cfif isDefined("Form.action") and Form.action eq "ChangeCreditHours">selected</cfif>>Change Credit Hours for Variable Hours Courses</option>
            </select>
        </td>
    </tr>
    <script></script>
    <tr id="newcoursecrn" style="<cfif not isDefined("Form.action") or Form.action neq "Exchange">display:none;</cfif>">
    	<td>New Course CRN: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="new_course_crn" id="new_course_crn" maxlength="20" size="20" value="<cfif isDefined("Form.new_course_crn")>#Form.new_course_crn#</cfif>"></td>
    </tr>
    <tr id="newcoursesubject" style="<cfif not isDefined("Form.action") or Form.action neq "Exchange">display:none;</cfif>">
    	<td>New Course Subject: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="new_course_subject" id="new_course_subject" maxlength="20" size="20" value="<cfif isDefined("Form.new_course_subject")>#Form.new_course_subject#</cfif>"></td>
    </tr>
    <tr id="newcoursenum" style="<cfif not isDefined("Form.action") or Form.action neq "Exchange">display:none;</cfif>">
    	<td>New Course ##: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="new_course_number" id="new_course_number" maxlength="20" size="20" value="<cfif isDefined("Form.new_course_number")>#Form.new_course_number#</cfif>"></td>
    </tr>
    <tr id="newcoursetitle" style="<cfif not isDefined("Form.action") or Form.action neq "Exchange">display:none;</cfif>">
    	<td>New Course Title: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="new_course_title" id="new_course_title" maxlength="20" size="20" value="<cfif isDefined("Form.new_course_title")>#Form.new_course_title#</cfif>"></td>
    </tr>
    <tr id="newcoursecredithours" style="<cfif not isDefined("Form.action") or Form.action neq "Exchange">display:none;</cfif>">
    	<td>New Course ## of Credit Hours: <span style="color: red;"><b>*</b></span></td>
        <td><input style="margin-bottom:5px;" type="text" name="new_credit_hours" id="new_credit_hours" maxlength="20" size="20" value="<cfif isDefined("Form.new_credit_hours")>#Form.new_credit_hours#</cfif>"></td>
    </tr>
    <tr>
    	<td valign="top" style="width:30%;">Reason for the Registration Adjustment: <sup>1</sup><br><i>(A reason for the adjustment <u>must</u> be specified to act in accordance with university and external regulations.)</i>
 <span style="color: red;"><b>*</b></span></td>
        <td><textarea name="additional_information" rows="5" cols="62"><cfif isDefined("Form.additional_information")>#Form.additional_information#</cfif></textarea></td>
    </tr>
    <!---<tr>
    	<td valign="top">Reason for Grade Change: <span style="color: red;"><b>*</b></span><br>Ex: Error in grade or<br>removal of an incomplete</td>
        <td valign="top"><textarea style="margin-bottom:5px;" name="change_reason" rows="5" cols="62"></textarea></td>
    </tr>--->
</table><br>
</cfoutput>
<input type="submit" name="submitGradeAdjustment" value="Submit Registration Adjustment">
<cfoutput>
<input type="hidden" name="submit_name" value="#Cookie.login_name_gradechange#">
<input type="hidden" name="submit_campusid" value="#Cookie.campusid#">
</cfoutput>
</form>
<p><i><sup>1</sup> A valid reason is required.  Forms lacking an explanation will not be processed and will be returned to the sender.</i></p>
</CFFUNCTION>
<CFFUNCTION NAME="showCourses">
	<cfset smstr_code ="">

    <CFQUERY NAME="GETPANTHER_NUMBER" DATASOURCE="REGISTRY">
                        select  * from  v_ek_employee
                         where CAMPUSID ='#cookie.campusid#'       
    </CFQUERY>
    
    <CFQUERY NAME="GETSPRIDEN_PIDM" DATASOURCE="ADOPTIONS">
                         select  * from   SPRIDEN@bookstore_banner_link
                         where SPRIDEN_ID ='#GETPANTHER_NUMBER.PANTHER_NUMBER#' 
    </CFQUERY>
    
     <cfquery name="getCourses" datasource="ADOPTIONS">
        SELECT distinct SSBSECT_TERM_CODE, SSBSECT_CRN,SSBSECT_SEQ_NUMB, SSBSECT_SUBJ_CODE, SSBSECT_CRSE_NUMB,  	SCBCRSE_TITLE,  SSBSECT_MAX_ENRL, SSBSECT_ENRL, 	SSBSECT_SSTS_CODE, SPRIDEN_LAST_NAME, SPRIDEN_FIRST_NAME, SCBCRSE_COLL_CODE ,SSRMEET_BLDG_CODE
        FROM SSRMEET@bookstore_banner_link, SSBSECT@bookstore_banner_link, SCBCRSE@bookstore_banner_link, SIRASGN@bookstore_banner_link,  SPRIDEN@bookstore_banner_link
        WHERE SSBSECT_TERM_CODE = '#smstr_code#' 
        and  SCBCRSE_SUBJ_CODE  = SSBSECT_SUBJ_CODE
        and  SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB
        and  SCBCRSE_EFF_TERM =( 
        select max(SCBCRSE_EFF_TERM ) from SCBCRSE@bookstore_banner_link where SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB and  SCBCRSE_SUBJ_CODE  = SSBSECT_SUBJ_CODE)
        AND
        SIRASGN_CRN = SSBSECT_CRN 
        and SIRASGN_TERM_CODE= SSBSECT_TERM_CODE
        and SPRIDEN_PIDM (+) = SIRASGN_PIDM 
        and SPRIDEN_CHANGE_IND IS NULL 
        and SIRASGN_PRIMARY_IND (+) = 'Y'
        and
        SSRMEET_TERM_CODE = SSBSECT_TERM_CODE 
        and  SSRMEET_CRN = SSBSECT_CRN		         
         <!--- AND SPRIDEN_PIDM='#GETSPRIDEN_PIDM.SPRIDEN_PIDM#' ----->
          
              and SPRIDEN_ID ='#GETPANTHER_NUMBER.PANTHER_NUMBER#'      
         </CFQUERY>
         <span id="pleasechoose"><i>Please choose a semester and year above.</i></span>
         <span id="coursedropdown" style="display:none;">
         <select name="requested_course">
             <option value="">Select One</option>
             <cfoutput query="getCourses">
                <option value="#SSBSECT_CRSE_NUMB#" <cfif isDefined("Form.requested_course") and Form.requested_course eq "#SSBSECT_CRSE_NUMB#">selected</cfif>>#SCBCRSE_TITLE# - #SSBSECT_CRN#</option>
             </cfoutput>
         </select>
         </span>
</CFFUNCTION>
<CFFUNCTION NAME="showSubmittedRequest">
	<!---<cfset change_reason=Replace(Form.change_reason, #chr(13)#, "<br>", "all")>--->
    
	<cfoutput>
    
    <table>
    <tr><td>Form Submitted By:</td><td>#Form.submit_name# (#Form.submit_campusid#)</td></tr>
    <tr><td>Student Panther Number:</td><td>#Form.student_pnum#</td></tr>
    <tr><td>Student Name:</td><td>#Form.student_name#</td></tr>
    <tr><td>Instructor Campus ID:</td><td>#Form.instructor_campusid#</td></tr>
    <tr><td>Instructor Name:</td><td>#Form.instructor_name#</td></tr>
    <tr><td>Department:</td><td>#Form.authority_name#</td></tr>
    <tr><td>Approving Authority E-mail:</td><td>#Form.authority_email#</td></tr>
    <tr><td>Semester:</td>
    	<td>
        	<cfif isDefined("Form.semester")>
				<cfif Form.semester eq "01">
                    Spring
                <cfelseif Form.semester eq "05">
                    Summer
                <cfelseif Form.semester eq "08">
                    Fall
                <cfelse>
                    #Form.semester#
                </cfif>
             </cfif>
        </td>
    </tr>
    <tr><td>Year:</td><td>#Form.year#</td></tr>
    <tr><td>CRN:</td><td>#Form.crn#</td></tr>
    <tr><td>Subject:</td><td>#Form.subject#</td></tr>
    <tr><td>Course ##:</td><td>#Form.course_number#</td></tr>
    <tr><td>Course Title:</td><td>#Form.course_title#</td></tr>
    <tr><td>## of Credit Hours:</td><td>#Form.credit_hours#</td></tr>
    <tr><td>Action:</td><td>#Form.action#</td></tr>
    <cfif Form.action eq "Exchange">
        <tr><td>New Course CRN:</td><td>#Form.new_course_crn#</td></tr>
        <tr><td>New Course Subject:</td><td>#Form.new_course_subject#</td></tr>
        <tr><td>New Course ##:</td><td>#Form.new_course_number#</td></tr>
        <tr><td>New Course Title:</td><td>#Form.new_course_title#</td></tr>
        <tr><td>New Course Credit Hours:</td><td>#Form.new_credit_hours#</td></tr>
	</cfif>
    <tr><td>Explanation:</td><td><cfif Form.additional_information neq "">#Form.additional_information#<cfelse><i>None</i></cfif></td></tr>
    <!---<tr><td valign="top">Reason for Grade Change:</td><td>#change_reason#</td></tr>--->
    </table>
    </cfoutput>
</CFFUNCTION>
<CFFUNCTION NAME="validateGradeChangeForm">
	<cfoutput>
	<cfif Form.student_pnum eq "">
    	<h3 class="error">Please enter the student's Panther Number. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.student_name eq "">
		<h3 class="error">Please enter the student's name. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.instructor_name eq "">
		<h3 class="error">Please enter the instructor's name. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.instructor_campusid eq "">
		<h3 class="error">Please enter the instructor's campus id. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.authority_name eq "">
		<h3 class="error">Please enter the approving authority name. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.authority_email eq "">
		<h3 class="error">Please enter the approving authority's e-mail. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif not isDefined("Form.semester")>
		<h3 class="error">Please enter the semester. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.year eq "">
		<h3 class="error">Please enter the year. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.crn eq "">
		<h3 class="error">Please enter the CRN. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.subject eq "">
		<h3 class="error">Please enter the course subject. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.course_number eq "">
		<h3 class="error">Please enter the course number. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.course_title eq "">
		<h3 class="error">Please enter the course title. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.credit_hours eq "">
		<h3 class="error">Please enter the number of credit hours. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.action eq "">
		<h3 class="error">Please enter the action. Thank you.</h3>
		<cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
	<cfelseif Form.action eq "Exchange">
		<cfif Form.new_course_crn eq "">
			<h3 class="error">Please enter the new course's CRN. Thank you.</h3>
			<cfinvoke method="showGradeAdjustmentForm" />
        	<cfreturn false>
		<cfelseif Form.new_course_subject eq "">
			<h3 class="error">Please enter the new course's subject. Thank you.</h3>
			<cfinvoke method="showGradeAdjustmentForm" />
        	<cfreturn false>
		<cfelseif Form.new_course_number eq "">
			<h3 class="error">Please enter the new course number. Thank you.</h3>
			<cfinvoke method="showGradeAdjustmentForm" />
        	<cfreturn false>
		<cfelseif Form.new_course_title eq "">
			<h3 class="error">Please enter the new course title. Thank you.</h3>
			<cfinvoke method="showGradeAdjustmentForm" />
        	<cfreturn false>
		<cfelseif Form.new_credit_hours eq "">
			<h3 class="error">Please enter the number of credit hours for the new course. Thank you.</h3>
			<cfinvoke method="showGradeAdjustmentForm" />
        	<cfreturn false>
		</cfif>
    </cfif>
    <cfif Form.additional_information eq "">
    	<h3 class="error">Please enter the explanation for the registration adjustment request.</h3>
        <cfinvoke method="showGradeAdjustmentForm" />
        <cfreturn false>
    </cfif>
    </cfoutput>
    <cfreturn true>
</CFFUNCTION>
<CFFUNCTION NAME="submitGradeAdjustmentForm">
	<!---first validate--->
	
    <cfinvoke method="validateGradeChangeForm" returnvariable="validated" />
    <cfif validated eq "false"><cfreturn false></cfif>
    
    <!---done validating--->
    
	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
    	<cfset drive="d">
    <cfelse>
    	<cfset drive="c">
    </cfif>

    <cfoutput>
    <cfdocument filename="#drive#:\inetpub\wwwroot\registration_adjustment\sent_requests\registrationadjustmentrequest_#DateFormat(NOW(), 'mmddyyyy')#.pdf" format="PDF" overwrite="true">
		<cfinvoke method="showSubmittedRequest">
    </cfdocument>
    </cfoutput>

	<cfset descontact="">
	<cfif Form.subject neq "">
		<cfquery name="getEmail" datasource="registration_adjustment">
			select * from contacts where lcase(prefix)='#lcase(Form.subject)#'
		</cfquery>
		<cfif getEmail.RecordCount gt 0>
			<cfset descontact="#getEmail.email#">
		<cfelse>
			<cfset descontact="asmith7@gsu.edu">
		</cfif>
	<cfelse>
		<cfset descontact="asmith7@gsu.edu">
	</cfif>
    </p>

    <cfmail from="#Cookie.campusid#@gsu.edu"
    	 to="christina@gsu.edu"
         <!---to="#Form.authority_email#;#descontact#"
         cc="#Form.submit_campusid#@gsu.edu"--->
         bcc="christina@gsu.edu"
         server="mailhost.gsu.edu" 
         subject="Registration Adjustment Request" 
         type="html" 
         mimeattach="#drive#:\inetpub\wwwroot\registration_adjustment\sent_requests\registrationadjustmentrequest_#DateFormat(NOW(), 'mmddyyyy')#.pdf">
        A registration adjustment request has been submitted. The details are below as well as in the PDF document attached.<br><br>
        <cfinvoke method="showSubmittedRequest">
    </cfmail>
    <br><br><h3>Thank you, your registration adjustment form has been submitted.</h3><br><br><br>
</CFFUNCTION>	
<cffunction name="uploadContacts">
	<cfif Form.spreadsheet_file eq "">
    	<p><span class="error">Please browse for your file before pressing the upload button.</span></p>
        <cfinvoke method="showUploadForm" />
        <cfreturn false>
    </cfif>
	<cfif isDefined("Form.spreadsheet_file")>
     	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
			<cfset drive="d">
        <cfelse>
            <cfset drive="c">
        </cfif>
        <cfset accepted_file_types="application/octet-stream">
    	<cftry>
			<cfif Form.spreadsheet_file neq "">
              <cffile action="upload"
                 fileField="Form.spreadsheet_file"
                 destination="#drive#:\Inetpub\wwwroot\registration_adjustment\contacts.mdb"
                 nameconflict="overwrite"
                 accept="#accepted_file_types#">
                 <h2>Thank you, your file has been uploaded!</h2>  Please check that your information was uploaded correctly <a href="view_contacts.cfm">here</a>.<br><br><br>
            </cfif>
        <cfcatch>
        	<cfoutput>You have received an error.  <b>Before uploading the file</b>, please check these items:
            <ul>
            <li>The filename in the "Upload Spreadsheet" box is in the format "filename.mdb".  There should only be one dot in the filename.</li>
            <li>You have closed the Access file on your computer.</li>
            </ul><br>
           <!--- Error below:<br>#cfcatch.Detail# -> #cfcatch.Message#<br><br><br>--->
           </cfoutput>
        </cfcatch>
        </cftry>
    </cfif>
</cffunction>
<cffunction name="uploadContactsExcel">
	<cfif Form.spreadsheet_file eq "">
    	<p><span class="error">Please browse for your file before pressing the upload button.</span></p>
        <cfinvoke method="showUploadForm" />
        <cfreturn false>
    </cfif>
	<cfif isDefined("Form.spreadsheet_file")>
     	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
			<cfset drive="d">
        <cfelse>
            <cfset drive="c">
        </cfif>
        <cfset accepted_file_types="application/octet-stream, application/vnd.ms-excel">
    	<cftry>
			<cfif Form.spreadsheet_file neq "">
              <cffile action="upload"
                 fileField="Form.spreadsheet_file"
                 destination="#drive#:\Inetpub\wwwroot\registration_adjustment\contacts.csv"
                 nameconflict="overwrite"
                 accept="#accepted_file_types#">
                 
            </cfif>
        <cfcatch>
        	<cfoutput>You have received an error.  <b>Before uploading the file</b>, please check these items:
            <ul>
            <li>The filename in the "Upload Spreadsheet" box is in the format "filename.csv".  There should only be one dot in the filename.</li>
            <li>You have closed the Excel file on your computer.</li>
            </ul><br>
            Error below:<br>#cfcatch.Detail# -> #cfcatch.Message#<br><br><br></cfoutput>
            <cfreturn>
        </cfcatch>
        </cftry>
        
		<!--- get and read the CSV-TXT file ---> 
        <cffile action="read" file="#drive#:\Inetpub\wwwroot\registration_adjustment\contacts.csv" variable="csvfile"> 
        
        <!--- loop through the CSV-TXT file on line breaks and insert into database ---> 
        <cfquery name="deleteContacts" datasource="registration_adjustment">
        	delete from contacts
        </cfquery>
        <cfloop index="index" list="#csvfile#" delimiters="#chr(10)##chr(13)#"> 
        	<cfoutput>
            <cfif #trim(listgetAt('#index#',1, ','))# neq "Course Prefix">
		<cfset courseprefix=#trim(listgetAt('#index#',1, ','))#>
		<cfset courseprefix = Replace(courseprefix, "#chr(13)##chr(10)#", "", "ALL")>
		<cftry>
			<cfset email=#trim(listgetAt('#index#',2, ','))#>
			<cfset email = Replace(email, "#chr(13)#", "", "ALL")>
			<cfset email = Replace(email, "#chr(10)#", "", "ALL")>
			<cfset email = Replace(email, "\n", "", "ALL")>
		<cfcatch>
			<cfset email="">
		</cfcatch>
		</cftry>
                <cfquery name="uploadContacts" datasource="registration_adjustment">
                INSERT INTO contacts (prefix,email) 
                 VALUES 
                          ('#courseprefix#', 
                           '#email#'
                          
                          ) 
                </cfquery>
             </cfif>
          </cfoutput>
        </cfloop> 
        
        <!--- 
        <cfquery name="getcontacts" datasource="registration_adjustment"> 
                 SELECT * FROM contacts 
        </cfquery> 
        <cfdump var="#getcontacts#"> 
         ---> 
        
        <h2>Thank you, your file has been uploaded!</h2>  Please check that your information was uploaded correctly <a href="view_contacts.cfm">here</a>.<br><br><br>
    </cfif>
</cffunction>
<cffunction name="showUploadForm">
	<cfset accepted_file_types="application/octet-stream, application/vnd.ms-excel">
    <form method="post" action="upload_contacts.cfm" enctype="multipart/form-data" onsubmit="return validate_uploadform(this);">
    <cfoutput>
    <b>Please note:</b>
    <p>This file must be in .mdb format.  Before uploading, please check these items:</p>
    <ul>
    <li>Your database file is closed on your computer.</li>
    <li>The filename in the Upload Spreadsheet box has .mdb on the end and only has one dot in the filename.</li>
    </ul><br>
    Upload Spreadsheet: <span class="error"><b>*</b></span> &nbsp; <input type="file" name="spreadsheet_file" size="15" maxlength="75" accept="#accepted_file_types#"><br><br>
    <input type="Submit" name="submitFile" value="Upload File">
    <br><br><br>
    </cfoutput>
    </form> 
</cffunction>
<cffunction name="showUploadFormExcel">
	<cfset accepted_file_types="application/vnd.ms-excel">
    <form method="post" action="upload_contacts.cfm" enctype="multipart/form-data" onsubmit="return validate_uploadform_excel(this);">
    <cfoutput>
    <b>Please note:</b>
    <p>This file must be in .csv format.  Before uploading, please check these items:</p>
    <ul>
    <li>Your spreadsheet file is closed on your computer.</li>
    <li>The filename in the Upload Spreadsheet box has .csv on the end and only has one dot in the filename.</li>
    </ul><br>
    Upload Spreadsheet: <span class="error"><b>*</b></span> &nbsp; <input type="file" name="spreadsheet_file" size="15" maxlength="75" accept="#accepted_file_types#"><br><br>
    <input type="Submit" name="submitFile" value="Upload File">
    <br><br><br>
    </cfoutput>
    </form> 
</cffunction>
<cffunction name="viewContacts">
	<cfquery name="getContacts" datasource="registration_adjustment">
    	select * from contacts
    </cfquery>
    <br><br>
    <h2>View Registration Adjustment Contacts</h2>
    <table>
   	<tr><th>Course Prefix</th><th>E-mail</th></tr>
    <cfoutput query="getContacts">
    	<tr><td>#prefix#</td><td>#email#</td></tr>
    </cfoutput>
    </table>
    <br><br><br>
</cffunction>
<cffunction name="showPageFooter">
    <cftry>
    <cfhttp method="get" url="http://www.gsu.edu/new_gsu_page_footer.html" resolveurl="Yes" throwonerror="Yes"></cfhttp><cfoutput>#Trim(cfhttp.FileContent)#</cfoutput> 
    <cfcatch>© #Year(NOW())# Georgia State University. <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a>. </cfcatch>
    </cftry>
</cffunction>