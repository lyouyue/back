package shop.store.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.store.pojo.SupplierMallCoinDetail;
import shop.store.service.ISupplierMallCoinDetailService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.Utils;
/**
 * 供应商金币收支明细Action
 * @author lmh
 * **/
public class SupplierMallCoinDetailAction extends BaseAction{
	/**供应商金币收支明细Service**/
	private ISupplierMallCoinDetailService supplierMallCoinDetailService;
	/**
	 * 供应商金币收支明细bean
	 * **/
	private SupplierMallCoinDetail supplierMallCoinDetail;
	/**
	 * 供应商金币收支明细List
	 * **/
	private List<Map> supplierMallCoinDetailList;
	/**导出excel文件的列名称**/
	private List<String> typeNameList = new ArrayList<String>();

	//跳转供应商金币收支明细页面
	public String gotoSupplierMallCoinDetailPage(){
			return SUCCESS;
	}
	//供应商金币明细列表
	public void listSupplierMallCoinDetail()throws IOException{
		//hql查询语句
		String hql="SELECT a.supplierLoginName as supplierLoginName, c.loginName AS loginName, s.shopName AS shopName,a.ordersNo as ordersNo,a.tradingTime as tradingTime ,a.type as type ,a.tradMallCoin as tradMallCoin ,a.totalInPut as totalInPut ,a.totalOutPut as totalOutPut FROM SupplierMallCoinDetail a,"+
		" Orders o,ShopInfo s,Customer c";
		String countHql="SELECT count(a.supplierLoginName) FROM SupplierMallCoinDetail a,Orders o,ShopInfo s,Customer c";
		//获取前台查询参数
		String supplierLoginName = request.getParameter("supplierLoginName");
		String registerDate = request.getParameter("registerDate");
		String registerDate2 = request.getParameter("registerDate2");
		String ordersNo = request.getParameter("ordersNo");
		String shopName = request.getParameter("shopName");
		//追加where条件
		hql+=" where 1=1 AND a.ordersId=o.ordersId AND o.shopInfoId=s.shopInfoId AND o.customerId=c.customerId";
		countHql+=" where 1=1 AND a.ordersId=o.ordersId AND o.shopInfoId=s.shopInfoId AND o.customerId=c.customerId";
		if(supplierLoginName!=null&&!"".equals(supplierLoginName)){
			hql+=" and a.supplierLoginName like '%"+supplierLoginName+"%'";
			countHql+=" and a.supplierLoginName like '%"+supplierLoginName+"%'";
		}
		if(registerDate!=null&&!"".equals(registerDate)){
			hql+= " and UNIX_TIMESTAMP(a.tradingTime) >= UNIX_TIMESTAMP('"+registerDate+"')";
			countHql+= " and UNIX_TIMESTAMP(a.tradingTime) >= UNIX_TIMESTAMP('"+registerDate+"')";
		}
		if(registerDate2!=null&&!"".equals(registerDate2)){
			hql+= " and UNIX_TIMESTAMP(a.tradingTime) <= UNIX_TIMESTAMP('"+registerDate2+"')";
			countHql+= " and UNIX_TIMESTAMP(a.tradingTime) <= UNIX_TIMESTAMP('"+registerDate2+"')";
		}
		if(ordersNo!=null&&!"".equals(ordersNo)){
			hql+=" and a.ordersNo like '%"+ordersNo+"%'";
			countHql+=" and a.ordersNo like '%"+ordersNo+"%'";
		}
		if(Utils.objectIsNotEmpty(shopName)){
			hql+=" and s.shopName like '%"+shopName.trim()+"%'";
			countHql+=" and s.shopName like '%"+shopName.trim()+"%'";
		}
		int totalRecordCount = supplierMallCoinDetailService.getMultilistCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		supplierMallCoinDetailList = supplierMallCoinDetailService.findListMapPage(hql+" order by a.tradingTime desc", pageHelper);
		if(supplierMallCoinDetailList!=null&&supplierMallCoinDetailList.size()>0){
			for(Map<String,Object> m:supplierMallCoinDetailList){
				SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String time = fm.format(m.get("tradingTime"));
				m.put("tradingTime", time);
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", supplierMallCoinDetailList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}


	/**excel列名**/
	private List<String> ordersColumnNamesList(){
		typeNameList.add(0,"供应商登录名称");
		typeNameList.add("购买会员名");
		typeNameList.add("店铺名");
		typeNameList.add("订单号");
		typeNameList.add("交易时间");
		typeNameList.add("交易类型");
		typeNameList.add("交易金币");
		typeNameList.add("总收入");
		typeNameList.add("总支出");
		return typeNameList;
	}
	/**
	 * 导出分享记录EXCEL
	 */
	public String exportSupplierMallCoinExcel() throws IOException{
		//hql查询语句
		String hql="SELECT a.supplierLoginName as supplierLoginName,a.ordersNo as ordersNo,a.tradingTime as tradingTime ,a.type as type ,a.tradMallCoin as tradMallCoin ,a.totalInPut as totalInPut ,a.totalOutPut as totalOutPut FROM SupplierMallCoinDetail a,ShopInfo s,Customer c,Orders o";
		//获取前台查询参数
		String loginName = request.getParameter("loginName");
		String createTime = request.getParameter("createTime");
		String endTime = request.getParameter("endTime");
		String ordersNo = request.getParameter("ordersNo");
		//追加where条件
		hql+=" where 1=1 AND a.ordersId=o.ordersId AND o.shopInfoId=s.shopInfoId AND o.customerId=c.customerId ";
		if(loginName!=null&&!"".equals(loginName)){
			hql+=" and a.supplierLoginName like '%"+loginName+"%'";
		}
		if(createTime!=null&&!"".equals(createTime)){
			hql+= " and UNIX_TIMESTAMP(a.tradingTime) >= UNIX_TIMESTAMP('"+createTime+"')";
		}
		if(endTime!=null&&!"".equals(endTime)){
			hql+= " and UNIX_TIMESTAMP(a.tradingTime) <= UNIX_TIMESTAMP('"+endTime+"')";
		}
		if(ordersNo!=null&&!"".equals(ordersNo)){
			hql+=" and a.ordersNo like '%"+ordersNo+"%'";
		}
		supplierMallCoinDetailList = supplierMallCoinDetailService.findListMapByHql(hql+" order by a.tradingTime desc");
		if(supplierMallCoinDetailList!=null&&supplierMallCoinDetailList.size()>0){
			for(Map<String,Object> m:supplierMallCoinDetailList){
				SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String time = fm.format(m.get("tradingTime"));
				m.put("tradingTime", time);
			}
		}
		if(supplierMallCoinDetailList!=null&&supplierMallCoinDetailList.size()>0){
			session.setAttribute("columnNames", ordersColumnNamesList());//把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues", ordersColumnValuesList(supplierMallCoinDetailList));//把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "SupplierMallCoin");
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
		for(Map cc : list){
			List<String> columnValuesList = null;
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.get("supplierLoginName")));
			columnValuesList.add(String.valueOf(cc.get("loginName")));
			columnValuesList.add(String.valueOf(cc.get("shopName")));
			String ordersNo ="无";
			Object ordersObj = cc.get("ordersNo");
			if(ordersObj!=null){
				ordersNo = String.valueOf(ordersObj);
			}
			columnValuesList.add(ordersNo);
			columnValuesList.add(String.valueOf(cc.get("tradingTime")));
			String type = "";
			String typeStr = String.valueOf(cc.get("type"));
			if("1".equals(typeStr)){
				type = "收入";
			}else if("2".equals(typeStr)){
				type = "支出";
			}else if("3".equals(typeStr)){
				type = "提现";
			}else if("4".equals(typeStr)){
				type = "提现失败";
			}
			columnValuesList.add(type);
			String tradMallCoin = "";
			Object tradMallCoinObj = cc.get("tradMallCoin");
			if(tradMallCoinObj!=null){
				tradMallCoin = String.valueOf(tradMallCoinObj);
			}
			columnValuesList.add(tradMallCoin);
			String totalInPut = "";
			Object totalInPutObj = cc.get("totalInPut");
			if(totalInPutObj!=null){
				totalInPut = String.valueOf(totalInPutObj);
			}
			columnValuesList.add(totalInPut);
			String totalOutPut = "";
			Object totalOutPutObj = cc.get("totalOutPut");
			if(totalOutPutObj!=null){
				totalOutPut = String.valueOf(totalOutPutObj);
			}
			columnValuesList.add(totalOutPut);
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


	public void setSupplierMallCoinDetailService(
			ISupplierMallCoinDetailService supplierMallCoinDetailService) {
		this.supplierMallCoinDetailService = supplierMallCoinDetailService;
	}

	public SupplierMallCoinDetail getSupplierMallCoinDetail() {
		return supplierMallCoinDetail;
	}

	public void setSupplierMallCoinDetail(
			SupplierMallCoinDetail supplierMallCoinDetail) {
		this.supplierMallCoinDetail = supplierMallCoinDetail;
	}
	public List<Map> getSupplierMallCoinDetailList() {
		return supplierMallCoinDetailList;
	}
	public void setSupplierMallCoinDetailList(List<Map> supplierMallCoinDetailList) {
		this.supplierMallCoinDetailList = supplierMallCoinDetailList;
	}
	public List<String> getTypeNameList() {
		return typeNameList;
	}
	public void setTypeNameList(List<String> typeNameList) {
		this.typeNameList = typeNameList;
	}
}
