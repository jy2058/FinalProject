<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">
<link rel="icon" href="../../favicon.ico">

<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- Custom styles for this template -->
 <link href="${cp}/css/boxErd.css" rel="stylesheet">

</head>

<body>
<%-- 	<%@ include file="/WEB-INF/views/module/header.jsp"%> --%>

	<div class="container-fluid">
		<div class="row">
			<%@ include file="/WEB-INF/views/post/left.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<h1 class="page-header">답글 등록</h1>
				<form id="frm" action="${cp}/post/postReply" method="post"
						class="form-horizontal" role="form" enctype="multipart/form-data">
					<div class="form-group">
						<label for="postTitle" class="col-sm-2 control-label">글제목</label>
						<div class="col-sm-7">
							<input type="text" class="form-control" id="postTitle" name="postTitle" placeholder="RE: ${postVo.postTitle}" 
							        rows="10" cols="100" style="width: 400px; height: 30px;" />
						</div>
					</div>
					
					<div class="form-group">
						<label for="WriterId" class="col-sm-2 control-label">작성자</label>
						<div class="col-sm-7">
							<input type="text" id="writerId" name="writerId" value="${SESSION_MEMBERVO.memId}" 
			                       rows="10" cols="100" style="width: 400px; height: 30px;" readonly />
						</div>
					</div>
					
					

					<div class="form-group">
						<label for="postContent" class="col-sm-2 control-label"></label>
						<div class="col-sm-10">
							<textarea name="postContent" id="smarteditor" rows="10" cols="100" style="width: 766px; height: 412px;" ></textarea>
						</div>
					</div>

					<div class="form-group">
						<label for="files" class="col-sm-2 control-label">첨부파일</label>
						<div id="fileUpload" class="col-sm-7">
							<input type="file" class="form-control" name="file" />
						</div>
						<div class="col-sm-1">
							<button id="fileAddBtn" type="button" class="btn btn-default">추가</button>
						</div>
					</div>

					<div class="form-group">
						<div class="col-sm-offset-5 col-sm-10">
							<input type="hidden" id="boardNo" name="boardNo" />
							<button id="cancelBtn" type="button" class="btn btn-default">취소</button>
							<button id="insBtn" type="button" class="btn btn-default">저장</button>
						</div>
					</div>
					<input type="hidden" name="postNo" value="${postVo.postNo}" />
				</form>
			</div>
		</div>
	</div>
	
	<form id="cancelFrm" action="${cp}/post/postDetail" method="get">
		<input type="hidden" id="postNo" name="postNo" value="${postVo.postNo}">
	</form>

	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

	<script src="../SE2/js/HuskyEZCreator.js"></script>
	<script>
		var oEditors = [];
		$(document).ready(function() {
			// Editor Setting
			nhn.husky.EZCreator.createInIFrame({
				oAppRef : oEditors, // 전역변수 명과 동일해야 함.
				elPlaceHolder : "smarteditor", // 에디터가 그려질 textarea ID 값과 동일 해야 함.
				sSkinURI : "/SE2/SmartEditor2Skin.html", // Editor HTML
				fCreator : "createSEditor2", // SE2BasicCreator.js 메소드명이니 변경 금지 X
				htParams : {
					// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
					bUseToolbar : true,
					// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
					bUseVerticalResizer : true,
					// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
					bUseModeChanger : true, 
				}
			});

			// 전송버튼 클릭이벤트
			$("#insBtn").click(function(){
				if(confirm("답글을 저장하시겠습니까?")) {
					// id가 smarteditor인 textarea에 에디터에서 대입
					oEditors.getById["smarteditor"].exec("UPDATE_CONTENTS_FIELD", []);

					// 이부분에 에디터 validation 검증
					if(validation()) {
						$("#boardNo").val("${boardNo}");
						$("#frm").submit();
					}
				}
			});
		});
		
		// 취소버튼 클릭이벤트
		$("#cancelBtn").click(function() {
			$("#cancelFrm").submit();
		});
		
		// 필수값 Check
		function validation(){
			if($("#postTitle").val() == '') {
				alert("제목을 입력하세요.");
				$("#postTitle").focus();
				return false;
			}
			
			var contents = $.trim(oEditors[0].getContents());
			if(contents == '<p>&nbsp;</p>' || contents == ''){ // 기본적으로 아무것도 입력하지 않아도 <p>&nbsp;</p> 값이 입력되어 있음. 
				alert("내용을 입력하세요.");
				oEditors.getById['smarteditor'].exec('FOCUS');
				return false;
			}

			return true;
		}
		
		var file_cnt = 1;
		// 파일 추가 버튼 클릭이벤트
		$("#fileAddBtn").click(function(){
			if (file_cnt >= 5) {
				alert("첨부파일은 최대 5개까지 첨부 가능합니다.");
			} else {
				file_cnt++;
				$("#fileUpload").append("<input type='file' class='form-control' name='file' />");
			}
		});
	</script>
</body>
</html>