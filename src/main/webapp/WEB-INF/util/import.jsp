<%@ page language="java" pageEncoding="utf-8" import="java.util.*" %>
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/jqueryeasyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}3thParty/jqueryeasyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}common/css/demo.css">
<link rel="stylesheet" type="text/css" href="${fileUrlConfig.sysFileVisitRoot_back}common/css/table.css">
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.tools.min.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.form.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/common.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.validate.js"></script> 
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.metadata.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.validate_customerMethod.js"></script>
<script type="text/javascript" src="${fileUrlConfig.sysFileVisitRoot_back}common/js/jquery.validate_customerMessage.js"></script>
<script type="text/javascript">
	var webRoot="${pageContext.request.contextPath}";//获得树Tree	型JS加载项目名称
	var folderName="${folderName}";//获取文件上传的文件夹名称
	var doc_file_upload="${doc_file_upload}";//文档文件类型
	var img_file_upload="${img_file_upload}";//图片文件类型
	var zip_file_upload="${zip_file_upload}";//压缩文件类型
	var pageSize=10;//设置页面列表默认展示的记录数
	var queryParams=null;//设置查询参数条件
	var currentPage=1;//默认的当前页面
	var fileServiceUploadRoot="${fileUrlConfig.sysFileVisitRoot_back}";
	//控制保存按钮不可用，避免重复提交
	$(function(){
		$("form").bind("submit", function(){
			//控制保存按钮变灰，避免重复提交
			  $("#btnSave").attr("disabled",true);
		});
		//点击保存按钮时，加载浮层
		$("#btnSave").click(function(){
			/* $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body"); 
			$("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请等待......").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 400) / 2}); */
		});
	});
	
	//图片表单重置信息
	function resetFormPhoto(){
		$("#photo").html("");
		$("#mymessage").html("");
		$("#tishi").html("");
		$("#fileId").val(null);
	}
	
	//上传大图片 
	function uploadPhoto(imageInfoPath,width,height,photoIndex) {
		if(width==undefined)width="150px";
		if(height==undefined)height="150px";
		if(photoIndex==undefined)photoIndex="1";
		//添加上传提示信息，控制按钮不可用
		addFormPhotoMessage(photoIndex);
		$(document).ready( function() {
			var options = {
				url : "${pageContext.request.contextPath}/back/upload/asyncUploadImage.action?imageInfoPath="+imageInfoPath,
				type : "post",
				dataType : "json",
				success : function(data) {
					//清空上传提示信息，恢复按钮可用
					clearFormPhotoMessage(photoIndex);
					if (data.photoUrl == "false_error") {//上传文件错误，请重试！
						msgShow("系统提示","上传的图片失败，请重试！","error");
					}else if (data.photoUrl == "false_error1") {//上传文件错误，请重试！
						msgShow("系统提示","请选择要上传的图片！","error");
					}else if (data.photoUrl == "false_error2") {//上传文件错误，请重试！
						//msgShow("图片异常","您上传的图片格式不对，请确认图片类型为：.gif,.jpg,.jpeg,.png,.bmp格式；上传图片大小不超过2M。",'error');
						msgShow("系统提示","请确认图片类型为：.gif,.jpg,.jpeg,.png,.bmp格式；上传图片大小不超过2M。","error");
					}else if (data.photoUrl == "false_error3") {//上传文件错误，请重试！
						msgShow("系统提示",data.photoUrlErrorMessage,"error");
					}else {
						$("#imageUrl"+photoIndex).val(data.photoUrl);
						$("#photo"+photoIndex).html("");
						$("#photo"+photoIndex).html("<img style='padding-top:10px' src='"+data.uploadFileVisitRoot+data.photoUrl+"' width='"+width+"' height='"+height+"' />");
					}
				}
			};
			$("#photoForm"+photoIndex).ajaxSubmit(options);
		});
	}
	//添加上传提示信息，控制按钮不可用
	function addFormPhotoMessage(photoIndex){
		$("#buttonId"+photoIndex).attr("disabled","true");//提交按钮不可用
	}
	//清空上传提示信息，恢复按钮可用
	function clearFormPhotoMessage(photoIndex){
		$("#mymessage"+photoIndex).html("");//清空提示信息
		$("#buttonId"+photoIndex).removeAttr("disabled");//提交按钮恢复可用
	}
	 /**
	  * 对Date的扩展，将 Date 转化为指定格式的String
	  * 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
	  * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
	  * 例子： 
	  * new Date().Format("yyyy-MM-dd hh:mm:ss") ==> 2006-07-02 08:09:04.423 
	  * new Date().Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
	  */
	Date.prototype.Format = function (fmt) {
	  var o = {
	      "M+": this.getMonth() + 1, //月份 
	      "d+": this.getDate(), //日 
	      "h+": this.getHours(), //小时 
	      "m+": this.getMinutes(), //分 
	      "s+": this.getSeconds(), //秒 
	      "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
	      "S": this.getMilliseconds() //毫秒 
	  };
	  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	  for (var k in o)
	  if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	  return fmt;
	};

	/**
	 * 将msyql数据库中查询的时间格式化
	 * jsondate 是一个obj类型的对象
	 * fmt 是需要转换的格式 例如：yyyy-MM-dd hh:mm:ss
	 */
	function toJsonDate(jsondate,fmt) {
		 if(jsondate!=null && jsondate!=""){
			jsondate = jsondate.time;
			return new Date(parseInt(jsondate, 10)).Format(fmt);
		 }else{
			 return "";
		 }
	}
	
</script> 