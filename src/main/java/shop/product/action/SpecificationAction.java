package shop.product.action;
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
import shop.product.pojo.ProductType;
import shop.product.pojo.Specification;
import shop.product.pojo.SpecificationValue;
import shop.product.service.IProductTypeService;
import shop.product.service.ISpecificationService;
import shop.product.service.ISpecificationValueService;
import util.action.BaseAction;
import util.other.Utils;
import util.upload.ImageFileUploadUtil;
/**
 * SpecificationAction - 套餐规格Action类
 */
@SuppressWarnings({ "serial", "unused" })
public class SpecificationAction extends BaseAction{
	Logger logger = Logger.getLogger(this.getClass());
	private ISpecificationService specificationService;//套餐规格Service
	private ISpecificationValueService specificationValueService;//套餐规格值service
	private IProductTypeService productTypeService;//套餐分类Service
	private List<Specification> specificationList = new ArrayList<Specification>();//套餐规格List
	private List<SpecificationValue> specificationValueList = new ArrayList<SpecificationValue>();//套餐规格值List
	private List<ProductType> productTypeList = new ArrayList<ProductType>();//套餐分类List
	private List<ProductType> sendProductTypeList = new ArrayList<ProductType>();//套餐二级分类List
	private Specification specification;//套餐规格
	private String specificationId;//套餐规格ID
	private String ids;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**套餐扩展属性action**/
	private ProductAttributeAction productAttributeAction;
	private Map<Object,Object> map = new HashMap<Object,Object>();
	private String prodTypeNames;
	public String gotoTestPage(){
		productTypeList = productTypeService.findObjects(" where o.parentId not in(0)");
		return SUCCESS;
	}
	public String findSpecificationByProductTypeId(){
		String productTypeId = request.getParameter("productTypeId");
		List<Specification> specificationList = specificationService.findObjects(" where o.productTypeId='"+productTypeId+"'");
		for(Specification sp : specificationList){
			List<SpecificationValue> specificationValueList = specificationValueService.findObjects(" where o.specificationId='"+sp.getSpecificationId()+"'");
			map.put(sp, specificationValueList);
		}
		return SUCCESS;
	}
	// 异步ajax 图片上传
	public void uploadImage() throws Exception {
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		// 1图片上传
		if (imagePath != null) {
			String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_specification");
			jo.accumulate("photoUrl", otherImg);
			jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
		} else {
			jo.accumulate("photoUrl", "false1");
		}
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//跳转到套餐规格列表页面
	public String gotoSpecificationPage(){
		List<ProductType> oldProdTypeList = productTypeService.findObjects(" where o.parentId=1");//一级分类
		for(ProductType prodType:oldProdTypeList){
			productTypeList.add(prodType);//添加一级分类
			int i=productTypeList.indexOf(prodType);//获取当前一级下标
			List<ProductType> listProductType2=productTypeService.findObjects(" where o.parentId="+prodType.getProductTypeId());//所属二级
			for(ProductType prodType2:listProductType2){
				List<ProductType> listProductType3=productTypeService.findObjects(" where o.parentId="+prodType2.getProductTypeId());//所属三级
				productTypeList.add(i+1, prodType2);//添加一级下的二级分类
				int j=productTypeList.indexOf(prodType2);//获取当前二级分类的下标
				for(ProductType prodType3:listProductType3){
					productTypeList.add(j+1, prodType3);//添加二级下的三级分类
				}
			}
		}
		return SUCCESS;
	}
	//查询所有的套餐规格
	public void listSpecification() throws IOException{
		String totalHql ="select count(a.specificationId) from Specification a ,ProductType b where a.productTypeId=b.productTypeId";
		String sql ="select a.specificationId as specificationId,a.name as name,a.productTypeId as productTypeId,a.sort as sort," +
				" a.notes as notes,a.type as type,b.productTypeId as productTypeId from  Specification  a ,ProductType b " +
				" where a.productTypeId=b.productTypeId ";
		String name = (String) request.getParameter("specificationName");
		String productTypeName = (String) request.getParameter("productTypeName");
		if(StringUtils.isNotEmpty(name)){
			name = name.trim();
			totalHql+=" and a.name like '%"+name+"%'";
			sql+=" and a.name like '%"+name+"%'";
		}
		if(StringUtils.isNotEmpty(productTypeName)){
			productTypeName = productTypeName.trim();
			totalHql+=" and b.sortName like '%"+productTypeName+"%'";
			sql+=" and b.sortName like '%"+productTypeName+"%'";
		}
		sql+=" order by a.specificationId desc";
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
	//查询套餐分类
	public void getPorductTypeList(){
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
	//保存或者修改套餐规格
	public void saveOrUpdateSpecification() throws IOException{
		String image = "";
		if(specification!=null){
			Integer sfid=specification.getSpecificationId();
			specification = (Specification) specificationService.saveOrUpdateObject(specification);
			//if(sfid==null){
				List<String> list = new ArrayList<String>();
				List<String> iamgeList = new ArrayList<String>();
				String parameter = request.getParameter("info");//规格值信息(文本)
				String imageUrl = request.getParameter("imageUrl");
				if(parameter!=null && !"".equals(parameter)){
					if(imageUrl!=null && !"".equals(imageUrl)){//规格值信息(图片前台代码已注释不再使用)
						String[] splitImage = imageUrl.split(",");
						for(int i=1;i<splitImage.length;i++){
							String[] subSplitImage = splitImage[i].split("_");
							iamgeList.add(subSplitImage[1].replace(","," "));
						}
					}
					String[] split = parameter.split("@");//将规格值分割
					for(int i=0;i<split.length;i++){
						if(iamgeList.size()>0){
							image = image+split[i]+","+iamgeList.get(i)+"@";
						}else{
							image = image+split[i]+"@";
						}
					}
					split = image.split("@");
					for(int i=0;i<split.length;i++){
						if(!split[i].contains("undefined_0,undefined")){
							list.add(split[i]);
						}
					}
					for(String s : list){
						SpecificationValue sv = new SpecificationValue();
						String[] split2 = s.split(",");
						sv.setSpecificationId(specification.getSpecificationId());
						if(split2.length>0){
							if(Utils.objectIsNotEmpty(split2[0])){
								String[] split3 = split2[0].split("_");
								if(Utils.objectIsNotEmpty(split3)){
									sv.setSort(Integer.parseInt(split3[0]));
									if(Utils.objectIsNotEmpty(split3[1])&&Integer.parseInt(split3[1])!=0){
										sv.setSpecificationValueId(Integer.parseInt(split3[1]));
									}
								}
							}else{
								sv.setSort(0);
							}
						}
						if(split2.length>1){
							sv.setName(split2[1]);
						}
						if(iamgeList.size()>0){
							sv.setImage(split2[2]);
						}
						specificationValueService.saveOrUpdateObject(sv);
					}
				}
			//}
			if(specification.getSpecificationId()!=null){
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
	//得到一条套餐规格记录
	public void getSpecificationInfo() throws IOException{
		specification = (Specification)specificationService.getObjectByParams(" where o.specificationId='"+specificationId+"'");
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap=productAttributeAction.getThreeLevelProdType(specification.getProductTypeId());
		jsonMap.put("specification", specification);
		//根据规格的ID查规格值
		specificationValueList=(List<SpecificationValue>)specificationValueService.findObjects(" where o.specificationId="+specification.getSpecificationId());
		jsonMap.put("specificationValueList", specificationValueList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除套餐规格
	public void deleteSpecification() throws IOException{
		Boolean isSuccess = specificationService.deleteObjectsByIds("specificationId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据套餐规格ID查询此ID下的套餐规格值列表页面
	public String findSpecificationValueListBySpecificationId(){
		//对Name进行解码处理
		String name = request.getParameter("name");
		request.setAttribute("name", name);
		return SUCCESS;
	}
	//根据规格ID查找规格值
	public void listSpecificationValueListBySpecificationId() throws IOException{
		int totalRecordCount = specificationValueService.getCount(" where o.specificationId='"+specificationId+"' order by o.specificationValueId");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		specificationValueList = specificationValueService.findListByPageHelper(null,pageHelper, " where o.specificationId='"+specificationId+"' order by o.specificationValueId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", specificationValueList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据父ID查找套餐分类
	public void findProductTypeListByParentId() throws IOException{
		String parentProductTypeId = request.getParameter("parentProductTypeId");
		sendProductTypeList = productTypeService.findObjects(" where o.parentId='"+parentProductTypeId+"'");
		JSONArray ja = JSONArray.fromObject(sendProductTypeList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(ja.toString());
		out.flush();
		out.close();
	}
	public List<Specification> getSpecificationList() {
		return specificationList;
	}
	public void setSpecificationList(List<Specification> specificationList) {
		this.specificationList = specificationList;
	}
	public List<ProductType> getProductTypeList() {
		return productTypeList;
	}
	public void setProductTypeList(List<ProductType> productTypeList) {
		this.productTypeList = productTypeList;
	}
	public Specification getSpecification() {
		return specification;
	}
	public void setSpecification(Specification specification) {
		this.specification = specification;
	}
	public String getSpecificationId() {
		return specificationId;
	}
	public void setSpecificationId(String specificationId) {
		this.specificationId = specificationId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setSpecificationService(ISpecificationService specificationService) {
		this.specificationService = specificationService;
	}
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public void setSpecificationValueService(
			ISpecificationValueService specificationValueService) {
		this.specificationValueService = specificationValueService;
	}
	public List<SpecificationValue> getSpecificationValueList() {
		return specificationValueList;
	}
	public void setSpecificationValueList(
			List<SpecificationValue> specificationValueList) {
		this.specificationValueList = specificationValueList;
	}
	public List<ProductType> getSendProductTypeList() {
		return sendProductTypeList;
	}
	public void setSendProductTypeList(List<ProductType> sendProductTypeList) {
		this.sendProductTypeList = sendProductTypeList;
	}
	public ProductAttributeAction getProductAttributeAction() {
		return productAttributeAction;
	}
	public void setProductAttributeAction(
			ProductAttributeAction productAttributeAction) {
		this.productAttributeAction = productAttributeAction;
	}
	public Map<Object, Object> getMap() {
		return map;
	}
	public void setMap(Map<Object, Object> map) {
		this.map = map;
	}
}
