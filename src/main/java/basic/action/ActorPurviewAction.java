package basic.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import basic.pojo.ActorPurview;
import basic.pojo.Functions;
import basic.pojo.Purview;
import basic.service.IActorPurviewService;
import basic.service.IFunctionsService;
import basic.service.IPurviewService;
/**
 * 角色权限Action
 * @author LQS
 *
 */
@SuppressWarnings("serial")
public class ActorPurviewAction extends BaseAction{
	private IActorPurviewService actorPurviewService;
	private IPurviewService purviewService;
	private List<ActorPurview> actorPurviewList = new ArrayList<ActorPurview>();
	private List<Purview> purviewList = new ArrayList<Purview>();
	private String actorId;
	private Integer[] purviewIds;
	private ActorPurview actorPurview;
	private IFunctionsService functionsService;
	private List <Functions>functionsList;
	private String [] functionValues;
	private Integer purviewId;
	//查选所有的权限和角色已经选择的权限
	public String assignPurview(){
		request.setAttribute("actorId", actorId);
		return SUCCESS;
	}
	
	//查选所有的权限和角色已经选择的权限
	public void getPurviewListByActorId() throws IOException{
		purviewList = purviewService.findObjects(" order by sortCode");
		actorPurviewList = actorPurviewService.findObjects(" where o.actorId='"+actorId+"'");
		//request.setAttribute("actorId", actorId);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("purviewList", purviewList);
		jsonMap.put("actorPurviewList", actorPurviewList);
		jsonMap.put("actorId", actorId);
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 保存角色和权限以及功能权限的关系值  需要改善到统一service中
	 * @throws IOException 
	 * @throws UnsupportedEncodingException 
	 */
	public void saveActorPurview() throws IOException{
		boolean isSuccess=actorPurviewService.saveActorPurview(purviewIds, actorId, functionValues);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 获取该模块权限下的所有功能权限
	 * @return
	 *//*
	public String getFunctionsListByPurviewId(){
		int totalRecordCount = functionsService.getCount(" where o.purviewId='"+purviewId+"' order by o.fid");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		functionsList = functionsService.findListByPageHelper(null,pageHelper, " where o.purviewId='"+purviewId+"' order by o.fid desc");
		ActorPurview ap=(ActorPurview)actorPurviewService.getObjectByParams(" where o.actorId="+actorId+" and o.purviewId="+purviewId);
		if(ap!=null){
			request.setAttribute("functionValues", ap.getFunctions());
		}
		request.setAttribute("totalRecordCount", totalRecordCount);
		return SUCCESS;
	}*/
	
	/**
	 * 获取该模块权限下的所有功能权限
	 * @return
	 * @throws IOException 
	 */
	public void getFunctionsListByPurviewId() throws IOException{
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		int totalRecordCount = functionsService.getCount(" where o.purviewId='"+purviewId+"' order by o.fid");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		functionsList = functionsService.findListByPageHelper(null,pageHelper, " where o.purviewId='"+purviewId+"' order by o.fid desc");
		ActorPurview ap=(ActorPurview)actorPurviewService.getObjectByParams(" where o.actorId="+actorId+" and o.purviewId="+purviewId);
		if(ap!=null){
			jsonMap.put("functionValues", ap.getFunctions());
		}
		jsonMap.put("functionsList", functionsList);
		jsonMap.put("totalRecordCount", totalRecordCount);
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	public List<ActorPurview> getActorPurviewList() {
		return actorPurviewList;
	}
	public void setActorPurviewList(List<ActorPurview> actorPurviewList) {
		this.actorPurviewList = actorPurviewList;
	}
	public List<Purview> getPurviewList() {
		return purviewList;
	}
	public void setPurviewList(List<Purview> purviewList) {
		this.purviewList = purviewList;
	}
	public String getActorId() {
		return actorId;
	}
	public void setActorId(String actorId) {
		this.actorId = actorId;
	}
	public Integer[] getPurviewIds() {
		return purviewIds;
	}
	public void setPurviewIds(Integer[] purviewIds) {
		this.purviewIds = purviewIds;
	}
	public Integer getPurviewId() {
		return purviewId;
	}
	public void setPurviewId(Integer purviewId) {
		this.purviewId = purviewId;
	}
	public ActorPurview getActorPurview() {
		return actorPurview;
	}
	public void setActorPurview(ActorPurview actorPurview) {
		this.actorPurview = actorPurview;
	}
	public void setActorPurviewService(IActorPurviewService actorPurviewService) {
		this.actorPurviewService = actorPurviewService;
	}
	public void setPurviewService(IPurviewService purviewService) {
		this.purviewService = purviewService;
	}
	public List<Functions> getFunctionsList() {
		return functionsList;
	}
	public void setFunctionsList(List<Functions> functionsList) {
		this.functionsList = functionsList;
	}
	public String[] getFunctionValues() {
		return functionValues;
	}
	public void setFunctionValues(String[] functionValues) {
		this.functionValues = functionValues;
	}
	public void setFunctionsService(IFunctionsService functionsService) {
		this.functionsService = functionsService;
	}
}
