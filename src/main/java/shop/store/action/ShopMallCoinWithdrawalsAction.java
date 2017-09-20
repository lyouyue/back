package shop.store.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.store.pojo.ShopInfo;
import shop.store.pojo.ShopMallCoinWithdrawals;
import shop.store.pojo.SupplierMallCoinDetail;
import shop.store.service.IShopInfoService;
import shop.store.service.IShopMallCoinWithdrawalsService;
import shop.store.service.ISupplierMallCoinDetailService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import basic.pojo.Users;
/**
 * 供应商金币提现Action
 * @author lmh
 * **/
@SuppressWarnings("serial")
public class ShopMallCoinWithdrawalsAction extends BaseAction{
	/**供应商金币提现Service**/
	private IShopMallCoinWithdrawalsService shopMallCoinWithdrawalsService;
	/**供应商金币收支明细Service**/
	private ISupplierMallCoinDetailService supplierMallCoinDetailService;
	/**店铺Service**/
	private IShopInfoService shopInfoService;

	/**
	 * 供应商金币提现bean
	 * **/
	private ShopMallCoinWithdrawals shopMallCoinWithdrawals;
	/**
	 * 供应商金币提现List
	 * **/
	private List<Map> shopMallCoinWithdrawalsList;
	/**导出excel文件的列名称**/
	private List<String> typeNameList = new ArrayList<String>();
	private String ids;
	//跳转供应商金币提现页面
	public String gotoShopMallCoinWithdrawalsPage(){
			return SUCCESS;
	}
	//供应商金币提现列表
	public void listShopMallCoinWithdrawals()throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String hql="SELECT a.detailId as detailId,a.payeeName as payeeName,s.shopName AS shopName,a.withdrawBL as withdrawBL,a.serialNumber as serialNumber ,a.state as state ,a.transactionAmount as transactionAmount,a.tradeTime as tradeTime,a.reviewer as reviewer,a.reviewerDate as reviewerDate  FROM ShopMallCoinWithdrawals a,ShopInfo s "+
		" where a.incomeExpensesType=5  AND a.payeeId=s.customerId";
		String countHql="SELECT count(a.detailId) FROM ShopMallCoinWithdrawals a where a.incomeExpensesType=5 ";
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String payeeName = request.getParameter("payeeName");
			String serialNumber = request.getParameter("serialNumber");
			String beginTime = request.getParameter("beginTime");
			String endTime = request.getParameter("endTime");
			if(payeeName!=null&&!"".equals(payeeName)){
				hql+=" and a.payeeName like '%"+payeeName+"%'";
				countHql+=" and a.payeeName like '%"+payeeName+"%'";
			}
			if(serialNumber!=null&&!"".equals(serialNumber)){
				hql+=" and a.serialNumber like '%"+serialNumber+"%'";
				countHql+=" and a.serialNumber like '%"+serialNumber+"%'";
			}
			if(beginTime!=null&&!"".equals(beginTime)){
				hql+= " and UNIX_TIMESTAMP(a.tradeTime) >= UNIX_TIMESTAMP('"+beginTime+"')";
				countHql+= " and UNIX_TIMESTAMP(a.tradeTime) >= UNIX_TIMESTAMP('"+beginTime+"')";
			}
			if(endTime!=null&&!"".equals(endTime)){
				hql+= " and UNIX_TIMESTAMP(a.tradeTime) <= UNIX_TIMESTAMP('"+endTime+"')";
				countHql+= " and UNIX_TIMESTAMP(a.tradeTime) <= UNIX_TIMESTAMP('"+endTime+"')";
			}
		}
		int totalRecordCount = shopMallCoinWithdrawalsService.getMultilistCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		shopMallCoinWithdrawalsList = shopMallCoinWithdrawalsService.findListMapPage(hql+" order by a.tradeTime desc", pageHelper);
		if(shopMallCoinWithdrawalsList!=null&&shopMallCoinWithdrawalsList.size()>0){
			for(Map<String,Object> m:shopMallCoinWithdrawalsList){
				SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String time = fm.format(m.get("tradeTime"));
				m.put("tradeTime", time);
				String reviewerDate = "";
				Object reviewerDateObj = m.get("reviewerDate");//审核时间
				if(reviewerDateObj!=null){
					reviewerDate = fm.format(reviewerDateObj);
				}
				m.put("reviewerDate", reviewerDate);
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", shopMallCoinWithdrawalsList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**excel列名**/
	private List<String> ordersColumnNamesList(){
		typeNameList.add(0,"收款人姓名");
		typeNameList.add("店铺名");
		typeNameList.add("提现比例");
		typeNameList.add("流水号");
		typeNameList.add("交易金额");
		typeNameList.add("交易时间");
		typeNameList.add("审核状态");
		typeNameList.add("审核人");
		typeNameList.add("审核时间");
		return typeNameList;
	}
	/**
	 * 导出分享记录EXCEL
	 */
	public String exportShopMallCoinWithdrawalsExcel() throws IOException{
		String hql="SELECT a.payeeName as payeeName,s.shopName as shopName,a.withdrawBL as withdrawBL,a.serialNumber as serialNumber ,a.state as state ,a.transactionAmount as transactionAmount,a.tradeTime as tradeTime,a.reviewer as reviewer,a.reviewerDate as reviewerDate  FROM ShopMallCoinWithdrawals a,ShopInfo s  where a.incomeExpensesType=5 and a.payeeId=s.customerId ";
		String payeeName = request.getParameter("payeeName");
		String serialNumber = request.getParameter("serialNumber");
		String beginTime = request.getParameter("beginTime");
		String endTime = request.getParameter("endTime");
		if(payeeName!=null&&!"".equals(payeeName)){
			hql+=" and a.payeeName like '%"+payeeName+"%'";
		}
		if(serialNumber!=null&&!"".equals(serialNumber)){
			hql+=" and a.serialNumber like '%"+serialNumber+"%'";
		}
		if(beginTime!=null&&!"".equals(beginTime)){
			hql+= " and UNIX_TIMESTAMP(a.tradeTime) >= UNIX_TIMESTAMP('"+beginTime+"')";
		}
		if(endTime!=null&&!"".equals(endTime)){
			hql+= " and UNIX_TIMESTAMP(a.tradeTime) <= UNIX_TIMESTAMP('"+endTime+"')";
		}
		shopMallCoinWithdrawalsList = shopMallCoinWithdrawalsService.findListMapByHql(hql+" order by a.tradeTime desc");
		if(shopMallCoinWithdrawalsList!=null&&shopMallCoinWithdrawalsList.size()>0){
			for(Map<String,Object> m:shopMallCoinWithdrawalsList){
				SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String time = fm.format(m.get("tradeTime"));
				m.put("tradeTime", time);
				String reviewerDate = "";
				Object reviewerDateObj = m.get("reviewerDate");//审核时间
				if(reviewerDateObj!=null){
					reviewerDate = fm.format(reviewerDateObj);
				}
				m.put("reviewerDate", reviewerDate);
			}
			session.setAttribute("columnNames", ordersColumnNamesList());//把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues", ordersColumnValuesList(shopMallCoinWithdrawalsList));//把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "ShopMallCoinWithdrawals");
			return "success";
		}else {
			this.addActionError("没有数据");
			return "error";
		}
	}
	/**excel对应列的值**/
	public List<List<String>> ordersColumnValuesList(List<Map> list) throws IOException{
		//保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		List<String> columnValuesList = null;
		for(Map cc : list){
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(paramsValue(cc.get("payeeName")));
			columnValuesList.add(paramsValue(cc.get("shopName")));
			columnValuesList.add(paramsValue(cc.get("withdrawBL")));
			columnValuesList.add(paramsValue(cc.get("serialNumber")));
			columnValuesList.add(paramsValue(cc.get("transactionAmount")));
			columnValuesList.add(paramsValue(cc.get("tradeTime")));
			String state = "";
			String stateStr = String.valueOf(cc.get("state"));
			if("1".equals(stateStr)){
				state = "申请提现";
			}else if("2".equals(stateStr)){
				state = "审核通过";
			}else if("3".equals(stateStr)){
				state = "审核未通过";
			}else if("4".equals(stateStr)){
				state = "支付完成";
			}else if("5".equals(stateStr)){
				state = "支付失败";
			}
			columnValuesList.add(state);
			columnValuesList.add(paramsValue(cc.get("reviewer")));
			columnValuesList.add(paramsValue(cc.get("reviewerDate")));
			columnRowsList.add(columnValuesList);//把当前的行 添加到 列表中
		}
		return columnRowsList;
	}


	/**
	 * excel导出字段去空处理
	 * @param paramsObj 从map中获取的obj对象
	 * @return paramsValue 去空后的值
	 */
	public String paramsValue(Object paramsObj){
		String paramsValue = "";
		if(paramsObj!=null){
			paramsValue = String.valueOf(paramsObj);
		}
		return paramsValue;
	}

	//获取一条记录
	public void getShopMallCoinWithdrawalsById() throws IOException{
		shopMallCoinWithdrawals = (ShopMallCoinWithdrawals) shopMallCoinWithdrawalsService.getObjectByParams(" where o.detailId='"+ids+"'");
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(shopMallCoinWithdrawals,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public void saveOrUpdateShopMallCoinWithdrawalsObject() throws IOException{
		Users users =(Users)session.getAttribute("users");
		ShopMallCoinWithdrawals shopMallCoinWithdrawals1 =(ShopMallCoinWithdrawals) shopMallCoinWithdrawalsService.getObjectById(shopMallCoinWithdrawals.getDetailId()+"");
		if(shopMallCoinWithdrawals.getState()==3||shopMallCoinWithdrawals.getState()==5){
			ShopInfo shopInfo = (ShopInfo)shopInfoService.getObjectByParams(" where o.customerId="+shopMallCoinWithdrawals1.getPayeeId());
			SupplierMallCoinDetail sc = new  SupplierMallCoinDetail();
			sc.setSupplierId(shopInfo.getShopInfoId());//客户ID
			sc.setSupplierLoginName(shopInfo.getCustomerName());//供应商账号
			sc.setType(4);//取现失败
			//提现金币数
			BigDecimal multiply = shopMallCoinWithdrawals1.getTransactionAmount().multiply(new BigDecimal(shopMallCoinWithdrawals1.getWithdrawBL()));
			sc.setTradMallCoin(multiply);
			//查询出最后一条交易记录的余额
			List<SupplierMallCoinDetail> findObjects = supplierMallCoinDetailService.findObjects(" where o.supplierId="+shopInfo.getShopInfoId()+" order by o.supplierMallCoinDetailId desc limit 1");
			if(findObjects!=null){
				SupplierMallCoinDetail supplierMallCoinDetail = findObjects.get(0);
				BigDecimal subtract = supplierMallCoinDetail.getTotalInPut().add(multiply);
				sc.setTotalInPut(subtract);//总收入
				sc.setTotalOutPut(supplierMallCoinDetail.getTotalOutPut());
			}
			sc.setTradingTime(new Date());
			supplierMallCoinDetailService.saveOrUpdateObject(sc);
		}
		shopMallCoinWithdrawals1.setState(shopMallCoinWithdrawals.getState());
		shopMallCoinWithdrawals1.setServerMessage(shopMallCoinWithdrawals.getServerMessage());
		shopMallCoinWithdrawals1.setUpdateTime(new Date());
		shopMallCoinWithdrawals1.setReviewer(users.getUserName());
		shopMallCoinWithdrawals1.setReviewerDate(new Date());
		shopMallCoinWithdrawalsService.saveOrUpdateObject(shopMallCoinWithdrawals1);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess","true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public ShopMallCoinWithdrawals getShopMallCoinWithdrawals() {
		return shopMallCoinWithdrawals;
	}
	public void setShopMallCoinWithdrawals(
			ShopMallCoinWithdrawals shopMallCoinWithdrawals) {
		this.shopMallCoinWithdrawals = shopMallCoinWithdrawals;
	}
	public List<Map> getShopMallCoinWithdrawalsList() {
		return shopMallCoinWithdrawalsList;
	}
	public void setShopMallCoinWithdrawalsList(List<Map> shopMallCoinWithdrawalsList) {
		this.shopMallCoinWithdrawalsList = shopMallCoinWithdrawalsList;
	}
	public void setShopMallCoinWithdrawalsService(
			IShopMallCoinWithdrawalsService shopMallCoinWithdrawalsService) {
		this.shopMallCoinWithdrawalsService = shopMallCoinWithdrawalsService;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public List<String> getTypeNameList() {
		return typeNameList;
	}
	public void setTypeNameList(List<String> typeNameList) {
		this.typeNameList = typeNameList;
	}
	public void setSupplierMallCoinDetailService(
			ISupplierMallCoinDetailService supplierMallCoinDetailService) {
		this.supplierMallCoinDetailService = supplierMallCoinDetailService;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
}

