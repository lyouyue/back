package wxmg.fansMessage.service.imp;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;
import org.springframework.web.context.ServletContextAware;

import shop.customer.pojo.Customer;
import shop.customer.pojo.ShopCustomerInfo;
import shop.customer.service.ICustomerService;
import shop.customer.service.IShopCustomerInfoService;
import shop.store.service.IShopInfoService;
import util.other.Base64;
import util.other.ConfigUtils;
import util.other.DateUtil;
import util.other.Utils;
import util.other.WxBase64;
import util.service.BaseService;
import util.upload.FileTypeUtil;
import wxmg.basicInfo.pojo.FansPublicno;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.basicInfo.service.IFansPublicnoService;
import wxmg.basicInfo.service.IFansUserInfoService;
import wxmg.fansMessage.pojo.EventMessageInfo;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.fansMessage.service.IExpandEventMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
import wxmg.util.wx.CreateQrVisitingCard;
import wxmg.util.wx.HttpDownloadImage;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WXGroupManager;
import wxmg.util.wx.WXUploadForMidea;
import wxmg.util.wx.WXUserManager;
import distribution.customer.pojo.DisCustomer;
import distribution.customer.service.IDisCustomerService;

public class ExpandEventMessageInfoService extends BaseService<EventMessageInfo> implements
		IExpandEventMessageInfoService, ServletContextAware {
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	private IFansUserInfoService fansUserInfoService;
	private IDisCustomerService disCustomerService;
	private IShopCustomerInfoService shopCustomerInfoService;
	private IPublicNoInfoService publicNoInfoService;
	private ICustomerService customerService;
	private IFansPublicnoService fansPublicnoService;
	@SuppressWarnings("unused")
	private IShopInfoService shopInfoService;
	private final String SENDTEXT = "text";
	private final String SENDIMAGE = "image";
	//servlet 上下文
	private ServletContext servletContext;
	private long CardVALIDTIME = 561600000;

	/**
	 * 根据用户ID 不同场景 微信发送消息
	 * @param customerId
	 * @param scene
	 * @param sourceName
	 * @param params
	 */
	public void sendMessageByOpenIdWithcustomerIdAndScene(int customerId,int scene,String sourceName,Map<Object,Object> params){
		Customer customer = (Customer) customerService.getObjectById(customerId+"");
		FansUserInfo fansUserInfo = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId='"+customer.getLoginName()+"'");
		PublicNoInfo publicNoInfo =	(PublicNoInfo)ServletActionContext.getServletContext().getAttribute("publicNoInfo");
		String accessToken = publicNoInfoService.getToken(publicNoInfo);
		sendMessageByOpenIdWithScene(accessToken,customer.getCustomerId(), fansUserInfo, publicNoInfo, null, scene, sourceName, params);
	}
	/**
	 * 根据用户ID 指定发送内容 微信发送消息
	 * @param customerId
	 * @param sendContent
	 * @param remark
	 * @param sendType  text image
	 */
	public void sendMessageByOpenIdWithcustomerId(int customerId,String sendContent,String remark,String sendType){
		Customer customer = (Customer) customerService.getObjectById(customerId+"");
		FansUserInfo fansUserInfo = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId='"+customer.getLoginName()+"'");
		PublicNoInfo publicNoInfo =	(PublicNoInfo)ServletActionContext.getServletContext().getAttribute("publicNoInfo");
		String accessToken = publicNoInfoService.getToken(publicNoInfo);
		TextMessageInfo tmInfo = new TextMessageInfo();
		tmInfo.setFromUserName(fansUserInfo.getUserOpenId());
		tmInfo.setTextMessageInfoId(1102);
		sendMessage(accessToken, fansUserInfo, publicNoInfo, null, tmInfo, sendContent, remark, sendType);
	}

	/**
	 * 系统给微信分心粉丝发送消息不同场景设置不同发送内容
	 * @param fansUserInfo
	 * @param publicNoInfo
	 * @param globalRetrunCodeList
	 * @param scene  区分不同的场景 1 用户订阅   2 点击分享 当前用户成为谁的下级 3点击分享 谁成为谁的下级   5 微信二维码名片
	 */
	public void sendMessageByOpenIdWithScene(String access_token,int customerId,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,int scene,String sourceName,Map<Object,Object> params){
		TextMessageInfo tmInfo = new TextMessageInfo();
		tmInfo.setFromUserName(fansUserInfo.getUserOpenId());
		tmInfo.setTextMessageInfoId(1101);
		String sendContent = null,remark=null,sendType=null;
		try {
			String nickname = WxBase64.decode(fansUserInfo.getNickName());
			if(sourceName!=null&&scene!=5){
				sourceName = WxBase64.decode(sourceName);
			}
			switch (scene) {
			case 1:
				sendContent = String.valueOf(ConfigUtils. getFileUrlConfigValue("welcome"));
				remark = "系统消息：订阅提示信息";
				sendType= SENDTEXT;
				break;
			case 2:
				sendContent = "恭喜您成为"+sourceName+"的一级代言人";
				remark = "系统消息：通过分享"+nickname+"成为"+sourceName+"的下级";
				sendType= SENDTEXT;
				break;
			case 3:
				sendContent = sourceName;
				remark = "系统消息：通过分享"+sourceName+"成为"+nickname+"的下级";
				sendType= SENDTEXT;
				break;
			case 5:
				sendContent = sourceName;
				remark = "系统消息:"+nickname+"获取二维码名片";
				sendType= SENDIMAGE;
				break;
			}
			sendMessage(access_token, fansUserInfo, publicNoInfo, globalRetrunCodeList, tmInfo, sendContent, remark, sendType);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	};

	/**
	 * 微信发送消息 入口
	 * @param access_token
	 * @param fansUserInfo
	 * @param publicNoInfo
	 * @param globalRetrunCodeList
	 * @param tmInfo
	 * @param sendContent
	 * @param remark
	 * @param sendType
	 */
	public void sendMessage(String access_token,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,TextMessageInfo tmInfo,String sendContent,String remark,String sendType){
		wXPublicNumberSendMsgInfoService.saveReplyMessage(fansUserInfo.getNickName(),access_token,sendContent, tmInfo, publicNoInfo,globalRetrunCodeList,remark,sendType);
	};

	/**
	 * 扫描事件的定义
	 */
	public void saveConfirmScanEvent(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList){
		//根据openId查找用户的详细信息,并且保存入库
		if(eventMessageInfo!=null){
			String strJson = WXUserManager.getUserBasicInformation(access_token,eventMessageInfo.getFromUserName() ,"zh_CN");
			// 对strJson串的判断 看是否返回错误消息
			String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){//为空则返回的正确值
				JSONObject jo = JSONObject.fromObject(strJson);
				if("1".equals(jo.getString("subscribe"))){//如果等于1则为已关注    为已关注状态时才能有详细信息
					FansUserInfo fansUserInfo =(FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
					//获取用户ID
					ShopCustomerInfo shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.wxUserOpenId='"+ eventMessageInfo.getFromUserName()+"'");
					//Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId ="+shopCustomerInfo.getCustomerId());
					if(shopCustomerInfo==null){
						logger.info("未创建用户");
						saveFanUserInfoAndCustomer(access_token, eventMessageInfo, publicNoInfo, globalRetrunCodeList, strJson);
					}else{
						logger.info("创建用户");
						int customerId = shopCustomerInfo.getCustomerId();
						confirmEventSource(customerId,false,access_token,fansUserInfo,publicNoInfo,globalRetrunCodeList,eventMessageInfo);
					}
				}
			}
		}

	}

	/**
	 * 确定 用户关注微信来源
	 * @param eventMessageInfo
	 */
	public void confirmEventSource(int customerId,boolean isNew,String access_token,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,EventMessageInfo eventMessageInfo){
		String eventKey = eventMessageInfo.getEventKey();
		logger.info("用户关注微信来源:"+eventKey);
		if(null!=eventKey&&!"".equals(eventKey)){
			if(eventKey.contains("qrscene_")){//获取scene_id
				eventKey = eventKey.substring("qrscene_".length());
			}
			String scene = eventKey.substring(0,1);
			String sceneKey = eventKey.substring(1);
			logger.info("scene:"+scene+";sceneKey:"+sceneKey);
			if(null!=scene&&!"".equals(scene)){
				if("1".equals(scene)){//用户分享
					DisCustomer hasUpperStrata = hasUpperStrata(customerId,Integer.parseInt(sceneKey));
					if(hasUpperStrata!=null){
						sendMessageByUpperStrata(hasUpperStrata,access_token,fansUserInfo,publicNoInfo,globalRetrunCodeList);
					}
				}else{
					DisCustomer newCustomer = new DisCustomer();
					newCustomer.setCustomerId(customerId);
					newCustomer.setCreateTime(new Date());
					newCustomer = (DisCustomer) disCustomerService.saveOrUpdateObject(newCustomer);
				}
			}
		}else{
			String isCreation = String.valueOf(ConfigUtils. getFileUrlConfigValue("isCreation"));
			if("true".equals(isCreation)){
				//自己关注
				if(isNew){
					DisCustomer newCustomer = new DisCustomer();
					newCustomer.setCustomerId(customerId);
					newCustomer.setCreateTime(new Date());
					newCustomer = (DisCustomer) disCustomerService.saveOrUpdateObject(newCustomer);
				}
			}
		}
	}

	/**
	 * 上下级关系成立发送微信消息
	 * @param disCustomer
	 * @param access_token
	 * @param fansUserInfo
	 * @param publicNoInfo
	 * @param globalRetrunCodeList
	 */
	public void sendMessageByUpperStrata(DisCustomer disCustomer,String access_token,FansUserInfo fansUserInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList){
		int level1Id = disCustomer.getLevel1id();
		Customer customerYingtao = (Customer) customerService.getObjectById(level1Id+"");
		ShopCustomerInfo shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.customerId="+ customerYingtao.getCustomerId());
		FansUserInfo fansYingtao = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId ='"+shopCustomerInfo.getWxUserOpenId()+"'");
		String toName = WxBase64.decode(fansUserInfo.getNickName());
		String contents = "恭喜您,通过您的努力"+toName+"成为您的一级代言人";
		sendMessageByOpenIdWithScene(access_token,customerYingtao.getCustomerId(), fansYingtao, publicNoInfo, globalRetrunCodeList,3,WxBase64.encode(contents),null);
	/*	if(disCustomer.getLevel2id()>0){
			int level2Id = disCustomer.getLevel2id();
			Customer customerXiangjiao = (Customer) customerService.getObjectById(level2Id+"");
			FansUserInfo fansXiangjiao = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId ='"+customerXiangjiao.getLoginName()+"'");
			String name = WxBase64.decode(fansUserInfo.getNickName());
			String content ="恭喜您,通过您的努力"+name+"成为您的二级代言人";
			sendMessageByOpenIdWithScene(access_token,customerXiangjiao.getCustomerId(), fansXiangjiao, publicNoInfo, globalRetrunCodeList,3,WxBase64.encode(content),null);
		}*/
	/*	if(disCustomer.getLevel3id()>0){
			int level3Id = disCustomer.getLevel3id();
			Customer customerApple = (Customer) customerService.getObjectById(level3Id+"");
			FansUserInfo fansApple = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId ='"+customerApple.getLoginName()+"'");
			String name = WxBase64.decode(fansUserInfo.getNickName());
			String content ="恭喜您,通过您的努力"+name+"成为您的三级代言人";
			sendMessageByOpenIdWithScene(access_token,customerApple.getCustomerId(),fansApple, publicNoInfo, globalRetrunCodeList,3,WxBase64.encode(content),null);
		}*/
		sendMessageByOpenIdWithScene(access_token,disCustomer.getCustomerId(),fansUserInfo, publicNoInfo, globalRetrunCodeList,2,fansYingtao.getNickName(),null);
	}
	/**
	 * 判断 当前用户是否存在 上级推广员
	 * @param customerId 当前用户ID，targetId 分享链接
	 * @return
	 */
	public DisCustomer hasUpperStrata(int customerId,int targetId){
		if(targetId==customerId){
			return null;
		}
		DisCustomer disCustomer =  (DisCustomer) disCustomerService.getObjectByParams(" where o.customerId="+customerId);
		DisCustomer targetObj = (DisCustomer) disCustomerService.getObjectByParams(" where o.customerId="+targetId);
		if(disCustomer!=null){
			//是否有上下级
			List<DisCustomer> list = disCustomerService.findObjects(" where o.level1id="+disCustomer.getCustomerId());
			//Customer customer = (Customer) customerService.getObjectById(customerId+"");
			//ShopInfo shopInfo = (ShopInfo) shopInfoService.getObjectById(targetObj.getJMSId().intValue()+"");
			//if((disCustomer.getLevel1id()==0&&(customer.getShopInfoId()==null||(customer.getShopInfoId()!=null&&customer.getShopInfoId()==0)))&&list.size()==0&&(targetObj.getIsJMS()==1&&shopInfo!=null)){
			if((disCustomer.getLevel1id()==0)&&list.size()==0){
					disCustomer.setLevel1id(targetId);
//						if(targetObj.getLevel1id()>0){
//							disCustomer.setLevel2id(targetObj.getLevel1id());
//							if(targetObj.getLevel2id()>0){
//								disCustomer.setLevel3id(targetObj.getLevel2id());
//							}else{
//								disCustomer.setLevel3id(0);
//							}
//						}else{
					disCustomer.setLevel2id(0);
					disCustomer.setLevel3id(0);
//						}
				String sql="update dis_customer o set o.level1id='"+targetId+"' where o.customerId="+customerId;
				disCustomerService.updateBySQL(sql);
				disCustomer = (DisCustomer) disCustomerService.saveOrUpdateObject(disCustomer);
				return disCustomer;
			}else{
				sendMessageByOpenIdWithcustomerId(customerId,String.valueOf(ConfigUtils.getFileUrlConfigValue("BDJXTS")),String.valueOf(ConfigUtils.getFileUrlConfigValue("BDJXTS")), "text");
			}
			return null;
		}else{
			//新用户
			DisCustomer newCustomer = new DisCustomer();
			newCustomer.setCustomerId(customerId);
			newCustomer.setLevel1id(targetId);
			if( Utils.objectIsNotEmpty(targetObj) &&targetObj.getLevel1id()>0){
				newCustomer.setLevel2id(targetObj.getLevel1id());
				if(targetObj.getLevel2id()>0){
					newCustomer.setLevel3id(targetObj.getLevel2id());
				}else{
					newCustomer.setLevel3id(0);
				}
			}else{
				newCustomer.setLevel2id(0);
				newCustomer.setLevel3id(0);
			}
			newCustomer.setCreateTime(new Date());
			newCustomer = (DisCustomer) disCustomerService.saveOrUpdateObject(newCustomer);
			return newCustomer;
		}
	}
	/**
	 * 用户在商城上线之前已经关注过微信号 需要自动添加账号
	 */
	@Override
	public void saveFanUserInfoAndCustomer(String access_token,EventMessageInfo eventMessageInfo, PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,String weixinInfo) {
		if(weixinInfo==null){
			if(eventMessageInfo!=null){
				String strJson = WXUserManager.getUserBasicInformation(access_token,eventMessageInfo.getFromUserName() ,"zh_CN");
				// 对strJson串的判断 看是否返回错误消息
				String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
				if(backMessage==null){//为空则返回的正确值
					weixinInfo = strJson;
				}
			}
		}
		JSONObject jo = JSONObject.fromObject(weixinInfo);
		if("1".equals(jo.getString("subscribe"))){//如果等于1则为已关注    为已关注状态时才能有详细信息
			FansUserInfo fansUserInfo =(FansUserInfo)fansUserInfoService.getObjectByParams(" where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
			int fansGroupId = jo.getInt("groupid");
			//保存粉丝用户信息表并得到fansUserInfo
			if(fansUserInfo==null){
				fansUserInfo= saveFansUserInfo(jo,0,fansGroupId);
				logger.info("用户粉丝信息ID:"+fansUserInfo.getUserId());
				//保存粉丝用户和公众号关联信息表
				if(fansUserInfo.getUserId()!=null){
					saveFansPublicno(eventMessageInfo,publicNoInfo,fansUserInfo);
				}
				//新建用户
				Customer customer = new Customer();
				customer.setLoginName(fansUserInfo.getUserOpenId());
				customer.setNickName(fansUserInfo.getNickName());
				customer.setPhotoUrl(saveImage(fansUserInfo.getHeadimgUrl()));
				logger.info("粉丝头像HeadimgUrl："+fansUserInfo.getHeadimgUrl());
				customer = customerService.saveCustomer(customer,fansUserInfo.getUserOpenId(),fansUserInfo.getNickName(),1);
				//查看参数 是否是分享
				confirmEventSource(customer.getCustomerId(),true,access_token,fansUserInfo,publicNoInfo,globalRetrunCodeList,eventMessageInfo);
			}
		}
	}
	//获取粉丝用户分组id
	public int getFansGroupId(String access_token,String openId,List<GlobalRetrunCode> globalRetrunCodeList){
		JSONObject jsonObject = new JSONObject();
		jsonObject.accumulate("openid",openId);
		String sJson = WXGroupManager.postSubmit(access_token, jsonObject.toString(), "searchUserInGroup");//获取用户分组
		String baM=WXGlobalreturncode.getGlobalReturnCode(sJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		int fansGroupId=0;
		if(baM==null){
			JSONObject jo = JSONObject.fromObject(sJson);
			fansGroupId=Integer.parseInt(jo.getString("groupid"));
		}
		return fansGroupId;
	}
	private String saveImage(String photoUrl){
		//读取系统systemConfig.properties中的信息
		Map<?,?> fileUrlConfig = (Map<?,?>)ServletActionContext.getServletContext().getAttribute("fileUrlConfig");
		//定义新文件保存实际路径+配置文件systemConfig.properties中定义的文件生成目录规则：年月日
		String newImagePath = fileUrlConfig.get("shop") + "/"+ fileUrlConfig.get("image_customer") + "/"+ FileTypeUtil.getSerial(new Date(), fileUrlConfig.get("fileRule")) + "/" ;
		String savePath = fileUrlConfig.get("fileUploadRoot") + "/"+ newImagePath;
		try {
			String name = HttpDownloadImage.download(photoUrl, savePath);
			newImagePath = newImagePath+name;
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return newImagePath;
	}
	/**
	 * 自定义微信菜单点击事件
	 * 取前4位 区分定义的不同类型 wzfs的直接取出缓存中的对应的文字回复  ywfs 找出对应的业务进行处理
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void confirmClickEvent(String access_token,EventMessageInfo eventMessageInfo, PublicNoInfo publicNoInfo,
			List<GlobalRetrunCode> globalRetrunCodeList,Map<Object,Object> fileUrlConfig) {
		if(publicNoInfo==null){
			publicNoInfo = publicNoInfoService.getPublicNoInfo();
		}
		if(fileUrlConfig==null){
			//读取系统systemConfig.properties中的信息
			fileUrlConfig = (Map<Object,Object>)ServletActionContext.getServletContext().getAttribute("fileUrlConfig");
		}
		if(globalRetrunCodeList==null){
			globalRetrunCodeList = (List<GlobalRetrunCode>) ServletActionContext.getServletContext().getAttribute("globalRetrunCodeList");
		}

		String eventKey = eventMessageInfo.getEventKey();
		String indexKey = eventKey.substring(0,4);
		String modelKey = eventKey.substring(4);
		logger.info("名片modelKey："+modelKey);
		if("wzfs".equals(indexKey)){
			//回复文字信息
		}
		if("ywfs".equals(indexKey)){
			try {
				modelClickEvent(modelKey,access_token,eventMessageInfo,publicNoInfo,globalRetrunCodeList,fileUrlConfig);
			} catch (IOException e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			} catch (Exception e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}

	}

	/**
	 * 点击事件 业务处理逻辑入口
	 * @param modelKey 业务key
	 * @param access_token
	 * @param eventMessageInfo
	 * @param publicNoInfo
	 * @param globalRetrunCodeList
	 * @throws Exception
	 * @throws IOException
	 */
	public void modelClickEvent(String modelKey,String access_token,EventMessageInfo eventMessageInfo, PublicNoInfo publicNoInfo,
			List<GlobalRetrunCode> globalRetrunCodeList,Map<Object,Object> fileUrlConfig) throws IOException, Exception{
		ShopCustomerInfo shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.wxUserOpenId='"+ eventMessageInfo.getFromUserName()+"'");
		Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId="+shopCustomerInfo.getCustomerId());
		//获取二维码名片
		if("visitingCard".equals(modelKey)){
			sendVisitingCard(customer,shopCustomerInfo,access_token,eventMessageInfo,publicNoInfo,globalRetrunCodeList,fileUrlConfig);
		}
	}

	public void sendVisitingCard(Customer customer,ShopCustomerInfo shopCustomerInfo,String access_token,
		EventMessageInfo eventMessageInfo, PublicNoInfo publicNoInfo,
		List<GlobalRetrunCode> globalRetrunCodeList,Map<Object,Object> fileUrlConfig) throws IOException, Exception{
		DisCustomer disCustomer = (DisCustomer) disCustomerService.getObjectByParams(" where o.customerId="+ customer.getCustomerId());
		if(Utils.objectIsEmpty(disCustomer)){
			DisCustomer newCustomer = new DisCustomer();
			newCustomer.setCustomerId(customer.getCustomerId());
			newCustomer.setCreateTime(new Date());
			disCustomer = (DisCustomer) disCustomerService.saveOrUpdateObject(newCustomer);
		}
		// 获取明信片的地址
		if(null==disCustomer.getVisitingCard()||"".equals(disCustomer.getVisitingCard())||(!"".equals(disCustomer.getVisitingCard())&&isOverTimeCard(disCustomer.getCardOverTime()))){
			CreateQrVisitingCard cqvc = new CreateQrVisitingCard();
			String name = null;
			if(Utils.objectIsNotEmpty(shopCustomerInfo.getWxName())){
				name = new String(Base64.decodeBase64(shopCustomerInfo.getWxName().getBytes("utf-8")),"utf-8");
			}
			logger.info("微信昵称："+name);
			Date date = new Date();
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        String specifiedDay = sdf.format(date);
	        String time = DateUtil.getSpecifiedDayAfter(specifiedDay,7);
			String visitingCardPath = cqvc.createQrVisitingCard("1"+customer.getCustomerId(),fileUrlConfig.get("fileUploadRoot")+"/"+customer.getPhotoUrl(),access_token,fileUrlConfig,name, time+"之前有效",1);
			logger.info("我的名片路径："+visitingCardPath);
			disCustomer.setVisitingCard(visitingCardPath);
			disCustomer.setCardOverTime((long)(System.currentTimeMillis()+CardVALIDTIME)+"");
			disCustomerService.saveOrUpdateObject(disCustomer);
		}
		//上传到微信素材库 临时的
		String result = WXUploadForMidea.postSubmit(access_token, new File(fileUrlConfig.get("fileUploadRoot")+disCustomer.getVisitingCard()), "image");
		if(result != null){
			JSONObject resultObj = JSONObject.fromObject(result);
			String mediaId = resultObj.getString("media_id");
			FansUserInfo fansUserInfo = (FansUserInfo) fansUserInfoService.getObjectByParams(" where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
			//发送消息
			sendMessageByOpenIdWithScene(access_token,disCustomer.getCustomerId(),fansUserInfo, publicNoInfo, globalRetrunCodeList,5, mediaId,null);
		}
	}

	private boolean isOverTimeCard(String compareTime){
		long current = System.currentTimeMillis();
		long compareDate = Long.parseLong(compareTime);
		return current>=compareDate?true:false;
	}

	//保存粉丝用户信息表并返回fansUserInfo
	public FansUserInfo saveFansUserInfo(JSONObject jo,long userId,int fansGroupId){
		FansUserInfo  fansUserInfo=new FansUserInfo();
		if(userId>0){//userd>0则说明有该值 进行更新操作
			fansUserInfo.setUserId(userId);
		}
		fansUserInfo.setBindingFlag(0);
		fansUserInfo.setFansGroupId(fansGroupId);
		fansUserInfo.setHeadimgUrl(jo.getString("headimgurl"));
		fansUserInfo.setNickName(WxBase64.encode((jo.getString("nickname"))));
		fansUserInfo.setRemark(jo.getString("remark"));
		fansUserInfo.setSubscribe_time(Integer.parseInt(jo.getString("subscribe_time")));
		fansUserInfo.setSubscribe(Integer.parseInt(jo.getString("subscribe")));
		fansUserInfo.setUserOpenId(jo.getString("openid"));
		fansUserInfo.setSex(Integer.parseInt(jo.getString("sex")));
		fansUserInfo.setUserCity(jo.getString("city"));
		fansUserInfo.setUserLanguage(jo.getString("language"));
		fansUserInfo.setUserProvince(jo.getString("province"));
		fansUserInfo.setUserCountry(jo.getString("country"));
		fansUserInfo=(FansUserInfo)fansUserInfoService.saveOrUpdateObject(fansUserInfo);
		return fansUserInfo;
	}

	//保存粉丝用户和公众号关联信息表
	public void saveFansPublicno(EventMessageInfo eventMessageInfo,PublicNoInfo publicNoInfo,FansUserInfo fansUserInfo){
		FansPublicno fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.userId="+fansUserInfo.getUserId()+"  and o.publicNumberId="+publicNoInfo.getPublicNumberId());
		if(fansPublicno==null){
			FansPublicno fansPublicnoA=new FansPublicno();
			fansPublicnoA.setPublicNumberId((long)publicNoInfo.getPublicNumberId());
			fansPublicnoA.setPublicNumberName(publicNoInfo.getWxName());
			fansPublicnoA.setSubscribeFlag(1);
			fansPublicnoA.setSubscribeTime(new Date());
			fansPublicnoA.setUserOpenId(eventMessageInfo.getFromUserName());
			fansPublicnoA.setToUserName(eventMessageInfo.getToUserName());
			fansPublicnoA.setUserId(fansUserInfo.getUserId());
			fansPublicnoService.saveOrUpdateObject(fansPublicnoA);
		}
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}

	public void setFansUserInfoService(IFansUserInfoService fansUserInfoService) {
		this.fansUserInfoService = fansUserInfoService;
	}
	public void setDisCustomerService(IDisCustomerService disCustomerService) {
		this.disCustomerService = disCustomerService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}
	public void setFansPublicnoService(IFansPublicnoService fansPublicnoService) {
		this.fansPublicnoService = fansPublicnoService;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	public void setShopCustomerInfoService(
			IShopCustomerInfoService shopCustomerInfoService) {
		this.shopCustomerInfoService = shopCustomerInfoService;
	}
}
