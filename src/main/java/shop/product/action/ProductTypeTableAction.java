package shop.product.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import basic.pojo.KeyBook;

import com.opensymphony.xwork2.ActionContext;

import shop.homeIndex.pojo.HomeKeyBook;
import shop.product.pojo.ProductType;
import shop.product.service.IProductTypeService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * 套餐分类表格维护
 * @author 
 * 2015/06/04
 */
@SuppressWarnings("serial")
public class ProductTypeTableAction extends BaseAction{
	/**套餐分类Service**/
	private IProductTypeService productTypeService;
	/**套餐分类实体类**/
	private ProductType productType;
	/**分类名称**/
	private String prodTypeNames;
	/**套餐分类ID**/
	private String productTypeId;
	/**分类级别**/
	private String level;
	/**分类总级别**/
	private Integer type_level;
	
	/**
	 * 跳转到套餐分类列表页
	 */
	@SuppressWarnings("unchecked")
	public String gotoProductTypeTablePage(){
		Map<String,List<KeyBook>> map = (Map<String, List<KeyBook>>) servletContext.getAttribute("keybook");
		type_level = Integer.parseInt(map.get("type_level").get(0).getValue());
		if(Utils.objectIsEmpty(productTypeId)){
			productTypeId=String.valueOf(1);
			level=String.valueOf(1);
		}else{
			productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+productTypeId);
			level=String.valueOf(productType.getLevel());
			//套餐分类导航
			getProductTypeName(productTypeId,productType.getParentId());
		}
		return SUCCESS;
	}
	
	/**
	 * 获取当前分类名称（无级限）
	 */
	public void getProductTypeName(String prodTypeId,Integer fatherTypeId){
		ProductType pt =  (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+prodTypeId);
		String label = pt.getSortName();
		if(StringUtils.isNotEmpty(prodTypeNames)){
			if(pt!=null && pt.getParentId()==0){
				prodTypeNames = label +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}else{
				prodTypeNames = label +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}
		}else{
			if(pt!=null && pt.getParentId()==0){
				prodTypeNames = label;
			}else{
				prodTypeNames = label;
			}
		}
		//递归
		if(pt!=null && pt.getParentId()!=0){
			getProductTypeName(String.valueOf(pt.getParentId()),fatherTypeId);
		}
	}
	
	/**
	 * 查询套餐分类列表
	 */
	public void listProductType() throws IOException{
		String hql = " where o.parentId= "+productTypeId;
		String name = (String) request.getParameter("productTypeName");
		if(StringUtils.isNotEmpty(name)){
			hql+=" and o.sortName like '%"+name.trim()+"%'";
		}
		int totalRecordCount = productTypeService.getCount(hql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<ProductType> productTypeList = productTypeService.findListByPageHelper(null,pageHelper,hql+" order by o.sortCode asc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		for(ProductType productType:productTypeList){
			prodTypeNames="";
			if(Utils.objectIsNotEmpty(productType)){
				getProductTypeName(productType.getParentId());
				if(StringUtils.isNotEmpty(prodTypeNames)){
					productType.setProdTypeNames(prodTypeNames);
				}
			}
		}
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", productTypeList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
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
			if(pt!=null){
				getProductTypeName(pt.getParentId());
			}
	}
	//新增或许修改套餐分类 
	public void saveOrEditProductType() throws Exception {
		if(productType.getProductTypeId()==null){//添加
			productType.setLoadType("1");
			//父对象
			ProductType pt = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+productType.getParentId());
			//计算级别
			Integer level=0;
			if(pt!=null){
				level = pt.getLevel();
				pt.setLoadType("0");
				productTypeService.saveOrUpdateObject(pt);//更改父对象的节点信息
			}
			productType.setLevel(level+1);
		}
		Object o = productTypeService.saveOrUpdateObject(productType);
		JSONObject jo = new JSONObject();
		if(o!=null){
			jo.accumulate("strFlag", true);
		}else{
			jo.accumulate("strFlag", false);
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		
	}
		
	//得到分类对象
	public void getProductTypeObject() throws Exception {
	    ProductType productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		JSONObject jo = JSONObject.fromObject(productType);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	 
	 //删除分类
	@SuppressWarnings("rawtypes")
	public void delProductType() throws Exception {
		Boolean isSuccess;
	    List list = productTypeService.queryByParentId(productTypeId);
	    if(list==null || list.size()==0){
	    	//删除的时候要判断此节点的父类还有没有子类，如果没有了就要把父类改成叶子节点，否则不变
	    	productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
	    	Integer parentId = productType.getParentId();
	    	isSuccess =  productTypeService.deleteObjectByParams(" where o.productTypeId='"+productTypeId+"'");
	    	Integer count = productTypeService.getCount(" where o.parentId="+parentId+"");
	    	if(count==0){
	    		ProductType pt = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId='"+parentId+"'");
	    		pt.setLoadType("1");
	    		productTypeService.saveOrUpdateObject(pt);
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

	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}

	public ProductType getProductType() {
		return productType;
	}

	public void setProductType(ProductType productType) {
		this.productType = productType;
	}

	public String getProductTypeId() {
		return productTypeId;
	}

	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}

	public String getProdTypeNames() {
		return prodTypeNames;
	}

	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public Integer getType_level() {
		return type_level;
	}

	public void setType_level(Integer type_level) {
		this.type_level = type_level;
	}
}
