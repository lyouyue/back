package shop.customer.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.commons.io.FileUtils;
import shop.customer.pojo.Customer;
import shop.customer.pojo.CustomerComplaint;
import shop.customer.service.ICustomerComplaintService;
import shop.customer.service.ICustomerService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import basic.pojo.KeyBook;
import basic.service.IKeyBookService;
/**
 * CustomerComplaintAction - 客户投诉Action类
 */
@SuppressWarnings("serial")
public class CustomerComplaintAction extends BaseAction{
	private ICustomerComplaintService customerComplaintService;//客户投诉Service
	private ICustomerService customerService;//会员Service
	private List<CustomerComplaint> customerComplaintList = new ArrayList<CustomerComplaint>();//客户投诉List
	private List<Customer> customerList = new ArrayList<Customer>();//会员List
	private CustomerComplaint customerComplaint;
	private String customerComplaintId;
	private String ids;
	private IKeyBookService keyBookService;//数据字典service
	private List<KeyBook> keyBookList = new ArrayList<KeyBook>();//数据字典List
	/**
	 * 投诉类型 1：产品相关 2：价格相关 3：服务相关 4：物流相关 5：售后相关 6：财务相关 7：活动相关 8：网站相关 9：其它方面
	 */
	private Integer complaintType;
	/**
	 * 状态 1：审核中 2：处理中3：已关闭
	 */
	private Integer state;
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**投诉列表**/
	private List<Map> listComplaint;
	//跳转到客户投诉列表页面
	public String gotoCustomerComplaintPage(){
		//查询所有会员
		customerList = customerService.findObjects(null);
		keyBookList = keyBookService.findObjects(" where o.type = 'complaintType'");
		return SUCCESS;
	}
	//保存或者修改客户投诉
	public void saveOrUpdateCustomerComplaint() throws Exception {
		if(customerComplaint!=null){
			if(customerComplaint.getCustomerComplaintId()==null || "".equals(customerComplaint.getCustomerComplaintId())){
				customerComplaint.setCreateTime(new Date());
			}
			customerComplaint=(CustomerComplaint)customerComplaintService.saveOrUpdateObject(customerComplaint);
		}
		if(customerComplaint.getCustomerComplaintId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//会员投诉信息列表
	public void listCustomerComplaint() throws IOException{
		String hql="select b.loginName as customerName, a.customerComplaintId as customerComplaintId " +
				",a.customerId as customerId,a.complaintType as complaintType,a.complaintOrdersNo as complaintOrdersNo " +
				",a.complaintContext as complaintContext,a.complaintImageUrl as complaintImageUrl ,a.state as state," +
				"a.createTime as createTime " +
				"from CustomerComplaint a,Customer b where a.customerId=b.customerId";
		String countHql = " select count(a.customerComplaintId) from CustomerComplaint a,Customer b  where a.customerId=b.customerId";
		if(complaintType !=null && complaintType.compareTo(-1)!=0){
			hql+=" and a.complaintType="+complaintType;
		}
		if(state!=null && state.compareTo(-1)!=0){
			hql+=" and a.state="+state;
		}
		if(createTime!=null){
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String dateString = formatter.format(createTime);
			hql+=" and a.createTime like '%"+dateString+"%'";
		}
		int totalRecordCount = customerComplaintService.getMoreTableCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		listComplaint = customerComplaintService.findListMapPage(hql, pageHelper);
		for(Map map:listComplaint){
			SimpleDateFormat formatter = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
			map.put("createTime", formatter.format(map.get("createTime")));
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", listComplaint);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//得到会员投诉对象
	public void getCustomerComplaintObject() throws IOException{
		if(customerComplaintId != null){
			customerComplaint = (CustomerComplaint)customerComplaintService.getObjectByParams(" where o.customerComplaintId='"+customerComplaintId+"'");
			if(customerComplaint.getCustomerComplaintId()!= null){
				JsonConfig jsonConfig = new JsonConfig();
				jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
				JSONObject jo = JSONObject.fromObject(customerComplaint,jsonConfig);
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.print(jo.toString());
				out.flush();
				out.close();
			}
		}
	}
	//删除会员投诉
	public void deleteCustomerComplaint() throws Exception {
		Boolean isSuccess = customerComplaintService.deleteObjectsByIds("customerComplaintId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<CustomerComplaint> getCustomerComplaintList() {
		return customerComplaintList;
	}
	public void setCustomerComplaintList(
			List<CustomerComplaint> customerComplaintList) {
		this.customerComplaintList = customerComplaintList;
	}
	public List<Customer> getCustomerList() {
		return customerList;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}
	public CustomerComplaint getCustomerComplaint() {
		return customerComplaint;
	}
	public void setCustomerComplaint(CustomerComplaint customerComplaint) {
		this.customerComplaint = customerComplaint;
	}
	public String getCustomerComplaintId() {
		return customerComplaintId;
	}
	public void setCustomerComplaintId(String customerComplaintId) {
		this.customerComplaintId = customerComplaintId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setCustomerComplaintService(
			ICustomerComplaintService customerComplaintService) {
		this.customerComplaintService = customerComplaintService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public List<KeyBook> getKeyBookList() {
		return keyBookList;
	}
	public void setKeyBookList(List<KeyBook> keyBookList) {
		this.keyBookList = keyBookList;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public Integer getComplaintType() {
		return complaintType;
	}
	public void setComplaintType(Integer complaintType) {
		this.complaintType = complaintType;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public List<Map> getListComplaint() {
		return listComplaint;
	}
	public void setListComplaint(List<Map> listComplaint) {
		this.listComplaint = listComplaint;
	}
}
