package shop.customer.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import shop.customer.pojo.CusService;
import shop.customer.service.ICustomerServiceService;
import util.action.BaseAction;

/**
 * 客服信息Action
 * @author wy
 */
@SuppressWarnings("serial")
public class CustomerServiceAction extends BaseAction{
	private ICustomerServiceService customerServiceService;
	private List<CusService> customerServiceList;
	private CusService customerService;
	private String ids;
	/**跳转至客服列表页面**/
	public String gotoCustomerServicePage(){
		return SUCCESS;
	}
	/**查找客服列表**/
	public void listCustomerService() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append(" where 1=1");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String trueName = request.getParameter("trueName");
			String nikeName = request.getParameter("nikeName");
			String qq = request.getParameter("qq");
			String useState = request.getParameter("useState");
			if(StringUtils.isNotEmpty(trueName)){
				trueName = trueName.trim();
				hqlsb.append(" and o.trueName like '%"+trueName+"%'");
			}
			if(StringUtils.isNotEmpty(nikeName)){
				nikeName = nikeName.trim();
				hqlsb.append(" and o.nikeName like '%"+nikeName+"%'");
			}
			if(StringUtils.isNotEmpty(qq)){
				nikeName = nikeName.trim();
				hqlsb.append(" and o.qq like '%"+qq+"%'");
			}
			if(useState!=null&&!"-1".equals(useState.trim())){
				useState = useState.trim();
				hqlsb.append(" and o.useState="+useState);
			}
		}
		hqlsb.append(" order by o.customerServiceId desc");
		int totalRecordCount = customerServiceService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		customerServiceList = customerServiceService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customerServiceList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateCustomerService() throws IOException{
		if(customerService!=null){
			if(customerService.getCustomerServiceId()==null){
				List<CusService> cusList = customerServiceService.findObjects("order by o.workNumber desc");
				if(cusList==null&&cusList.size()==0){
					customerService.setWorkNumber("01000");
				}else{
					customerService.setWorkNumber("0"+(Integer.valueOf(cusList.get(0).getWorkNumber())+1));
				}
			}
			customerService = (CusService) customerServiceService.saveOrUpdateObject(customerService);
			if(customerService.getCustomerServiceId()!=null){
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
	//获取一条记录
	public void getCustomerServiceInfo() throws IOException{
		customerService = (CusService) customerServiceService.getObjectByParams(" where o.customerServiceId='"+ids+"'");
		JSONObject jo = JSONObject.fromObject(customerService);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteCustomerServices() throws IOException{
		Boolean isSuccess = customerServiceService.deleteObjectsByIds("customerServiceId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public void setCustomerServiceService(
			ICustomerServiceService customerServiceService) {
		this.customerServiceService = customerServiceService;
	}
	public List<CusService> getCustomerServiceList() {
		return customerServiceList;
	}
	public void setCustomerServiceList(List<CusService> customerServiceList) {
		this.customerServiceList = customerServiceList;
	}
	public CusService getCustomerService() {
		return customerService;
	}
	public void setCustomerService(CusService customerService) {
		this.customerService = customerService;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
}
