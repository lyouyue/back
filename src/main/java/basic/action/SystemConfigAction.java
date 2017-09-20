package basic.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.other.Utils;
import basic.pojo.SystemConfig;
import basic.service.ISystemConfigService;
/**
 * 基础配置Action
 * @author Administrator
 * 2014-08-19
 */
@SuppressWarnings("serial")
public class SystemConfigAction extends BaseAction{
	/**基础配置service**/
	private ISystemConfigService systemConfigService;
	/**基础配置集合**/
	private List<SystemConfig> systemConfigList = new ArrayList<SystemConfig>();
	/**基础配置实体类**/
	private SystemConfig systemConfig;
	private String id;
	private String ids;
	private String name;
	private String type;
	
	/**
	 * 跳转到基础配置列表页面
	 * @return
	 */
	public String gotoSystemConfigPage(){
		return SUCCESS;
	}
	/**
	 * 查询所有基础配置信息
	 */
	public void listSystemConfig() throws Exception{
		String hql =" where 1=1 ";
		if(name!=null&&!"".equals(name.trim())){
			hql += " and o.name like '%"+name.trim()+"%'";
		}
		if(type!=null&&!"".equals(type.trim())){
			hql += " and o.type like '%"+type.trim()+"%'";
		}
		int totalRecordCount = systemConfigService.getCount(hql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		systemConfigList = systemConfigService.findListByPageHelper(null,pageHelper, hql+" order by o.id desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", systemConfigList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 添加或者保存基础配置信息
	 */
	public void saveOrUpdateSystemConfig() throws Exception{
		if(systemConfig!=null){
			systemConfig = (SystemConfig) systemConfigService.saveOrUpdateObject(systemConfig);
			if(systemConfig.getId()!=null){
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
	/**
	 * 查询一条记录
	 */
	public void getSystemConfigObject() throws Exception{
		systemConfig = (SystemConfig) systemConfigService.getObjectById(id);
		JSONObject jo = JSONObject.fromObject(systemConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 删除
	 */
	public void deleteSystemConfig() throws Exception{
		Boolean isSuccess = systemConfigService.deleteObjectsByIds("id",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//更新初始化配置数据
	@SuppressWarnings("unchecked")
	public void updateSystemConfig() throws IOException{
		Boolean isSuccess = false;//返回值，是否更新成功，默认是否
		//全局基础设置
		Map<String,String> systemConfigFile = new HashMap<String,String>();
		List<SystemConfig> systemConfigList = systemConfigService.findObjects(null," order by o.id desc");
		if (Utils.objectIsNotEmpty(systemConfigList) && systemConfigList.size() > 0) {
			for (SystemConfig s : systemConfigList) {
				String key = s.getType();
				String value = s.getValue();
				systemConfigFile.put(key, value);
			}
		}
		servletContext.setAttribute("fileUrlConfig", systemConfigFile);
		isSuccess = true;
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public List<SystemConfig> getSystemConfigList() {
		return systemConfigList;
	}
	public void setSystemConfigList(List<SystemConfig> systemConfigList) {
		this.systemConfigList = systemConfigList;
	}
	public SystemConfig getSystemConfig() {
		return systemConfig;
	}
	public void setSystemConfig(SystemConfig systemConfig) {
		this.systemConfig = systemConfig;
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
	public void setSystemConfigService(ISystemConfigService systemConfigService) {
		this.systemConfigService = systemConfigService;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
}
