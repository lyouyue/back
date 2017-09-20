package shop.measuringUnit.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;

import org.apache.log4j.Logger;
import shop.measuringUnit.pojo.MeasuringUnit;
import shop.measuringUnit.pojo.ProductMeasuringUnit;
import shop.measuringUnit.service.IMeasuringUnitService;
import shop.measuringUnit.service.IProductMeasuringUnitService;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import util.action.BaseAction;
/**
 * 套餐计量单位Action
 * @author wangya
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class ProductMeasuringUnitAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private IProductMeasuringUnitService productMeasuringUnitService;
	private IMeasuringUnitService measuringUnitService;
	private List<ProductMeasuringUnit> productMeasuringUnitList;
	private ProductMeasuringUnit productMeasuringUnit;//套餐计量单位
	private String productMeasuringUnitId;
	private String productTypeId;//分类ID
	/**计量单位Id集合**/
	private Integer[] measuringUnitIds;
	//根据分类查询计量单位
	public String gotoProductMeasuringUnitListByProductTypeId(){
		request.setAttribute("productTypeId",productTypeId);
		return SUCCESS;
	}
	//根据分类ID查询套餐计量单位
	 public void listProductMeasuringUnitByProductTypeId() throws IOException{
		int totalRecordCount = measuringUnitService.getCount(",ProductMeasuringUnit p where p.productTypeId='"+productTypeId+"' and o.measuringUnitId=p.measuringUnitId order by p.productTypeId");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<MeasuringUnit> measuringUnitList = measuringUnitService.findListByPageHelper(null,pageHelper,",ProductMeasuringUnit p where p.productTypeId='"+productTypeId+"' and o.measuringUnitId=p.measuringUnitId order by p.productTypeId");
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
	 
	//删除套餐和计量单位关系
	 public void deleteProductMeasuringUnit() throws IOException{
		String measuringUnitId = request.getParameter("measuringUnitId");
		Boolean isSuccess = productMeasuringUnitService.deleteObjectByParams(" where o.measuringUnitId='"+measuringUnitId+"'and o.productTypeId='"+productTypeId+"'");
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	 }
		 
	 /**
	  * 查找所有计量单位，除当前分类下已选择的
	  */
	public void findTypeMeasuringUnit(){
		 try {
			 String hql = "select a.measuringUnitId as measuringUnitId,a.name from shop_measuring_unit a  where a.measuringUnitId not in (select x.measuringUnitId as oldMeasuringUnitId from shop_product_measuring_unit x where x.productTypeId="+productTypeId+") and a.useState=1";
			 List<Map<String, Object>> list = measuringUnitService.findListMapBySql(hql);
			 JSONArray ja = JSONArray.fromObject(list);
			 response.setContentType("text/html;charset=utf-8");
			 PrintWriter out;
			 out = response.getWriter();
			 out.println(ja.toString());
			 out.flush();
			 out.close();
		 } catch (IOException e) {
			 String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		 }
	 }
	
	 /**
	 * 批量保存计量单位和分类关系
	 */
	public void saveMoreProductMeasuringUnit(){
		try {
			boolean flag = true;
			if(measuringUnitIds.length>0){
				flag = productMeasuringUnitService.saveMoreProductMeasuringUnit(measuringUnitIds, Integer.parseInt(productTypeId));
			}
			JSONObject ja = JSONObject.fromObject(flag);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out;
			out = response.getWriter();
			out.println(ja.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	
	public List<ProductMeasuringUnit> getProductMeasuringUnitList() {
		return productMeasuringUnitList;
	}
	public void setProductMeasuringUnitList(
			List<ProductMeasuringUnit> productMeasuringUnitList) {
		this.productMeasuringUnitList = productMeasuringUnitList;
	}
	public ProductMeasuringUnit getProductMeasuringUnit() {
		return productMeasuringUnit;
	}
	public void setProductMeasuringUnit(ProductMeasuringUnit productMeasuringUnit) {
		this.productMeasuringUnit = productMeasuringUnit;
	}
	public String getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}
	public void setProductMeasuringUnitService(
			IProductMeasuringUnitService productMeasuringUnitService) {
		this.productMeasuringUnitService = productMeasuringUnitService;
	}
	public void setMeasuringUnitService(IMeasuringUnitService measuringUnitService) {
		this.measuringUnitService = measuringUnitService;
	}
	public String getProductMeasuringUnitId() {
		return productMeasuringUnitId;
	}
	public void setProductMeasuringUnitId(String productMeasuringUnitId) {
		this.productMeasuringUnitId = productMeasuringUnitId;
	}
	public Integer[] getMeasuringUnitIds() {
		return measuringUnitIds;
	}
	public void setMeasuringUnitIds(Integer[] measuringUnitIds) {
		this.measuringUnitIds = measuringUnitIds;
	}
	 
}
