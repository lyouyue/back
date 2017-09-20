package shop.returnsApply.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.customer.pojo.Customer;
import shop.customer.pojo.Sonaccount;
import shop.customer.service.ICustomerService;
import shop.customer.service.ISonaccountService;
import shop.order.pojo.Orders;
import shop.order.pojo.OrdersList;
import shop.order.service.IOrdersListService;
import shop.order.service.IOrdersService;
import shop.product.pojo.ProductInfo;
import shop.product.service.IProductInfoService;
import shop.returnsApply.pojo.ReturnsApply;
import shop.returnsApply.pojo.ReturnsApplyOPLog;
import shop.returnsApply.service.IReturnsApplyOPLogService;
import shop.returnsApply.service.IReturnsApplyService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.CreateWhereSQLForSelect;
import util.other.JSONFormatDate;
import util.other.Utils;
/**
 * 退换申请Action
 * 
 *
 */
@SuppressWarnings("serial")
public class ReturnsApplyAction extends BaseAction{
	private IReturnsApplyService returnsApplyService;//退换申请Service
	private ICustomerService customerService;//用户Service
	private IOrdersService ordersService;//订单Service
	private IOrdersListService ordersListService;//订单明细Service
	private IProductInfoService productInfoService;//套餐Service
	private IReturnsApplyOPLogService returnsApplyOPLogService;//退换申请操作日志Service
	private List<Map<String, Object>> returnsApplyList = new ArrayList<Map<String,Object>>();//退换申请List
	private List<Orders> ordersList = new ArrayList<Orders>();//订单List
	private List<OrdersList> ordersLisList = new ArrayList<OrdersList>();//订单明细List
	private List<Customer> customerList = new ArrayList<Customer>();//用户List
	private List<Sonaccount> sonaccountList = new ArrayList<Sonaccount>();//子账号List
	private ISonaccountService sonaccountService;
	private ReturnsApply returnsApply;
	private String ids;
	private String returnsApplyId;
	private String customerId;
	private String ordersId;
	private Integer productId;
	private String params;//查询条件
	private ReturnsApplyOPLog returnsApplyOPLog = new ReturnsApplyOPLog();
	//跳转到退换申请列表页面
	public String gotoReturnsApplyPage(){
		return SUCCESS;
	}
	//根据用户ID查询此用户的订单列表
	public void findordersByCustomerId() throws IOException{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		if (customerId != null && !"".equals(customerId)) {
			ordersList = ordersService.findObjects(" where o.customerId='"+customerId+"'");
			JSONArray ja = JSONArray.fromObject(ordersList);
			out.write(ja.toString());
		}
		out.flush();
		out.close();
	}
	//根据订单ID查询此订单的订单明细
	public void findOrdersListListByOrdersId() throws IOException{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		if (ordersId != null && !"".equals(ordersId)) {
			ordersLisList = ordersListService.findObjects(" where o.ordersId='"+ordersId+"'");
			JSONArray ja = JSONArray.fromObject(ordersLisList);
			out.write(ja.toString());
		}
		out.flush();
		out.close();
	}
	//根据套餐ID查询一条套餐记录
	public void getProductInfoByProductId() throws IOException{
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		if (productId != null && !"".equals(productId)) {
			ProductInfo productInfo = (ProductInfo) productInfoService.getObjectById(String.valueOf(productId));
			if(null!=productInfo){
				JSONObject jo = JSONObject.fromObject(productInfo);
				out.write(jo.toString());
			}
		}
		out.flush();
		out.close();
	}
	//保存或者修改退换申请
	public void saveOrUpdateReturnsApply() throws Exception{
		String ecustomerId = request.getParameter("ecustomerId");
		String ereturnsApplyNo = request.getParameter("ereturnsApplyNo");
		String eordersId = request.getParameter("eordersId");
		String eordersNo = request.getParameter("eordersNo");
		String eproductId = request.getParameter("eproductId");
		String eproductName = request.getParameter("eproductName");
		String edproductAccessories = request.getParameter("edproductAccessories");
		String shippingAddress = request.getParameter("shippingAddress");
		Customer customer = (Customer) request.getSession().getAttribute("customer");
		String isAddress = request.getParameter("isAddress");
		if(returnsApply!=null){
			if("0".equals(isAddress)){
				@SuppressWarnings("unused")
				Orders orders = (Orders) ordersService.getObjectByParams(" where o.ordersId='"+returnsApply.getOrdersId()+"'");
//				returnsApply.setShippingAddress(orders.getProvince()+orders.getCityDistrict()+orders.getCounty()+orders.getAddress());
			}
			if(returnsApply.getReturnsApplyId()==null || "".equals(returnsApply.getReturnsApplyId())){
				SimpleDateFormat sdf = new  SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String formatTime = sdf.format(new Date());
				Date date = sdf.parse(formatTime);
				returnsApply.setApplyTime(date);
				returnsApply.setUpdateTime(date);
				Orders orders = (Orders) ordersService.getObjectByParams(" where o.ordersId='"+returnsApply.getOrdersId()+"'");
				returnsApply.setOrdersNo(orders.getOrdersNo());//订单号
				ProductInfo productInfo = (ProductInfo) productInfoService.getObjectById(returnsApply.getProductId().toString());
				returnsApply.setProductName(productInfo.getProductName());//套餐名称
				returnsApply=(ReturnsApply)returnsApplyService.saveOrUpdateObject(returnsApply);
//				if(returnsApply.getReturnsApplyId()!=null){
//					returnsApply.setReturnsApplyNo(returnsApply.getReturnsApplyId());
//					returnsApply=(ReturnsApply)returnsApplyService.saveOrUpdateObject(returnsApply);
//				}
				Integer dd = returnsApply.getReturnsApplyId();
				returnsApplyOPLog.setApplyId(dd);
				returnsApplyOPLog.setReturnsApplyNo(returnsApply.getReturnsApplyNo());
				returnsApplyOPLog.setOperatorName("客户");
				returnsApplyOPLog.setComments("提交申请成功");
				returnsApplyOPLog.setOperatorTime(date);
				returnsApplyOPLogService.saveOrUpdateObject(returnsApplyOPLog);
			}else{
				returnsApply.setCustomerId(Integer.parseInt(ecustomerId));
//				returnsApply.setReturnsApplyNo(Integer.parseInt(ereturnsApplyNo));
				returnsApply.setOrdersId(Integer.parseInt(eordersId));
				returnsApply.setOrdersNo(eordersNo);
				returnsApply.setProductId(Integer.parseInt(eproductId));
				returnsApply.setProductName(eproductName);
				returnsApply.setProductAccessories(edproductAccessories);
				returnsApply.setShippingAddress(shippingAddress);
				returnsApply.setUpdateMember(customer.getLoginName());
				SimpleDateFormat sdf = new  SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
				String formatTime = sdf.format(new Date());
				Date date = sdf.parse(formatTime);
				returnsApply.setUpdateTime(date);
				returnsApply=(ReturnsApply)returnsApplyService.saveOrUpdateObject(returnsApply);
			}
		}
		if(returnsApply.getReturnsApplyId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//根据用户ID得到用户退换申请信息
	public void listReturnsApply() throws Exception {
		String selectFlag=request.getParameter("selectFlag");
		String applyState=request.getParameter("sqStatus");
		String returnsState=request.getParameter("thStatus");
		String shopInfoType=request.getParameter("shopInfoType");
		String returnsApplyNo=request.getParameter("thno");
		String hql=" SELECT count(r.returnsApplyId) FROM ReturnsApply r, Customer c, ShopInfo s WHERE 1 = 1 AND r.customerId = c.customerId AND r.shopInfoId = s.shopInfoId ";
		String sql="SELECT r.returnsApplyNo AS returnsApplyNo, r.productName AS productName, c.loginName AS loginName,"+
		" s.shopName AS shopName,s.shopInfoType AS shopInfoType, date_format( r.applyTime, '%Y-%m-%d %h:%m:%s') AS applyTime, r.applyState AS applyState, r.returnsState AS returnsState"+
		" FROM shop_returnsapply r, basic_customer c, shop_shopinfo s WHERE 1=1 AND r.customerId=c.customerId AND r.shopInfoId=s.shopInfoId";
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			if(!"-1".equals(request.getParameter("sqStatus"))){
				sql+=" and r.applyState="+applyState;
				hql+=" and r.applyState="+applyState;
			}
			if(!"-1".equals(request.getParameter("thStatus"))){
				sql+=" and r.returnsState="+returnsState;
				hql+=" and r.returnsState="+returnsState;
			}
			if(returnsApplyNo!=null&&!"".equals(returnsApplyNo)){
				sql+=" and r.returnsApplyNo like '%"+returnsApplyNo.trim()+"%'";
				hql+=" and r.returnsApplyNo like '%"+returnsApplyNo.trim()+"%'";
			}
			if(Utils.stringIsNotEmpty(shopInfoType)){
				sql+=" and s.shopInfoType="+shopInfoType;
				hql+=" and s.shopInfoType="+shopInfoType;
			}

		}
		int totalRecordCount = returnsApplyService.getCountByHQL(hql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		returnsApplyList = returnsApplyService.findListMapPageBySql(sql+" order by r.applyTime desc", pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", returnsApplyList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除退换申请信息
	public void deleteReturnsApply() throws IOException{
		Boolean isSuccess = returnsApplyService.deleteObjectsByIds("returnsApplyId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//通过ID得到一条数据
	public void getReturnsApplyObject() throws IOException{
		returnsApply = (ReturnsApply) returnsApplyService.getObjectByParams(" where o.returnsApplyNo='"+returnsApplyId+"'");
		Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId="+returnsApply.getCustomerId());
		List<String> showUploadImgList =  new ArrayList<String>();
		if(null!=returnsApply && null!=returnsApply.getUploadImage()){
			String[] split = returnsApply.getUploadImage().split("@");
			for(String s:split){
				showUploadImgList.add(s);
			}
		}
		Map<String,Object> map = new HashMap<String,Object>();
		JsonConfig jsonConfig = new JsonConfig();
		map.put("returnsApply", returnsApply);
		map.put("customer", customer);
		map.put("showUploadImgList", showUploadImgList);
		map.put("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(map,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 退换货操作明细
	 * @return
	 * @throws IOException
	 */
	public void getReturnsApplyOPLogList() throws IOException{
		String hql = " where o.returnsApplyNo='"+returnsApplyId+"'";
		List<ReturnsApplyOPLog> returnsApplyOPLogList = returnsApplyOPLogService.findObjects(hql);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONArray jo = JSONArray.fromObject(returnsApplyOPLogList,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public List<Orders> getOrdersList() {
		return ordersList;
	}
	public void setOrdersList(List<Orders> ordersList) {
		this.ordersList = ordersList;
	}
	public List<OrdersList> getOrdersLisList() {
		return ordersLisList;
	}
	public void setOrdersLisList(List<OrdersList> ordersLisList) {
		this.ordersLisList = ordersLisList;
	}
	public ReturnsApply getReturnsApply() {
		return returnsApply;
	}
	public void setReturnsApply(ReturnsApply returnsApply) {
		this.returnsApply = returnsApply;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getReturnsApplyId() {
		return returnsApplyId;
	}
	public void setReturnsApplyId(String returnsApplyId) {
		this.returnsApplyId = returnsApplyId;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getOrdersId() {
		return ordersId;
	}
	public void setOrdersId(String ordersId) {
		this.ordersId = ordersId;
	}
	public void setReturnsApplyService(IReturnsApplyService returnsApplyService) {
		this.returnsApplyService = returnsApplyService;
	}
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public void setOrdersListService(IOrdersListService ordersListService) {
		this.ordersListService = ordersListService;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public ReturnsApplyOPLog getReturnsApplyOPLog() {
		return returnsApplyOPLog;
	}
	public void setReturnsApplyOPLog(ReturnsApplyOPLog returnsApplyOPLog) {
		this.returnsApplyOPLog = returnsApplyOPLog;
	}
	public void setReturnsApplyOPLogService(
			IReturnsApplyOPLogService returnsApplyOPLogService) {
		this.returnsApplyOPLogService = returnsApplyOPLogService;
	}
	public List<Customer> getCustomerList() {
		return customerList;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public List<Sonaccount> getSonaccountList() {
		return sonaccountList;
	}
	public void setSonaccountList(List<Sonaccount> sonaccountList) {
		this.sonaccountList = sonaccountList;
	}
	public void setSonaccountService(ISonaccountService sonaccountService) {
		this.sonaccountService = sonaccountService;
	}
	public List<Map<String, Object>> getReturnsApplyList() {
		return returnsApplyList;
	}
	public void setReturnsApplyList(List<Map<String, Object>> returnsApplyList) {
		this.returnsApplyList = returnsApplyList;
	}
}
