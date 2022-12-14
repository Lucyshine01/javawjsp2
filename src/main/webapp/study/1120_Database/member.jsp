<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>member.jsp</title>
  <jsp:include page="../../include/bs4.jsp"></jsp:include>
	<script>
		'use strict'
		function searchMid() {
			let mid = prompt("찾고자 하는 아이디를 입력하세요?");
			
			location.href="${pageContext.request.contextPath}/database/SearchMid?mid="+mid;
		}
	</script>
</head>
	<body>
<p><br/></p>
<div class="container">
  <h2>회원 전용방</h2>
  <p><font color="blue">${sName}</font>님 로그인 중이십니다.</p>
	<hr/>
	<p><img src="${pageContext.request.contextPath}/images/ecat.png" width="300px"/></p>
	<hr/>
	<p>
	  현재 보유중인 포인트 : <font color='red'><b>${point}</b></font><br/>
	  최종 방문일자 : <font color='red'><b>${sLastDate}</b></font>
	</p>
	<hr/>
	<div style="width:600px; margin: 0 auto;">
		<div><a href="${pageContext.request.contextPath}/database/MyInfoUpdate" class="btn btn-warning form-control m-3">개인 정보 수정</a></div>
		<div><a href="${pageContext.request.contextPath}/study/1120_Database/memberSearch.jsp" class="btn btn-success form-control m-3">개별 회원 조회</a></div>
		<div><a href="${pageContext.request.contextPath}/database/MemberList" class="btn btn-primary form-control m-3">회원 전체 조회</a></div>
		<div><a href="${pageContext.request.contextPath}/database/LogOut" class="btn btn-secondary form-control m-3">로그아웃</a></div>
	</div>
	<hr/>
</div>
<p><br/></p>
</body>
</html>