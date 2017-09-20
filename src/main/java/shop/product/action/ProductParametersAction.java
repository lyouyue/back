package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.compass.core.json.JsonArray;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import shop.product.pojo.ParamGroup;
import shop.product.pojo.ParamGroupInfo;
import shop.product.pojo.ProductParameters;
import shop.product.pojo.ProductType;
import shop.product.service.IProductParametersService;
import shop.product.service.IProductTypeService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * ProductParametersAction - 套餐详细参数Action类
 * @author 孟琦瑞
 */
@SuppressWarnings({ "serial", "unused" })
public class ProductParametersAction extends BaseAction {
	Logger logger = Logger.getLogger(ProductParametersAction.class);
	private IProductParametersService productParametersService;//套餐详细参数service
	private IProductTypeService productTypeService;//套餐分类service
	private ProductType productType=new ProductType();//套餐分类对象
	private List<ProductType> productTypeList=new ArrayList<ProductType>();//套餐分类集合
	private List<ProductParameters> productParametersList=new ArrayList<ProductParameters>();//套餐详细参数集合
	private ProductParameters productParameters = new ProductParameters();//套餐详细参数对象
	private String productParametersId;//套餐信息参数ID
	private String productTypeId;//套餐信息参数ID
	private String ids;
	private String paramGroupId;//参数组Id
	/**详细参数内容集合**/
	private List<ParamGroup> listParamGroup;
	/**详细内容明细集合**/
	private List<ParamGroupInfo> listParamGroupInfo;
	/**套餐扩展属性action**/
	private ProductAttributeAction productAttributeAction;
	/**套餐分类的集合**/
	private List<ProductType> prodTypeList = new ArrayList<ProductType>();
	/**所属分类名称**/
	private String prodTypeNames;
	/******************************end
	 * @throws UnsupportedEncodingException ***********************************************/
	public String gotoProductParametersPage() throws UnsupportedEncodingException{
		if(Utils.stringIsNotEmpty(productTypeId)){
			request.setAttribute("productTypeId", productTypeId);
		}
		productType = (ProductType)productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		if(Utils.objectIsNotEmpty(productType)){
			request.setAttribute("name", productType.getSortName());
		}
		return SUCCESS;
	}
	public String gotoProductParametersNewPage() throws UnsupportedEncodingException{
		if(Utils.stringIsNotEmpty(productTypeId)){
			request.setAttribute("productTypeId", productTypeId);
		}
		productType = (ProductType)productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		if(Utils.objectIsNotEmpty(productType)){
			request.setAttribute("name", productType.getSortName());
		}
		return SUCCESS;
	}
	public String gotoProductParameters(){
		return SUCCESS;
	}
	//查询所有信息列表
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void listProductParameters() throws IOException{
		String totalHql="select count(a.productTypeId) from ProductParameters a ,ProductType b where a.productTypeId=b.productTypeId";
		String hql="select a.productParametersId as productParametersId,a.info as info ,a.name as name,a.sort as sort," +
				" b.sortName as sortName,b.productTypeId as productTypeId from ProductParameters a ,ProductType b where a.productTypeId=b.productTypeId";
		String paramName = (String) request.getParameter("paramName");
		//String prodType = (String) request.getParameter("prodType");
		if(StringUtils.isNotEmpty(paramName)){
			paramName = paramName.trim();
			totalHql+=" and a.name like '%"+paramName+"%'";
			hql+=" and a.name like '%"+paramName+"%'";
		}
		if(StringUtils.isNotEmpty(productTypeId)){
			totalHql+=" and a.productTypeId ="+productTypeId;
			hql+=" and a.productTypeId ="+productTypeId;
		}
//		if(null!=prodType && !"-1".equals(prodType)){
//			totalHql+=" and a.productTypeId = "+prodType;
//			hql+=" and a.productTypeId = "+prodType;
//		}
		hql+=" order by a.productParametersId desc limit 0,1 ";
		List<Map> list=productParametersService.findListMapByHql(hql);
		List<ParamGroup> newLsit = new ArrayList<ParamGroup>();
		prodTypeNames="";
		if(Utils.collectionIsNotEmpty(list)){
			Integer productTypeId = Integer.parseInt(String.valueOf(list.get(0).get("productTypeId")));
			Integer productParametersId = Integer.parseInt(String.valueOf(list.get(0).get("productParametersId")));
			getProductTypeName(productTypeId);
			List<ParamGroup> paramGroupList= JSONArray.toList(JSONArray.fromObject(list.get(0).get("info").toString()),ParamGroup.class);
			if(StringUtils.isNotEmpty(prodTypeNames)&&Utils.collectionIsNotEmpty(paramGroupList)){
				for(ParamGroup paramGroup:paramGroupList){
					if(Utils.objectIsNotEmpty(paramGroup)){
						paramGroup.setProdTypeNames(prodTypeNames);
						paramGroup.setProductParametersId(productParametersId);
						newLsit.add(paramGroup);
					}
				}
			}
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		List<ParamGroup> resultLsit = new ArrayList<ParamGroup>();
		if(Utils.collectionIsNotEmpty(newLsit)){
			for(int i=(pageSize*(currentPage-1));i<((pageSize*currentPage)>newLsit.size()?newLsit.size():(pageSize*currentPage));i++){
				resultLsit.add(newLsit.get(i));
			}
		}
		pageHelper.setPageInfo(pageSize, newLsit.size(), currentPage);
		jsonMap.put("total", newLsit.size());
		jsonMap.put("rows", resultLsit);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateProductParameters() throws IOException{
		if(Utils.collectionIsNotEmpty(listParamGroup)&&Utils.collectionIsNotEmpty(listParamGroupInfo)){
			ParamGroup temp = null ;
			//用冒泡法按照order字段值从小到大给集合排序
			for (int i = 0 ; i < listParamGroup.size() - 1 ; i++){
				for (int j = i + 1 ; j < listParamGroup.size() ; j++){
					if (listParamGroup.get(j).getOrder() < listParamGroup.get(i).getOrder()){
						temp = listParamGroup.get(i);
						listParamGroup.remove(i);
						listParamGroup.add(i, listParamGroup.get(j-1)); 
						listParamGroup.remove(j);
						listParamGroup.add(j, temp);
						temp = null;
					}
				}
			}
			//将参数信息，归属到参数组中
			for(ParamGroup pg:listParamGroup ){
				if(Utils.objectIsNotEmpty(pg)){
					List<ParamGroupInfo> listPGI=new ArrayList<ParamGroupInfo>();
					for(ParamGroupInfo pgi:listParamGroupInfo){
						if(pg.getParamGroupId().equals(pgi.getPgiId())){
							listPGI.add(pgi);
						}
					}
					pg.setParamGroupInfo(listPGI);
				}
			}
		}
		//格式化参数组信息
		JSONArray jbListPG = JSONArray.fromObject(listParamGroup);
		if(Utils.objectIsNotEmpty(productParameters)&&Utils.objectIsNotEmpty(productParameters.getProductTypeId())){
			productParameters.setInfo(jbListPG.toString());
			productParameters = (ProductParameters) productParametersService.saveOrUpdateObject(productParameters);
			if(productParameters.getProductParametersId()!=null){
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", true);
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}

	}
	//获取一条记录
	public void getPorductParametersInfo() throws IOException{
		productParameters = (ProductParameters)productParametersService.getObjectByParams(" where o.productParametersId='"+productParametersId+"'");
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		getProductTypeName(productParameters.getProductTypeId());
		jsonMap.put("productParameters", productParameters);
		jsonMap.put("prodTypeNames",prodTypeNames);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取productTypeList
	public void getPorductTypeList() {
		productTypeList = (List<ProductType>)productTypeService.findObjects(" where o.parentId=1");
		try {
			JSONArray jo = JSONArray.fromObject(productTypeList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out;
			out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	//获取productTypeName
	public void getPorductTypeName() throws IOException{
		productType = (ProductType)productTypeService.getObjectByParams(" where o.productTypeId='"+productTypeId+"'");
		JSONObject jo = JSONObject.fromObject(productType);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteProductParameters() throws IOException{
		boolean isSuccess = false;
		if(Utils.stringIsNotEmpty(paramGroupId)&&Utils.stringIsNotEmpty(ids)){
			Integer de_paramGroupId = Integer.valueOf(paramGroupId);
			productParameters = (ProductParameters)productParametersService.getObjectByParams(" where o.productParametersId='"+ids+"'");
			if(Utils.objectIsNotEmpty(productParameters)&&Utils.objectIsNotEmpty(productParameters.getInfo())){
				List<ParamGroup> paramGroupList= JSONArray.toList(JSONArray.fromObject(productParameters.getInfo()),ParamGroup.class);
				if(Utils.collectionIsNotEmpty(paramGroupList)){
					for(ParamGroup paramGroup:paramGroupList){
						if(Utils.objectIsNotEmpty(paramGroup)&&Utils.objectIsNotEmpty(paramGroup.getParamGroupId())&&paramGroup.getParamGroupId().compareTo(de_paramGroupId)==0){
							paramGroupList.remove(paramGroup);
							break;
						}
					}
				}
				if(Utils.collectionIsNotEmpty(paramGroupList)){
					//参数组不为空时，修改参数组信息
					//List转JSONArray
					JSONArray jbListPG = JSONArray.fromObject(paramGroupList);
					String info = jbListPG.toString();
					productParameters.setInfo(info);
					productParameters = (ProductParameters) productParametersService.saveOrUpdateObject(productParameters);
					isSuccess = true;
				}else{
					//参数组为空时，直接删除记录
					isSuccess = productParametersService.deleteObjectById(ids);
				}
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**查看数据库中是否已经配置此分类的参数***/
	public void getPorductParameters() throws IOException{
		productParameters = (ProductParameters)productParametersService.getObjectByParams("where o.productTypeId="+productTypeId);
		JSONObject jo = JSONObject.fromObject(productParameters);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 获取当前分类名称（无级限）
	 */
	public  void getProductTypeName(Integer prodTypeId){
		//获取当前的对象
		ProductType pt =  (ProductType) productTypeService.getObjectByParams(" where o.productTypeId="+prodTypeId);
		if(pt!=null){
			//加上超链接
			String aLabel =pt.getSortName();
			if(StringUtils.isNotEmpty(prodTypeNames)){
				prodTypeNames = aLabel +"&nbsp;&gt;&nbsp;"+prodTypeNames;
			}else{
				prodTypeNames = aLabel;
			}
		}
		//递归
		if(pt!=null && pt.getParentId()!=1){
			getProductTypeName(pt.getParentId());
		}
	}
	/**
	 * setter getter
	 * @return
	 */
	public IProductParametersService getProductParametersService() {
		return productParametersService;
	}
	public String getProdTypeNames() {
		return prodTypeNames;
	}
	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}
	public void setProductParametersService(
			IProductParametersService productParametersService) {
		this.productParametersService = productParametersService;
	}
	public List<ProductParameters> getProductParametersList() {
		return productParametersList;
	}
	public void setProductParametersList(
			List<ProductParameters> productParametersList) {
		this.productParametersList = productParametersList;
	}
	public ProductParameters getProductParameters() {
		return productParameters;
	}
	public void setProductParameters(ProductParameters productParameters) {
		this.productParameters = productParameters;
	}
	public void setProductAttributeAction(
			ProductAttributeAction productAttributeAction) {
		this.productAttributeAction = productAttributeAction;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getProductParametersId() {
		return productParametersId;
	}
	public void setProductParametersId(String productParametersId) {
		this.productParametersId = productParametersId;
	}
	public IProductTypeService getProductTypeService() {
		return productTypeService;
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
	public List<ProductType> getProductTypeList() {
		return productTypeList;
	}
	public void setProductTypeList(List<ProductType> productTypeList) {
		this.productTypeList = productTypeList;
	}
	public List<ParamGroup> getListParamGroup() {
		return listParamGroup;
	}
	public void setListParamGroup(List<ParamGroup> listParamGroup) {
		this.listParamGroup = listParamGroup;
	}
	public List<ParamGroupInfo> getListParamGroupInfo() {
		return listParamGroupInfo;
	}
	public void setListParamGroupInfo(List<ParamGroupInfo> listParamGroupInfo) {
		this.listParamGroupInfo = listParamGroupInfo;
	}
	public List<ProductType> getProdTypeList() {
		return prodTypeList;
	}
	public void setProdTypeList(List<ProductType> prodTypeList) {
		this.prodTypeList = prodTypeList;
	}
	public String getParamGroupId() {
		return paramGroupId;
	}
	public void setParamGroupId(String paramGroupId) {
		this.paramGroupId = paramGroupId;
	}
	
}
