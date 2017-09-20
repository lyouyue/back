package rating.buyersRecord.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import rating.buyersRecord.pojo.BuyersRecord;
import rating.buyersRecord.service.IBuyersRecordService;
import rating.buyersStrategy.pojo.BuyersStrategy;
import rating.buyersStrategy.service.IBuyersStrategyService;
import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import util.action.BaseAction;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.pojo.Users;
/**
 * 买家等级升迁记录Action
 * @author wsy
 *
 */
@SuppressWarnings("serial")
public class BuyersRecordAction extends BaseAction {
	/**买家等级升迁记录service**/
	private IBuyersRecordService buyersRecordService;
	/**买家等级升迁实体**/
	private BuyersRecord buyersRecord;
	/**买家升级策略service**/
	private IBuyersStrategyService buyersStrategyService;
	/**买家升级策略实体**/
	private BuyersStrategy buyersStrategy;
	/**买家升级策略集合**/
	private List<BuyersStrategy> listBuyersStrategy;
	/**会员实体**/
	private Customer customer;
	/**会员service**/
	private ICustomerService customerService;
	private String ids;
	private String ratingRecordId;
	private String customerId;
	/**跳转会员列别**/
	public String gotoBRCustomerPage(){
		listBuyersStrategy = buyersStrategyService.findObjects(" where o.type=1");
		request.setAttribute("customerId", customerId);
		return SUCCESS;
	}
	/**跳转买家升迁记录**/
	public String gotoBuyersRecordId(){
		listBuyersStrategy = buyersStrategyService.findObjects("");
		request.setAttribute("customerId", customerId);
		return SUCCESS;
	}
	/**查看所有记录**/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void listBuyersRecord() throws IOException{
		String hql=null;
		if(customerId!=null){
			hql="select br.ratingRecordId as ratingRecordId, br.customerId as customerId, br.minRefValue as minRefValue, br.maxRefValue as maxRefValue, br.buyersLevel as buyersLevel, br.buyerRank as buyerRank, "
				+ "br.levelIcon as levelIcon, br.lineOfCredit as lineOfCredit, br.creditDate as creditDate, br.optionDate as optionDate, br.operator as operator,b.type as type,br.remark as remark "
				+ "from BuyersRecord br,Customer b where br.customerId=b.customerId and  br.customerId="+customerId+ " order by br.ratingRecordId desc";
		}
		//总条数查询
		String countHql="select count(br.ratingRecordId) from BuyersRecord br,Customer b where br.customerId=b.customerId and  br.customerId="+customerId;
		int totalRecordCount = buyersRecordService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> lmap = buyersRecordService.findListMapPage(hql, pageHelper);
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
		public void listBRCustomer() throws IOException{
			//hql查询语句
			String sqlHead="SELECT d.loginName AS loginName, d.phone AS phone, d.ratingRecordId AS ratingRecordId, d.customerId AS customerId, d.minRefValue AS minRefValue, d.maxRefValue AS maxRefValue,"+
									" d.buyersLevel AS buyersLevel, d.buyerRank AS buyerRank, d.levelIcon AS levelIcon, d.lineOfCredit AS lineOfCredit, d.creditDate AS creditDate, d.optionDate AS optionDate, d.operator AS operator,"+
									" d.type AS type FROM ( ";
			String sqlBody="SELECT c.loginName AS loginName, c.phone AS phone, b.ratingRecordId AS ratingRecordId, b.customerId AS customerId, b.minRefValue AS minRefValue, b.maxRefValue AS maxRefValue,"+
								" b.buyersLevel AS buyersLevel, b.buyerRank AS buyerRank, b.levelIcon AS levelIcon, b.lineOfCredit AS lineOfCredit, b.creditDate AS creditDate, b.optionDate AS optionDate, b.operator AS operator,"+
								" c.type AS type, c.registerDate AS registerDate FROM rating_buyers_record b, basic_customer c WHERE b.customerId=c.customerId AND c.type =1 ";
			String sqlFoot=" ORDER BY b.optionDate DESC, b.ratingRecordId DESC ) d GROUP BY d.customerId ORDER BY d.registerDate DESC";
			String countHql="SELECT COUNT(distinct b.customerId) FROM BuyersRecord b, Customer c WHERE b.customerId=c.customerId AND c.type=1 ";
			//获取前台查询参数
			String selectFlag=request.getParameter("selectFlag");
			String loginName = request.getParameter("loginName");
			String phone=request.getParameter("phone");
			if(Utils.objectIsNotEmpty(selectFlag)){
				//追加where条件
				if(loginName!=null&&!"".equals(loginName)){
					sqlBody+=" and c.loginName like '%"+loginName+"%'";
					countHql+=" and c.loginName like '%"+loginName+"%'";
				}
				if(phone!=null&&!"".equals(phone)){
					sqlBody+=" and c.phone like '%"+phone+"%'";
					countHql+=" and c.phone like '%"+phone+"%'";
				}
			}
			String sql=sqlHead+sqlBody+sqlFoot;
			int totalRecordCount = buyersRecordService.getCountByHQL(countHql);
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			List<Map<String, Object>> customerList = buyersRecordService.findListMapPageBySql(sql, pageHelper);
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
	public void savaOrUpdateBuyersRecord() throws Exception{
		//添加记录
		String remark = request.getParameter("remark");
		String customerId = request.getParameter("customerId");
		Users users = (Users)session.getAttribute("users");
		String id = request.getParameter("id");
		buyersStrategy = (BuyersStrategy)buyersStrategyService.getObjectByParams("where o.buyersLevel = "+id);
		if(!id.equals(buyersStrategy.getBuyersLevel())){
			BuyersRecord buyersRecord = new BuyersRecord();
			buyersRecord.setBuyerRank(buyersStrategy.getBuyerRank());
			buyersRecord.setLevelIcon(buyersStrategy.getLevelIcon());
			buyersRecord.setBuyersLevel(buyersStrategy.getBuyersLevel());
			buyersRecord.setLineOfCredit(buyersStrategy.getLineOfCredit());
			buyersRecord.setCreditDate(buyersStrategy.getCreditDate());
			buyersRecord.setMinRefValue(buyersStrategy.getMinRefValue());
			buyersRecord.setMaxRefValue(buyersStrategy.getMaxRefValue());
			buyersRecord.setLevelDiscountValue(buyersStrategy.getLevelDiscountValue());
			buyersRecord.setOperator(users.getUserName());
			buyersRecord.setRemark(remark);
			buyersRecord.setCustomerId(Integer.parseInt(customerId));
			if(buyersRecord.getRatingRecordId()==null || "".equals(buyersRecord.getRatingRecordId())){
				buyersRecord.setOptionDate(new Date());
			}
			BuyersRecord  buyersRecords=buyersRecordService.saveBuyersRecord(buyersRecord);
			if(buyersRecords.getRatingRecordId()!=null){
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", "true");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}else{
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "false");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	/**获取对象
	 * @throws Exception **/
	public void getByersRecord() throws Exception{
		buyersRecord = (BuyersRecord) buyersRecordService.getObjectByParams(" where o.customerId="+customerId+" order by o.optionDate desc limit 1");
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = new JSONObject();
		jo.accumulate("buyersRecord", buyersRecord);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**获取最新一条记录**/
	public void getBuyersRecordObject() throws IOException{
		buyersRecord = (BuyersRecord) buyersRecordService.getObjectById(ratingRecordId);
		if(Utils.objectIsNotEmpty(buyersRecord.getCustomerId())){
			customer = (Customer) customerService.getObjectById(String.valueOf(buyersRecord.getCustomerId()));
		}
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = new JSONObject();
		jo.accumulate("buyersRecord", buyersRecord);
		jo.accumulate("customer", customer);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**删除记录**/
	public void deleteBuyersRecord() throws IOException{
		Boolean isSuccess = buyersRecordService.deleteObjectsByIds("ratingRecordId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public BuyersRecord getBuyersRecord() {
		return buyersRecord;
	}
	public void setBuyersRecord(BuyersRecord buyersRecord) {
		this.buyersRecord = buyersRecord;
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
	public void setBuyersRecordService(IBuyersRecordService buyersRecordService) {
		this.buyersRecordService = buyersRecordService;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public List<BuyersStrategy> getListBuyersStrategy() {
		return listBuyersStrategy;
	}
	public void setListBuyersStrategy(List<BuyersStrategy> listBuyersStrategy) {
		this.listBuyersStrategy = listBuyersStrategy;
	}
	public void setBuyersStrategyService(
			IBuyersStrategyService buyersStrategyService) {
		this.buyersStrategyService = buyersStrategyService;
	}
	public BuyersStrategy getBuyersStrategy() {
		return buyersStrategy;
	}
	public void setBuyersStrategy(BuyersStrategy buyersStrategy) {
		this.buyersStrategy = buyersStrategy;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public Customer getCustomer() {
		return customer;
	}
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
}
