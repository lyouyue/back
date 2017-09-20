package shop.order.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.order.pojo.Orders;
import shop.order.pojo.Shipping;
import shop.order.service.IOrdersService;
import shop.order.service.IShippingService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
/**
 * 发货详情Action
 * 
 *
 */
@SuppressWarnings("serial")
public class ShippingAction extends BaseAction{
	private IShippingService shippingService;//发货详情Service
	private IOrdersService ordersService;//订单Service
	private List<Shipping> shippingList = new ArrayList<Shipping>();//发货详情List
	private List<Orders> ordersList = new ArrayList<Orders>();//订单List
	private Shipping shipping;
	private String shippingId;
	private String ids;
	private String params;
	private Orders orders;
	//跳转到发货详情列表页面
	public String gotoShippingPage(){
		//所有订单
		ordersList = ordersService.findObjects(null);
		return SUCCESS;
	}
	//获得发货详情对象
	public void getShippingObject() throws IOException{
		shipping = (Shipping)shippingService.getObjectByParams(" where o.shippingId='"+shippingId+"'");
		if(Utils.objectIsNotEmpty(shipping)){
			 orders=(Orders) ordersService.getObjectById(String.valueOf(shipping.getOrdersId()));
		}
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(shipping,jsonConfig);
		jo.accumulate("orders", orders);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.print(jo.toString());
		out.flush();
		out.close();
	}
	//保存或修改发货详情
	public void saveOrUpdateShipping() throws Exception{
		if(shipping != null){
			if(shipping.getShippingId()==null || "".equals(shipping.getShippingId())){
				//生成流水号
				SimpleDateFormat sdf1 = new  SimpleDateFormat("yyyyMMddHHmmss");
				String no = sdf1.format(new Date());
				Double random = Math.random();
				String num = random.toString().substring(2, 8);
				shipping.setShippingSn(no+num);
			}
			shippingService.saveOrUpdateObject(shipping);
		}
		if(shipping.getShippingId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//发货初始化列表
	public void listShipping() throws IOException{
		String shippingSn = request.getParameter("title");
		String ordersNo = request.getParameter("ordersNo");
		String shopInfoType = request.getParameter("shopInfoType");
		String hql="SELECT a.shippingId as shippingId,a.ordersId as ordersId,c.loginName as loginName,s.shopName as shopName,s.shopInfoType as shopInfoType,a.shippingSn as shippingSn,a.deliveryCorpName as deliveryCorpName,a.deliverySn as deliverySn,a.deliveryUrl as deliveryUrl,b.ordersNo as ordersNo FROM Shipping a ,Orders b,Customer c,ShopInfo s  where a.ordersId=b.ordersId and  b.customerId=c.customerId AND b.shopInfoId=s.shopInfoId";
		String hqlCount="SELECT count(a.shippingId) FROM Shipping a ,Orders b ,Customer c,ShopInfo s where a.ordersId=b.ordersId and  b.customerId=c.customerId AND b.shopInfoId=s.shopInfoId";
		if(shippingSn!=null&&!"".equals(shippingSn.trim())){
			hql+=" and a.shippingSn like'%"+shippingSn.trim()+"%'";
			hqlCount+=" and a.shippingSn like'%"+shippingSn.trim()+"%'";
		}
		if(ordersNo!=null&&!"".equals(ordersNo.trim())){
			hql+=" and b.ordersNo like'%"+ordersNo.trim()+"%'";
			hqlCount+=" and b.ordersNo like'%"+ordersNo.trim()+"%'";
		}
		if(Utils.objectIsNotEmpty(shopInfoType)){
			hql+=" and s.shopInfoType="+shopInfoType;
        	hqlCount+=" and s.shopInfoType="+shopInfoType;
        }
		int totalRecordCount = shippingService.getMultilistCount(hqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> shippingList = shippingService.findListMapPage(hql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", shippingList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除发货详情
	public void deleteShipping() throws IOException{
		Boolean isSuccess = shippingService.deleteObjectsByIds("shippingId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<Shipping> getShippingList() {
		return shippingList;
	}
	public void setShippingList(List<Shipping> shippingList) {
		this.shippingList = shippingList;
	}
	public List<Orders> getOrdersList() {
		return ordersList;
	}
	public void setOrdersList(List<Orders> ordersList) {
		this.ordersList = ordersList;
	}
	public Shipping getShipping() {
		return shipping;
	}
	public void setShipping(Shipping shipping) {
		this.shipping = shipping;
	}
	public String getShippingId() {
		return shippingId;
	}
	public void setShippingId(String shippingId) {
		this.shippingId = shippingId;
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
	public void setShippingService(IShippingService shippingService) {
		this.shippingService = shippingService;
	}
	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public Orders getOrders() {
		return orders;
	}
	public void setOrders(Orders orders) {
		this.orders = orders;
	}
}
