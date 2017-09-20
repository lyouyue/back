package basic.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.other.Utils;
import basic.pojo.Actor;
import basic.pojo.UsersActor;
import basic.service.IActorService;
import basic.service.IUsersActorService;
/**
 * 管理员角色Action
 * 
 *
 */
@SuppressWarnings("serial")
public class UsersActorAction extends BaseAction{
	private IUsersActorService usersActorService;//管理员角色Service
	private IActorService actorService;//角色Service
	private List<UsersActor> usersActorList = new ArrayList<UsersActor>();//管理员角色List
	private List<Actor> actorList = new ArrayList<Actor>();
	private String usersId;
	private UsersActor usersActor;
	private String actorName;
	private List<String> actorInfos;//提交多个角色信息
	private String ids;
	private String userName;
	//查选所有的角色和用户已经选择的角色
	public String findActorListByUsersId(){
		request.setAttribute("usersId", usersId);
		request.setAttribute("userNameInfo",userName);
		return SUCCESS;
	}
	//查询管理员已经分配的角色
	public void listUsersActorByUsersId() throws IOException{
		String hqlCount = " select count(a.userActorId) from UsersActor a,Actor b where a.actorId = b.actorId and a.usersId = '"+usersId+"' order by a.userActorId desc ";
		String hql = " select a.userActorId as userActorId,b.actorName as actorName from UsersActor a,Actor b where a.actorId = b.actorId and a.usersId = '"+usersId+"' order by a.userActorId desc ";
		int total = usersActorService.getCountByHQL(hqlCount);
		pageHelper.setPageInfo(pageSize, total, currentPage);
		List<Map> List = usersActorService.findListMapPage(hql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", total);// total键 存放总记录数，必须的
		jsonMap.put("rows", List);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据条件查询角色信息
	public void listActorInfo() throws IOException{
		String hql = " where 1=1 ";
		String id="";
		if(Utils.objectIsNotEmpty(usersId)){
			List<UsersActor> list=usersActorService.findObjects(" where o.usersId="+usersId);
			if(Utils.objectIsNotEmpty(list)&&list.size()>0)
			for(int i=0; i<list.size();i++){
				if(i==list.size()-1){
					id+=list.get(i).getActorId();
				}else{
					id+=list.get(i).getActorId()+",";
				}
			}
		}
		if(Utils.objectIsNotEmpty(id)){
			hql+=" and o.actorId not in("+id+")";
		}
		if("".equals(actorName) || actorName==null){
			hql += " order by o.actorId";
		}else{
			hql += " and o.actorName like'%"+actorName+"%' order by o.actorId";
		}
		actorList = actorService.findObjects(hql);
		JSONArray jo = JSONArray.fromObject(actorList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存管理员选择的角色
	public String saveOrUpdateUsersActor() throws UnsupportedEncodingException{
		usersId = usersActor.getUsersId().toString();
		if(ids!=null && ids.length()>0){
			List<Actor> list=actorService.findObjects(" where o.actorId in("+ids+")");
			for(Actor actor : list){
				UsersActor usersActor = new UsersActor();
				usersActor.setUsersId(Integer.parseInt(usersId));
				usersActor.setActorId(actor.getActorId());
				usersActor.setActorName(actor.getActorName());
				usersActorService.saveOrUpdateObject(usersActor);
			}
		}
		return SUCCESS;
	}
	//删除管理员角色信息
	public void deleteUsersActor() throws IOException{
		Boolean isSuccess = usersActorService.deleteObjectsByIds("userActorId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<UsersActor> getUsersActorList() {
		return usersActorList;
	}
	public void setUsersActorList(List<UsersActor> usersActorList) {
		this.usersActorList = usersActorList;
	}
	public String getUsersId() {
		return usersId;
	}
	public void setUsersId(String usersId) {
		this.usersId = usersId;
	}
	public UsersActor getUsersActor() {
		return usersActor;
	}
	public void setUsersActor(UsersActor usersActor) {
		this.usersActor = usersActor;
	}
	public void setUsersActorService(IUsersActorService usersActorService) {
		this.usersActorService = usersActorService;
	}
	public List<Actor> getActorList() {
		return actorList;
	}
	public void setActorList(List<Actor> actorList) {
		this.actorList = actorList;
	}
	public String getActorName() {
		return actorName;
	}
	public void setActorName(String actorName) {
		this.actorName = actorName;
	}
	public void setActorService(IActorService actorService) {
		this.actorService = actorService;
	}
	public List<String> getActorInfos() {
		return actorInfos;
	}
	public void setActorInfos(List<String> actorInfos) {
		this.actorInfos = actorInfos;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
