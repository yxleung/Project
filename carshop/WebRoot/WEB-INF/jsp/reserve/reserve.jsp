<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML>
<html>
<head>
<title></title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
</head>
<body>
<!-- 全局保存openid -->
<input id="openid" value=${openid} type="hidden"/>
<!-- 创建预约 -->
<div>
	<div><span>创建预约</span></div>
		<div>
			<span>选择车型</span>
			<select id="select_car" name="carid">
				<c:if test="${!empty mycar}" >
				<optgroup label="我的车型">
					<c:forEach var="item" items="${mycar}" varStatus="status"> 
						<option value="${item.id}">${item.name }&nbsp;${item.num }</option>
					</c:forEach>
					<option value="other">手动输入</option>
				</optgroup>
				</c:if>
			</select>
			<span id="other_car" style="display: none;">
			<label>车牌：</label>
			<input id="other_car_num" type="text" placeholder="填写车牌号"/>
			<label>车架号：</label>
			<input id="other_car_vin" type="text" placeholder="填写车架号"/>
			<span>*请填写车牌或车架号</span>
			</span>
		</div>
		<div>
			<span>选择4s店</span>
			<select id="select_shop" name="shopid">
				<c:if test="${empty shop}" >
					<option value="-1">没有店铺</option>
				</c:if>
				<c:forEach var="item" items="${shop}" varStatus="status"> 
					<option value="${item.id}">${item.name }</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<span>预约时间</span>
			<select id="select_time" disabled="disabled" name="timeid">
				<option value="-1">请选择4s店</option>
			</select>
		</div>
		<div>
			<span>班组</span>
			<select id="select_team" disabled="disabled" name="teamid">
				<option value="-1">请先选择预约时间</option>
			</select>
			<span>顾问</span>
			<select id="select_consultant" disabled="disabled" name="consultantid">
				<option value="-1">请先选择预约时间</option>
			</select>
		</div>
		<div><input id="create" type="submit" value="预约"/><span id="result"></span></div>
</div>

</body>

<!-- scripts -->
<script src="/lib/jquery/jquery-2.1.1.min.js"></script>

<script>
$(document).ready(function(){
	//手动输入车型是否显示
	var carSelectVal=$("#select_car").val();
	if(carSelectVal=="other"){
		$("#other_car_model").show();
	}else{
		$("#other_car_model").hide();
	}
	
	//加载预约时间
	var selectShop=$("#select_shop").val();
	if(selectShop!=-1){
		loadSelectTime(selectShop);
	}
	
	
	$("#select_car").on("change",function(){
		var val=$(this).val();
		if(val=="other"){
			$("#other_car").show();
		}else{
			$("#other_car").hide();
		}
	});
	
	$("#select_shop").on("change",function(){
		var val=$(this).val();
		loadSelectTime(val);
	});
	
	/**加载预约时间*/
	function loadSelectTime(shopid){
		if(shopid!=""){
			$.ajax({
	             type: "GET",
	             url: "/reserve/getSelectTime.do",
	             data: {shopid:shopid},
	             dataType: "json",
	             success: function(data){
	            	var dataObj=eval(data);
	            	if(dataObj.length>0){
		            	var selectTime=$('#select_time');
		            	selectTime.empty();
		            	$.each(dataObj, function(index, value) {
		            		selectTime.append("<option value='"+value.id+"'>"+value.time+"</option>");
		            	});
	            		selectTime.attr("disabled",false);
	            	}
	            	
	            	var timeid=$("#select_time").val();
	            	//加载班组和顾问
	            	loadTeam(timeid);
	            	loadConsultant(timeid);
	             }
	         	});
			}
		}
	
	/**加载班组*/
	function loadTeam(timeid){
		if(timeid!=""){
			$.ajax({
	             type: "GET",
	             url: "/reserve/getTeam.do",
	             data: {timeid:timeid},
	             dataType: "json",
	             success: function(data){
	            	var dataObj=eval(data);
	            	if(dataObj.length>0){
		            	var selectTeam=$('#select_team');
		            	selectTeam.empty();
		            	$.each(dataObj, function(index, value) {
		            		selectTeam.append("<option value='"+value.id+"'>"+value.name+"</option>");
		            	});
		            	selectTeam.attr("disabled",false);
	            	}
	             }
	         	});
			}
		}
	
	
	/**加载顾问*/
	function loadConsultant(timeid){
		if(timeid!=""){
			$.ajax({
	             type: "GET",
	             url: "/reserve/getConsultant.do",
	             data: {timeid:timeid},
	             dataType: "json",
	             success: function(data){
	            	var dataObj=eval(data);
	            	if(dataObj.length>0){
		            	var selectConsultant=$('#select_consultant');
		            	selectConsultant.empty();
		            	$.each(dataObj, function(index, value) {
		            		selectConsultant.append("<option value='"+value.id+"'>"+value.name+"</option>");
		            	});
		            	selectConsultant.attr("disabled",false);
	            	}
	             }
	         	});
			}
		}
	
	$("#create").on("click",function(){
		var carid=$("#select_car").val();
		var isOther=false;
		var otherCarNum=$("#other_car_num").val();
		var otherCarVin=$("#other_car_vin").val();
		if(carid=="other"){
			if(otherCarNum==""&&otherCarVin==""){
				$("#result").text("车牌号和车架号至少填写一个");
				return;
			}else{
				$("#result").text("");
				isOther=true;
			}
		}
		var shopid=$("#select_shop").val();
		if(shopid==-1){
			$("#result").text("请选择商店");
			return;
		}else{
			$("#result").text("");
		}
		var timeid=$("#select_time").val();
		if(timeid==-1){
			$("#result").text("请选择预约时间");
			return;
		}else{
			$("#result").text("");
		}
		var teamid=$("#select_team").val();
		if(teamid==-1){
			$("#result").text("请选择班组");
			return;
		}else{
			$("#result").text("");
		}
		var consultantid=$("#select_consultant").val();
		if(consultantid==-1){
			$("#result").text("请选择顾问");
			return;
		}else{
			$("#result").text("");
		}
		
		$.ajax({
            type: "POST",
            url: "/reserve/create.do",
            data: {carid:carid,isOther:isOther,otherCarNum:otherCarNum,otherCarVin:otherCarVin,shopid:shopid,timeid:timeid,teamid:teamid,consultantid:consultantid},
            dataType: "json",
            success: function(data){
           		var dataObj=eval(data);
           		console.log(dataObj.code);
           		console.log(dataObj.msg);
            }
        	});
		
	});
	
});

</script>
</html>