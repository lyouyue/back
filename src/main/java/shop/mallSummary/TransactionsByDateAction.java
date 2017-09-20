package shop.mallSummary;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import jxl.Workbook;
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;


import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import shop.order.service.IOrdersService;
import util.action.BaseAction;
import util.other.Utils;

/**
 * 商城汇总action
 * @author wy
 *
 */
public class TransactionsByDateAction extends BaseAction{
	private static final long serialVersionUID = -8056927570045394070L;
	Logger logger = Logger.getLogger(this.getClass());
	private IOrdersService ordersService;
	private List<Map<String,Object>> transactionsByDateList;
	private String id;

	//转到商户交易汇总页面
	public String gotoTransactionsByDatePage(){
		return SUCCESS;
	}
	//交易汇总
	public void ListTransactionsByDate() throws IOException, ParseException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer sql=new StringBuffer();
		sql.append("SELECT a.shopInfoId as shopInfoId,b.commission as commission,b.companyName as companyName,b.shopName as shopName,a.transactionAmount as transactionAmount,a.createTime as createTime,b.isVip as isVip FROM "
				+" (SELECT shopInfoId as shopInfoId,SUM(finalAmount) AS transactionAmount,DATE_FORMAT(createTime,'%Y-%m-%d') as createTime FROM shop_orders WHERE 1=1 ");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String state = request.getParameter("state");
			String beginTime = request.getParameter("beginTime");
			String endTime = request.getParameter("endTime");
			if(state!=null&&!"-1".equals(state)){
				if("1".equals(state)){
					sql.append(" and ordersState=0 and settlementStatus=0");
				}else if("2".equals(state)){
					sql.append(" and ordersState=0 and settlementStatus=1");
				}else if("5".equals(state)){
					sql.append(" and (ordersState="+state.trim()+" or ordersState=9) ");
				}else{
					sql.append(" and ordersState="+state);
				}
			}
			if(beginTime!=null&&!"".equals(beginTime)){
				if(endTime!=null&&!"".equals(endTime)){
					sql.append(" and createTime between '"+beginTime.trim()+" 00:00:00' and '"+endTime.trim()+" 23:59:59'");
				}else{
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					Date d1 = df.parse(beginTime.trim());
					Calendar  g = Calendar.getInstance();
					g.setTime(d1);
					g.add(Calendar.MONTH,+1);
					Date d2 = g.getTime();
					endTime=(new SimpleDateFormat("yyyy-MM-dd")).format(d2);
					sql.append(" and createTime between '"+beginTime.trim()+" 00:00:00' and '"+endTime+" 23:59:59'");
				}
			}
		}
		sql.append(" GROUP BY shopInfoId,DATE_FORMAT(createTime,'%Y-%m-%d')) a "
				+ " LEFT JOIN shop_shopinfo b ON a.shopInfoId=b.shopInfoId where b.isPass=3 AND b.isClose=0");
		if("true".equals(selectFlag)){
			String shopName=request.getParameter("shopName");
			String shopInfoType = request.getParameter("shopInfoType");
			if(shopName!=null&&!"".equals(shopName)){
				sql.append(" and b.shopName like '%"+shopName.trim()+"%' ");
			}
			if(Utils.objectIsNotEmpty(shopInfoType)){
				sql.append(" and b.shopInfoType="+shopInfoType);
			}
		}
		int totalRecordCount = 0;
		List<Map<String,Object>> listTemp=ordersService.findListMapBySql(sql.toString());
		if(listTemp!=null&&listTemp.size()>0){
			totalRecordCount=listTemp.size();
		}
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		transactionsByDateList=ordersService.findListMapPageBySql(sql.toString(), pageHelper);
		//格式Map中的时间 
		//格式化创建时间
		if(transactionsByDateList!=null&&transactionsByDateList.size()>0){
			for(Map<String,Object> m:transactionsByDateList){
				//结算佣金
				BigDecimal commissionProportion = new BigDecimal(0);
				String strCommission = String.valueOf(m.get("commission"));
				if(Utils.objectIsNotEmpty(strCommission)&&!"null".equals(strCommission)){
					commissionProportion = new BigDecimal(strCommission);
				}else{
					Boolean isVip = (Boolean) m.get("isVip");
					if(StringUtils.isNotEmpty(String.valueOf(isVip))&&!"null".equals(String.valueOf(isVip))){
						if("1".equals(String.valueOf(isVip))||isVip){
							commissionProportion= new BigDecimal((String.valueOf(getFileUrlConfig().get("vipCommissionProportion"))));//佣金百分比
						}else{
							commissionProportion= new BigDecimal(String.valueOf(getFileUrlConfig().get("commissionProportion")));//佣金百分比
						}
					}else{
						commissionProportion= new BigDecimal(String.valueOf(getFileUrlConfig().get("commissionProportion")));//佣金百分比
					}
				}
				BigDecimal transactionAmount= (BigDecimal)m.get("transactionAmount");//交易金额 (己完成交易)
				if(transactionAmount==null||"null".equals(transactionAmount)){
					transactionAmount=new BigDecimal(0);
				}
				BigDecimal commissionAmount=new BigDecimal(commissionProportion.multiply(transactionAmount).doubleValue()/100);
				BigDecimal payableAmount = transactionAmount.subtract(commissionAmount);
				m.put("commissionProportion",commissionProportion);
				m.put("commissionAmount",commissionAmount.setScale(2,BigDecimal.ROUND_HALF_UP));
				m.put("payableAmount",payableAmount.setScale(2,BigDecimal.ROUND_HALF_UP));
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", transactionsByDateList);
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//交易汇总详情
	public void getCollectiveOrderInfo(){
		
	}
	/**
	 * 交易汇总表中的导出
	 * @throws IOException 
	 * @throws Exception 
	 */
	public void importExcelJYHZBD() throws Exception{
		String beginTime = request.getParameter("beginTime");
		String shopName=request.getParameter("shopName");
		String endTime = request.getParameter("endTime");
		String state = request.getParameter("state");
		StringBuffer sql=new StringBuffer();
		sql.append("SELECT a.shopInfoId as shopInfoId,b.commission as commission,b.companyName as companyName,b.shopName as shopName,a.transactionAmount as transactionAmount,a.createTime as createTime,b.isVip as isVip FROM "
				+" (SELECT shopInfoId as shopInfoId,SUM(finalAmount) AS transactionAmount,DATE_FORMAT(createTime,'%Y-%m-%d') as createTime FROM shop_orders WHERE 1=1 ");
		if(state!=null&&!"-1".equals(state)&&!"".equals(state)){
			if("1".equals(state)){
				sql.append(" and ordersState=0 and settlementStatus=0");
			}else if("2".equals(state)){
				sql.append(" and ordersState=0 and settlementStatus=1");
			}else{
				sql.append(" and ordersState="+state);
			}
		}
		if(beginTime!=null&&!"".equals(beginTime)){
			if(endTime!=null&&!"".equals(endTime)){
				sql.append(" and createTime between '"+beginTime.trim()+" 00:00:00' and '"+endTime.trim()+" 23:59:59'");
			}else{
				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				Date d1 = df.parse(beginTime.trim());
				Calendar  g = Calendar.getInstance();
				g.setTime(d1);
				g.add(Calendar.MONTH,+1);
				Date d2 = g.getTime();
				endTime=(new SimpleDateFormat("yyyy-MM-dd")).format(d2);
				sql.append(" and createTime between '"+beginTime.trim()+" 00:00:00' and '"+endTime+" 23:59:59'");
			}
		}
		sql.append(" GROUP BY shopInfoId,DATE_FORMAT(createTime,'%Y-%m-%d')) a "
				+ " LEFT JOIN shop_shopinfo b ON a.shopInfoId=b.shopInfoId where b.isPass=3 AND b.isClose=0");
		if(shopName!=null&&!"".equals(shopName)){
			sql.append(" and b.shopName like '%"+shopName.trim()+"%' ");
		}
		List<Map<String,Object>> list=ordersService.findListMapBySql(sql.toString());
		//格式Map中的时间 
		if(list!=null&&list.size()>0){
			for(Map<String,Object> m:list){
				//结算佣金
				BigDecimal commissionProportion = new BigDecimal(0);
				String strCommission = String.valueOf(m.get("commission"));
				if(Utils.objectIsNotEmpty(strCommission)&&!"null".equals(strCommission)){
					commissionProportion = new BigDecimal(strCommission);
				}else{
					Boolean isVip = (Boolean) m.get("isVip");
					if(StringUtils.isNotEmpty(String.valueOf(isVip))&&!"null".equals(String.valueOf(isVip))){
						if("1".equals(String.valueOf(isVip))||isVip){
							commissionProportion = new BigDecimal(String.valueOf(getFileUrlConfig().get("vipCommissionProportion")));//佣金百分比
						}else{
							commissionProportion = new BigDecimal(String.valueOf(getFileUrlConfig().get("commissionProportion")));//佣金百分比
						}
					}else{
						commissionProportion = new BigDecimal(String.valueOf(getFileUrlConfig().get("commissionProportion")));//佣金百分比
					}
				}
				BigDecimal transactionAmount= (BigDecimal)m.get("transactionAmount");//交易金额 (己完成交易)
				if(transactionAmount==null||"null".equals(transactionAmount)){
					transactionAmount=new BigDecimal(0);
				}
				BigDecimal commissionAmount=new BigDecimal(commissionProportion.multiply(transactionAmount).doubleValue()/100);
				BigDecimal payableAmount = transactionAmount.subtract(commissionAmount);
				m.put("commissionProportion",commissionProportion);
				m.put("commissionAmount",commissionAmount.setScale(2,BigDecimal.ROUND_HALF_UP));
				m.put("payableAmount",payableAmount.setScale(2,BigDecimal.ROUND_HALF_UP));
			}
		}
		long time = new Date().getTime();
		Boolean b = madeExl(list,time);
		//相对路径[服务器]
		String filePathXLS ="excel/SummaryByDate_"+time+".xls";
		//文件名
		String downloadFileName = "SummaryByDate_"+time+".xls";
		JSONObject jo = new JSONObject();
		jo.accumulate("filePathXLS",filePathXLS);
		jo.accumulate("downloadFileName",downloadFileName);
		jo.accumulate("isSuccess", b + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 订单统计列表导出:先保存在服务器,在下载
	 * @param list   数据集合
	 * @return
	 * @throws IOException
	 * @throws RowsExceededException
	 */
	@SuppressWarnings("rawtypes")
	public boolean madeExl(List<Map<String, Object>> list,long time)throws IOException, RowsExceededException{
		boolean b=true;
		try {
			String url =String.valueOf(getFileUrlConfig().get("fileUploadRoot"));
			File file = new File(url+"/excel");
			file.mkdirs();
			File toFile = new File(url+"/excel/SummaryByDate_"+time+".xls");
			if(!toFile.exists()){ 
				toFile.createNewFile();}// 创建目标文件
			WritableWorkbook wbook = Workbook.createWorkbook(toFile);
			// 创建一个工作表 第一个工作区
			WritableSheet wsheet = wbook.createSheet("SHOPJSP:商户交易汇总表(按照店铺日期汇总)", 0);
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD, false);//设置字体
	        WritableCellFormat wcfmt3 = new WritableCellFormat(wf3);
	        wcfmt3.setWrap(true);// 自动换行
	        wcfmt3.setVerticalAlignment(VerticalAlignment.TOP);//顶端对齐
	        wcfmt3.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //设置边框
	        wcfmt3.setAlignment(jxl.format.Alignment.CENTRE);
			biaoge(wsheet);
			int i=1;//拿list中的数据[因为有大表头,所以从2开始生成数据]
			if(list!=null&&list.size()>0){
				for(Map m:list){
					Label a = new Label(0, i+1, String.valueOf(i), wcfmt3);//1序号
					wsheet.addCell(a);
					Label companyName = new Label(1, i+1, String.valueOf(m.get("companyName")), wcfmt3);//2公司名称 
					wsheet.addCell(companyName);
					Label shopName = new Label(2, i+1, String.valueOf(m.get("shopName")), wcfmt3);//3店铺名称
					wsheet.addCell(shopName);
					Label transactionAmount = new Label(3, i+1, String.valueOf(m.get("transactionAmount")), wcfmt3);//4交易金额 (己完成交易)
					wsheet.addCell(transactionAmount);
					Label commissionProportion = new Label(4, i+1, String.valueOf(m.get("commissionProportion")), wcfmt3);//5佣金百分比
					wsheet.addCell(commissionProportion);
					Label commissionAmount = new Label(5, i+1, String.valueOf(m.get("commissionAmount")), wcfmt3);//6佣金 
					wsheet.addCell(commissionAmount);
					Label payableAmount = new Label(6, i+1, String.valueOf(m.get("payableAmount")), wcfmt3);//7平台给店铺结算的应付金额
					wsheet.addCell(payableAmount);
					Label createTime = new Label(7, i+1, String.valueOf(m.get("createTime")), wcfmt3);//8统计日期
					wsheet.addCell(createTime);
					i++;
				}
			}else{
				Label cwqd = new Label(1, i+1, "错误清单", wcfmt3);//错误
				wsheet.addCell(cwqd);
			}
			wbook.write();// 写入文件
			wbook.close();
		} catch (WriteException e) {
			b=false;
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} 
		return b;
	}
	/**
	 * 设置表格样式
	 * @return
	 * @throws WriteException 
	 */
	public void biaoge(WritableSheet wsheet) throws WriteException{
		//设置 行、 列的 宽度 、高度
		wsheet.setColumnView(0, 5); // 设置列的宽度---序号
		wsheet.setColumnView(1, 25); // 设置列的宽度---公司名称
		wsheet.setColumnView(2, 17); // 设置列的宽度---店铺名称
		wsheet.setColumnView(3, 30); // 设置列的宽度---交易金额 (己完成交易)
		wsheet.setColumnView(4, 25); // 设置列的宽度---佣金百分比
		wsheet.setColumnView(5, 12); // 设置列的宽度---佣金 
		wsheet.setColumnView(6, 17); // 设置列的宽度---平台给店铺结算的应付金额
		wsheet.setColumnView(7, 17); // 设置列的宽度---统计日期
		//让 第一列居中
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 20, WritableFont.NO_BOLD, false);
        WritableCellFormat wcfmt = new WritableCellFormat(wf);
        wcfmt.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
        wcfmt.setAlignment(jxl.format.Alignment.CENTRE);
        wcfmt.setBackground(jxl.format.Colour.BLACK); // 设置单元格的背景颜色
        Label lable1 = new Label(0,0,"SHOPJSP:商户交易汇总表(按照店铺日期汇总)",wcfmt);//添加 Lable对象  (列、行)
        wsheet.addCell(lable1);
		wsheet.mergeCells(0, 0, 7, 0);//合并单元格（列、行）
		 //列头
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.NO_BOLD, false);
        WritableCellFormat wcfmt2 = new WritableCellFormat(wf2);
        wcfmt2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
        wcfmt2.setAlignment(jxl.format.Alignment.CENTRE);
        wcfmt2.setBackground(jxl.format.Colour.GRAY_25);// 设置单元格的背景颜色
		String[] title = {"序号","公司名称", "店铺名称", "交易金额 (己完成交易)(元)","佣金百分比(%)", "佣金 (元)","平台给店铺结算的应付金额(元)","统计日期"};
		for (int m = 0; m < title.length; m++) {		// 设置表头
			Label excelTitle = new Label(m, 1, title[m], wcfmt2);// 一列列的打印表头 按照我们规定的格式
			wsheet.addCell(excelTitle);// 把标头加到我们的工作区
		}
	}
	
	public List<Map<String, Object>> getTransactionsByDateList() {
		return transactionsByDateList;
	}
	public void setTransactionsByDateList(
			List<Map<String, Object>> transactionsByDateList) {
		this.transactionsByDateList = transactionsByDateList;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	
}
