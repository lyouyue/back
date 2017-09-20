package shop.measuringUnit.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import shop.measuringUnit.pojo.MeasuringUnit;
import shop.measuringUnit.service.IMeasuringUnitService;
import shop.measuringUnit.service.IProductMeasuringUnitService;
import util.action.BaseAction;
/**
 * 计量单位Action
 * @author wangya
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class MeasuringUnitAction extends BaseAction {
	private IMeasuringUnitService measuringUnitService;
	private MeasuringUnit measuringUnit;
	private List<MeasuringUnit> measuringUnitList;
	private IProductMeasuringUnitService productMeasuringUnitService;
	private String ids;
	private String measuringUnitId;
	//验证计量单位是否重复
	public void checkMeasuringUnit() throws IOException{
		String name = request.getParameter("name");
		if(name!=null && !"".equals(name)){
			Integer count = measuringUnitService.getCount(" where o.name='"+name+"'");
			if(count.intValue()==0){
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.print("ok");
				out.flush();
				out.close();
			}
		}
	}
	//跳转到计量单位列表页面
	public String gotoMeasuringUnitPage(){
		return SUCCESS;
	}
	//查询所有信息列表
	public void listMeasuringUnit() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append(" where 1=1");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String name = request.getParameter("name");
			String useState = request.getParameter("useState");
			if(StringUtils.isNotEmpty(name)){
				name = name.trim();
				hqlsb.append(" and o.name like '%"+name+"%'");
			}
			if(!"-1".equals(useState)){
				hqlsb.append(" and o.useState = "+useState);
			}
		}
		hqlsb.append(" order by o.measuringUnitId desc");
		int totalRecordCount = measuringUnitService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		measuringUnitList = measuringUnitService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", measuringUnitList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateMeasuringUnit() throws IOException{
		if(measuringUnit!=null){
			measuringUnit = (MeasuringUnit) measuringUnitService.saveOrUpdateObject(measuringUnit);
			if(measuringUnit.getMeasuringUnitId()!=null){
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
	public void getMeasuringUnitInfo() throws IOException{
		measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where o.measuringUnitId='"+measuringUnitId+"'");
		JSONObject jo = JSONObject.fromObject(measuringUnit);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteMeasuringUnits() throws IOException{
		Boolean isSuccess = measuringUnitService.deleteObjectsByIds("measuringUnitId",ids);
		//删除关联关系
		productMeasuringUnitService.deleteObjectByParams(" where o.measuringUnitId in ("+ids+")");
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public MeasuringUnit getMeasuringUnit() {
		return measuringUnit;
	}
	public void setMeasuringUnit(MeasuringUnit measuringUnit) {
		this.measuringUnit = measuringUnit;
	}
	public List<MeasuringUnit> getMeasuringUnitList() {
		return measuringUnitList;
	}
	public void setMeasuringUnitList(List<MeasuringUnit> measuringUnitList) {
		this.measuringUnitList = measuringUnitList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getMeasuringUnitId() {
		return measuringUnitId;
	}
	public void setMeasuringUnitId(String measuringUnitId) {
		this.measuringUnitId = measuringUnitId;
	}
	public void setMeasuringUnitService(IMeasuringUnitService measuringUnitService) {
		this.measuringUnitService = measuringUnitService;
	}
	public void setProductMeasuringUnitService(
			IProductMeasuringUnitService productMeasuringUnitService) {
		this.productMeasuringUnitService = productMeasuringUnitService;
	}
	
}
