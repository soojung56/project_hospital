<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오호병원</title>
<link href="resources/css/appoint.css" rel="stylesheet">
<%
 if(session.getAttribute("p_id") == null) {
    %>
    <script type="text/javascript">
    alert("로그인 후 이용할 수 있습니다!");
    window.location.href = "login";
    </script>
    <%
 }
    
%>
<!-- 기본 BASE -->    
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript">

//의사, 과명 스크립트
$(document).ready(function() {  
      $("#ap_showDoctor").empty();
      $("#ap_showbuser").change(doctorshow);
      $("#ap_dday").change(dayselect);
      $("#ap_dtime").change(timeselect);
      $("#submit").click(function(){ // 빈칸 경고메시지
			if($("#ap_buser_show").val()==""){
				swal("경고","진료과를 선택해주세요","warning");
				return false;
			}else{  
				$("#ap_buser_show").focus();
			}
			if($("#ap_doctor_show").val()==""){
				swal("경고","진료의를 선택해주세요","warning");
				return false;
			}else{  
				$("#ap_doctor_show").focus(); 
			}
			if($("#ap_doctor_day").val()==""){
				swal("경고","진료일을 선택해주세요","warning"); 
				return false;
			}else{ 
				$("#ap_doctor_day").focus(); 
			}
			if($("#ap_doctor_time").val()==""){
				swal("경고","진료시간을 선택해주세요","warning");
				return false;
			}else{  
				$("#ap_doctor_time").focus(); 
			}
			swal("성공","예약이 접수 되었습니다.","success");
	});
});
   
function doctorshow(c_class){ //과 선택후 의사 보여주기

   $("#ap_showDoctor").empty();
   var show = $("#ap_showbuser option:selected").val();
   document.getElementById("ap_buser_show").value = show; // 과선택시 밑 화면 출력
   $.ajax({
         type:"get",
         url:"doctor",
         data:{"c_class":$("#ap_showbuser option:selected").val()},
         dataType:"json",
         success:function(doctors){
           var list = doctors.datas;
             var str ="<option name='select' value = '' selected disabled hidden>"+"==선택하세요=="+"</option>";
            $(list).each(function(idx, objArr){
               str += "<option value= '"+objArr.d_name+"'>"+objArr["d_name"]+ "</option>";
            });
            $("#ap_showDoctor").append(str);
            $("#ap_showDoctor").change(doctorselect); // 의사선택시 밑 화면 출력
   
         },
         error:function(){
            $("#ap_showDoctor").text("에러발생 "); 
         }
           
      });
}

function doctorselect(d_name){// 의사선택시 밑 화면 출력 and 의사번호 불러오기
   $.ajax({
         type:"get",
         url:"doctor_no",
         data:{"d_name":$("#ap_showDoctor> option:selected").val()},
         dataType:"json",
         success:function(doctorsnum){
           var list = doctorsnum.ddatas;
            $(list).each(function(idx, objArr){
               $("#ap_dno").val(objArr.d_number);
               var show5 = $("#ap_showDoctor> option:selected").val();
               document.getElementById("ap_doctor_show").value = show5;
            });
         },
         error:function(){
            $("#ap_dno").text("에러발생 "); 
         }
   });
}

function dayselect(){// 예약일 설정시 밑 화면 출력
   //alert("c");
   var show3 = $("#ap_dday").val();
   document.getElementById("ap_doctor_day").value = show3;

}
function timeselect(){// 시간 출력
   var show4 = $("#ap_dtime").val();
   document.getElementById("ap_doctor_time").value = show4;
}

</script>
<style type="text/css">
input, select{
	 border: none;
	 background: transparent;
	 height: 30px
}
</style>
</head>
<body>
<%@ include file="main_top.jsp" %>
<br><br><br><br>
<form class="quick-reservation" action="appinsert" method="post">
<div class="container">
   <header class="quick-reservation__header">
      <h2 class="title">
         방문 예약하기
      </h2>
         <span></span>
         <span></span>
   </header>
   
   <div class="quick-reservation__form">
      <section class="form__content">
         <div class="row-wrapper">
            <div class="ele first-name">
               <label for="adults">진료과</label>
               <select name="adults" id="ap_showbuser">
                  <option name="first" value="hide">==선택하세요==</option>
   					<c:forEach var="b" items="${classdatas}">
   					<option name="b_select" id="b_select" value="${b.c_class}">${b.c_class}</option>
   					</c:forEach>
               </select>
            </div>
            <div class="ele first-name">
               <label for="children">담당의</label>
               <select name="children" id="ap_showDoctor">
               </select>
            </div>
            <div class="ele first-name">
               <label for="rateType">날짜선택</label>
              <input type="date" id="ap_dday" name="ap_dday" min="2020-10-16">
            </div>
            <div class="ele first-name">
               <label for="Rooms">진료시간</label>
               <input type="time" id="ap_dtime" name="ap_dtime" value="09:00:00"min="09:00:00" max="18:00:00">
            </div>         
         </div>
         <div class="row-wrapper">  
            <div class="ele first-name">
               <label for="title">환자이름</label>
               <input type="text" readonly name="ap_pname" id="ap_pname" size="15" value="${pdata.getP_name()}" >
            </div>
            <div class="ele first-Name">
               <label for="lastName">연락처</label>
               <input type="text" readonly name="ap_tell" id="ap_tell" size="15" value="${pdata.getP_tel() }">
            </div> 
         <div class="ele last-name">
               <label for="lastName">생년월일</label>
               <input type="text" readonly name="ap_pbirth" id="ap_pbirth" size="15" value="${pdata.getP_birth() }">
            </div>     
         </div>
         
         <div class="row-wrapper">
            <div class="ele email-address">
               <label for="emailAddress">진료과</label>
               <input type="text" name="ap_buser_show" id="ap_buser_show" readonly>
            </div>
			<div class="ele email-address">
               <label for="emailAddress">담당의</label>
               <input type="text" name="ap_doctor_show" id="ap_doctor_show" >
            </div>
			<div class="ele email-address">
               <label for="emailAddress">진료일</label>
               <input type="text" name="ap_doctor_day" id="ap_doctor_day" readonly>
            </div>
			<div class="ele email-address">
               <label for="emailAddress">예약시간</label>
               <input type="text" name="ap_doctor_time" id="ap_doctor_time" readonly>
            </div>
            
            
         </div>
         
         <div class="row-wrapper more-options">
   			<div class="ele email-address">
               <label for="emailAddress">환자번호</label>
               <input type="text" name="ap_pno" id="ap_pno" value="${pdata.getP_number()}">
            </div>
   			<div class="ele email-address">
               <label for="emailAddress">의사번호</label>
               <input type="text" name="ap_dno" id="ap_dno" >
            </div> 
         </div>
         
      </section>
   </div>
   
   <footer class="form__footer">
      <div class="footer-wrapper">
         <input type="submit" id="submit" value="예약하기">
         <input type="button" value="목록" onclick="location.href='appoint_list'">
      </div>
   </footer>
</div>
   
</form>
<br><br><br><br>
<!-- 하단 필수항목 -->
<%@ include file="main_bottom.jsp" %>
<script type="text/javascript" src="resources/js/menu.js"></script>

</body>
</html>



