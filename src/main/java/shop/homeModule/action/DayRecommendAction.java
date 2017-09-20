package shop.homeModule.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.emay.slf4j.Logger;
import net.sf.json.JSONObject;
import shop.homeModule.pojo.DayRecommend;
import shop.homeModule.service.IDayRecommendService;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductSpecificationValue;
import shop.product.pojo.ProductType;
import shop.product.pojo.Specification;
import shop.product.pojo.SpecificationValue;
import shop.product.service.IProductInfoService;
import shop.product.service.IProductSpecificationValueService;
import shop.product.service.IProductTypeService;
import shop.product.service.ISpecificationService;
import shop.product.service.ISpecificationValueService;
import util.action.BaseAction;
import util.other.Utils;
/**
 * DayRecommendAction -- 每日推荐Action
 * @author 张攀攀
 * 2014-01-07
 *
 */
@SuppressWarnings("serial")
public class DayRecommendAction extends BaseAction {
	/**每日推荐Service**/
	private IDayRecommendService dayRecommendService;
	/**套餐Service**/
	private IProductInfoService productInfoService;
	/**每日推荐集合**/
	private List<DayRecommend> dayRecommendList = new ArrayList<DayRecommend>();
	private List<ProductInfo> productInfoList = new ArrayList<ProductInfo>();//套餐信息List
	/**每日推荐实体类**/
	private DayRecommend dayRecommend;
	private String id;
	private String ids;
	private String typeId;
	private List<String> sorts;//存放排序号数组
	private Integer [] productIds;//存放套餐ID的数组
	private String productData;
	private IProductTypeService productTypeService;
	private ISpecificationValueService specificationValueService;
	private List<SpecificationValue> SpecificationValueList = new ArrayList<SpecificationValue>();//套餐分类List
	private IProductSpecificationValueService productSpecificationValueService; //套餐规格中间表
	private List<ProductSpecificationValue> productSpecificationValueList = new ArrayList<ProductSpecificationValue>();
	/**
	 * 跳转到每日推荐列表页面
	 * @return
	 */
	public String gotoDayRecommendPage(){
		return SUCCESS;
	}
	//查询所有信息列表
	public void listDayRecommend() throws IOException{
		//productCode,productId,productName,sort,isShow,id
		String selectFlag=request.getParameter("selectFlag");
		String productCode=request.getParameter("productCode");
		String productName=request.getParameter("productName");
		String select_count = "select count(dr.id) from DayRecommend dr,ProductInfo pi";
		String select_list = "select dr.id as id,dr.sort as sort,dr.isShow as isShow,dr.productId as productId,pi.productCode as productCode,pi.productName as productName,pi.salesPrice as salesPrice,pi.logoImg AS logoImages,pi.createDate AS createDate, pi.updateDate AS updateDate,pi.shopName as shopName from DayRecommend dr,ProductInfo pi";
		String condition = " where dr.productId=pi.productId ";
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(productCode)){
				condition+=" and pi.productCode ="+productCode;
			}
			if(Utils.objectIsNotEmpty(productName)){
				condition+=" and pi.productName like '%"+productName.trim()+"%'";
			}
		}
		condition+=" order by dr.sort, pi.productId desc ";
		int totalRecordCount = dayRecommendService.getCountByHQL(select_count+condition);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> dayRecommendList = dayRecommendService.findListMapPage(select_list+condition, pageHelper);
		//dayRecommendList = dayRecommendService.findListByPageHelper(null,pageHelper,hql);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", dayRecommendList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateDayRecommend() throws Exception {
		if(Utils.stringIsNotEmpty(productData)){
			Boolean isSuccess = dayRecommendService.saveOrUpdateDayRecommend(dayRecommend,productData);
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", isSuccess + "");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}else{
			dayRecommend = (DayRecommend) dayRecommendService.saveOrUpdateObject(dayRecommend);
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", true);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//获取一条记录
	public void getDayRecommendInfo() throws IOException{
		String select_Object = "select dr.id as id,dr.sort as sort,dr.isShow as isShow,dr.productId as productId,pi.productCode as productCode,pi.productName as productName,pi.logoImg as logoImg from DayRecommend dr,ProductInfo pi"+
		      " where dr.id="+id+" and dr.productId=pi.productId";
		List<Map> mapList = dayRecommendService.findListMapByHql(select_Object);
		if(Utils.collectionIsNotEmpty(mapList)){
			Map<String, Object> map = mapList.get(0);
			JSONObject jo = JSONObject.fromObject(map);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//删除记录
	public void deleteDayRecommend() throws IOException{
		Boolean isSuccess = dayRecommendService.deleteObjectsByIds("id",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据套餐分类查询对应的套餐
	public void listProductByType() throws Exception {
		String hql_count = "select distinct(o.productId) from ProductInfo o where o.productId  not in  (select DISTINCT( d.productId) from DayRecommend d ) and o.isPass=1 and o.isPutSale=2 AND o.isShow=1";
		String hql_list = "select distinct(o.productId) as productId,o.productCode as productCode,o.productFullName as productFullName,o.marketPrice as marketPrice,o.salesPrice as salesPrice,o.logoImg AS logoImg,o.isShow as isShow from ProductInfo o where o.productId  not in "+
				" (select DISTINCT( d.productId) from DayRecommend d ) and o.isPass=1 and o.isPutSale=2 AND o.isShow=1";
		
		if(Utils.stringIsNotEmpty(typeId)){
			System.out.println("分类ID："+typeId);
			String ProductIds = getTypeIdListByTypeId(typeId);
			hql_count += " and o.productId in ("+ProductIds+")";
			hql_list += " and o.productId in ("+ProductIds+")";
		}else{
			typeId="2179";
			hql_count += " and o.productTypeId =2179";
			hql_list += " and o.productTypeId =2179";
		}
		
		String productNo = request.getParameter("productNo");
		if(Utils.stringIsNotEmpty(productNo)){
			hql_count += " and o.productCode like '%"+productNo+"%'";
			hql_list += " and o.productCode like '%"+productNo+"%'";
		}
		String productName = request.getParameter("productName");
		if(Utils.stringIsNotEmpty(productName)){
			hql_count += " and o.productName like '%"+productName+"%'";
			hql_list += " and o.productName like '%"+productName+"%'";
		}
		int totalRecordCount = 0;
		List productInfoIds = productInfoService.findObjectsByHQL(hql_count);
		if(Utils.collectionIsNotEmpty(productInfoIds)){
			totalRecordCount = productInfoIds.size();
		}
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		Map<String,Object> jsonMap = new HashMap<String,Object>();// 定义map
		List<Map> productInfoList=new ArrayList<Map>();
		if(typeId!=null&&!"".equals(typeId)){
			productInfoList= productInfoService.findListMapPage(hql_list, pageHelper);
		}else{
			totalRecordCount=0;
		}
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", productInfoList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("textml;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	@SuppressWarnings("unchecked")
	private String getTypeIdListByTypeId(String typeIdParams) {
		//根据套餐规格查询出套餐ID
		String ProductIds = "";
		productSpecificationValueList = productSpecificationValueService.findObjects(null," where o.specificationValueId="+typeIdParams);
		if(Utils.collectionIsNotEmpty(productSpecificationValueList)){
			for(ProductSpecificationValue pt : productSpecificationValueList){
				ProductIds += ","+pt.getProductId();
			}
		}
		return ProductIds.substring(1);
	}
	public IProductSpecificationValueService getProductSpecificationValueService() {
		return productSpecificationValueService;
	}
	public void setProductSpecificationValueService(IProductSpecificationValueService productSpecificationValueService) {
		this.productSpecificationValueService = productSpecificationValueService;
	}
	public List<DayRecommend> getDayRecommendList() {
		return dayRecommendList;
	}
	public void setDayRecommendList(List<DayRecommend> dayRecommendList) {
		this.dayRecommendList = dayRecommendList;
	}
	public DayRecommend getDayRecommend() {
		return dayRecommend;
	}
	public void setDayRecommend(DayRecommend dayRecommend) {
		this.dayRecommend = dayRecommend;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setDayRecommendService(IDayRecommendService dayRecommendService) {
		this.dayRecommendService = dayRecommendService;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public List<ProductInfo> getProductInfoList() {
		return productInfoList;
	}
	public void setProductInfoList(List<ProductInfo> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public List<String> getSorts() {
		return sorts;
	}
	public void setSorts(List<String> sorts) {
		this.sorts = sorts;
	}
	public Integer[] getProductIds() {
		return productIds;
	}
	public void setProductIds(Integer[] productIds) {
		this.productIds = productIds;
	}
	public String getProductData() {
		return productData;
	}
	public void setProductData(String productData) {
		this.productData = productData;
	}
	public String getTypeId() {
		return typeId;
	}
	public void setTypeId(String typeId) {
		this.typeId = typeId;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public ISpecificationValueService getSpecificationValueService() {
		return specificationValueService;
	}
	public void setSpecificationValueService(ISpecificationValueService specificationValueService) {
		this.specificationValueService = specificationValueService;
	}
	public IProductInfoService getProductInfoService() {
		return productInfoService;
	}
	public IDayRecommendService getDayRecommendService() {
		return dayRecommendService;
	}	
	
}
