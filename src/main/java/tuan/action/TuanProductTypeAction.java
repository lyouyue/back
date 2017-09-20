package tuan.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import shop.product.pojo.ProductType;
import tuan.pojo.TuanProductType;
import tuan.service.ITuanProductService;
import tuan.service.ITuanProductTypeService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
/**
 * 团购套餐分类Action
 * @author
 *
 */
@SuppressWarnings("serial")
public class TuanProductTypeAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private ITuanProductTypeService tuanProductTypeService;//团购套餐分类Service
	private ITuanProductService tuanProductService;//团购套餐Service
	private String id;
	private String ids;
	private String tuanProductTypeId;
	private TuanProductType tuanProductType;
	private String tuanId;
	/**团购套餐List**/
	@SuppressWarnings("rawtypes")
	private List<Map> tuanProductList;

    //管理分类
    public String gotoTuanProductTypePage(){
    	return SUCCESS;
    }
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void getNodes() {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/xml;charset=utf-8");
		List<ProductType> list = tuanProductTypeService.queryByParentId(id);
		StringBuffer sbf = new StringBuffer();
		TuanProductType tuanProductType = null;
		sbf.append("<List>");
		for (Iterator ite = list.iterator(); ite.hasNext();) {
			tuanProductType = (TuanProductType) ite.next();
			if (tuanProductType != null) {
				sbf.append("<TuanProductType>");
				sbf.append("<name>").append(tuanProductType.getSortName()).append(
						"</name>");
				sbf.append("<id>").append(tuanProductType.getTuanProductTypeId()).append(
						"</id>");
				sbf.append("<loadType>").append(tuanProductType.getLoadType()).append(
					"</loadType>");
				sbf.append("</TuanProductType>");
			}
		}
		sbf.append("</List>");
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(sbf.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}

	}

	//新增或许修改新闻分类
	public void saveOrEditTuanProductType() throws Exception {
		if(tuanProductType!=null){
//			Integer parentId = tuanProductType.getParentId();
//			if(parentId != 0){
//				tuanProductTypeService.updateFatherLoadType(parentId.toString());
//			}
			if(Utils.objectIsEmpty(tuanProductType.getTuanProductTypeId())){
				tuanProductType.setCreateTime(new Date());
			}
			tuanProductType.setLoadType("1");
			tuanProductTypeService.saveOrUpdateObject(tuanProductType);
		}
	}

	 //得到分类对象
	 public void getTuanProductTypeObject() throws Exception {
		 	TuanProductType tuanProductType = (TuanProductType) tuanProductTypeService.getObjectByParams(" where o.tuanProductTypeId='"+tuanProductTypeId+"'");
		 	JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
			JSONObject jo = JSONObject.fromObject(tuanProductType,jsonConfig);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	 //删除分类
	@SuppressWarnings("rawtypes")
	public void delTuanProductType() throws Exception {
		Boolean isSuccess;
	    List list = tuanProductTypeService.queryByParentId(tuanProductTypeId);
	    if(list==null || list.size()==0){
	    	//删除的时候要判断此节点的父类还有没有子类，如果没有了就要把父类改成叶子节点，否则不变
	    	tuanProductType = (TuanProductType) tuanProductTypeService.getObjectByParams(" where o.tuanProductTypeId='"+tuanProductTypeId+"'");
	    	Integer parentId = tuanProductType.getParentId();
	    	isSuccess =  tuanProductTypeService.deleteObjectByParams(" where o.tuanProductTypeId='"+tuanProductTypeId+"'");
	    	Integer count = tuanProductTypeService.getCount(" where o.parentId="+parentId+"");
	    	if(count==0){
	    		TuanProductType pt = (TuanProductType) tuanProductTypeService.getObjectByParams(" where o.tuanProductTypeId='"+parentId+"'");
	    		pt.setLoadType("1");
	    		tuanProductTypeService.saveOrUpdateObject(pt);
	    	}
	    }else{
	    	isSuccess = false;
	    }
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	 //根据分类查询套餐
	 public String gotoProductInfoListByTuanProductTypeId(){
		 return SUCCESS;
	 }
	 //根据分类ID查询套餐
	@SuppressWarnings("unchecked")
	public void listProductInfoByTuanProductTypeId() throws IOException{
		String hql = "select p.productId as productId ,p.productFullName as productFullName,t.tuanImageUrl as tuanImageUrl,t.title as title,t.price as price,t.openGroupCount as openGroupCount,"
				+ "t.introduction as introduction,t.tuanPeriod as tuanPeriod,t.createTime as createTime,t.beginTime as beginTime,t.endTime as endTime,"
				+ "t.state as state,t.bought as bought from ProductInfo p,TuanProduct t where p.productId=t.productId and t.tuanProductTypeId="+tuanProductTypeId;

		String productFullName=request.getParameter("productFullName");
		String beginTime=request.getParameter("beginTime");
		String expirationTime=request.getParameter("expirationTime");
		if(productFullName!=null&&!"".equals(productFullName.trim())){
			hql +=" and p.productFullName like '%"+productFullName.trim()+"%'";
		}
		//起始时间为空
		if(Utils.objectIsNotEmpty(beginTime)){
			hql +=" and t.beginTime>='"+beginTime.trim()+" 00:00:00 000'";
		}
		//结束时间
		if(Utils.objectIsNotEmpty(expirationTime)){
			hql +=" and t.endTime<='"+expirationTime.trim()+" 23:59:59 999'";
		}
		hql+=" ORDER BY t.state ASC ";
		int totalRecordCount = tuanProductService.getCount(" where o.tuanProductTypeId="+tuanProductTypeId);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		tuanProductList = tuanProductService.findListMapPage(hql,pageHelper);
		SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		for(Map<String,Object> m:tuanProductList){//格式化创建时间
			if(m.get("createTime")!=null){
				Date date = (Date) m.get("createTime");
				String format = fm.format(date);
				m.put("createTime", format);
			}
			if(m.get("beginTime")!=null){
				Date date = (Date) m.get("beginTime");
				String format = fm.format(date);
				m.put("beginTime", format);
			}
			if(m.get("endTime")!=null){
				Date date = (Date) m.get("endTime");
				String format = fm.format(date);
				m.put("endTime", format);
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", tuanProductList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	 }
	//团购分类列表
	public void findTuanList() throws Exception{
		String where=" where 1=1";
		int totalRecordCount = tuanProductTypeService.getCount(where);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List list=tuanProductTypeService.findListByPageHelper(null, pageHelper, where);
		Map<String,Object> jsonMap = new HashMap<String, Object>();//定义map
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", list);//rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	 //删除套餐和分类关系
	 public void deleteTuanTypeProduct() throws IOException{

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
	public String getTuanProductTypeId() {
		return tuanProductTypeId;
	}
	public void setTuanProductTypeId(String tuanProductTypeId) {
		this.tuanProductTypeId = tuanProductTypeId;
	}
	public TuanProductType getTuanProductType() {
		return tuanProductType;
	}
	public void setTuanProductType(TuanProductType tuanProductType) {
		this.tuanProductType = tuanProductType;
	}
	public String getTuanId() {
		return tuanId;
	}
	public void setTuanId(String tuanId) {
		this.tuanId = tuanId;
	}
	public void setTuanProductTypeService(
			ITuanProductTypeService tuanProductTypeService) {
		this.tuanProductTypeService = tuanProductTypeService;
	}
	public void setTuanProductService(ITuanProductService tuanProductService) {
		this.tuanProductService = tuanProductService;
	}
	@SuppressWarnings("rawtypes")
	public List<Map> getTuanProductList() {
		return tuanProductList;
	}
	@SuppressWarnings("rawtypes")
	public void setTuanProductList(List<Map> tuanProductList) {
		this.tuanProductList = tuanProductList;
	}
}
