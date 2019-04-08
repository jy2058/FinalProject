<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/css/member/modify.css">


<style>
.label-memberDel{
cursor: pointer;}

.filebox label {
  display: inline-block;
  color: #fff;
  font-size: inherit;
  line-height: normal;
  vertical-align: middle;
  background-color: #FA4358;
  cursor: pointer;
  border: 1px solid #FA4358;
  border-radius: .25em;
}

.filebox label:hover {
  background-color: #FA4358;
}

.filebox label:active {
  background-color: #FA4358;
}

.filebox input[type="file"] {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}
</style>

<div class="member">

	<div class="line-title">
		<h1 class="page-title">EDIT PROFILE</h1>
		<div class="line-btn btn-style1">수정완료</div>
	</div>
	
	
	<div class="row">
	<form id="frm" action="${cp }/member/memberModify" class="label-member" method="post" enctype="multipart/form-data">
			<div class="profileImg col-sm-4">

				<div class="sampleImg">
					<div class="exText">
								<img src="${cp }/member/memberImg?memId=${SESSION_MEMBERVO.memId }" width="340" height="320"/>
					</div>
				</div>
				<div class="filebox img-btn btn-style1">
					<label  class="btn-style1" for="input_img">프로필 이미지 올리기</label> 
					<input	type="file" id="input_img" name="profileImg" />
				</div>
			</div>


			<div class="col-shinys-1 col-shinys-offset">
			
				<span>이름</span>
				<input type="text"  id="memNm" name="memNm"/>
				<span>아이디</span>
				<input type="text" id="memId" name="memId" />
				<span>이메일</span>
				<input type="text" id="memMail" name="memMail"/>
				<span>자기소개</span>
				<input type="text" id="memIntro" name="memIntro"/>
				<span>비밀번호</span>
				<input type="password" class="memPass" id="memPass" oninput="checkPwd()" />
				<span>비밀번호 확인</span>
				<input type="password" class="memPass" id="reMemPass" name="memPass" oninput="checkPwd()"/>
			
			<div class="label-memberDel" id="delBtn">
				<span>계정삭제</span>
			</div>
			
		
			</div>
		</form>
	</div>
	

	<script>
	$("#memNm").val("${SESSION_MEMBERVO.memNm}");
	$("#memId").val("${SESSION_MEMBERVO.memId}");
	$("#memMail").val("${SESSION_MEMBERVO.memMail}");
	$("#memIntro").val("${SESSION_MEMBERVO.memIntro}");
	
	$(".line-btn").on("click",function(){
		
		if($("#memMail").val().trim()==""  ){
			//$("#memId").val().trim()
			
			alert("이메일을 입력해 주세요");
			$("#memMail").focus();
			return;
		}
		
		var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
		if($("#memMail").val().trim()==""  || exptext.test($("#memMail").val())==false){
			//$("#memId").val().trim()
			alert(" 메일형식이 올바르지 않습니다");
			$("#memMail").focus();
			return;
		}
		
		if($("#memPass").val().trim()==""){
			//$("#memId").val().trim()
			alert("비밀번호를 입력해 주세요");
			$("#memPass").focus();
			return;
		}
		
		if($("#reMemPass").val().trim()==""){
			//$("#memId").val().trim()
			alert("비밀번호를 입력해 주세요");
			$("#reMemPass").focus();
			return;
		}
		
		if(!/^[a-zA-Z0-9!@#$%^&*()?_~]{6,15}$/.test($("#reMemPass").val()))
		 { 
		  alert("비밀번호는 숫자, 영문, 특수문자 조합으로 6~15자리를 사용해야 합니다."); 
		  return false;
		 }
		
		$("#frm").submit();
		
	});
	
	
	$("#delBtn").on("click",function(){
		if (confirm("정말 삭제  하시겠습니까??") == true) {
			$("#frm").attr("action","member/memberDelete");
			$("#frm").submit();
		}else{
			return false;
		}
	});
	
	var pwdCheck=0;
	function checkPwd() {
		var inputed = $(".memPass").val();
        var reinputed = $("#reMemPass").val();
		console.log(inputed);
		
	     if(reinputed=="" && (inputed != reinputed || inputed == reinputed)){
	            $("#reMemPass").css("background-color", "#FFCECE");
	        }
	        else if (inputed == reinputed) {
	            $("#reMemPass").css("background-color", "#B0F6AC");
	            pwdCheck = 1;
	        } else if (inputed != reinputed) {
	            pwdCheck = 0;
	            $("#reMemPass").css("background-color", "#FFCECE");
	            
	        }

	}
	
	  var sel_file;
	  
      $(document).ready(function() {
          $("#input_img").on("change", handleImgFileSelect);
      }); 

      function handleImgFileSelect(e) {
          var files = e.target.files;
          var filesArr = Array.prototype.slice.call(files);
			alert(files);
			alert(filesArr);
          filesArr.forEach(function(f) {
              if(!f.type.match("image.*")) {
                  alert("확장자는 이미지 확장자만 가능합니다.");
                  return;
              }

              sel_file = f;

              var reader = new FileReader();
              reader.onload = function(e) {
                  $("#memImg").attr("src", e.target.result);
			alert(e.target.result);
              }
              reader.readAsDataURL(f);
          });
      }
	</script>
</div>
