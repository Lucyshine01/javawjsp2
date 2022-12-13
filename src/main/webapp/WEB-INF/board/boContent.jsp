<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% pageContext.setAttribute("newLine", "\n"); %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>boContent.jsp</title>
  <jsp:include page="/include/bs4.jsp"></jsp:include>
  <script src="https://kit.fontawesome.com/368f95b037.js" crossorigin="anonymous"></script>
  <script>
  	'use strict'
  	function goodCheck() {
			$.ajax({
				type: "post",
				url: "${ctp}/boGood.bo",
				// 값에 숫자는 그냥 써도 되지만 문자는 ""사이에 넣어줘야함
				data: {idx: ${vo.idx}},
				success: function(res){
					location.reload();
				},
				error: function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// 게시글 삭제처리
  	function boDelCheck() {
			let ans = confirm("현 게시글을 삭제하시겠습니까?");
			if(ans) location.href = "${ctp}/boDeleteOk.bo?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}&mid=${vo.mid}";
		}
  	
  	// 댓글 달기
  	function replyCheck() {
  		let content = $("#content").val();
  		if(content.trim() == "") {
  			alert("댓글을 입력하세요");
  			$("#content").focus;
  			return false;
  		}
  		let query = {
  				boardIdx : ${vo.idx},
  				mid : '${sMid}',
  				nickName : '${sNickName}',
  				content : content,
  				hostIp : '${pageContext.request.remoteAddr}'
  		};
			$.ajax({
				type : "post",
				url : "${ctp}/boReplyInput.bo",
				data : query,
				success:function(res) {
					if(res == "1") {
						alert("댓글이 등록되었습니다.");
						location.reload();
					}
					else {
						alert("댓글 등록에 실패했습니다.");
					}
				},
				error : function() {
					alert("전송 오류");
				}
			});
		}
  	
  	// 댓글 삭제하기
  	function replyDelCheck(idx) {
			let ans = confirm("댓글을 삭제하시겠습니까?");
			if(!ans) return false;
			$.ajax({
				type: "post",
				url : "${ctp}/boReplyDeleteOk.bo",
				data : {idx : idx},
				success : function(res) {
					if(res == "1"){
						alert("댓글이 삭제되었습니다.");
						location.reload();
					}
					else {
						alert("댓글 삭제가 처리되지 않았습니다.");
					}
				},
				error : function() {
						alert("전송 오류");
				}
			});
			
		}
  </script>
  <style>
  	#main-table th {
  		text-align: center;
  		
  	}
  </style>
</head>
<body>
<jsp:include page="/include/header.jsp"/>
<p><br/></p>
<div class="container">
  <h2>글 내 용 보 기</h2>
  <br/>
  <table class="table table-borderless">
  	<tr>
  		<th class="text-right">hostIp : ${vo.hostIp}</th>
  	</tr>
  </table>
  <table class="table table-bordered" id="main-table">
  	<tr>
  		<th>글쓴이</th>
  		<td>${vo.nickName}</td>
  		<th>작성 날짜</th>
  		<td width="400px">
  			${fn:substring(vo.wDate,0,16)}
  			<c:if test="${!empty vo.uDate}"> 
  				<font style="font-size: 0.9em; float: right;">
	  				<c:if test="${vo.upDay_diff == 0}">(방금 전 수정)</c:if>
	  				<c:if test="${0 < vo.upDay_diff && vo.upDay_diff < 60}">(${vo.upDay_diff}분 전 수정)</c:if>
	  				<c:if test="${60 < vo.upDay_diff && vo.upDay_diff < 60*24}">
	  					(${fn:substring(vo.upDay_diff/60,0,fn:indexOf(vo.upDay_diff/60,'.'))}시간 전 수정)</c:if>
	  				<c:if test="${60*24 < vo.upDay_diff}">
	  					(${fn:substring(vo.upDay_diff/(60*24),0,fn:indexOf(vo.upDay_diff/(60*24),'.'))}일 전 수정)</c:if>
  				</font>
  			</c:if>
  		</td>
  	</tr>
  	<tr>
  		<th>제목</th>
  		<td colspan="3">${vo.title}</td>
  	</tr>
  	<tr>
  		<th>이메일</th>
  		<td>${vo.email}</td>
  		<th>조회수</th>
  		<td>${vo.readNum}</td>
  	</tr>
  	<tr>
  		<th>홈페이지</th>
  		<td>${vo.homePage}</td>
  		<th>좋아요</th>
  		<td>
  			<c:set var="goodToggle" value="${'board'}${''+vo.idx}"/>
  			<c:if test="${fn:contains(sGood,goodToggle)}"><font color="red"><a href="javascript:goodCheck()">❤</a></font>${vo.good}</c:if>
  			<c:if test="${fn:contains(sGood,goodToggle)==false}"><a href="javascript:goodCheck()">❤</a>${vo.good}</c:if> , 👍계속증가 👎계속감소
  		</td>
  	</tr>
  	<tr>
  		<th>글내용</th>
  		<td colspan="3" style="height: 250px">${fn:replace(vo.content, newLine, "<br/>")}</td>
  	</tr>
	</table>
	<table class="table table-borderless">
  	<tr>
			<c:if test="${flag == 'search'}">
				<td class="text-left">
	  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/boSearch.bo?pageSize=${pageSize}&pag=${pag}&search=${search}&searchString=${searchString}';" class="btn btn-primary" />
				</td>
				<td class="text-right">
  				<c:if test="${vo.mid == sMid || sLevel == 0}">
		  			<input type="button" value="수정하기" onclick="location.href='${ctp}/boUpdate.bo?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}';" class="btn btn-success"/>
		  			<input type="button" value="삭제하기" onclick="boDelCheck()" class="btn btn-danger"/>
	  			</c:if>
					<input type="hidden" name="search" value="${search}"/>
					<input type="hidden" name="searchString" value="${searchString}" />
  			</td>
			</c:if>
			<c:if test="${flag != 'search'}">
				<td class="text-left">
  				<input type="button" value="돌아가기" onclick="location.href='${ctp}/boList.bo?pageSize=${pageSize}&pag=${pag}';" class="btn btn-primary"/>
  			</td>
				<td class="text-right">
	  			<c:if test="${vo.mid == sMid || sLevel == 0}">
		  			<input type="button" value="수정하기" onclick="location.href='${ctp}/boUpdate.bo?idx=${vo.idx}&pageSize=${pageSize}&pag=${pag}';" class="btn btn-success"/>
		  			<input type="button" value="삭제하기" onclick="boDelCheck()" class="btn btn-danger"/>
	  			</c:if>
  			</td>
			</c:if>
  	</tr>
  </table>
  <%-- <c:if test="${flag != 'search'}"> --%>
	  <!-- 이전글/다음글 처리 -->
	  <table class="table table-borderless">
		  <tr>
	  		<td style="font-size: 1.1em">
		  		<c:if test="${nextVo.nextIdx != 0}">
		  			<a href="${ctp}/boContent.bo?idx=${nextVo.nextIdx}&pageSize=${pageSize}&pag=${pag}">
		  				<i class="fa-solid fa-arrow-up"></i> 다음글 : ${nextVo.nextTitle}
		  			</a>
		  		</c:if>
		  		<br/>
		  		<c:if test="${preVo.preIdx != 0}">
		  			<a href="${ctp}/boContent.bo?idx=${preVo.preIdx}&pageSize=${pageSize}&pag=${pag}">
		  				<i class="fa-solid fa-arrow-down"></i> 이전글 : ${preVo.preTitle}
		  			</a>
		  		</c:if>
	  		</td>
		  </tr>
	  </table>
  <%-- </c:if> --%>
  <br/>
</div>
<div class="container">
	<table class="table table-hover text-center">
		<tr>
			<th>작성자</th>
			<th>댓글내용</th>
			<th>작성일자</th>
			<th>접속IP</th>
		</tr>
		<%-- <c:set var="replyCnt" value="${0}"/> --%>
		<c:forEach var="replyVo" items="${replyVos}">
			<tr>
				<td>
					${replyVo.nickName}
				</td>
				<td style="width: 600px; border-left: 1px solid #eee; padding-left: 30px" class="text-left">
					${fn:replace(replyVo.content, newLine, "<br/>")}
				</td>
				<td style="border-left: 1px solid #eee;">${fn:substring(replyVo.wDate,0,16)}</td>
				<td style="border-left: 1px solid #eee;">
					${replyVo.hostIp}
					<c:if test="${sMid == replyVo.mid || sLevel == 0}">
						<a href="javascript:replyDelCheck(${replyVo.idx})" style="width: 50px;font-size: 1.5em;" title="삭제하기">x</a>
					</c:if>
				</td>
			</tr>
			<%-- <c:set var="replyCnt" value="${replyCnt + 1}"/> --%>
		</c:forEach>
		<c:if test="${empty replyVos}">
			<tr><td colspan="4">게시글에 댓글이 없습니다!</td></tr>
		</c:if>
	</table>
	<!-- 댓글 입력창 -->
	<form name="replyForm">
		<table class="table text-center">
			<tr>
				<td style="width: 85%" class="text-left">
					글내용 : 
					<textarea rows="4" name="content" id="content" placeholder="댓글을 입력해주세요." class="form-control"></textarea>
				</td>
				<td style="width: 15%">
					<br/>
					<p>작성 : ${sNickName}</p>
					<p>
						<input type="button" value="댓글달기" onclick="replyCheck()" class="btn btn-info btn-sm" />
					</p>
				</td>
			</tr>
		</table>
		<%-- <input type="hidden" name="boardIdx" value="${vo.idx}"/>
		<input type="hidden" name="hoistIp" value="${pageContext.request.remoteAddr}"/> --%>
	</form>
</div>
<p><br/></p>
<jsp:include page="/include/footer.jsp"/>
</body>
</html>