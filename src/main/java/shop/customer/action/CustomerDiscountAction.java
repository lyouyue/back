package shop.customer.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import shop.customer.pojo.CustomerDiscount;
import shop.customer.service.ICustomerDiscountService;
import util.action.BaseAction;
import util.other.CreateWhereSQLForSelect;
/**
 * 会员折扣action
 * @author wsy
 */
@SuppressWarnings("serial")
public class CustomerDiscountAction extends BaseAction{
	private ICustomerDiscountService customerDiscountService;//会员折扣Service
	private CustomerDiscount customerDiscount;//会员折扣实体
	private List<CustomerDiscount> cdList= new ArrayList<CustomerDiscount>();//会员折扣list 
	private String customerId;//会员Id
	private String ids;
	/** 查看当前会员所有 **/
	public void listCustomerDiscount() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
		}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" customerDiscountId desc"));
		int totalRecordCount = customerDiscountService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		cdList = customerDiscountService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", cdList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/** 添加和修改折扣值 **/
	public void saveOrUpdateCustomerDiscount() throws Exception{
		if(customerDiscount!=null){
			customerDiscount = (CustomerDiscount) customerDiscountService.saveOrUpdateObject(customerDiscount);
			if(customerDiscount.getCustomerDiscountId()!=null){
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", "true");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}
	}
	/** 查看当前会员折扣 **/
	public void getCustomerDiscountObject() throws IOException{
		customerDiscount = (CustomerDiscount) customerDiscountService.getObjectById(customerId);
		JSONObject jo = JSONObject.fromObject(customerDiscount);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/** 批量删除  **/
	public void deleteCustomerDiscount() throws IOException{
		Boolean isSuccess = customerDiscountService.deleteObjectsByIds("customerDiscountId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public CustomerDiscount getCustomerDiscount() {
		return customerDiscount;
	}
	public void setCustomerDiscount(CustomerDiscount customerDiscount) {
		this.customerDiscount = customerDiscount;
	}
	public void setCustomerDiscountService(
			ICustomerDiscountService customerDiscountService) {
		this.customerDiscountService = customerDiscountService;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public List<CustomerDiscount> getCdList() {
		return cdList;
	}
	public void setCdList(List<CustomerDiscount> cdList) {
		this.cdList = cdList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
}
