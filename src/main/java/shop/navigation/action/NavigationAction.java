package shop.navigation.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import shop.navigation.pojo.Navigation;
import shop.navigation.service.INavigationService;
import util.action.BaseAction;
/**
 * 导航条Action
 * @author 王亚
 *
 */
@SuppressWarnings("serial")
public class NavigationAction extends BaseAction {
	private INavigationService navigationService;
	private List<Navigation> navigationList;
	private Navigation navigation;
	private String navigationId;
	private String ids;
	
	public String gotoNavigationPage(){
		return SUCCESS;
	}
	
	public void listNavigation() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append(" where 1=1");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String navigationName = request.getParameter("navigationName");
			String isUser = request.getParameter("isUser");
			String isShowOnBar = request.getParameter("isShowOnBar");
			if(StringUtils.isNotEmpty(navigationName)){
				navigationName = navigationName.trim();
				hqlsb.append(" and o.navigationName like '%"+navigationName+"%'");
			}
			if(!"-1".equals(isUser)){
				hqlsb.append(" and o.isUser = "+isUser);
			}
			if(!"-1".equals(isShowOnBar)){
				hqlsb.append(" and o.isShowOnBar = "+isShowOnBar);
			}
		}
		hqlsb.append(" order by o.navigationId desc");
		int totalRecordCount = navigationService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		navigationList = navigationService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", navigationList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public void saveOrUpdateNavigation() throws IOException{
		if(navigation!=null){
			navigation = (Navigation) navigationService.saveOrUpdateObject(navigation);
			if(navigation.getNavigationId()!=null){
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
	
	public void deleteNavigation() throws IOException{
		Boolean isSuccess = navigationService.deleteObjectsByIds("navigationId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public void getNavigationObject() throws IOException{
		navigation = (Navigation) navigationService.getObjectByParams(" where o.navigationId='"+navigationId+"'");
		JSONObject jo = JSONObject.fromObject(navigation);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//验证计量单位是否重复
	public void checkNavigationName() throws IOException{
		String navigationName = request.getParameter("navigationName");
		if(navigationName!=null && !"".equals(navigationName)){
			Integer count = navigationService.getCount(" where o.navigationName='"+navigationName+"'");
			if(count.intValue()==0){
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.print("ok");
				out.flush();
				out.close();
			}
		}
	}
	public List<Navigation> getNavigationList() {
		return navigationList;
	}
	public void setNavigationList(List<Navigation> navigationList) {
		this.navigationList = navigationList;
	}
	public Navigation getNavigation() {
		return navigation;
	}
	public void setNavigation(Navigation navigation) {
		this.navigation = navigation;
	}
	public String getNavigationId() {
		return navigationId;
	}
	public void setNavigationId(String navigationId) {
		this.navigationId = navigationId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setNavigationService(INavigationService navigationService) {
		this.navigationService = navigationService;
	}
}
