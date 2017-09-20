package shop.store.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;

import shop.common.pojo.DistrictInfo;
import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import shop.store.pojo.ShopCategory;
import shop.store.pojo.ShopInfo;
import shop.store.service.ISelfSupportShopInfoService;
import shop.store.service.IShopCategoryService;
import util.action.BaseAction;
import util.other.JSONFormatDate;
import util.other.QRCode;
import util.other.Utils;
import basic.pojo.Users;
import basic.service.IAreaService;
import basic.service.IKeyBookService;
/**
 * ShopInfoAction - 自营店铺action基本信息
 * @Author §j*fm§
 */
@SuppressWarnings("serial")
public class SelfSupportShopInfoAction extends BaseAction {
	private ISelfSupportShopInfoService selfSupportShopInfoService;//店铺基本信息Service
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();//店铺信息列表
	private List<Map> shopInfoListMap = new ArrayList<Map>();//店铺信息列表
	private List<ShopCategory> shopCategoryList = null;//店铺分类信息列表
	private List<Customer> customerList = null;//客户信息列表
	private IShopCategoryService shopCategoryService;//店铺分类Service
	private ICustomerService customerService;//客户信息Service
	private List<DistrictInfo> districtInfoList = null;//国家信息列表
	private List<DistrictInfo> regionLocationList = null;//各州信息列表
	private String ids;
	private ShopInfo shopInfo;//店铺基本信息实体
	/**区域Service**/
	private IAreaService areaService;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**查询数字字典公司认证**/
	private IKeyBookService keyBookService;
	private Integer saveIsPass;
	private Integer savePhoneShowStatus;
	private String shopName;
	private Integer shopCategoryId;
	private String phone;
	private String addressForInvoice;
	private String mainProduct;
	private String postCode;
	private BigDecimal postage;
	private String logoUrl;
	private String bannerUrl;
	private String marketBrandUrl;
	private String companyNameForInvoice;
	private String businessLicense;
	private String iDCardsImage;
	private String businessHoursStart;
	private String businessHoursEnd; 
	private String address;
	private Integer templateSet;
	private BigDecimal minAmount;
	private String shopInfoId;
	private Integer businessType;
	private String email;
	private String marketBrand;
	private String companyDocuments;
	private String taxRegistrationDocuments;
	private String companyRegistered;
	private String legalOwner;
	private String iDCards;
	private String companyCertification;
	public String gotoShopInfoPage() throws Exception {
		//初始化加载的数据getName
		shopCategoryList = shopCategoryService.findObjects("where o.shopCategoryId >1)");
		customerList = customerService.findObjects(null);
//		businessTypeList = (List<KeyBook>) ((Map) ActionContext.getContext().getApplication().get("keybook")).get("businessType");
		return SUCCESS;
	}
	/**跳转到自营店铺客服**/
	public String gotoSelfSupportCustomerService(){
		//初始化加载的数据getName
			shopCategoryList = shopCategoryService.findObjects("where o.shopCategoryId >1)");
			customerList = customerService.findObjects(null);
		return SUCCESS;
	}
	//店铺基本信息查询列表
	public void listShopInfo() throws IOException {
		String sql="SELECT a.shopInfoId as shopInfoId, a.customerId as customerId, a.customerName as customerName ,a.shopName as shopName,b.shopCategoryName as shopCategoryName,a.mainProduct as mainProduct ,a.isPass as isPass ,a.isClose as isClose ,a.isVip as isVip ,a.verifier as verifier from ShopInfo a , ShopCategory b,Customer c where a.shopInfoType=1 and a.shopCategoryId=b.shopCategoryId  and a.customerId=c.customerId ";
		String sqlCount="SELECT count(a.shopInfoId) from ShopInfo a , ShopCategory b,Customer c where a.shopInfoType=1 and a.shopCategoryId=b.shopCategoryId  and a.customerId=c.customerId ";
		String selectFlag=request.getParameter("selectFlag");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String shopName = request.getParameter("shopName");
			String isClose = request.getParameter("isClose");
			String custName = request.getParameter("custName");
			String shopCategoryId = request.getParameter("shopCategoryId");
			String isPass = request.getParameter("isPass");
			String isVip = request.getParameter("isVip");
			/*String registerDate = request.getParameter("registerDate");
			String registerDate2 = request.getParameter("registerDate2");*/
//			if(registerDate!=null&&!"".equals(registerDate)){
//				sql+= " and c.registerDate>= '"+registerDate.trim()+" 00:00:00"+"'";
//				sqlCount+= " and  c.registerDate >= '"+registerDate.trim()+" 00:00:00"+"'";
//			}
//			if(registerDate2!=null&&!"".equals(registerDate2)){
//				sql+= " and c.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
//				sqlCount+= " and  c.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
//			}
			if(shopName!=null&&StringUtils.isNotEmpty(shopName)){
				shopName = shopName.trim();
				sql+=" and a.shopName like '%"+shopName+"%'";
				sqlCount+=" and a.shopName like '%"+shopName+"%'";
			}
			if(custName!=null&&StringUtils.isNotEmpty(custName)){
				custName = custName.trim();
				sql+=" and a.customerName like '%"+custName+"%'";
				sqlCount+=" and a.customerName like '%"+custName+"%'";
			}
			if(!"-1".equals(isClose)){
				sql+=" and a.isClose="+isClose;
				sqlCount+=" and a.isClose="+isClose;
			}
			/*if(!"-1".equals(isVip)){
				sql+=" and a.isVip="+isVip;
				sqlCount+=" and a.isVip="+isVip;
			}*/
			if(!"-1".equals(isPass)){
				sql+=" and a.isPass="+isPass;
				sqlCount+=" and a.isPass="+isPass;
			}
			if(!"-1".equals(shopCategoryId)){
				sql+=" and a.shopCategoryId="+shopCategoryId;
				sqlCount+=" and a.shopCategoryId="+shopCategoryId;
			}
		}
		sql+=" order by a.shopInfoId desc";
		int totalRecordCount = selfSupportShopInfoService.getMoreTableCount(sqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		shopInfoListMap = selfSupportShopInfoService.findListMapPage(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", shopInfoListMap);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	// 异步ajax 图片上传
	public void uploadImage() throws Exception {
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		// 1图片上传
		if (imagePath != null) {
			// 1上传文件的类型
			String typeStr = imagePathFileName.substring(imagePathFileName.lastIndexOf(".") + 1);
			if ("jpg".equals(typeStr) || "JPG".equals(typeStr) || "png".equals(typeStr) || "PNG".equals(typeStr) || "GIF".equals(typeStr) ||"gif".equals(typeStr) || "".equals(typeStr)) {
				// 需要修改图片的存放地址
				String newName = imagePathFileName.substring(imagePathFileName.lastIndexOf("."));
				newName = UUID.randomUUID() + newName;
				File savefile = new File(new File(String.valueOf(getFileUrlConfig().get("fileUploadRoot")) + "/"+ String.valueOf(getFileUrlConfig().get("shop")) + "/image/shopInfo"), newName);
				if (!savefile.getParentFile().exists()) {
					savefile.getParentFile().mkdirs();
				}
				FileUtils.copyFile(imagePath, savefile);
				imagePathFileName = String.valueOf(getFileUrlConfig().get("shop")) + "/image/shopInfo/" + newName;
				jo.accumulate("photoUrl", imagePathFileName);
				jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
			} else {
				jo.accumulate("photoUrl", "false2");
			}
		} else {
			jo.accumulate("photoUrl", "false1");
		}
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据id删除就条或批量删除店铺
	public void deleteShopInfo() throws IOException{
		Boolean isSuccess = selfSupportShopInfoService.deleteObjectsByIds("shopInfoId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	public void getShopInfoById() throws IOException{
		shopInfo = (ShopInfo) selfSupportShopInfoService.getObjectById(shopInfoId);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject json =JSONObject.fromObject(shopInfo, jsonConfig); 
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(json.toString());
		out.flush();
		out.close();
	}
	//保存或修改企业信息
	public void saveOrUpdateEnterprise() throws Exception {
		ShopInfo shopInfoOld=null; 
		if(Utils.objectIsNotEmpty(shopInfo)&&Utils.objectIsNotEmpty(shopInfo.getShopInfoId())){
			
		}
		shopInfoOld = (ShopInfo) selfSupportShopInfoService.getObjectByParams(" where o.shopInfoId="+shopInfo.getShopInfoId());
		if(Utils.objectIsNotEmpty(shopInfoOld)){
			shopInfoOld.setCompanyDocuments(shopInfo.getCompanyDocuments());
			shopInfoOld.setCompanyRegistered(shopInfo.getCompanyRegistered());
			shopInfoOld.setLegalOwner(shopInfo.getLegalOwner());
			shopInfoOld.setIDCards(shopInfo.getIDCards());
			shopInfoOld.setCompanyCertification(shopInfo.getCompanyCertification());
			shopInfoOld.setTaxRegistrationDocuments(shopInfo.getTaxRegistrationDocuments());
			shopInfoOld.setIDCardsImage(shopInfo.getIDCardsImage());
			shopInfoOld.setBusinessLicense(shopInfo.getBusinessLicense());
			shopInfoOld.setPostCode(shopInfo.getPostCode());
			shopInfoOld = (ShopInfo) selfSupportShopInfoService.saveOrUpdateObject(shopInfoOld);
		}
		JSONObject jo = new JSONObject();
		if(Utils.objectIsNotEmpty(shopInfoOld)){
			jo.accumulate("isSuccess", "true");
		}else{
			jo.accumulate("isSuccess", "false");
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		
	}
	//保存或修改店铺基本信息
	public void saveOrUpdateShopInfo() throws IOException, ParseException{
		ShopInfo shopInfoOld = null;
		if(Utils.objectIsNotEmpty(shopInfo)&&Utils.objectIsNotEmpty(shopInfo.getShopInfoId())){
			
			}
		shopInfoOld = (ShopInfo) selfSupportShopInfoService.getObjectByParams(" where o.shopInfoId="+shopInfo.getShopInfoId());
		if(Utils.objectIsNotEmpty(shopInfoOld)){
			if(shopInfo.getShopCategoryId()!=-1){
			shopInfoOld.setShopCategoryId(shopInfo.getShopCategoryId());
			shopInfoOld.setShopName(shopInfo.getShopName());
			shopInfoOld.setBusinessType(shopInfo.getBusinessType());
			shopInfoOld.setPostCode(shopInfo.getPostCode());
			shopInfoOld.setMainProduct(shopInfo.getMainProduct());
			shopInfoOld.setEmail(shopInfo.getEmail());
			shopInfoOld.setPhone(shopInfo.getPhone());
			shopInfoOld.setLogoUrl(shopInfo.getLogoUrl());
			shopInfoOld.setBannerUrl(shopInfo.getBannerUrl());
			shopInfoOld.setBusinessHoursStart(shopInfo.getBusinessHoursStart());
			shopInfoOld.setBusinessHoursEnd(shopInfo.getBusinessHoursEnd());
			shopInfoOld.setMarketBrand(shopInfo.getMarketBrand());
			shopInfoOld.setMarketBrandUrl(shopInfo.getMarketBrandUrl());
			shopInfoOld.setIsClose(shopInfo.getIsClose());
			shopInfoOld.setShopInfoCheckSatus(shopInfo.getIsPass());
			shopInfoOld.setSynopsis(shopInfo.getSynopsis());
			shopInfoOld.setAddressForInvoice(shopInfo.getAddressForInvoice());
			shopInfoOld = (ShopInfo) selfSupportShopInfoService.saveOrUpdateObject(shopInfoOld);
			}
		}
		JSONObject jo = new JSONObject();
		if(Utils.objectIsNotEmpty(shopInfoOld)){
			jo.accumulate("isSuccess", "true");
		}else{
			jo.accumulate("isSuccess", "false");
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public void selectCountry() throws IOException{
		JSONArray jo = JSONArray.fromObject(regionLocationList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 批量开启或关闭
	 * @throws Exception
	 */
	public void saveOrUpdateIsCloss() throws Exception{
		boolean flag= selfSupportShopInfoService.saveOrUpdateIsCloss(saveIsPass, ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", flag );
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 批量设置VIP（特定）店铺
	 * @throws Exception
	 */
	public void saveOrUpdateIsVip() throws Exception{
		//将字符串转换为字符串数组
		String[] shopInfoIds = ids.split(",");
		boolean flag= selfSupportShopInfoService.saveOrUpdateIsVip(saveIsPass, shopInfoIds);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", flag );
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//批量生成二维码
	public void shopInfoGeneratedQrCode() throws IOException{
		boolean isSuccess=false;
		String failureLog1=""; 
		String failureLog2=""; 
		if(Utils.objectIsNotEmpty(ids)){
			String basePath = String.valueOf(getFileUrlConfig().get("phoneBasePath"));
			String sql="select shopInfoId as shopInfoId, shopName as shopName from shop_shopinfo where shopInfoId in ("+ids+") ";
			List<Map<String,Object>> shopInfoList=selfSupportShopInfoService.findListMapBySql(sql);
			if(Utils.objectIsNotEmpty(shopInfoList)&&shopInfoList.size()>0){
				int size=shopInfoList.size();
				for(int i=0;i<size;i++){
					if(Utils.objectIsNotEmpty(shopInfoList.get(i).get("shopInfoId"))){
						String addUrl = basePath+"/phone/shopInfo/phoneGotoShopInfoPage.action?shopInfoId="+shopInfoList.get(i).get("shopInfoId")+"&orderBy=normal";
						String codeUrl = QRCode.createQRPng(addUrl, null, getFileUrlConfig(), "shop" ,"image_shopInfo");
						isSuccess=selfSupportShopInfoService.updateBySQL("update shop_shopinfo set qrCode='"+codeUrl+"' where shopInfoId="+shopInfoList.get(i).get("shopInfoId"));
						if(!isSuccess){
							if(i==size-1){
								failureLog2+=shopInfoList.get(i).get("shopName");
							}else{
								failureLog2+=shopInfoList.get(i).get("shopName")+",";
							}
						}
					}
				}
			}else{
				failureLog1="生成失败！";
			}
		}
		JSONObject jo=new JSONObject();
		jo.accumulate("failureLog1", failureLog1);
		if(Utils.objectIsNotEmpty(failureLog2)){
			jo.accumulate("failureLog2", "店铺名称为："+failureLog2+"的记录生成失败！");
		}else{
			jo.accumulate("failureLog2", failureLog2);
		}
		if(Utils.objectIsEmpty(failureLog1)&&Utils.objectIsEmpty(failureLog2)){
			isSuccess=true;
		}else{
			isSuccess=false;
		}
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		pw.print(jo.toString());
		pw.flush();
		pw.close();
	}
	
	
	public void setSelfSupportShopInfoService(
			ISelfSupportShopInfoService selfSupportShopInfoService) {
		this.selfSupportShopInfoService = selfSupportShopInfoService;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public ShopInfo getShopInfo() {
		return shopInfo;
	}
	public void setShopInfo(ShopInfo shopInfo) {
		this.shopInfo = shopInfo;
	}
	public List<ShopCategory> getShopCategoryList() {
		return shopCategoryList;
	}
	public List<Map> getShopInfoListMap() {
		return shopInfoListMap;
	}
	public void setShopInfoListMap(List<Map> shopInfoListMap) {
		this.shopInfoListMap = shopInfoListMap;
	}
	public void setShopCategoryList(List<ShopCategory> shopCategoryList) {
		this.shopCategoryList = shopCategoryList;
	}
	public List<Customer> getCustomerList() {
		return customerList;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}
	public void setShopCategoryService(IShopCategoryService shopCategoryService) {
		this.shopCategoryService = shopCategoryService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
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
	public List<DistrictInfo> getDistrictInfoList() {
		return districtInfoList;
	}
	public void setDistrictInfoList(List<DistrictInfo> districtInfoList) {
		this.districtInfoList = districtInfoList;
	}
	public List<DistrictInfo> getRegionLocationList() {
		return regionLocationList;
	}
	public void setRegionLocationList(List<DistrictInfo> regionLocationList) {
		this.regionLocationList = regionLocationList;
	}
	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}
	public IAreaService getAreaService() {
		return areaService;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public Integer getSaveIsPass() {
		return saveIsPass;
	}
	public void setSaveIsPass(Integer saveIsPass) {
		this.saveIsPass = saveIsPass;
	}
	public Integer getSavePhoneShowStatus() {
		return savePhoneShowStatus;
	}
	public void setSavePhoneShowStatus(Integer savePhoneShowStatus) {
		this.savePhoneShowStatus = savePhoneShowStatus;
	}
	public String getShopName() {
		return shopName;
	}
	public void setShopName(String shopName) {
		this.shopName = shopName;
	}
	public Integer getShopCategoryId() {
		return shopCategoryId;
	}
	public void setShopCategoryId(Integer shopCategoryId) {
		this.shopCategoryId = shopCategoryId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getMainProduct() {
		return mainProduct;
	}
	public void setMainProduct(String mainProduct) {
		this.mainProduct = mainProduct;
	}
	public String getPostCode() {
		return postCode;
	}
	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}
	public BigDecimal getPostage() {
		return postage;
	}
	public void setPostage(BigDecimal postage) {
		this.postage = postage;
	}
	public String getLogoUrl() {
		return logoUrl;
	}
	public void setLogoUrl(String logoUrl) {
		this.logoUrl = logoUrl;
	}
	public String getBannerUrl() {
		return bannerUrl;
	}
	public void setBannerUrl(String bannerUrl) {
		this.bannerUrl = bannerUrl;
	}
	public String getMarketBrandUrl() {
		return marketBrandUrl;
	}
	public void setMarketBrandUrl(String marketBrandUrl) {
		this.marketBrandUrl = marketBrandUrl;
	}
	public String getCompanyNameForInvoice() {
		return companyNameForInvoice;
	}
	public void setCompanyNameForInvoice(String companyNameForInvoice) {
		this.companyNameForInvoice = companyNameForInvoice;
	}
	public String getBusinessLicense() {
		return businessLicense;
	}
	public void setBusinessLicense(String businessLicense) {
		this.businessLicense = businessLicense;
	}
	public String getiDCardsImage() {
		return iDCardsImage;
	}
	public void setiDCardsImage(String iDCardsImage) {
		this.iDCardsImage = iDCardsImage;
	}
	public ISelfSupportShopInfoService getSelfSupportShopInfoService() {
		return selfSupportShopInfoService;
	}
	public IShopCategoryService getShopCategoryService() {
		return shopCategoryService;
	}
	public ICustomerService getCustomerService() {
		return customerService;
	}
	public IKeyBookService getKeyBookService() {
		return keyBookService;
	}
	public String getAddressForInvoice() {
		return addressForInvoice;
	}
	public void setAddressForInvoice(String addressForInvoice) {
		this.addressForInvoice = addressForInvoice;
	}
	public String getBusinessHoursStart() {
		return businessHoursStart;
	}
	public void setBusinessHoursStart(String businessHoursStart) {
		this.businessHoursStart = businessHoursStart;
	}
	public String getBusinessHoursEnd() {
		return businessHoursEnd;
	}
	public void setBusinessHoursEnd(String businessHoursEnd) {
		this.businessHoursEnd = businessHoursEnd;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Integer getTemplateSet() {
		return templateSet;
	}
	public void setTemplateSet(Integer templateSet) {
		this.templateSet = templateSet;
	}
	public BigDecimal getMinAmount() {
		return minAmount;
	}
	public void setMinAmount(BigDecimal minAmount) {
		this.minAmount = minAmount;
	}
	public String getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(String shopInfoId) {
		this.shopInfoId = shopInfoId;
	}
	public Integer getBusinessType() {
		return businessType;
	}
	public void setBusinessType(Integer businessType) {
		this.businessType = businessType;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMarketBrand() {
		return marketBrand;
	}
	public void setMarketBrand(String marketBrand) {
		this.marketBrand = marketBrand;
	}
	public String getCompanyDocuments() {
		return companyDocuments;
	}
	public void setCompanyDocuments(String companyDocuments) {
		this.companyDocuments = companyDocuments;
	}
	public String getTaxRegistrationDocuments() {
		return taxRegistrationDocuments;
	}
	public void setTaxRegistrationDocuments(String taxRegistrationDocuments) {
		this.taxRegistrationDocuments = taxRegistrationDocuments;
	}
	public String getCompanyRegistered() {
		return companyRegistered;
	}
	public void setCompanyRegistered(String companyRegistered) {
		this.companyRegistered = companyRegistered;
	}
	public String getLegalOwner() {
		return legalOwner;
	}
	public void setLegalOwner(String legalOwner) {
		this.legalOwner = legalOwner;
	}
	public String getiDCards() {
		return iDCards;
	}
	public void setiDCards(String iDCards) {
		this.iDCards = iDCards;
	}
	public String getCompanyCertification() {
		return companyCertification;
	}
	public void setCompanyCertification(String companyCertification) {
		this.companyCertification = companyCertification;
	}
	
	
}
