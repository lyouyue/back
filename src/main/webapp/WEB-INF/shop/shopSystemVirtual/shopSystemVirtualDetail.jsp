<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<script type="text/javascript">
	function showDetailInfo(id){
		createWindow(900,450,"&nbsp;&nbsp;详情","icon-tip",false,"detailWin");
		$("#addOrEditWin").css("display","none");
		$("#detailWin").css("display","");
		$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/back/systemVirtualCoin/getVirtualCoinInfo.action",
			   data: {sysVirtualCoinId:id},
			   dataType: "JSON",
			   success: function(data){
				   var htmlString='<tr><td width="200px" class="toright_td">订单号:</td><td width="200px" class="toleft_td">'+data.ordersNo+'</td><td width="200px" class="toright_td">会员信息:</td><td width="200px" class="toleft_td" colspan="2">'+data.customerName+'</td></tr>';
				   var productList=data.productList;
				   var l1=productList.length+1;
				   var l2=productList.length;
				   htmlString+=' <tr><td width="200px" class="toright_td" rowspan="'+l1+'">购买套餐:</td><td width=200px" class="toleft_td">套餐</td><td width="200px" class="toleft_td">赠送金币数量</td><td width="200px" class="toleft_td" colspan="2">赠送总数</td></tr>';
				   if(productList.length>0){
					   for(var i=0;i<productList.length;i++){
						   if(i==0){
							   htmlString+='<tr><td width="200px" class="toleft_td"><img src="${uploadFileVisitRoot}'+productList[i].logoImg+'" title="'+productList[i].productName+'"  width="60px" height="30px" /></td>'+
													   '<td width="200px" class="toleft_td">'+productList[i].num+'</td>'+
													   '<td width="200px" class="toleft_td" rowspan="'+l2+'" colspan="2">'+data.total+'</td></tr>';
						   }else{
							   htmlString+='<tr><td width="200px" class="toleft_td"><img src="${uploadFileVisitRoot}/>'+productList[i].logoImg+'" title="'+productList[i].productName+'"  width="60px" height="30px" /></td>'+
													   '<td width="200px" class="toleft_td">'+productList[i].num+'</td>'+
													   '</tr>';

						   }
					   }
				   }
				   var ptbl=100;
				   //判断易彩币数与分享比例
				   var GRBL=data.GRBL;
				   var GR=data.GR;
				   if(GRBL==null){GRBL=false;}
				   if(GRBL){
					   GR=data.GR;
					   GRBL=data.shareGRFXS+"%";
					   ptbl=Number(ptbl)-Number(data.shareGRFXS);
					}else{GR="-";GRBL="-";}
				   var XSBL=data.XSBL;
				   var XS=data.XS;
				   if(XSBL==null){XSBL=false;}
				   if(XSBL){
					   XS=data.XS;
					   XSBL=data.shareXSFXS+"%";
					   ptbl=Number(ptbl)-Number(data.shareXSFXS);
				   }else{XS="-";XSBL="-";}
				   var SJBL=data.SJBL;
				   var SJ=data.SJ;
				   if(SJBL==null){SJBL=false;}
				   if(SJBL){
					   SJ=data.SJ;
				  	   SJBL=data.shareSJFXS+"%";
				  	  ptbl=Number(ptbl)-Number(data.shareSJFXS);
				   }else{SJ="-";SJBL="-";}

				   //对区域进行判断
				   var XSArea=data.XSArea;
				   if(XSArea==null){XSArea="-";}
				   var SJArea=data.SJArea;
				   if(SJArea==null){SJArea="-";}
				   var CJZDArea = data.CJZDArea;
				   if(CJZDArea==null){CJZDArea="-";}
				   var CJZD = data.CJZD;
				   if(CJZD==null||CJZD=="undefined"){CJZD="0.00";}
				   var shareCJZD = data.shareCJZD;
				   if(shareCJZD==null||shareCJZD=="undefined"){shareCJZD="0";}
				   ptbl=Number(ptbl)-Number(shareCJZD);
				   htmlString+='<tr> <td width="200px" class="toright_td" rowspan="6">类型:</td>'+
				   						  '<td width="100px" class="toleft_td">名称</td>'+
				   						  '<td width="100px" class="toleft_td">所在地</td>'+
				   						  '<td width="100px" class="toleft_td">分享金币数</td>'+
				   						  '<td width="100px" class="toleft_td">分享比例</td></tr>';
				   htmlString+='<tr><td width="100px" class="toleft_td">个人分销商</td>'+
				   						  '<td width="100px" class="toleft_td">-</td>'+
				   						  '<td width="100px" class="toleft_td">'+GR+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+GRBL+'</td></tr>';
				   htmlString+='<tr><td width="100px" class="toleft_td">县市分销商</td>'+
				   						  '<td width="100px" class="toleft_td">'+XSArea+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+XS+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+XSBL+'</td></tr>';
				   htmlString+='<tr><td width="100px" class="toleft_td">省级分销商</td>'+
				   						  '<td width="100px" class="toleft_td">'+SJArea+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+SJ+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+SJBL+'</td></tr>';
				   htmlString+='<tr><td width="100px" class="toleft_td">线下联盟</td>'+
				   						  '<td width="100px" class="toleft_td">'+CJZDArea+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+CJZD+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+shareCJZD+'%</td></tr>';
				   htmlString+='<tr><td width="100px" class="toleft_td">平台</td>'+
				   						  '<td width="100px" class="toleft_td">-</td>'+
				   						  '<td width="100px" class="toleft_td">'+formatCurrency(data.PT)+'</td>'+
				   						  '<td width="100px" class="toleft_td">'+ptbl+'%</td></tr>';

				   $("#showDetail").html(htmlString);
			   }
		});
	}
	/**
     * 将数值四舍五入(保留2位小数)后格式化成金额形式
     *
     * @param num 数值(Number或者String)
     * @return 金额格式的字符串,如'1,234,567.45'
     * @type String
     */
    function formatCurrency(num) {
        num = num.toString().replace(/\$|\,/g,'');
        if(isNaN(num))
        num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
        if(cents<10)
        cents = "0" + cents;
        for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
        num.substring(num.length-(4*i+3));
        return (((sign)?'':'-') + num + '.' + cents);
    }
</script>
<div id="detailWin">
    <table id="showDetail" align="center" class="addOrEditTable" width="850px;">
    </table>
    <div data-options="region:'south',border:false" style="text-align:center;padding:5px 0;">
		<input type="button" id="close" class="button_close" onclick="closeWin()" value="" style="cursor:pointer;"/>&nbsp;
	</div>
</div>