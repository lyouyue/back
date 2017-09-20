package shop.logistics.action;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import basic.pojo.BasicArea;
import basic.service.IAreaService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.cityCourier.pojo.CityCourier;
import shop.cityCourier.service.ICityCourierService;
import shop.logistics.pojo.Logistics;
import shop.logistics.service.ILogisticsService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
/**
 * 物流公司Action实体类
 * @author Administrator
 * 2014-07-25
 */
@SuppressWarnings("serial")
public class LogisticsAction extends BaseAction {
	/**物流公司Service**/
	private ILogisticsService logisticsService;
	/**物流公司集合**/
	private List<Map> logisticsList ;
	/**物流公司实体类**/
	private Logistics logistics;
	private String ids;
	private String id;
	/**同城快递Service**/
	private ICityCourierService cityCourierService;
	/**物流公司集合**/
	private List<CityCourier> cityCourierList = new ArrayList<CityCourier>();
	/**地区表Service**/
	private IAreaService areaService;

	/**
	 * 跳转到物流公司列表页
	 */
	public String gotoLogisticsPage(){
		return SUCCESS;
	}

	/**
	 * 查询物流公司列表信息
	 */
	public void listLogistics() throws Exception{
		String selectFlag=request.getParameter("selectFlag");
		String code=request.getParameter("code");
		String deliveryCorpName=request.getParameter("deliveryCorpName");
		String hql=" SELECT l.logisticsId AS logisticsId,l.code AS code,l.deliveryCorpName AS deliveryCorpName,l.deliveryUrl AS deliveryUrl,l.createDate AS createDate,"+
				" l.sortCode AS sortCode,l.isCommon AS isCommon FROM Logistics  l WHERE 1=1 ";
		String hqlCount="SELECT count(l.logisticsId) FROM Logistics l WHERE 1=1";
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(code)){
				hql+=" and l.code like '%"+code.trim()+"%'";
				hqlCount+=" and l.code like '%"+code.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(deliveryCorpName)){
				hql+=" and l.deliveryCorpName like '%"+deliveryCorpName.trim()+"%'";
				hqlCount+=" and l.deliveryCorpName like '%"+deliveryCorpName.trim()+"%'";
			}
		}
		hql+="order by l.logisticsId desc";
		int totalRecordCount = logisticsService.getCountByHQL(hqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		logisticsList = logisticsService.findListMapPage(hql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", logisticsList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 添加或修改物流公司信息
	 */
	public void saveOrUpdateLogistics() throws Exception{
		if(logistics!=null){
			if(logistics.getLogisticsId()==null){
				logistics.setCreateDate(new Date());
			}
			logistics = (Logistics) logisticsService.saveOrUpdateObject(logistics);
			if(logistics.getLogisticsId()!=null){
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
	public void getLogisticsObject() throws Exception{
		logistics = (Logistics) logisticsService.getObjectById(id);
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap.put("logistics", logistics);
		//JSONObject jo = JSONObject.fromObject(logistics);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 删除
	 */
	public void deleteLogistics() throws Exception{
		Boolean isSuccess = logisticsService.deleteObjectsByIds("id",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 初始化物流公司信息
	 */
	@SuppressWarnings("unchecked")
	public void initLogistics() throws Exception{
		List<Logistics> logisticsList = logisticsService.findObjects(null, " where 1=1 order by o.logisticsId desc");
		JSONArray jo = JSONArray.fromObject(logisticsList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 初始化同城快递信息
	 */
	@SuppressWarnings("unchecked")
	public void initCityCourier() throws Exception{
		List<CityCourier> cityCourierList = cityCourierService.findObjects(null, " where o.responsibleAreas='"+id+"' order by o.cityCourierId desc");
		for(int i=0;i<cityCourierList.size();i++){
			String[] areas = cityCourierList.get(i).getResponsibleAreas().split(",");
			BasicArea district=(BasicArea) areaService.getObjectByParams(" where o.areaId="+areas[2]);
			cityCourierList.get(i).setResponsibleAreas(district.getFullName());
		}
		JSONArray jo = JSONArray.fromObject(cityCourierList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}


	public Logistics getLogistics() {
		return logistics;
	}

	public void setLogistics(Logistics logistics) {
		this.logistics = logistics;
	}

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setLogisticsService(ILogisticsService logisticsService) {
		this.logisticsService = logisticsService;
	}

	public List<CityCourier> getCityCourierList() {
		return cityCourierList;
	}

	public void setCityCourierList(List<CityCourier> cityCourierList) {
		this.cityCourierList = cityCourierList;
	}

	public void setCityCourierService(ICityCourierService cityCourierService) {
		this.cityCourierService = cityCourierService;
	}

	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}

	public List<Map> getLogisticsList() {
		return logisticsList;
	}

	public void setLogisticsList(List<Map> logisticsList) {
		this.logisticsList = logisticsList;
	}

}
