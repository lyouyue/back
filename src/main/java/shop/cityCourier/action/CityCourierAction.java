package shop.cityCourier.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import basic.pojo.BasicArea;
import basic.service.IAreaService;

import com.sun.org.apache.regexp.internal.recompile;

import shop.cityCourier.pojo.CityCourier;
import shop.cityCourier.service.ICityCourierService;
import shop.common.pojo.CoinRules;
import util.action.BaseAction;
import util.other.CreateWhereSQLForSelect;
import util.other.JSONFormatDate;
import util.other.Utils;

/**
 * 同城快递员人事档案Action类
 * @author wy
 *
 */

@SuppressWarnings("serial")
public class CityCourierAction extends BaseAction{
	private ICityCourierService cityCourierService;
	private IAreaService areaService;
	private List<CityCourier> cityCourierList;
	private List<BasicArea> provinceList;
	private List<BasicArea> cityList;
	private BasicArea province;
	private BasicArea city;
	private BasicArea district;
	private CityCourier cityCourier;
	private String ids;
	private String id;
	
	public String gotoCityCourierPage(){
		String purviewId=request.getParameter("purviewId");
		request.getSession().setAttribute("purviewId", purviewId);
		//获取省
		provinceList=areaService.findObjects(" where o.parentId=0");
		return SUCCESS;
	}
	
	public void ListCityCourier() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String hql=" where 1=1 ";
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String cityCourierName = request.getParameter("cityCourierName");
			String phone = request.getParameter("phone");
			String responsibleAreas = request.getParameter("responsibleAreas");
			if(Utils.objectIsNotEmpty(cityCourierName)){
				hql+=" and o.cityCourierName like '%"+cityCourierName.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(phone)){
				hql+=" and o.phone like '%"+phone.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(responsibleAreas)){
				hql+=" and o.responsibleAreas= '"+responsibleAreas+"'";
			}
		}
		hql+=" order by  o.cityCourierId desc ";
		int totalRecordCount = cityCourierService.getCount(hql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String [] selectColumns={"cityCourierId","cityCourierName","responsibleAreas","phone","entryTime"};
		cityCourierList = cityCourierService.findListByPageHelper(selectColumns,pageHelper, hql);
		if(cityCourierList!=null&&cityCourierList.size()>0){
			for(int i=0;i<cityCourierList.size();i++){
				String[] areas = cityCourierList.get(i).getResponsibleAreas().split(",");
				BasicArea district=(BasicArea) areaService.getObjectByParams(" where o.areaId="+areas[2]);
				cityCourierList.get(i).setResponsibleAreas(district.getFullName());
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", cityCourierList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateCityCourier() throws IOException{
		if(cityCourier!=null){
			cityCourier = (CityCourier) cityCourierService.saveOrUpdateObject(cityCourier);
			if(cityCourier.getCityCourierId()!=null){
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
	public void getCityCourierInfo() throws IOException{
		cityCourier = (CityCourier) cityCourierService.getObjectById(id);
		String[] areas = cityCourier.getResponsibleAreas().split(",");
		List<BasicArea> cityList=areaService.findObjects(" where o.parentId="+areas[0]);
		List<BasicArea> districtList=areaService.findObjects(" where o.parentId="+areas[1]);
		BasicArea district=(BasicArea) areaService.getObjectByParams(" where o.areaId="+areas[2]);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("cityCourier", cityCourier);
		jsonMap.put("cityList", cityList);
		jsonMap.put("districtList", districtList);
		jsonMap.put("district", district);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteCityCouriers() throws IOException{
		Boolean isSuccess = cityCourierService.deleteObjectsByIds("cityCourierId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取市
	public void findCityList() throws IOException{
		cityList=areaService.findObjects(" where o.parentId="+id);
		JSONArray jo = JSONArray.fromObject(cityList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<CityCourier> getCityCourierList() {
		return cityCourierList;
	}
	public void setCityCourierList(List<CityCourier> cityCourierList) {
		this.cityCourierList = cityCourierList;
	}
	public CityCourier getCityCourier() {
		return cityCourier;
	}
	public void setCityCourier(CityCourier cityCourier) {
		this.cityCourier = cityCourier;
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
	public void setCityCourierService(ICityCourierService cityCourierService) {
		this.cityCourierService = cityCourierService;
	}
	public List<BasicArea> getProvinceList() {
		return provinceList;
	}
	public void setProvinceList(List<BasicArea> provinceList) {
		this.provinceList = provinceList;
	}
	public List<BasicArea> getCityList() {
		return cityList;
	}
	public void setCityList(List<BasicArea> cityList) {
		this.cityList = cityList;
	}
	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}
	public BasicArea getProvince() {
		return province;
	}
	public void setProvince(BasicArea province) {
		this.province = province;
	}
	public BasicArea getCity() {
		return city;
	}
	public void setCity(BasicArea city) {
		this.city = city;
	}
	public BasicArea getDistrict() {
		return district;
	}
	public void setDistrict(BasicArea district) {
		this.district = district;
	}
}
