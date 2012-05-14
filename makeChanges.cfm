<cfapplication name="gradeChangeAdjustment" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!---<cfset Session.odatasource="B8DEVORACLE_HS">--->

<cfif isDefined("URL.pnum") and URL.pnum neq "">
    <cftry>
        <cfstoredproc  procedure="wwokbapi.f_get_general" datasource="#Session.odatasource#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#URL.pnum#"> 
        <cfprocresult name="out_result_set">
        </cfstoredproc> 
        <cfoutput>#out_result_set.first_name# #out_result_set.mi# #out_result_set.last_name#</cfoutput>
    <cfcatch>
        <cfif Find("ORA-20105", #cfcatch.Detail#) gt 0>
        	Invalid Panther Number above
        <cfelse>
			<cfoutput>#cfcatch.Detail# -> #cfcatch.Message#</cfoutput>
        </cfif>
    </cfcatch>
    </cftry>
<cfelseif isDefined("URL.instructor_campusid")>
	<cfinvoke component="ldapAuthentication" method="getName" uid="#URL.instructor_campusid#" returnvariable="instructor_name" system="prod" />
    <cfoutput>#instructor_name#</cfoutput>
<cfelseif isDefined("URL.getCourses")>
	<cfset smstr_code = "#URL.year##URL.semester#">

    <CFQUERY NAME="GETPANTHER_NUMBER" DATASOURCE="REGISTRY">
                        select  * from  v_ek_employee
                         where CAMPUSID ='#URL.campusid#'       
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
         <cfif getCourses.RecordCount eq 0>
         	0
         <cfelse>
             <select name="requested_course" id="requested_course" onChange="fillInCourses();">
             <option value="">Select One</option>
             <cfoutput query="getCourses">
                <option value="#SSBSECT_CRN#|#SSBSECT_SUBJ_CODE#|#SSBSECT_CRSE_NUMB#">#SCBCRSE_TITLE# - #SSBSECT_CRN#</option>
             </cfoutput>
             </select>
         </cfif>
<cfelseif isDefined("URL.getAuthorityEmail")>
    <cfoutput>
    <cfquery name="getEmail" datasource="registration_adjustment">
            select * from contacts where lcase(prefix)='#lcase(URL.subject)#'
    </cfquery>
    <cfif getEmail.RecordCount gt 0>
            #getEmail.email#
    <cfelse>
            asmith7@gsu.edu
    </cfif>
    </cfoutput>
    
    |
    <cfset smstr_code = "#URL.year##URL.semester#">
    <CFQUERY NAME="GETPANTHER_NUMBER" DATASOURCE="REGISTRY">
                        select  * from  v_ek_employee
                         where CAMPUSID ='#URL.campusid#'       
    </CFQUERY>
    <cfquery name="getCourses" datasource="ADOPTIONS">
        SELECT distinct SSBSECT_TERM_CODE, SSBSECT_CRN,SSBSECT_SEQ_NUMB, SSBSECT_SUBJ_CODE, SSBSECT_CRSE_NUMB,  	SCBCRSE_TITLE,  SSBSECT_MAX_ENRL, SSBSECT_ENRL, 	SSBSECT_SSTS_CODE, SPRIDEN_LAST_NAME, SPRIDEN_FIRST_NAME, SCBCRSE_COLL_CODE ,SSRMEET_BLDG_CODE, SCBCRSE_DEPT_CODE
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
         <cfif getCourses.RecordCount eq 0>
         	
         <cfelse>
            <cfoutput>#getCourses.SCBCRSE_DEPT_CODE#</cfoutput>
         </cfif>
    
    
    
</cfif>