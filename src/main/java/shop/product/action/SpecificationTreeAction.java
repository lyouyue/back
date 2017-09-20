package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import shop.product.pojo.ProductType;
import shop.product.service.IProductTypeService;
import shop.product.service.ISpecificationService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * SpecificationAction - 套餐规格Action类
 */
@SuppressWarnings({ "serial" })
public class SpecificationTreeAction extends BaseAction{
	private ISpecificationService specificationService;//套餐规格Service
	private IProductTypeService productTypeService;//套餐分类service
	private String productTypeId;//套餐分类Id
	private String prodTypeNames;
	/**
	 * 到套餐规格树页面
	 * @return
	 */
	public String gotoSpecificationTree(){
		return SUCCESS;
	}
	/**
	 * 到套餐规格树页面
	 * @return
	 */
	public String gotoSpecificationTreePage(){
		if(Utils.stringIsNotEmpty(productTypeId)){
			request.setAttribute("productTypeId", productTypeId);
		}
		ProductType productType = (ProductType)productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		if(Utils.objectIsNotEmpty(productType)){
			request.setAttribute("name", productType.getSortName());
		}
		return SUCCESS;
	}
	
	//查询分类下所有的套餐规格
	public void listSpecification() throws IOException{
		String totalHql ="select count(a.specificationId) from Specification a ,ProductType b where a.productTypeId=b.productTypeId and b.productTypeId="+productTypeId;
		String sql ="select a.specificationId as specificationId,a.name as name,a.productTypeId as productTypeId,a.sort as sort," +
				" a.notes as notes,a.type as type,b.productTypeId as productTypeId from  Specification  a ,ProductType b " +
				" where a.productTypeId=b.productTypeId and b.productTypeId="+productTypeId;
		String name = (String) request.getParameter("specificationName");
		if(StringUtils.isNotEmpty(name)){
			name = name.trim();
			totalHql+=" and a.name like '%"+name+"%'";
			sql+=" and a.name like '%"+name+"%'";
		}
		sql+=" order by a.sort,a.specificationId desc";
		int totalRecordCount = specificationService.getMoreTableCount(totalHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> list=specificationService.findListMapPage(sql,pageHelper);
		List<Map> newLsit = new ArrayList<Map>();
		for(Map<String, Object> map:list){
			prodTypeNames="";
			getProductTypeName(Integer.parseInt(map.get("productTypeId").toString()));
			if(StringUtils.isNotEmpty(prodTypeNames)){
				map.put("productTypeName", prodTypeNames);
				newLsit.add(map);
			}
		}
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", newLsit);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter pw = response.getWriter();
		pw.write(jo.toString());
		pw.flush();
		pw.close();
	}
	/***
	 * 根据分类的ID查找分类的名称
	 * @param productTypeId
	 * @return 所有级的名称的组拼
	 */
	public void getProductTypeName(Integer productTypeId){
			//获取当前的对象
			ProductType pt =  (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+productTypeId);
			if(pt!=null){
				//加上超链接
				if(StringUtils.isNotEmpty(prodTypeNames)){
					prodTypeNames = pt.getSortName() +"&nbsp;&gt;&nbsp;"+prodTypeNames;
				}else{
					prodTypeNames = pt.getSortName();
				}
			}
			//递归
			if(pt!=null && pt.getParentId()!=1){
				getProductTypeName(pt.getParentId());
			}
	}
	public void setSpecificationService(ISpecificationService specificationService) {
		this.specificationService = specificationService;
	}
	public String getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public String getProdTypeNames() {
		return prodTypeNames;
	}
	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}
	
}
