package shop.customer.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.commons.lang.StringUtils;

import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import basic.pojo.Users;
import basic.service.IKeyBookService;
/**
 * 企业管理Action
 * @author wsy
 *
 */
@SuppressWarnings("serial")
public class CompanyManageAction extends BaseAction {
	/**企业信息service**/
	private IShopInfoService shopInfoService;
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();//店铺信息列表
	@SuppressWarnings("rawtypes")
	private List<Map> shopInfoListMap = new ArrayList<Map>();//店铺信息列表
	private String ids;
	private ShopInfo shopInfo;//店铺基本信息实体
	private Integer saveShopInfoCheckSatus;//企业审核状态
	private Integer saveInvoiceCheckStatus;//发票审核状态
	/**查询数字字典公司认证**/
	private IKeyBookService keyBookService;
	/**跳转企业管理页面**/
	public String gotoCompanyManagePage(){
		return SUCCESS;
	}
	//店铺基本信息查询列表
	public void listCompantManage() throws IOException {
		String sql="SELECT a.shopInfoId as shopInfoId, a.customerName as customerName ,a.companyName as companyName,a.postCode as postCode,"
				+ " a.companyRegistered as companyRegistered,a.passUserName as passUserName ,a.invoiceCheckStatus as invoiceCheckStatus,a.shopInfoCheckSatus as shopInfoCheckSatus,"
				+ "a.addressForInvoice as addressForInvoice, a.regionLocation as regionLocation, a.city as city, a.areaCounty as areaCounty,"
				+ "b.type as type, date_format( b.registerDate, '%Y-%m-%d %h:%m:%s') as registerDate,b.lockedState as lockedState,b.customerId as customerId "
				+ " from ShopInfo a,Customer b where b.type = 2 and a.customerId=b.customerId and length(a.companyName)>0 ";
		String sqlCount="SELECT count(a.shopInfoId) from ShopInfo a,Customer b where b.type = 2 and a.customerId=b.customerId and length(a.companyName)>0";
		String selectFlag=request.getParameter("selectFlag");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String companyName = request.getParameter("companyName");
			String custName = request.getParameter("custName");
			String shopInfoCheckSatus = request.getParameter("shopInfoCheckSatus");
			String registerDate = request.getParameter("registerDate");
			String registerDate2 = request.getParameter("registerDate2");
			if(registerDate!=null&&!"".equals(registerDate)){
				sql+= " and b.registerDate>= '"+registerDate.trim()+" 00:00:00"+"'";
				sqlCount+= " and  b.registerDate >= '"+registerDate.trim()+" 00:00:00"+"'";
			}
			if(registerDate2!=null&&!"".equals(registerDate2)){
				sql+= " and b.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
				sqlCount+= " and  b.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
			}
			if(StringUtils.isNotEmpty(companyName)){
				companyName = companyName.trim();
				sql+=" and a.companyName like '%"+companyName+"%'";
				sqlCount+=" and a.companyName like '%"+companyName+"%'";
			}
			if(StringUtils.isNotEmpty(custName)){
				custName = custName.trim();
				sql+=" and a.customerName like '%"+custName+"%'";
				sqlCount+=" and a.customerName like '%"+custName+"%'";
			}
			if(!"-1".equals(shopInfoCheckSatus)){
				sql+=" and a.shopInfoCheckSatus="+shopInfoCheckSatus;
				sqlCount+=" and a.shopInfoCheckSatus="+shopInfoCheckSatus;
			}
		}
		sql+=" order by a.shopInfoId desc";
		int totalRecordCount = shopInfoService.getMoreTableCount(sqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		shopInfoListMap = shopInfoService.findListMapPage(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", shopInfoListMap);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**查询一个企业的详细信息
	 * @throws IOException **/
	public void getCompanyManageById() throws IOException{
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId='"+ids+"'");
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap.put("shopInfo", shopInfo);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**修改企业审核状态
	 * @throws IOException **/
	public void saveOrUpdateCompanyManage() throws IOException{
		Users users = (Users)request.getSession().getAttribute("users");
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId="+ids);
		shopInfo.setShopInfoCheckSatus(saveShopInfoCheckSatus);
		if(saveShopInfoCheckSatus!=null){
			shopInfo.setVerifier(users.getUserName());
			shopInfo.setPassTime(new Date());
			shopInfo.setPassUserName(users.getUserName());
		}
		shopInfo = (ShopInfo) shopInfoService.saveOrUpdateObject(shopInfo);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**修改发票审核状态
	 * @throws IOException **/
	public void saveOrUpdateCompanyManageInvoice() throws IOException{
		Users users = (Users)request.getSession().getAttribute("users");
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId="+ids);
		shopInfo.setInvoiceCheckStatus(saveInvoiceCheckStatus);
		if(saveInvoiceCheckStatus.compareTo(3)==0){
			shopInfo.setVerifier(users.getUserName());
			shopInfo.setPassTime(new Date());
		}
		shopInfo = (ShopInfo) shopInfoService.saveOrUpdateObject(shopInfo);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	@SuppressWarnings("rawtypes")
	public List<Map> getShopInfoListMap() {
		return shopInfoListMap;
	}
	@SuppressWarnings("rawtypes")
	public void setShopInfoListMap(List<Map> shopInfoListMap) {
		this.shopInfoListMap = shopInfoListMap;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public ShopInfo getShopInfo() {
		return shopInfo;
	}
	public void setShopInfo(ShopInfo shopInfo) {
		this.shopInfo = shopInfo;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public Integer getSaveShopInfoCheckSatus() {
		return saveShopInfoCheckSatus;
	}
	public void setSaveShopInfoCheckSatus(Integer saveShopInfoCheckSatus) {
		this.saveShopInfoCheckSatus = saveShopInfoCheckSatus;
	}
	public Integer getSaveInvoiceCheckStatus() {
		return saveInvoiceCheckStatus;
	}
	public void setSaveInvoiceCheckStatus(Integer saveInvoiceCheckStatus) {
		this.saveInvoiceCheckStatus = saveInvoiceCheckStatus;
	}
}
