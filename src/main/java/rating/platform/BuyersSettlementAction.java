package rating.platform;
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
import shop.order.pojo.Orders;
import shop.order.service.IOrdersService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
/**
 * BuyersSettlementAction -- 平台与买家结算Action
 * @author Administrator
 *
 */
@SuppressWarnings("serial")
public class BuyersSettlementAction extends BaseAction {
	/**店铺信息Service**/
	private IShopInfoService shopInfoService;
	/**订单Service**/
	private IOrdersService ordersService;
	/**买家信息实体类**/
	private ShopInfo shopInfo;
	/**买家信息集合**/
	@SuppressWarnings("rawtypes")
	private List<Map> shopInfoList = new ArrayList<Map>();
	/**订单集合**/
	private List<Orders> ordersList = new ArrayList<Orders>();
	private String customerId;
	/**公司名称(查询条件)**/
	private String companyName;
	private Date startTime;
	private Date endTime;
	private BigDecimal sum=new BigDecimal(0);
	//跳转到买家信息列表
	public String gotoBuyersPage(){
		return SUCCESS;
	}
	//跳转到买家未结算订单明细列表
	@SuppressWarnings("unchecked")
	public String gotoBuyersOrders(){
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.customerId="+customerId);
		String [] selectColumns = {"ordersNo","finalAmount"};
		ordersList = ordersService.findObjects(selectColumns, " where o.settlementStatus=0 and o.customerId="+customerId);
		for(Orders orders:ordersList){
			sum = sum.add(orders.getFinalAmount());
		}
		return SUCCESS;
	}
	//查询买家列表信息
	public void listBuyersSettlement() throws Exception{
		String hql="select s.customerId as customerId,s.companyName as companyName,s.openingBank as openingBank,s.bankAccountNumber as bankAccountNumber,s.phoneForInvoice as phoneForInvoice from " +
				" Customer c,ShopInfo s where c.customerId=s.customerId and c.type=1";
		String countHql="select count(s.shopInfoId) from Customer c,ShopInfo s  where c.customerId=s.customerId and c.type=1";
		if(companyName!=null){
			hql += " and s.companyName like '%" + companyName + "%'";
			countHql += " and s.companyName like '%" + companyName + "%'";
		}
		//String [] selectColumns = {"customerId","companyName","openingBank","bankAccountNumber","phoneForInvoice"};
		int totalRecordCount = shopInfoService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		shopInfoList = shopInfoService.findListMapPage(hql+" order by s.shopInfoId",pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", shopInfoList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询买家未付款订单
	public void listBuyersNoPayOrders() throws Exception{
		SimpleDateFormat dateformat=new SimpleDateFormat("yyyy-MM-dd");
		String hql = " where 1=1";
		if(startTime != null){
			String dateStart = dateformat.format(startTime);
			hql += " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('"+dateStart+"')";
		}
		if(endTime != null){
			String dateEnd = dateformat.format(endTime);
			hql += " and UNIX_TIMESTAMP('"+dateEnd+"') >= UNIX_TIMESTAMP(o.createTime)";
		}
		int totalRecordCount = ordersService.getCount(hql+" and o.settlementStatus=0 and o.customerId="+customerId);
		String [] selectColumns = {"ordersId","customerId","ordersNo","finalAmount","createTime","ordersState"};
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		ordersList = ordersService.findListByPageHelper(selectColumns, pageHelper, hql+" and o.settlementStatus=0 and o.customerId="+customerId);
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
	@SuppressWarnings("rawtypes")
	public List<Map> getShopInfoList() {
		return shopInfoList;
	}
	@SuppressWarnings("rawtypes")
	public void setShopInfoList(List<Map> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
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
	public Date getStartTime() {
		return startTime;
	}
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	public ShopInfo getShopInfo() {
		return shopInfo;
	}
	public void setShopInfo(ShopInfo shopInfo) {
		this.shopInfo = shopInfo;
	}
	public BigDecimal getSum() {
		return sum;
	}
	public void setSum(BigDecimal sum) {
		this.sum = sum;
	}
}
