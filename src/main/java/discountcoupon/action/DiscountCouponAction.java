package discountcoupon.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import discountcoupon.pojo.Customerdiscountcoupon;
import discountcoupon.service.ICustomerdiscountcouponService;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.io.FileUtils;

import org.apache.log4j.Logger;
import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.CreateWhereSQLForSelect;
import util.other.DateUtil;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.pojo.Users;
import discountcoupon.pojo.DiscountCoupon;
import discountcoupon.service.IDiscountCouponService;
import wxmg.basicInfo.service.IFansGroupService;

/**
 * DiscountCouponAction - 优惠券信息Action
 */
@SuppressWarnings("serial")
public class DiscountCouponAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private IDiscountCouponService discountCouponService;//优惠券Service
	private List<DiscountCoupon> discountCouponList = new ArrayList<DiscountCoupon>();//优惠券List
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();//店铺信息List
	private ICustomerService customerService;//客户信息Service接口
	private ICustomerdiscountcouponService customerdiscountcouponService;//用户优惠券户表Service层接口
	private IShopInfoService shopInfoService;//店铺Service
	private DiscountCoupon discountCoupon;//优惠券对象
	private IFansGroupService fansGroupService;//粉丝分组Service接口
	private String discountCouponId;
	private String ispass;
	private String useStatus;
	private String ids;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	//跳转到优惠券列表页面
	public String gotoDiscountCouponPage(){
//		//初始化店铺记录
//		shopInfoList = shopInfoService.findObjects(" where o.isClose = '0'");
		//查询有效粉丝组
		List<Map> customerFansGroup=fansGroupService.findListMapByHql("select f.id as id,f.name as name FROM FansGroup f where f.isValid=0");
		request.setAttribute("customerFansGroup",customerFansGroup);
		SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		String date = sdf.format(new Date());
		List<DiscountCoupon> list = discountCouponService.findUnDistinctList("discountCouponID"," where UNIX_TIMESTAMP(o.expirationTime)<UNIX_TIMESTAMP('"+date+"')");
		if(Utils.collectionIsNotEmpty(list)){
			String discountCouponIDs = Utils.listToString(list,",");
			discountCouponService.updateBySQL("update shop_discountcoupon set useStatus=2 where discountCouponID in("+discountCouponIDs+")");
		}
		return SUCCESS;
	}
	//查询所有的优惠券记录
	public void listDiscountCouponApply() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
//			String shopInfoId = request.getParameter("shopInfoId");
//			String discountCouponAmount = request.getParameter("discountCouponAmount");
			String qdiscountCouponName = request.getParameter("qdiscountCouponName");
			String beginTime = request.getParameter("beginTime");
			String expirationTime = request.getParameter("expirationTime");
			String createTime = request.getParameter("createTime");
			StringBuffer sb = CreateWhereSQLForSelect.appendLike(null, null, null);
//			if(!"-1".equals(shopInfoId)){
//				sb.append(CreateWhereSQLForSelect.appendLike("shopInfoId","like",shopInfoId));
//			}
			if(Utils.objectIsNotEmpty(qdiscountCouponName)){
				sb.append(CreateWhereSQLForSelect.appendLike("discountCouponName","like",qdiscountCouponName));
			}
			if(useStatus!=null&&!"".equals(useStatus)){
				sb.append(CreateWhereSQLForSelect.appendLike("useStatus","like",useStatus));
			}
			if(ispass!=null&&!"".equals(ispass)){
				sb.append(CreateWhereSQLForSelect.appendLike("isPass","like",ispass));
			}
			if(beginTime!=null&&!"".equals(beginTime)){
				sb.append(CreateWhereSQLForSelect.appendLike("beginTime","like",beginTime));
			}
			if(expirationTime!=null&&!"".equals(expirationTime)){
				sb.append(CreateWhereSQLForSelect.appendLike("expirationTime","like",expirationTime));
			}
			if(createTime!=null&&!"".equals(createTime)){
				sb.append(CreateWhereSQLForSelect.appendLike("createTime","like",createTime));
			}
			if(!"".equals(sb.toString()) && sb != null){
				hqlsb=CreateWhereSQLForSelect.createSQL(sb);
			}
		}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" expirationTime desc"));
		int totalRecordCount = discountCouponService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		discountCouponList = discountCouponService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", discountCouponList);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//修改启用状态
	public void saveOrUpdateuseStatus() throws IOException, ParseException{
//		int i=-1;
//		if(Utils.objectIsNotEmpty(useStatus)){
//			i = Integer.parseInt(useStatus);
//		}
		Date createTime = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String formatTime = sdf.format(createTime);
		Date createTimes = sdf.parse(formatTime);
		discountCoupon=(DiscountCoupon) discountCouponService.getObjectById(discountCouponId);
		if(discountCoupon!=null){
			discountCoupon.setUpdateTime(createTimes);
			discountCoupon.setUseStatus(Integer.parseInt(useStatus));
			discountCoupon = (DiscountCoupon) discountCouponService.saveOrUpdateObject(discountCoupon);
			if(discountCoupon.getDiscountCouponID()!=null){
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
	//审核
	public void saveOrUpdateispass() throws IOException, ParseException{
//		int i=-1;
//		if(Utils.objectIsNotEmpty(ispass)){
//			i = Integer.parseInt(ispass);
//		}
		Users s = (Users) session.getAttribute("users");
		Date createTime = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String formatTime = sdf.format(createTime);
		Date createTimes = sdf.parse(formatTime);
		discountCoupon=(DiscountCoupon) discountCouponService.getObjectById(discountCouponId);
		if(discountCoupon!=null){
			discountCoupon.setVerifier(s.getUserName());
			discountCoupon.setCheckTime(createTimes);
			discountCoupon.setIsPass(Integer.parseInt(ispass));
			discountCoupon = (DiscountCoupon) discountCouponService.saveOrUpdateObject(discountCoupon);
			if(discountCoupon.getDiscountCouponID()!=null){
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
	//添加或修改优惠券
	public void saveOrUpdateDiscountCoupon() throws IOException, ParseException{
		Date createTimes = new Date();
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		String formatTime = sdf.format(createTime);
//		Date createTimes = sdf.parse(formatTime);
		String discountCouponCode =Utils.getRandomCode();
		discountCoupon.setShopId(1);
		if(discountCoupon!=null){
			int s=discountCoupon.getDistributionCount();
			if(Utils.objectIsNotEmpty(discountCoupon.getDiscountCouponID())){
				discountCoupon.setUpdateTime(createTimes);
			}else {
				discountCoupon.setCreateTime(createTimes);
				discountCoupon.setUpdateTime(createTimes);
				discountCoupon.setSurplus(s);
				discountCoupon.setUseStatus(0);
				discountCoupon.setIsPass(1);
				discountCoupon.setDiscountCouponCode(discountCouponCode);
				Date expireDate = discountCoupon.getExpirationTime();
				expireDate = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()).parse(DateUtil.dateToStringYTD(expireDate) + " 23:59:59");
				discountCoupon.setExpirationTime(expireDate);
			}
			discountCoupon = (DiscountCoupon) discountCouponService.saveOrUpdateObject(discountCoupon);
			if(discountCoupon.getDiscountCouponID()!=null){
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
			// 1上传文件的类型
			String typeStr = imagePathFileName.substring(imagePathFileName.lastIndexOf(".") + 1);
			if ("jpg".equals(typeStr) || "JPG".equals(typeStr) || "png".equals(typeStr) || "PNG".equals(typeStr) || "GIF".equals(typeStr) ||"gif".equals(typeStr) || "".equals(typeStr)) {
				// 需要修改图片的存放地址
				String newName = imagePathFileName.substring(imagePathFileName.lastIndexOf("."));
				newName = UUID.randomUUID() + newName;
				File savefile = new File(new File(String.valueOf(getFileUrlConfig().get("fileUploadRoot")) + "/"+ String.valueOf(getFileUrlConfig().get("shop")) + "/image/discountcoupon"), newName);
				if (!savefile.getParentFile().exists()) {
					savefile.getParentFile().mkdirs();
				}
				FileUtils.copyFile(imagePath, savefile);
				imagePathFileName = String.valueOf(getFileUrlConfig().get("shop")) + "/image/discountcoupon/" + newName;
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
	//批量删除
	public void deleteDiscountCoupon() throws IOException{
		Boolean isSuccess = discountCouponService.deleteObjectsByIds("discountCouponID",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	public void getDiscountCouponById() throws IOException{
		discountCoupon = (DiscountCoupon) discountCouponService.getObjectByParams(" where o.discountCouponID='"+ids+"'");
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(discountCoupon,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取需要手动赠送的优惠券
	public void manualGiveCoupon() throws IOException{
		if(Utils.objectIsNotEmpty(discountCouponId)&&Utils.objectIsNotEmpty(ids)){
		Customerdiscountcoupon customerdiscountcoupon=new Customerdiscountcoupon();
		JSONObject jo = new JSONObject();
		DiscountCoupon discountCoupon=(DiscountCoupon) discountCouponService.getObjectByParams("where o.discountCouponID="+discountCouponId);
			String[] idArys = null;
			try {
				idArys = ids.split(",");
			}catch (Exception e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
			for (int i = 0; i < idArys.length; i++) {
				Customer customer = (Customer)customerService.getObjectByParams(" where o.customerId="+idArys[i]);
				int count=customerdiscountcouponService.getCount("where o.customerId="+idArys[i]+"and o.discountCouponID="+discountCouponId);
				if(count<1){
				customerdiscountcoupon.setCustomerId(customer.getCustomerId());//会员ID
				customerdiscountcoupon.setDiscountCouponID(discountCoupon.getDiscountCouponID());//优惠券ID
				customerdiscountcoupon.setDiscountCouponCode(discountCoupon.getDiscountCouponCode());//优惠券码
				customerdiscountcoupon.setDiscountCouponName(discountCoupon.getDiscountCouponName());//优惠券名称
				customerdiscountcoupon.setDiscountCouponAmount(discountCoupon.getDiscountCouponAmount());//优惠金额
				customerdiscountcoupon.setDiscountCouponLowAmount(discountCoupon.getDiscountCouponLowAmount());//优惠下线金额
				customerdiscountcoupon.setBeginTime(discountCoupon.getBeginTime());//开始时间
				customerdiscountcoupon.setExpirationTime(discountCoupon.getExpirationTime());//到期时间
				customerdiscountcoupon.setDiscountImage(discountCoupon.getDiscountImage());//优惠券图片
				customerdiscountcoupon.setUseStatus(0);//使用状态：0，未使用 1，已使用
				customerdiscountcoupon.setStatus(1);//优惠券状态 1：正常 2：过期 3：作废
				customerdiscountcoupon.setCreateTime(new Date());
				customerdiscountcoupon.setUpdateTime(new Date());
				customerdiscountcouponService.saveOrUpdateObject(customerdiscountcoupon);
				}
			}
			jo.accumulate("isSuccess","true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	public void setDiscountCouponService(
			IDiscountCouponService discountCouponService) {
		this.discountCouponService = discountCouponService;
	}
	public List<DiscountCoupon> getDiscountCouponList() {
		return discountCouponList;
	}
	public void setDiscountCouponList(List<DiscountCoupon> discountCouponList) {
		this.discountCouponList = discountCouponList;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public DiscountCoupon getDiscountCoupon() {
		return discountCoupon;
	}
	public void setDiscountCoupon(DiscountCoupon discountCoupon) {
		this.discountCoupon = discountCoupon;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
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
	public String getDiscountCouponId() {
		return discountCouponId;
	}
	public void setDiscountCouponId(String discountCouponId) {
		this.discountCouponId = discountCouponId;
	}
	public String getIspass() {
		return ispass;
	}
	public void setIspass(String ispass) {
		this.ispass = ispass;
	}
	public String getUseStatus() {
		return useStatus;
	}
	public void setUseStatus(String useStatus) {
		this.useStatus = useStatus;
	}

	public ICustomerService getCustomerService() {
		return customerService;
	}

	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}

	public ICustomerdiscountcouponService getCustomerdiscountcouponService() {
		return customerdiscountcouponService;
	}

	public void setCustomerdiscountcouponService(ICustomerdiscountcouponService customerdiscountcouponService) {
		this.customerdiscountcouponService = customerdiscountcouponService;
	}

	public IFansGroupService getFansGroupService() {
		return fansGroupService;
	}

	public void setFansGroupService(IFansGroupService fansGroupService) {
		this.fansGroupService = fansGroupService;
	}
}
