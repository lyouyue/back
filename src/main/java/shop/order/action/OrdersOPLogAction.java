package shop.order.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang.StringUtils;

import shop.order.pojo.Orders;
import shop.order.pojo.OrdersOPLog;
import shop.order.service.IOrdersOPLogService;
import shop.order.service.IOrdersService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.pojo.Users;
/**
 * 订单操作日志action操作类
 * @author 张攀攀
 *
 */
@SuppressWarnings("serial")
public class OrdersOPLogAction extends BaseAction {
	private IOrdersOPLogService ordersOPLogService;
	private IOrdersService ordersService;
	private List<Orders> ordersList;
	private List<OrdersOPLog> ordersOPLogList;
	private OrdersOPLog ordersOPLog;
	private String ordersOPLogId;
	private String ids;
	private String params;
	/**订单号**/
	private String ordersNo;
	//删除订单日志
	public void deleteOrdersOPLog(){
		ordersOPLogService.deleteObjectsByIds("ordersOPLogId", ids);
	}
	//获得订单日志对象
	@SuppressWarnings("unchecked")
	public void getOrdersOPLogObject() throws IOException{
		List<OrdersOPLog> ordersOPLogList = ordersOPLogService.findObjects(" where o.ordersNo='"+ordersNo+"' and o.ordersOperateState<=7");
		JsonConfig jsonConfig = new JsonConfig();
		Map<String,Object> map = new HashMap<String,Object>();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		ordersOPLogList = JSONArray.fromObject(ordersOPLogList,jsonConfig);
		map.put("ordersOPLogList", ordersOPLogList);
		map.put("ordersNo", ordersNo);
		JSONObject jo = JSONObject.fromObject(map,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(jo.toString());
		out.flush();
		out.close();
	}
	//保存或修改订单日志
	public void saveOrUpdateOrdersOPLog() throws ParseException{
		Users users = (Users) request.getSession().getAttribute("users");
		if(ordersOPLog != null){
			Orders orders = (Orders) ordersService.getObjectByParams(" where o.ordersId='"+ordersOPLog.getOrdersId()+"'");
			if(orders!=null){
				ordersOPLog.setOrdersNo(orders.getOrdersNo());
			}
			ordersOPLog.setOoperatorId(users.getUsersId());
			ordersOPLog.setOperatorName(users.getUserName());
			ordersOPLog.setOoperatorSource("1");
			SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
			String formatTime = sdf.format(new Date());
			Date date = sdf.parse(formatTime);
			ordersOPLog.setOperatorTime(date);
			if(ordersOPLog.getOrdersMsg()!=null && !"".equals(ordersOPLog.getOrdersMsg())){
				ordersOPLog.setOrdersOperateState(2);
			}
			ordersOPLogService.saveOrUpdateObject(ordersOPLog);
		}
	}
	//订单日志初始化列表
	@SuppressWarnings({"rawtypes", "unchecked" })
	public void ordersOPLogList() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		String countHql="select count(b.ordersNo) from OrdersOPLog a , Orders b,Customer c,ShopInfo s where a.ordersId=b.ordersId and b.customerId=c.customerId and b.shopInfoId = s.shopInfoId";
		hqlsb.append(" select b.ordersNo as ordersNo,b.ordersState as ordersState,a.operatorTime as operatorTime,a.operatorName as operatorName, a.ordersOperateState as ordersOperateState,b.createTime as createTime,c.loginName as loginName,s.shopName as shopName, s.shopInfoType AS shopInfoType from OrdersOPLog a , Orders b,Customer c,ShopInfo s where a.ordersId=b.ordersId and b.customerId=c.customerId and b.shopInfoId = s.shopInfoId");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String parameter = request.getParameter("title");
			String shopInfoType = request.getParameter("shopInfoType");
			if(StringUtils.isNotEmpty(parameter)){
				hqlsb.append(" and a.ordersNo like'%"+parameter.trim()+"%'");
				countHql+=" and a.ordersNo like'%"+parameter.trim()+"%'";
			}
			if(Utils.stringIsNotEmpty(shopInfoType)){
				hqlsb.append(" and s.shopInfoType ="+shopInfoType);
				countHql+=" and s.shopInfoType ="+shopInfoType;
			}
		}
		hqlsb.append(" order by createTime desc");
		int totalRecordCount = ordersOPLogService.getMoreTableCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> ordersOPLogList = ordersOPLogService.findListMapPage(hqlsb.toString(),pageHelper);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		SimpleDateFormat formatter = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		for(Map map:ordersOPLogList){
			map.put("operatorTime", formatter.format(map.get("operatorTime")));
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", ordersOPLogList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//订单操作日志初始化页面
	public String gotoOrdersOPLogPage(){
		return SUCCESS;
	}
	public void setOrdersOPLogService(IOrdersOPLogService ordersOPLogService) {
		this.ordersOPLogService = ordersOPLogService;
	}
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public List<Orders> getOrdersList() {
		return ordersList;
	}
	public void setOrdersList(List<Orders> ordersList) {
		this.ordersList = ordersList;
	}
	public List<OrdersOPLog> getOrdersOPLogList() {
		return ordersOPLogList;
	}
	public void setOrdersOPLogList(List<OrdersOPLog> ordersOPLogList) {
		this.ordersOPLogList = ordersOPLogList;
	}
	public OrdersOPLog getOrdersOPLog() {
		return ordersOPLog;
	}
	public void setOrdersOPLog(OrdersOPLog ordersOPLog) {
		this.ordersOPLog = ordersOPLog;
	}
	public String getOrdersOPLogId() {
		return ordersOPLogId;
	}
	public void setOrdersOPLogId(String ordersOPLogId) {
		this.ordersOPLogId = ordersOPLogId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public String getOrdersNo() {
		return ordersNo;
	}
	public void setOrdersNo(String ordersNo) {
		this.ordersNo = ordersNo;
	}
}
