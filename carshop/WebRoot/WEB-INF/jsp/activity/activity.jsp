<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML>
<html>
<head>
<title></title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<!-- 新 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="/lib/bootstrap-3.2.0-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="/css/main.css">
</head>
<body>
<!-- 全局保存openid -->
<input id="openid" value=${openid} type="hidden"/>
<c:if test="${!empty acts}">
	<ul>
	<c:forEach var="item" items="${acts}" varStatus="status"> 
		<li>
		<div>${item.name }</div><div>活动时间：${item.signup_from }-${item.signup_to }</div><div>${item.description }</div>
		<div>
			<c:if test="${!item.isjoin}">
			<button name="join" class="btn btn-default" actid="${item.id }">参与</button>
			</c:if>
			<c:if test="${item.isjoin}">
			<button disabled class="btn btn-default" actid="${item.id }">已参与</button>
			</c:if>
		</div>
		</li>		
	</c:forEach>
	</ul>
</c:if>
<c:if test="${empty acts}">
	<span>没有活动信息</span>
</c:if>

</body>

<!-- scripts -->
<script src="/lib/jquery/jquery-2.1.1.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="/lib/bootstrap-3.2.0-dist/js/bootstrap.min.js"></script>
<script>
$(document).ready(function(){
	$("button[name='join']").on("click",function(){
		var actid=$(this).attr("actid");
		var openid=$("#openid").val();
		$.ajax({
            type: "GET",
            url: "/activity/join.do",
            data: {openid:openid,actid:actid},
            dataType: "json",
            success: function(data){
           		var dataObj=eval(data);
           		console.log(dataObj.code);
           		if(dataObj.code==1){
           			location.reload();
           		}
            }
        	});
	});
});

</script>
</html>