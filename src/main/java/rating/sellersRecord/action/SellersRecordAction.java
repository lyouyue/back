package rating.sellersRecord.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import rating.sellersRecord.pojo.SellersRecord;
import rating.sellersRecord.service.ISellersRecordService;
import rating.sellersStrategy.pojo.SellersStrategy;
import rating.sellersStrategy.service.ISellersStrategyService;
import shop.customer.service.ICustomerService;
import basic.pojo.Users;
import util.action.BaseAction;
import util.other.JSONFormatDate;
/**
 * 卖家等级升迁记录Action
 * @author wsy
 *
 */
@SuppressWarnings("serial")
public class SellersRecordAction extends BaseAction {
	/**卖家等级升迁记录service**/
	private ISellersRecordService sellersRecordService;
	/**卖家等级升迁实体**/
	private SellersRecord sellersRecord;
	/**卖家升级策略service**/
	private ISellersStrategyService sellersStrategyService;
	/**卖家升级策略实体**/
	private SellersStrategy sellersStrategy;
	/**卖家升级策略集合**/
	private List<SellersStrategy> listSellersStrategy;
	/**会员service**/
	private ICustomerService customerService;
	private String ids;
	private String ratingRecordId;
	private String customerId;
	/**跳转会员列别**/
	public String gotoSRCustomerPage(){
		return SUCCESS;
	}
	/**跳转买家升迁记录**/
	public String gotoSellersRecordId(){
		listSellersStrategy = sellersStrategyService.findObjects("");
		request.setAttribute("customerId", customerId);
		return SUCCESS;
	}
	/**查看所有记录**/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void listSellersRecord() throws IOException{
		String hql="select sr.ratingRecordId as ratingRecordId, sr.customerId as customerId, sr.sellersLevel as sellersLevel, sr.sellersRank as sellersRank, "
				+ "sr.levelIcon as levelIcon, sr.optionDate as optionDate, sr.operator as operator "
				+ "from SellersRecord sr where sr.customerId="+customerId+ "order by sr.ratingRecordId desc";
		//总条数查询
		String countHql="select count(sr.ratingRecordId) from SellersRecord sr where sr.customerId="+customerId+ "order by sr.ratingRecordId desc";
		int totalRecordCount = sellersRecordService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> lmap = sellersRecordService.findListMapPage(hql, pageHelper);
		if(lmap!=null&&lmap.size()>0){
			SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd");
			for(Map m:lmap){
				Object object = m.get("optionDate");
				if(object!=null){
					String time = formatter.format(object);
					m.put("optionDate", time);
				}
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", lmap);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//会员基本信息列表
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void listSRCustomer() throws IOException{
		//hql查询语句
		String hql="SELECT a.loginName as loginName,a.customerId as customerId,b.trueName as trueName , b.sex as sex ,a.type as type ,a.email as email ,a.registerDate as registerDate,a.registerIp as registerIp,a.lockedState as lockedState FROM Customer a,ShopCustomerInfo b where a.customerId=b.customerId and a.type=2"; 
		String countHql="SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b where a.customerId=b.customerId and a.type=2"; 
		int totalRecordCount = customerService.getMultilistCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> customerList = customerService.findListMapPage(hql+" order by a.registerDate desc", pageHelper);
		if(customerList!=null&&customerList.size()>0){
			for(Map m:customerList){
				SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
				String time = fm.format(m.get("registerDate"));
				m.put("registerDate", time);
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customerList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**保存新的记录**/
	public void savaOrUpdateSellersRecord() throws Exception{
		String remark = sellersRecord.getRemark();
		Integer customerId = sellersRecord.getCustomerId();
		Users users = (Users)session.getAttribute("users");
		String id = request.getParameter("sellersLevel");
		sellersStrategy = (SellersStrategy)sellersStrategyService.getObjectByParams("where o.sellersLevel = "+id);
		SellersRecord sellersRecord = new SellersRecord();
		sellersRecord.setSellersRank(sellersStrategy.getSellersRank());
		sellersRecord.setLevelIcon(sellersStrategy.getLevelIcon());
		sellersRecord.setSellersLevel(sellersStrategy.getSellersLevel());
		sellersRecord.setMinRefValue(sellersStrategy.getMinRefValue());
		sellersRecord.setMaxRefValue(sellersStrategy.getMaxRefValue());
		sellersRecord.setLevelDiscountValue(sellersStrategy.getLevelDiscountValue());
		sellersRecord.setOperator(users.getUserName());
		sellersRecord.setRemark(remark);
		sellersRecord.setCustomerId(customerId);
		if(sellersRecord.getRatingRecordId()==null || "".equals(sellersRecord.getRatingRecordId())){
			sellersRecord.setOptionDate(new Date());
		}
		sellersRecord = (SellersRecord) sellersRecordService.saveOrUpdateObject(sellersRecord);
		if(sellersRecord.getRatingRecordId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	/**获取最新一条记录**/
	public void getSellersRecordObject() throws IOException{
		sellersRecord = (SellersRecord) sellersRecordService.getObjectById(ratingRecordId);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(sellersRecord,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**删除记录**/
	public void deleteSellersRecord() throws IOException{
		Boolean isSuccess = sellersRecordService.deleteObjectsByIds("ratingRecordId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public SellersRecord getSellersRecord() {
		return sellersRecord;
	}
	public void setSellersRecord(SellersRecord sellersRecord) {
		this.sellersRecord = sellersRecord;
	}
	public SellersStrategy getSellersStrategy() {
		return sellersStrategy;
	}
	public void setSellersStrategy(SellersStrategy sellersStrategy) {
		this.sellersStrategy = sellersStrategy;
	}
	public List<SellersStrategy> getListSellersStrategy() {
		return listSellersStrategy;
	}
	public void setListSellersStrategy(List<SellersStrategy> listSellersStrategy) {
		this.listSellersStrategy = listSellersStrategy;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getRatingRecordId() {
		return ratingRecordId;
	}
	public void setRatingRecordId(String ratingRecordId) {
		this.ratingRecordId = ratingRecordId;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public void setSellersRecordService(ISellersRecordService sellersRecordService) {
		this.sellersRecordService = sellersRecordService;
	}
	public void setSellersStrategyService(
			ISellersStrategyService sellersStrategyService) {
		this.sellersStrategyService = sellersStrategyService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
}
