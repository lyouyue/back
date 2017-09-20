package shop.homeIndex.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.homeIndex.pojo.TopSearch;
import shop.homeIndex.service.ITopSearchService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * TopSearchAction -- 热门搜索Action
 * @author Administrator
 * 2014-05-12
 */
@SuppressWarnings("serial")
public class TopSearchAction extends BaseAction {
	/**热门搜索Service**/
	private ITopSearchService topSearchService;
	/**热门搜索实体类**/
	private TopSearch topSearch;
	/**热门搜素集合**/
	private List<TopSearch> topSearchList;
	private String id;
	private String ids;
	
	//跳转到热门搜索列表页面
	public String gotoTopSearchPage(){
		return SUCCESS;
	}
	//查询所有热门搜索列表
	public void listTopSearch() throws IOException{
		int totalRecordCount = topSearchService.getCount(null);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		topSearchList = topSearchService.findListByPageHelper(null, pageHelper, " order by o.sortCode, o.topSearchId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", topSearchList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateTopSearch() throws IOException{
		if(Utils.objectIsNotEmpty(topSearch)){
			if(Utils.objectIsNotEmpty(topSearch.getShowClient())){
				topSearch.setShowClient(topSearch.getShowClient().replaceAll(" ",""));
				topSearch = (TopSearch) topSearchService.saveOrUpdateObject(topSearch);
				if(topSearch.getTopSearchId()!=null){
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
	}
	//获取一条记录
	public void getTopSearchObject() throws IOException{
		topSearch = (TopSearch) topSearchService.getObjectByParams(" where o.topSearchId="+id);
		JSONObject jo = JSONObject.fromObject(topSearch);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteTopSearch() throws IOException{
		Boolean isSuccess = topSearchService.deleteObjectsByIds("topSearchId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public TopSearch getTopSearch() {
		return topSearch;
	}
	public void setTopSearch(TopSearch topSearch) {
		this.topSearch = topSearch;
	}
	public List<TopSearch> getTopSearchList() {
		return topSearchList;
	}
	public void setTopSearchList(List<TopSearch> topSearchList) {
		this.topSearchList = topSearchList;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setTopSearchService(ITopSearchService topSearchService) {
		this.topSearchService = topSearchService;
	}		
}
