package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import shop.measuringUnit.pojo.MeasuringUnit;
import shop.product.pojo.AttributeValue;
import shop.product.service.IAttributeValueService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * ProductAttributeAction - 套餐的扩展属性值信息
 */
@SuppressWarnings("unused")
public class AttributeValueAction extends BaseAction {
	private static final long serialVersionUID = -1012772988003566216L;
	private IAttributeValueService attributeValueService;
	private List<AttributeValue> attributeValueList;
	private AttributeValue attributeValue;
	private String productAttrId;
	private String productTypeId;
	private String ids;
	
	//验证套餐的扩展属性值是否重复
	public void checkAttrValueName() throws IOException{
		String name = request.getParameter("name");
		if(name!=null && !"".equals(name)){
			Integer count = attributeValueService.getCount(" where o.attrValueName='"+name+"' and o.productAttrId="+productAttrId);
			if(count.intValue()==0){
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.print("ok");
				out.flush();
				out.close();
			}
		}
	}
	/**
	 * 跳转至扩展属性值信息的页面
	 */
	public String gotoAttributeValuePage(){
		request.setAttribute("productTypeId", productTypeId);
		request.setAttribute("productAttrId", productAttrId);
		return SUCCESS;
	}
	
	/**
	 * 查询所有扩展属性值信息
	 */
	public void listAttributeValue() throws IOException{
		String productAttrId=(String) request.getAttribute("productAttrId");
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append(" where o.productAttrId="+productAttrId);
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String name = request.getParameter("name");
			if(StringUtils.isNotEmpty(name)){
				name = name.trim();
				hqlsb.append(" and o.attrValueName like '%"+name+"%'");
			}
		}
		hqlsb.append(" order by o.attrValueId desc");
		int totalRecordCount = attributeValueService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		attributeValueList = attributeValueService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", attributeValueList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateAttributeValue() throws IOException{
		if(attributeValue!=null){
			attributeValue = (AttributeValue) attributeValueService.saveOrUpdateObject(attributeValue);
			if(attributeValue.getAttrValueId()!=null){
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
	public void getAttributeValueInfo() throws IOException{
		attributeValue = (AttributeValue) attributeValueService.getObjectById(ids);
		JSONObject jo = JSONObject.fromObject(attributeValue);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteAttributeValues() throws IOException{
		Boolean isSuccess = attributeValueService.deleteObjectsByIds("attrValueId",ids);
		if(isSuccess&&Utils.objectIsNotEmpty(productAttrId)){
			Integer totalRecordCount = attributeValueService.getCount(" where o.productAttrId="+productAttrId);
			if(totalRecordCount.compareTo(0)==0){//没有属性值了
				attributeValueService.updateBySQL("UPDATE shop_product_attribute SET isListShow = 0 WHERE productAttrId="+productAttrId);
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<AttributeValue> getAttributeValueList() {
		return attributeValueList;
	}
	public void setAttributeValueList(List<AttributeValue> attributeValueList) {
		this.attributeValueList = attributeValueList;
	}
	public AttributeValue getAttributeValue() {
		return attributeValue;
	}
	public void setAttributeValue(AttributeValue attributeValue) {
		this.attributeValue = attributeValue;
	}
	public String getProductAttrId() {
		return productAttrId;
	}
	public void setProductAttrId(String productAttrId) {
		this.productAttrId = productAttrId;
	}
	
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setAttributeValueService(
			IAttributeValueService attributeValueService) {
		this.attributeValueService = attributeValueService;
	}
	public String getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}
}
