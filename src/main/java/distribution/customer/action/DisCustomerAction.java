package distribution.customer.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import distribution.customer.service.IDisCustomerService;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import util.action.BaseAction;
import util.other.Base64;
import util.other.JSONFormatDate;
import util.other.Utils;
import util.other.WxBase64;
import basic.pojo.Users;
/**
 * DisCustomerAction 分销Action
 * @author 
 *
 */
public class DisCustomerAction extends BaseAction{
	private static final long serialVersionUID = -6842819617868448074L;
	/**分销用户Service**/
	private IDisCustomerService disCustomerService;
	private ICustomerService customerService;//客户Service
	private String customerName;
	private String isJMS;
	private String isCriticalValue;
	private String levelId;
	private String level;//级别1：康乃馨2：红牡丹3：紫罗兰
	private List<Customer> customerList = new ArrayList<Customer>();//客户List
	private List<Map<String,Object>> customersList = new ArrayList<Map<String,Object>>();//客户List
	private String customerId;
	private String loginName;
	/**推荐人**/
	private String referrer;
	/**会员手机号**/
	private String mobilePhone;
	/**电子邮件**/
	private String email;
	/**注册时间**/
	private String startTime;
	private String endTime;
	 
	/**
	 * 跳转到会员统计列表
	 */
	public String gotoDisCustomerPage(){
		return SUCCESS;
	}
	
	//会员基本信息列表
	public void listCustomer() throws IOException{
		String hql = " where 1=1 ";
		//根据会员帐号查询
		if (loginName!=null&&!"".equals(loginName)) {
			hql += " and o.trueName like '%" + new String(Base64.encodeBase64(loginName.getBytes("utf-8")),"utf-8") + "%'";
		}
		//根据会员手机号查询
		if(Utils.stringIsNotEmpty(mobilePhone)){
			hql+=" and o.mobilePhone="+mobilePhone;
		}
		if(Utils.stringIsNotEmpty(email)){
			hql+=" and o.email='"+email+"'";
		}
		if(Utils.stringIsNotEmpty(startTime)){
			hql+=" and o.registerDate>='"+startTime+"'";
		}
		if(Utils.stringIsNotEmpty(endTime)){
			hql += " and o.registerDate<='"+endTime+"'";
		}
		//根据推荐人查询
		if (referrer!=null&&!"".equals(referrer.trim())) {
			referrer = referrer.trim();//去掉空格
			hql += " and o.referrer like '%" + referrer + "%'";
		}
		int totalRecordCount = customerService.getCountByHQL("select count(o.customerId) from Customer o "+hql+" order by o.customerId");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		customerList = customerService.findListByPageHelper(null,pageHelper, hql + " order by o.customerId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customerList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	@SuppressWarnings("static-access")
	public void resetPassword() throws IOException{
		boolean flag=false;
		if(Utils.objectIsNotEmpty(customerId)){
			//得到系统配置信息
			String password = String.valueOf(fileUrlConfig.get("defaultPassword"));
			Utils ut = new Utils();
			if(Utils.objectIsNotEmpty(password)){
				String encodeMd5 = ut.EncodeMd5(password);
				String encodeMd52 = ut.EncodeMd5(encodeMd5);
				flag=disCustomerService.updateBySQL("UPDATE dis_customer SET payPassword='"+encodeMd52+"' WHERE customerId="+customerId);
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("flag", flag);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public void getReturnAmount() throws IOException{
		String loginName=request.getParameter("loginName");
		String orderNo=request.getParameter("orderNo");
		String sql="select b.loginName,b.photoUrl,f.amount,o.finalAmount, DATE_FORMAT(f.transactionTime, '%Y-%m-%d %H:%m:%s') as transactionTime ,o.ordersNo from shop_orders o ,shop_fund_detail f,basic_customer b where  o.ordersState in(5,9) and f.source = 2 AND b.customerId = o.customerId AND f.customerId = b.customerId AND f.ordersNo = o.ordersNo";
		String  hql="select count(*) from Orders o ,FundDetail f,Customer b where  o.ordersState in(5,9) and f.source = 2 AND b.customerId = o.customerId AND f.customerId = b.customerId AND f.ordersNo = o.ordersNo ";
		if(Utils.stringIsNotEmpty(customerId)){
			sql+="  and b.customerId = "+customerId;
			hql+="  and b.customerId = "+customerId;
		}
		if(Utils.stringIsNotEmpty(loginName)){
			sql += " and b.loginName like '%" + loginName + "%'";
			hql+=" and b.loginName like '%" + loginName + "%'";
		}
		if(Utils.stringIsNotEmpty(orderNo)){
			sql += " and o.ordersNo like '%" + orderNo + "%'";
			hql+=" and o.ordersNo like '%" + orderNo + "%'";
		}
		int totalRecordCount = customerService.getCountByHQL(hql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		customersList = customerService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customersList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		
		
	}
	
	
	//跳转用户页面
	public String gotoResetPasswordPage(){
		return SUCCESS;
	}
	public void getCustomerList() throws IOException{
		pageHelper.setPageSize(pageSize);
		pageHelper.setCurrentPage(currentPage);
		pageHelper=disCustomerService.getPageHelper(pageHelper,getMap());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", pageHelper.getPageRecordCount());// total键 存放总记录数，必须的
		jsonMap.put("rows", pageHelper.getObjectList());// rows键 存放每页记录 list
		responseWriterMap(jsonMap);
	}
	
	public Map<String,Object>  getMap(){
		Map<String,Object> map=new HashMap<String, Object>();
		@SuppressWarnings("unused")
		Users users = (Users) request.getSession().getAttribute("users");
		String backJMSId="0";
    	/*if(null!=users.getShopInfoId()){
    		backJMSId=users.getShopInfoId().toString();
    	}*/
    	map.put("backJMSId",backJMSId);
		if(isCriticalValue==null){
			isCriticalValue="-1";
		}
		if(isJMS==null){
			isJMS="-1";
		}
		map.put("isCriticalValue",isCriticalValue);
		map.put("customerName", customerName);
		map.put("isJMS", isJMS);
		//level;//级别1：康乃馨2：红牡丹3：紫罗兰
		if(Utils.objectIsNotEmpty(level)&&Utils.objectIsNotEmpty(levelId)){
			if("1".equals(level)){
				map.put("level1Id", levelId);
			}else if("2".equals(level)){
				map.put("level2Id", levelId);
			}else if("3".equals(level)){
				map.put("level3Id", levelId);
			}
		}
		return map;
	}
	
	/**
	 * 获取我的下级代理/会员
	 */
	public String gotoLowePage(){
		request.setAttribute("customerId", customerId);
		//查询出我的三级会员数量
		String countHql="SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b,DisCustomer c where a.customerId=b.customerId and a.customerId=c.customerId";
		//一级
		int totalRecordCount1 = disCustomerService.getCountByHQL(countHql+" and c.level1id="+customerId);
		//二级
		int totalRecordCount2 = disCustomerService.getCountByHQL(countHql+" and c.level2id="+customerId);
		//三级
		int totalRecordCount3 = disCustomerService.getCountByHQL(countHql+" and c.level3id="+customerId);
		request.setAttribute("level1", totalRecordCount1);
		request.setAttribute("level2", totalRecordCount2);
		request.setAttribute("level3", totalRecordCount3);
		return SUCCESS;
	}
	
	/**
	 * 
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void listLoweCustomer() throws IOException{
		
		String loginName=request.getParameter("loginName");
		String wxName=request.getParameter("wxName");
		String levelId=request.getParameter("levelId");
		//hql查询语句
		String hql="SELECT a.loginName as loginName,a.customerId as customerId,b.trueName as trueName,a.phone as phone,a.email as email,a.registerDate as registerDate,a.registerIp as registerIp,"
				+ "b.wxName as wxName FROM Customer a,ShopCustomerInfo b,DisCustomer c where a.customerId=b.customerId and a.customerId=c.customerId ";
		String countHql="SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b,DisCustomer c where a.customerId=b.customerId and a.customerId=c.customerId";
		if(Utils.stringIsNotEmpty(loginName)){
			hql += " and a.loginName like '%" + loginName + "%'";
			countHql+=" and a.loginName like '%" + loginName + "%'";
		}
		if(Utils.stringIsNotEmpty(wxName)){
			hql += " and b.wxName like '%" + wxName + "%'";
			countHql+=" and b.wxName like '%" + wxName + "%'";
		}
		if(("1").equals(levelId)){
			hql +=" and c.level2id="+customerId;
			countHql +=" and c.level2id="+customerId;
		}else if(("2").equals(levelId)){
			hql +=" and c.level3id="+customerId;
			countHql +=" and c.level3id="+customerId;
		}else{
			hql +=" and c.level1id="+customerId;
			countHql +=" and c.level1id="+customerId;
		}
		int totalRecordCount = disCustomerService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> customerList = disCustomerService.findListMapPage(hql+" order by a.registerDate desc", pageHelper);
		if(customerList!=null&&customerList.size()>0){
			for(Map m:customerList){
				SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
				String time = fm.format(m.get("registerDate"));
				m.put("registerDate", time);
				String name ="";
				if(Utils.objectIsNotEmpty(m.get("wxName"))){
					name=WxBase64.decode((String)m.get("wxName"));	
					m.put("wxName", name);
				}else{
					m.put("wxName", m.get("loginName"));
				}
				//查询出该会员的返利金额
				String sql="select sum(f.amount) as amount from shop_orders o ,shop_fund_detail f,basic_customer b where  o.ordersState in(5,9) and f.source = 2 AND b.customerId = o.customerId AND f.customerId = b.customerId AND f.ordersNo = o.ordersNo and b.customerId="+m.get("customerId");
				List<Map<String, Object>> moneyMap=customerService.findListMapBySql(sql);
				if(Utils.collectionIsNotEmpty(moneyMap)){
					m.put("money", moneyMap.get(0).get("amount"));
				}else{
					m.put("money", 0.00);
				}
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
	
	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public void setDisCustomerService(IDisCustomerService disCustomerService) {
		this.disCustomerService = disCustomerService;
	}
	public String getIsJMS() {
		return isJMS;
	}

	public void setIsJMS(String isJMS) {
		this.isJMS = isJMS;
	}

	public String getIsCriticalValue() {
		return isCriticalValue;
	}

	public void setIsCriticalValue(String isCriticalValue) {
		this.isCriticalValue = isCriticalValue;
	}

	public String getLevelId() {
		return levelId;
	}

	public void setLevelId(String levelId) {
		this.levelId = levelId;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public String getReferrer() {
		return referrer;
	}
	public void setReferrer(String referrer) {
		this.referrer = referrer;
	}
	public String getMobilePhone() {
		return mobilePhone;
	}
	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}

	public List<Map<String, Object>> getCustomersList() {
		return customersList;
	}

	public void setCustomersList(List<Map<String, Object>> customersList) {
		this.customersList = customersList;
	}
	
	
}
