package rating.platform;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import net.sf.json.JsonConfig;
import org.apache.log4j.Logger;
import shop.order.pojo.Orders;
import shop.order.service.IOrdersService;
import shop.returnsApply.pojo.ReturnsApply;
import shop.returnsApply.service.IReturnsApplyService;
import shop.store.pojo.ShopSettlementDetail;
import shop.store.service.IShopInfoService;
import shop.store.service.IShopSettlementDetailService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.ConfigUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
@SuppressWarnings({"rawtypes","unchecked","unused","serial"})
public class SellerSettlementAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	/**店铺信息Service**/
	private IShopInfoService shopInfoService;
	/**订单Service**/
	private IOrdersService ordersService;
	/**店铺申请结算明细Service**/
	private IShopSettlementDetailService shopSettlementDetailService;
	/**退换货申请service**/
	private IReturnsApplyService returnsApplyService;
	/**店铺申请结算明细集合**/
	private List<ShopSettlementDetail> shopSettlementDetailList = new ArrayList<ShopSettlementDetail>();
	/**卖家信息集合**/
	private List<Map> shopInfoList = new ArrayList<Map>();
	/**订单集合**/
	private List<Orders> ordersList = new ArrayList<Orders>();
	/**店铺申请结算明细集合Map*/
	private List<Map> shopSettlementDetailListMap=new ArrayList<Map>();
	private String customerId;
	/**公司名称(查询条件)**/
	private String companyName;
	private String startTime;
	private String endTime;
	private String settlementId;
	/**申请结算状态*/
	private String status;
	/**店铺名*/
	private String shopName;
	//跳转到卖家信息列表
	public String gotoSellerPage(){
		return SUCCESS;
	}
	//跳转到卖家未结算订单明细列表
	public String gotoSellerOrders(){
		return SUCCESS;
	}
	//查询卖家申请结算列表信息
	public void listSellerSettlement() throws Exception{
		String hql = "select s.rebateAmount as rebateAmount,s.settlementId as settlementId,s.companyName as companyName,s.shopInfoId as shopInfoId, s.shopName as shopName,s.commissionProportion as commissionProportion,"
				+ " s.totalCost as totalCost,s.finaltTotalCost as finaltTotalCost,s.rakeCost as rakeCost,s.status as status,s.createDate as createDate,s.ordersIds as ordersIds "
				+ "from ShopSettlementDetail s where 1=1 ";
		String countHql="select count(o.settlementId) from ShopSettlementDetail o where 1=1 ";
		String shopName=request.getParameter("shopName");
		//查询条件店铺名称
		if(Utils.objectIsNotEmpty(shopName)){
			hql+=" and s.shopName like '%"+shopName+"%'";
			countHql+=" and o.shopName like'%"+shopName+"%'";
		}
		//查询条件申请结算状态
		if(Utils.objectIsNotEmpty(status)&&(!"-1".equals(status))){
			hql += " and s.status="+status;
			countHql += " and o.status="+status;
		}
		//查询条件申请结算开始时间
		if(Utils.objectIsNotEmpty(startTime)){
			hql += " and UNIX_TIMESTAMP(s.createDate) >= UNIX_TIMESTAMP('"+startTime+"')";
			countHql += " and UNIX_TIMESTAMP(o.createDate) >= UNIX_TIMESTAMP('"+startTime+"')";
		}
		//查询条件申请结算结束时间
		if(Utils.objectIsNotEmpty(endTime)){
			hql += " and UNIX_TIMESTAMP('"+endTime+"') >= UNIX_TIMESTAMP(s.createDate)";
			countHql += " and UNIX_TIMESTAMP('"+endTime+"') >= UNIX_TIMESTAMP(o.createDate)";
		}
		if(companyName!=null){
			hql += " and s.companyName like '%" + companyName + "%'";
			countHql += " and o.companyName like '%" + companyName + "%'";
		}
		int totalRecordCount = shopSettlementDetailService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		//shopSettlementDetailList = shopSettlementDetailService.findListByPageHelper(null,pageHelper,hql+" order by o.settlementId desc ");
		shopSettlementDetailListMap=shopSettlementDetailService.findListMapPage(hql+" order by s.settlementId desc",pageHelper);

		//格式Map中的时间
		SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		for(Map<String,Object> m:shopSettlementDetailListMap){//格式化创建时间
			if(m.get("createDate")!=null){
				Date date = (Date) m.get ("createDate");
				String format = fm.format(date);
				m.put("createDate", format);
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", shopSettlementDetailListMap);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//订单结算明细列表信息
	public void listSellerNoSettlementOrders() throws Exception{
		ShopSettlementDetail shopSettlementDetail = (ShopSettlementDetail) shopSettlementDetailService.getObjectByParams(" where o.settlementId="+settlementId);
		String hql = " where 1=1";
		int totalRecordCount = ordersService.getCount(hql+" and o.ordersId in("+shopSettlementDetail.getOrdersIds()+")");
		String [] selectColumns = {"ordersId","changeAmount","customerId","ordersNo","totalAmount","finalAmount","ordersState","settlementStatus","freight","taxation","isReturn"};
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		ordersList = ordersService.findListByPageHelper(selectColumns, pageHelper, hql+" and o.ordersId in("+shopSettlementDetail.getOrdersIds()+")");
		//#全局店铺抽佣比例 5%
		String commissionProportion = (String) ConfigUtils.getFileUrlConfigValue("finance_commission_proportion");
		for (Orders orders : ordersList) {
			BigDecimal rakeAmount = new BigDecimal(0);//平台抽取营业额让利金额
			BigDecimal finalAmount = new BigDecimal(0);//订单消费金额
			BigDecimal changeAmount = new BigDecimal(0);//金币抵扣金额
			if(Utils.objectIsNotEmpty(orders.getFinalAmount())){
				finalAmount = new BigDecimal(String.valueOf(orders.getFinalAmount()));
			}
			if(Utils.objectIsNotEmpty(orders.getChangeAmount())){
				changeAmount = new BigDecimal(String.valueOf(orders.getChangeAmount()));
			}
			//平台抽取营业额让利金额rakeAmount
			if(Utils.objectIsNotEmpty(commissionProportion)){
				rakeAmount = finalAmount.add(changeAmount).multiply(new BigDecimal(commissionProportion)).multiply(new BigDecimal("0.01")).setScale(2, BigDecimal.ROUND_HALF_UP);
			}
			orders.setRakeAmount(rakeAmount);
			BigDecimal returnAmountTotal = new BigDecimal(0);//退货返还总金额
			BigDecimal changeAmountTotal = new BigDecimal(0);//退货返还财富券总金额
			if(Utils.objectIsNotEmpty(orders.getIsReturn())){
				List<ReturnsApply> returnsApplyList = returnsApplyService.findObjects(" where o.ordersId = "+orders.getOrdersId());
				if(Utils.collectionIsNotEmpty(returnsApplyList)){
					for(ReturnsApply ra:returnsApplyList){
						//有申请退货且退货已完成
						if(Utils.objectIsNotEmpty(ra)&&Utils.objectIsNotEmpty(ra.getApplyState())&&Utils.objectIsNotEmpty(ra.getReturnsState())){
							//审核状态：1 等待处理 2 同意 3 拒绝
							if(ra.getApplyState()==2&&ra.getReturnsState()>=4){
								returnAmountTotal = returnAmountTotal.add(ra.getReturnAmount());
								changeAmountTotal = changeAmountTotal.add(ra.getChangeAmount().multiply(new BigDecimal(ra.getCount())));
							}
						}
					}

				}
			}
			orders.setChangeAmountTotal(changeAmountTotal);
			orders.setReturnAmountTotal(returnAmountTotal);
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", ordersList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**
	 * 审核商家申请的结算
	 * @throws Exception
     */
	public void check()throws Exception{
		boolean isSuccess = false;
		JSONObject jo=new JSONObject();
		String parameter = request.getParameter("checkParams");
		String settlementId = request.getParameter("settlementId");
		String paymentInfo = request.getParameter("paymentInfo");
		//如果paymentInfo不为空则为付款，为空是改变审核状态
		if(Utils.objectIsNotEmpty(paymentInfo)&&Utils.objectIsNotEmpty(settlementId)){
			isSuccess = shopSettlementDetailService.saveOrUpdatePayForShop(settlementId,paymentInfo);
		}else{
			if(Utils.objectIsNotEmpty(parameter)&&Utils.objectIsNotEmpty(settlementId)){
				//status 1.待审核 2.审核通过 3.审核未通过 4已结算
				isSuccess = shopSettlementDetailService.updateBySQL("UPDATE shop_settlement_detail SET status='"+Integer.parseInt(parameter)+"' WHERE settlementId='"+settlementId+"'");
			}
		}
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 获取一个对象
	 */
	public void getOneObject()throws IOException{
		ShopSettlementDetail shopSettlementDetail = (ShopSettlementDetail) shopSettlementDetailService.getObjectByParams(" where o.settlementId="+settlementId);
		JSONObject jo=JSONObject.fromObject(shopSettlementDetail);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 平台与卖家结算导出
	 */
	public void importExcelSellerSettlement() throws Exception{
		String hql = "select s.settlementId as settlementId,s.companyName as companyName, s.shopName as shopName, s.totalCost as totalCost,s.totalCost*s.commissionProportion*0.01 as commission,s.totalCost*(1-s.commissionProportion*0.01) as paymentCost,s.commissionProportion as commissionProportion, s.status as status,s.createDate as createDate from ShopSettlementDetail s where 1=1";
		//查询条件申请结算状态
		if(Utils.objectIsNotEmpty(status)&&(!"-1".equals(status))){
			hql += " and status="+status;
		}
		//查询条件申请结算开始时间
		if(Utils.objectIsNotEmpty(startTime)){
			hql += " and UNIX_TIMESTAMP(o.createDate) >= UNIX_TIMESTAMP('"+startTime+"')";
		}
		//查询条件申请结算结束时间
		if(Utils.objectIsNotEmpty(endTime)){
			hql += " and UNIX_TIMESTAMP('"+endTime+"') >= UNIX_TIMESTAMP(o.createDate)";
		}
		shopSettlementDetailListMap=shopSettlementDetailService.findListMapByHql(hql+" order by s.settlementId desc");
		//格式Map中的时间
		SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		for(Map<String,Object> m:shopSettlementDetailListMap){//格式化创建时间
			if(m.get("createDate")!=null){
				Date date = (Date) m.get ("createDate");
				String format = fm.format(date);
				m.put("createDate", format);
			}
		}
		long time = new Date().getTime();
		Boolean b = madeExl(shopSettlementDetailListMap,time);
		//相对路径[服务器]
		String filePathXLS ="excel/shopSettlement_"+time+".xls";
		//文件名
		String downloadFileName = "shopSettlement_"+time+".xls";
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
	public boolean madeExl(List<Map> list,long time)throws IOException, RowsExceededException{
		boolean b=true;
		try {
			String url =String.valueOf(getFileUrlConfig().get("fileUploadRoot"));
			File file = new File(url+"/excel");
			file.mkdirs();
			File toFile = new File(url+"/excel/shopSettlement_"+time+".xls");
			if(!toFile.exists()){
				toFile.createNewFile();}// 创建目标文件
			WritableWorkbook wbook = Workbook.createWorkbook(toFile);
			// 创建一个工作表 第一个工作区
			WritableSheet wsheet = wbook.createSheet("SHOPJSP:平台与卖家结算汇总表", 0);
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
					Label totalCost = new Label(3, i+1, String.valueOf(m.get("totalCost")), wcfmt3);//4申请结算金额
					wsheet.addCell(totalCost);
					Label commissionProportion = new Label(4, i+1, String.valueOf(m.get("commissionProportion"))+"%", wcfmt3);//5佣金百分比
					wsheet.addCell(commissionProportion);
					Label commission = new Label(5, i+1, String.valueOf(m.get("commission")), wcfmt3);//6佣金 
					wsheet.addCell(commission);
					Label paymentCost = new Label(6, i+1, String.valueOf(m.get("paymentCost")), wcfmt3);//7应付金额
					wsheet.addCell(paymentCost);
					Label createDate = new Label(7, i+1, String.valueOf(m.get("createDate")), wcfmt3);//8申请时间
					wsheet.addCell(createDate);
					if("0".equals(String.valueOf(m.get("status")))){
						Label status = new Label(8, i+1, "未结算", wcfmt3);//8结算状态
						wsheet.addCell(status);
					}else if("1".equals(String.valueOf(m.get("status")))){
						Label status = new Label(8, i+1,"待审核", wcfmt3);//8结算状态
						wsheet.addCell(status);
					}else if("2".equals(String.valueOf(m.get("status")))){
						Label status = new Label(8, i+1,"审核通过", wcfmt3);//8结算状态
						wsheet.addCell(status);
					}else if("3".equals(String.valueOf(m.get("status")))){
						Label status = new Label(8, i+1, "审核未通过", wcfmt3);//8结算状态
						wsheet.addCell(status);
					}else{
						Label status = new Label(8, i+1, "已结算", wcfmt3);//8结算状态
						wsheet.addCell(status);
					}
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
		wsheet.setColumnView(3, 30); // 设置列的宽度---申请结算金额
		wsheet.setColumnView(4, 25); // 设置列的宽度---佣金百分比
		wsheet.setColumnView(5, 12); // 设置列的宽度---佣金 
		wsheet.setColumnView(6, 17); // 设置列的宽度---应付金额
		wsheet.setColumnView(7, 17); // 设置列的宽度---申请时间
		wsheet.setColumnView(8, 17); // 设置列的宽度---结算状态
		//让 第一列居中
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 20, WritableFont.NO_BOLD, false);
        WritableCellFormat wcfmt = new WritableCellFormat(wf);
        wcfmt.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
        wcfmt.setAlignment(jxl.format.Alignment.CENTRE);
        wcfmt.setBackground(jxl.format.Colour.BLACK); // 设置单元格的背景颜色
        Label lable1 = new Label(0,0,"SHOPJSP:平台与卖家结算汇总表",wcfmt);//添加 Lable对象  (列、行)
        wsheet.addCell(lable1);
		wsheet.mergeCells(0, 0, 8, 0);//合并单元格（列、行）
		 //列头
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.NO_BOLD, false);
        WritableCellFormat wcfmt2 = new WritableCellFormat(wf2);
        wcfmt2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
        wcfmt2.setAlignment(jxl.format.Alignment.CENTRE);
        wcfmt2.setBackground(jxl.format.Colour.GRAY_25);// 设置单元格的背景颜色
		String[] title = {"序号","公司名称", "店铺名称", "申请结算金额(元)","佣金百分比", "佣金 (元)","应付金额 (元)","统计日期","结算状态"};
		for (int m = 0; m < title.length; m++) {		// 设置表头
			Label excelTitle = new Label(m, 1, title[m], wcfmt2);// 一列列的打印表头 按照我们规定的格式
			wsheet.addCell(excelTitle);// 把标头加到我们的工作区
		}
	}
	/**
	 * 订单结算明细导出
	 */
	public void importExcelSellerNoSettlementOrders() throws Exception{
		ShopSettlementDetail shopSettlementDetail = (ShopSettlementDetail) shopSettlementDetailService.getObjectByParams(" where o.settlementId="+settlementId);
		String hql = "select o.ordersNo as ordersNo,o.finalAmount as finalAmount,o.ordersState as ordersState,o.settlementStatus as settlementStatus from Orders o where o.ordersId in("+shopSettlementDetail.getOrdersIds()+")";
		List<Map> ordersList = ordersService.findListMapByHql(hql+" order by o.ordersId desc");
		long time = new Date().getTime();
		Boolean b = madeSellerNoSettlementOrdersExl(ordersList,time,shopSettlementDetail.getCompanyName());
		//相对路径[服务器]
		String filePathXLS ="excel/SellerNoSettlementOrders_"+time+".xls";
		//文件名
		String downloadFileName = "SellerNoSettlementOrders_"+time+".xls";
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
	 * 订单结算明细列表导出:先保存在服务器,在下载
	 * @param list   数据集合
	 * @return
	 * @throws IOException
	 * @throws RowsExceededException
	 */
	public boolean madeSellerNoSettlementOrdersExl(List<Map> list,long time,String companyName)throws IOException, RowsExceededException{
		boolean b=true;
		try {
			String url =String.valueOf(getFileUrlConfig().get("fileUploadRoot"));
			File file = new File(url+"/excel");
			file.mkdirs();
			File toFile = new File(url+"/excel/SellerNoSettlementOrders_"+time+".xls");
			if(!toFile.exists()){
				toFile.createNewFile();}// 创建目标文件
			WritableWorkbook wbook = Workbook.createWorkbook(toFile);
			// 创建一个工作表 第一个工作区
			WritableSheet wsheet = wbook.createSheet(companyName, 0);
			WritableFont wf3 = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD, false);//设置字体
			WritableCellFormat wcfmt3 = new WritableCellFormat(wf3);
			wcfmt3.setWrap(true);// 自动换行
			wcfmt3.setVerticalAlignment(VerticalAlignment.TOP);//顶端对齐
			wcfmt3.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //设置边框
			wcfmt3.setAlignment(jxl.format.Alignment.CENTRE);
			sellerNoSettlementOrdersBiaoge(wsheet);
			int i=1;//拿list中的数据[因为有大表头,所以从2开始生成数据]
			if(list!=null&&list.size()>0){
				for(Map m:list){
					Label a = new Label(0, i+1, String.valueOf(i), wcfmt3);//1序号
					wsheet.addCell(a);
					Label ordersNo = new Label(1, i+1, String.valueOf(m.get("ordersNo")), wcfmt3);//2订单号
					wsheet.addCell(ordersNo);
					Label finalAmount = new Label(2, i+1, String.valueOf(m.get("finalAmount")), wcfmt3);//3结算金额
					wsheet.addCell(finalAmount);
					if("0".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "生成订单", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("1".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1,"未付款", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("3".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1,"正在配货", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("4".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "待体检", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("5".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "确认体检", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("6".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "已取消", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("7".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "异常订单", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else{
						Label ordersState = new Label(3, i+1, "完成", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}
/*					if("0".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "生成订单", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("1".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1,"未付款", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("3".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1,"正在配货", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("4".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "已发货", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("5".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "完成", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("6".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "已取消", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else if("7".equals(String.valueOf(m.get("ordersState")))){
						Label ordersState = new Label(3, i+1, "异常订单", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}else{
						Label ordersState = new Label(3, i+1, "完成", wcfmt3);//4订单状态
						wsheet.addCell(ordersState);
					}
*/					if("0".equals(String.valueOf(m.get("settlementStatus")))){
						Label settlementStatus = new Label(4, i+1, "未付款", wcfmt3);//8客户付款状态
						wsheet.addCell(settlementStatus);
					}else if("1".equals(String.valueOf(m.get("settlementStatus")))){
						Label settlementStatus = new Label(4, i+1,"已付款", wcfmt3);//8客户付款状态
						wsheet.addCell(settlementStatus);
					}
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
	 * 设置订单结算明细表格样式
	 * @return
	 * @throws WriteException
	 */
	public void sellerNoSettlementOrdersBiaoge(WritableSheet wsheet) throws WriteException{
		//设置 行、 列的 宽度 、高度
		wsheet.setColumnView(0, 5); // 设置列的宽度---序号
		wsheet.setColumnView(1, 25); // 设置列的宽度---订单号
		wsheet.setColumnView(2, 17); // 设置列的宽度---结算金额
		wsheet.setColumnView(3, 17); // 设置列的宽度---订单状态
		wsheet.setColumnView(4, 17); // 设置列的宽度---客户付款状态
		//让 第一列居中
		WritableFont wf = new WritableFont(WritableFont.ARIAL, 20, WritableFont.NO_BOLD, false);
		WritableCellFormat wcfmt = new WritableCellFormat(wf);
		wcfmt.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
		wcfmt.setAlignment(jxl.format.Alignment.CENTRE);
		wcfmt.setBackground(jxl.format.Colour.BLACK); // 设置单元格的背景颜色
		Label lable1 = new Label(0,0,"SHOPJSP:订单结算明细汇总表",wcfmt);//添加 Lable对象  (列、行)
		wsheet.addCell(lable1);
		wsheet.mergeCells(0, 0, 4, 0);//合并单元格（列、行）
		//列头
		WritableFont wf2 = new WritableFont(WritableFont.ARIAL, 12, WritableFont.NO_BOLD, false);
		WritableCellFormat wcfmt2 = new WritableCellFormat(wf2);
		wcfmt2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); //给title设置边框
		wcfmt2.setAlignment(jxl.format.Alignment.CENTRE);
		wcfmt2.setBackground(jxl.format.Colour.GRAY_25);// 设置单元格的背景颜色
		String[] title = {"序号","订单号","结算金额(元)","订单状态","客户付款状态"};
		for (int m = 0; m < title.length; m++) {		// 设置表头
			Label excelTitle = new Label(m, 1, title[m], wcfmt2);// 一列列的打印表头 按照我们规定的格式
			wsheet.addCell(excelTitle);// 把标头加到我们的工作区
		}
	}
	public List<Map> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<Map> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public List<Orders> getOrdersList() {
		return ordersList;
	}
	public void setOrdersList(List<Orders> ordersList) {
		this.ordersList = ordersList;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public List<ShopSettlementDetail> getShopSettlementDetailList() {
		return shopSettlementDetailList;
	}
	public void setShopSettlementDetailList(
			List<ShopSettlementDetail> shopSettlementDetailList) {
		this.shopSettlementDetailList = shopSettlementDetailList;
	}
	public void setShopSettlementDetailService(
			IShopSettlementDetailService shopSettlementDetailService) {
		this.shopSettlementDetailService = shopSettlementDetailService;
	}
	public String getSettlementId() {
		return settlementId;
	}
	public void setSettlementId(String settlementId) {
		this.settlementId = settlementId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public List<Map> getShopSettlementDetailListMap() {
		return shopSettlementDetailListMap;
	}
	public void setShopSettlementDetailListMap(List<Map> shopSettlementDetailListMap) {
		this.shopSettlementDetailListMap = shopSettlementDetailListMap;
	}
	public String getShopName() {
		return shopName;
	}
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
	public IReturnsApplyService getReturnsApplyService() {
		return returnsApplyService;
	}
	public void setReturnsApplyService(IReturnsApplyService returnsApplyService) {
		this.returnsApplyService = returnsApplyService;
	}

}
