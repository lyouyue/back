package shop.store.action;

import java.io.File;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.io.FileUtils;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.store.pojo.ShopProCategory;
import shop.store.service.ISelfSupportShopProCategoryService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.upload.ImageFileUploadUtil;

/**
 * @作用：自营店铺内部分类信息
 * @功能：
 * @作者: wyc
 * @日期：2016年5月17日 上午11:22:46
 * @版本：V1.0
 */
public class SelfSupportShopProCategoryAction extends BaseAction{

	private static final long serialVersionUID = -1885023304960154310L;
	/**自营店铺内部分类serivce**/
	private ISelfSupportShopProCategoryService selfSupportShopProCategoryService;
	/**店铺内部分类实体**/
	private ShopProCategory shopProCategory;
	private String shopProCategoryId;
	private String Ids;
	private String shopInfoId;
	/**自营店铺内部分类列表**/
	private List<ShopProCategory> list;
	/**文件上传路径**/
	private File imagePath;
	/**文件上传名称**/
	private String imagePathFileName;
	/**跳转到自营店铺内部分类**/
	public String gotoSelfSupportShopProCategory(){
		request.setAttribute("shopInfoId", shopInfoId);
		return SUCCESS;
	}
	/**返回自营店铺列表**/
	public String gotoSelfSupportShopInfo(){
		return SUCCESS;
	}
	/**自营店铺内部分类列表查询
	 * @throws Exception **/
	public void getSelfSupportShopProCategoryList() throws Exception{
		//查询所有事项信息
		String hql=null;
		hql=" where o.shopInfoId="+ shopInfoId;
		//总条数查询
		String countHql=" where o.shopInfoId="+ shopInfoId;
		int totalRecordCount = selfSupportShopProCategoryService.getCount(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<ShopProCategory> list = selfSupportShopProCategoryService.findListByPageHelper(null, pageHelper, hql+ " order by o.shopProCategoryId desc ");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", list);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**根据id获取一条数据
	 * @throws Exception **/
	public void getObjectById() throws Exception{
		shopProCategory = (ShopProCategory) selfSupportShopProCategoryService.getObjectById(shopProCategoryId);
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap.put("shopProCategory", shopProCategory);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**删除自营店铺内部分类*/
	public void deleteSelfSupportShopProCategpry() throws Exception{
		Boolean isSuccess = selfSupportShopProCategoryService.deleteObjectsByIds("shopProCategoryId",Ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**保存或修改自营店铺内部分类
	 * @throws Exception **/
	public void saveOrUpdateShopOriCategory() throws Exception{
		//获取当前登录对象
		if(shopProCategory != null){
			if(shopProCategory.getShopProCategoryId()!=null){

			}else{
				shopProCategory.setShopInfoId(shopProCategory.getShopInfoId());
				shopProCategory.setShopProCategoryName(shopProCategory.getShopProCategoryName());
				shopProCategory.setSortCode(shopProCategory.getSortCode());
				shopProCategory.setIsShow(shopProCategory.getIsShow());
				shopProCategory.setCategoryImage(shopProCategory.getCategoryImage());
				shopProCategory.setCategoryDescription(shopProCategory.getCategoryDescription());
			}
			shopProCategory = (ShopProCategory)selfSupportShopProCategoryService.saveOrUpdateObject(shopProCategory);
			if(shopProCategory.getShopProCategoryId()!=null){
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
	// 异步ajax 图片上传
		public void uploadImage() throws Exception {
			JSONObject jo = new JSONObject();
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			// 1图片上传
			if (imagePath != null) {
				String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_promotion");
				jo.accumulate("photoUrl", otherImg);
				jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
			} else {
				jo.accumulate("photoUrl", "false1");
			}
			out.println(jo.toString());
			out.flush();
			out.close();
		}



	public ISelfSupportShopProCategoryService getSelfSupportShopProCategoryService() {
		return selfSupportShopProCategoryService;
	}
	public void setSelfSupportShopProCategoryService(
			ISelfSupportShopProCategoryService selfSupportShopProCategoryService) {
		this.selfSupportShopProCategoryService = selfSupportShopProCategoryService;
	}
	public ShopProCategory getShopProCategory() {
		return shopProCategory;
	}
	public void setShopProCategory(ShopProCategory shopProCategory) {
		this.shopProCategory = shopProCategory;
	}
	public List<ShopProCategory> getList() {
		return list;
	}
	public void setList(List<ShopProCategory> list) {
		this.list = list;
	}
	public String getIds() {
		return Ids;
	}
	public void setIds(String ids) {
		Ids = ids;
	}
	public String getShopProCategoryId() {
		return shopProCategoryId;
	}
	public void setShopProCategoryId(String shopProCategoryId) {
		this.shopProCategoryId = shopProCategoryId;
	}
	public String getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(String shopInfoId) {
		this.shopInfoId = shopInfoId;
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
}
