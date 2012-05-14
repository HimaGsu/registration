function updateStudentName(thisform, pnum){
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/registration_adjustment/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&pnum=" + pnum;
	//alert (url);
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var info=trim(xmlHttp.responseText);
	//alert(info);
	thisform.student_name.value=info;
}
function validateGradeChangeForm(thisform){
	if (thisform.student_pnum.value==""){
		alert("Please enter the student's panther number.");
		thisform.student_pnum.focus();
		return false;
	}
	if (thisform.student_name.value==""){
		alert("Please enter the student's name.");
		thisform.student_name.focus();
		return false;
	}
	if (thisform.instructor_name.value==""){
		alert("Please enter the instructor's name.");
		thisform.instructor_name.focus();
		return false;
	}
	if (thisform.instructor_campusid.value==""){
		alert("Please enter the instructor's campus id.");
		thisform.instructor_campusid.focus();
		return false;
	}
	if (thisform.authority_name.value==""){
		alert("Please enter the approving authority's name.");
		thisform.authority_name.focus();
		return false;
	}
	if (thisform.authority_email.value==""){
		alert("Please enter the approving authority's e-mail.");
		thisform.authority_email.focus();
		return false;
	}
	var semester_selected=false;
	for (i=thisform.semester.length-1; i > -1; i--) {
		if (thisform.semester[i].checked) {
			semester_selected=true;
		}
	}
	if (semester_selected == false) {
		alert("Please select a semester.");
		return false;
	}
	if (thisform.year.value==""){
		alert("Please enter the year.");
		thisform.year.focus();
		return false;
	}
	if (thisform.crn.value==""){
		alert("Please enter the course CRN.");
		thisform.crn.focus();
		return false;
	}
	if (thisform.subject.value==""){
		alert("Please enter the course subject.");
		thisform.subject.focus();
		return false;
	}
	if (thisform.course_number.value==""){
		alert("Please enter the course number.");
		thisform.course_number.focus();
		return false;
	}
	if (thisform.course_title.value==""){
		alert("Please enter the course title.");
		thisform.course_title.focus();
		return false;
	}
	if (thisform.credit_hours.value==""){
		alert("Please enter the number of credit hours.");
		thisform.credit_hours.focus();
		return false;
	}
	if (thisform.action.value==""){
		alert("Please select the action.");
		return false;
	}
	if (thisform.action.value=="Exchange"){
		if (thisform.new_course_crn.value==""){
			alert("Please enter the new course CRN.");
			thisform.new_course_crn.focus();
			return false;
		}
		if (thisform.new_course_subject.value==""){
			alert("Please enter the new course subject.");
			thisform.new_course_subject.focus();
			return false;
		}
		if (thisform.new_course_number.value==""){
			alert("Please enter the new course number.");
			thisform.new_course_number.focus();
			return false;
		}
		if (thisform.new_course_title.value==""){
			alert("Please enter the new course title.");
			thisform.new_course_title.focus();
			return false;
		}
		if (thisform.new_credit_hours.value==""){
			alert("Please enter the new course credit hours.");
			thisform.new_credit_hours.focus();
			return false;
		}
	}
	if (thisform.additional_information.value==""){
		alert("Please enter the explanation for the registration adjustment request.");
		thisform.additional_information.focus();
		return false;
	}
}
function changeCourseDropdown(thisform, campus_id){
	//alert(campus_id);
	var semester_selected="";
	for (i=thisform.semester.length-1; i > -1; i--) {
		if (thisform.semester[i].checked) {
			semester_selected=thisform.semester[i].value;
		}
	}
	var year_selected=thisform.year.value;
	//alert(semester_selected);
	//alert(year_selected);
	if (semester_selected!="" && year_selected!=""){
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/registration_adjustment/makeChanges.cfm";
		url=url+"?count="+count;
		url=url+"&getCourses=true&campusid=" + campus_id;
		url=url+"&semester=" + semester_selected;
		url=url+"&year=" + year_selected;
		//alert (url);
		var xmlHttp=createResponseObject();
		xmlHttp.open("GET",url,false);
		xmlHttp.send(null);
		var info=trim(xmlHttp.responseText);
		var browser=navigator.appName.toLowerCase(); 
		if (browser.indexOf("netscape")>-1) var display="table-row"; 
		else display="block"; 
		if (info=="0"){
			document.getElementById("pleasechoose").innerHTML="<p>No courses were found.  Please make sure the instructor campus id is correct and revise your semester and year.</p>";
			var otherstyle=document.getElementById("pleasechoose").style;
			otherstyle.display = otherstyle.display? display:display;
			document.getElementById("coursedropdown").style.display="none";
		}
		else{
			document.getElementById("coursedropdown").innerHTML=info;
			var dropdownstyle=document.getElementById("coursedropdown").style;
			dropdownstyle.display = dropdownstyle.display? display:display;
			document.getElementById("pleasechoose").style.display="none";
		}
	}
}
function fillInCourses(){
	var dropdown=document.getElementById("requested_course");
	var dropdownvalue=dropdown[dropdown.selectedIndex].value;
	var coursetitle=dropdown[dropdown.selectedIndex].text;
	coursearray=dropdownvalue.split("|")
	document.getElementById("crn").value=coursearray[0];
	document.getElementById("subject").value=coursearray[1];
	document.getElementById("course_number").value=coursearray[2];
	document.getElementById("course_title").value=coursetitle;
	
	
	var semester_selected="";
	for (i=document.courseForm.semester.length-1; i > -1; i--) {
		if (document.courseForm.semester[i].checked) {
			semester_selected=document.courseForm.semester[i].value;
		}
	}
	var year_selected=document.courseForm.year.value;
	var campusid=document.courseForm.instructor_campusid.value;
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/registration_adjustment/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&getAuthorityEmail=true&subject=" + coursearray[1];
	url=url+"&semester="+semester_selected+"&year="+year_selected+"&campusid="+campusid;
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var info1=trim(xmlHttp.responseText);
	var infoarray=info1.split("|")
	var email=trim(infoarray[0]);
	var authname=trim(infoarray[1]);
	document.getElementById("authority_email").value=email;
	document.getElementById("authority_name").value=authname;
}
function selectAction(action){
	var browser=navigator.appName.toLowerCase(); 
	if (browser.indexOf("netscape")>-1) var display="table-row"; 
	else display="block"; 
	var style=document.getElementById("newcoursenum").style;
	var style2=document.getElementById("newcoursecrn").style;
	var style3=document.getElementById("newcoursesubject").style;
	var style4=document.getElementById("newcoursetitle").style;
	var style5=document.getElementById("newcoursecredithours").style;
	if (action=="Exchange"){
		style.display = style.display? display:display;
		style2.display = style.display? display:display;
		style3.display = style.display? display:display;
		style4.display = style.display? display:display;
		style5.display = style.display? display:display;
	}
	else{
		document.getElementById("new_course_number").value="";
		style.display="none";
		style2.display="none";
		style3.display="none";
		style4.display="none";
		style5.display="none";
	}
}
function changeInstructorName(thisform, campus_id){
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/registration_adjustment/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&instructor_campusid=" + campus_id;
	//alert (url);
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var info=trim(xmlHttp.responseText);
	//alert(info);
	thisform.instructor_name.value=info;
}
function validate_uploadform(thisform){
	var file_parts = thisform.spreadsheet_file.value.split(".");
	//alert(file_parts.length);
	if (file_parts.length>2){
		alert("Please only have one extension for your file.  Your filename can only have one '.' in it.");
		return false;
	}
	var file_ext = thisform.spreadsheet_file.value.substr(thisform.spreadsheet_file.value.lastIndexOf('.') + 1).toLowerCase();
	//alert(file_ext);
	if (file_ext != "mdb"){
		alert("Please enter only a .mdb file.");
		return false;
	}
}
function validate_uploadform_excel(thisform){
	var file_parts = thisform.spreadsheet_file.value.split(".");
	//alert(file_parts.length);
	if (file_parts.length>2){
		alert("Please only have one extension for your file.  Your filename can only have one '.' in it.");
		return false;
	}
	var file_ext = thisform.spreadsheet_file.value.substr(thisform.spreadsheet_file.value.lastIndexOf('.') + 1).toLowerCase();
	//alert(file_ext);
	if (file_ext != "csv"){
		alert("Please enter only a .csv file.");
		return false;
	}
}





function createResponseObject()
{
	var tempobject=GetXmlHttpObject()
	if (tempobject==null)
	{
		alert ("Browser does not support HTTP Request")
		return false;
	}
	return tempobject;
}
function GetXmlHttpObject()
{ 
var objXMLHttp=null;
if (window.ActiveXObject)
{
//alert("ms");
objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
}
else if (window.XMLHttpRequest)
{
//alert("other");
objXMLHttp=new XMLHttpRequest()
}
return objXMLHttp
}
function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}
function open_window(url, window_name, attributes){
	window.open(url, window_name, attributes); 	
}