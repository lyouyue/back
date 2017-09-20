package wxmg.fansMessage.service.imp;

import it.sauronsoftware.base64.Base64;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.dom4j.Element;

import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import shop.customer.service.IShopCustomerInfoService;
import util.other.ConfigUtils;
import util.other.Utils;
import util.service.BaseService;
import util.upload.FileUploadUtil;
import wxmg.basicInfo.pojo.FansPublicno;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.basicInfo.service.IFansPublicnoService;
import wxmg.basicInfo.service.IFansUserInfoService;
import wxmg.fansMessage.dao.IEventMessageInfoDao;
import wxmg.fansMessage.pojo.EventMessageInfo;
import wxmg.fansMessage.service.IEventMessageInfoService;
import wxmg.fansMessage.service.IExpandEventMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WXGroupManager;
import wxmg.util.wx.WXUserManager;
import basic.pojo.KeyBook;

/**
 * 事件消息信息Service接口实现类
 * @author Administrator
 * 2014-09-05
 */
public class EventMessageInfoService extends BaseService<EventMessageInfo> implements IEventMessageInfoService{
	private IEventMessageInfoDao eventMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	private IFansUserInfoService fansUserInfoService;
	private IFansPublicnoService fansPublicnoService;
	private IShopCustomerInfoService shopCustomerInfoService;
	/**会员Service**/
	private ICustomerService customerService;
	private IExpandEventMessageInfoService expandEventMessageInfoService;

	//保存消息
	public void saveOrUpdateEventMessageInfo(Element root,EventMessageInfo eventMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList,List<KeyBook> listKeyBook){
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome( null," where o.toUserName= '"+eventMessageInfo.getToUserName()+"'");//得到当前公众号
		String event =eventMessageInfo.getEvent();
		if("LOCATION".equals(event)){//上报地理位置事件
//			logger.info("--------------上报地理位置事件------------------");
			/**
			 * 节省服务器开销，暂不保存
		eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);//保存事件消息表信息
		saveFansPublicNoOrFansUserInfo(access_token,eventMessageInfo,publicNoInfo,globalRetrunCodeList);//保存或更新粉丝用户表信息
			*/
		}else if("subscribe".equals(event)){//关注
//			logger.info("--------------关注------------------");
			//1 事件消息表保存一条数据
			eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);
			//2根据openId查找用户的详细信息,并且保存入库
			saveFollowFanUserInfo(access_token,eventMessageInfo,publicNoInfo,globalRetrunCodeList);
		}else if("unsubscribe".equals(event)){//取消关注事件
//			logger.info("-------------取消关注事件------------------");
			//1 事件消息表保存一条数据
			eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);//在事件表保存
			//修改粉丝用户信息表关注状态
			saveCancelFollowFanUserInfo(access_token,eventMessageInfo,publicNoInfo);
		}else if("SCAN".equals(event)){//分为未关注和已经关注两种情况 扫描带参数二维码事件
//			logger.info("-------------SCAN------------------");
			expandEventMessageInfoService.saveConfirmScanEvent(access_token, eventMessageInfo, publicNoInfo, globalRetrunCodeList);
		}else if("CLICK".equals(event)){//自定义菜单事件:点击菜单拉取消息时的事件推送
			//logger.info("-------------CLICK------------------");
			/**
			 * 节省服务器开销，暂不保存
		//1 事件消息表保存一条数据
		eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);//在事件表保存
			*/
			//2自动回复相关消息
			clickEvenReply(access_token,eventMessageInfo,listKeyBook);
		}else if("VIEW".equals(event)){//自定义菜单事件:点击菜单跳转链接时的事件推送
//			logger.info("-------------VIEW------------------");
			/**
			 * 节省服务器开销，暂不保存
		eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);//在事件表保存
			*/
		}else if("MASSSENDJOBFINISH".equals(event)){//事件信息（高级群发结果）
//			logger.info("-------------MASSSENDJOBFINISH事件信息（高级群发结果）------------------");
			/**
			 * 节省服务器开销，暂不保存
		eventMessageInfo=saveEventMessageInfo(root,eventMessageInfo);//在事件表保存
			*/
		}
	}

	//保存事件消息
	public EventMessageInfo saveEventMessageInfo(Element root,EventMessageInfo eventMessageInfo){
		String locationPrecision=root.elementText("Precision");
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome( null," where o.toUserName= '"+eventMessageInfo.getToUserName()+"'");
		eventMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		eventMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		eventMessageInfo.setCollectFlag(0);
		eventMessageInfo.setReplyFlag(0);
		eventMessageInfo.setLocationPrecision(locationPrecision);

		eventMessageInfo.setToUserName(root.elementText("ToUserName"));
		eventMessageInfo.setFromUserName(root.elementText("FromUserName"));
		eventMessageInfo.setCreateTime(Integer.parseInt(root.elementText("CreateTime")));
		eventMessageInfo.setMsgType(root.elementText("MsgType"));
		eventMessageInfo.setEvent(root.elementText("Event"));
		if(root.elementText("MsgID")!=null && !"".equals(root.elementText("MsgID"))){
			eventMessageInfo.setMsgID(Long.parseLong(root.elementText("MsgID")));
		}
		eventMessageInfo.setStatus(root.elementText("Status"));
		if(root.elementText("TotalCount")!=null && !"".equals(root.elementText("TotalCount"))){
			eventMessageInfo.setTotalCount(Integer.parseInt(root.elementText("TotalCount")));
		}
		if(root.elementText("FilterCount")!=null && !"".equals(root.elementText("FilterCount"))){
			eventMessageInfo.setFilterCount(Integer.parseInt(root.elementText("FilterCount")));
		}
		if(root.elementText("SentCount")!=null && !"".equals(root.elementText("SentCount"))){
			eventMessageInfo.setSentCount(Integer.parseInt(root.elementText("SentCount")));
		}
		if(root.elementText("ErrorCount")!=null && !"".equals(root.elementText("ErrorCount"))){
			eventMessageInfo.setErrorCount(Integer.parseInt(root.elementText("ErrorCount")));
		}
		eventMessageInfo=(EventMessageInfo)eventMessageInfoDao.saveOrUpdateObject(eventMessageInfo);
		return eventMessageInfo;
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
		fansUserInfo.setNickName(Base64.encode(jo.getString("nickname"), "UTF-8"));//需要换编码存入
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

        String rootFolder = String.valueOf(ConfigUtils.getFileUrlConfigValue("fileUploadRoot"));
        String folderName = String.valueOf(ConfigUtils.getFileUrlConfigValue("shop")) + "/" + String.valueOf(ConfigUtils.getFileUrlConfigValue("image_customer"));
		String fileRule = String.valueOf(ConfigUtils.getFileUrlConfigValue("fileRule"));
        String phoneUrl = FileUploadUtil.uploadHttpImage(fansUserInfo.getHeadimgUrl(), rootFolder, folderName, fileRule);
        //同步微信用户信息，头像与昵称
        shopCustomerInfoService.updateSyncWxInfo(fansUserInfo.getUserOpenId(), fansUserInfo.getNickName(), phoneUrl);

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


	//文本回复
	public String saveReplyEvenMessage(String sendMsgContent,PublicNoInfo publicNoInfo,EventMessageInfo eventMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", eventMessageInfo.getFromUserName());
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
//		logger.info("strJsonMap="+strJsonMap);
		String strJson=WXBasicUtil.sendMessage(access_token,strJsonMap);

		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){//为空则返回的正确值
				WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
				wXPublicNumberSendMsgInfo2.setFanUserName(eventMessageInfo.getFromUserName());
				wXPublicNumberSendMsgInfo2.setMessageInfoId((long)eventMessageInfo.getEventMessageInfoId());
				wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
				wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
				wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
				wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
				wXPublicNumberSendMsgInfo2.setRemark("粉丝事件消息回复");
				wXPublicNumberSendMsgInfo2.setSendTime(new Date());
				wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
				eventMessageInfo = (EventMessageInfo)eventMessageInfoDao.getObjectById(eventMessageInfo.getEventMessageInfoId()+"");
				eventMessageInfo.setReplyFlag(1);
				eventMessageInfoDao.saveOrUpdateObject(eventMessageInfo);
				return null;
			}else{
				return backMessage;
			}
	}

	//上报地理位置更新粉丝用户数据
	public void saveFansPublicNoOrFansUserInfo(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList){
		//更新粉丝用户信息表
		FansUserInfo fansUserInfo=(FansUserInfo)fansUserInfoService.getObjectByParams(" where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
		//判断粉丝用户表中是否存在相应数据如果有则更新如果没有则添加
		if(fansUserInfo!=null){//fansUserInfoList!=null 说明粉丝用户表中有相应数据 做更新操作
				saveFanUserInfoLocat(fansUserInfo,eventMessageInfo);//调用插入地理位置方法
		}else{//fansUserInfoList==null 做添加操作
			if(eventMessageInfo!=null){
				String strJson = WXUserManager.getUserBasicInformation(access_token,eventMessageInfo.getFromUserName() ,"zh_CN");//从微信公众平台得到粉丝信息串
				// 对strJson串的判断 看是否返回错误消息
				String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
				if(backMessage==null){//为空则返回的正确值
					JSONObject jo = JSONObject.fromObject(strJson);

					int fansGroupId=getFansGroupId(access_token,jo.getString("openid"),globalRetrunCodeList);//获取粉丝分组id
					//保存粉丝用户信息表并得到fansUserInfo
					FansUserInfo fansUserInfo2=saveFansUserInfo(jo,0,fansGroupId);
					FansUserInfo fansUserInfo3=saveFanUserInfoLocat(fansUserInfo2,eventMessageInfo);//调用插入地理位置方法
					//保存粉丝用户和公众号关联信息表
					if(fansUserInfo3.getUserId()!=null){
						saveFansPublicno(eventMessageInfo,publicNoInfo,fansUserInfo3);
					}
				}
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
	//向粉丝用户表插入地理位置并返回粉丝用户表数据
	public FansUserInfo saveFanUserInfoLocat(FansUserInfo fansUserInfo,EventMessageInfo eventMessageInfo){
		fansUserInfo.setLatitude(eventMessageInfo.getLatitude());
		fansUserInfo.setLocationPrecision(eventMessageInfo.getLocationPrecision());
		fansUserInfo.setLongitude(eventMessageInfo.getLongitude());
		fansUserInfo=(FansUserInfo)fansUserInfoService.saveOrUpdateObject(fansUserInfo);
		return fansUserInfo;
	}

	//关注后向粉丝用户信息表中插数据
	public void  saveFollowFanUserInfo(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo  publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList){
		//根据openId查找用户的详细信息,并且保存入库
		if(eventMessageInfo!=null){
			Customer customer = null;
			boolean isNew = false;
			String strJson = WXUserManager.getUserBasicInformation(access_token,eventMessageInfo.getFromUserName() ,"zh_CN");
			// 对strJson串的判断 看是否返回错误消息
			String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){//为空则返回的正确值
				JSONObject jo = JSONObject.fromObject(strJson);
				logger.info("是否关注："+jo.getString("subscribe"));
				if("1".equals(jo.getString("subscribe"))){//如果等于1则为已关注    为已关注状态时才能有详细信息
						//				List<FansUserInfo> fansUserInfoList=fansUserInfoService.findObjectsByHQL("select o from FansUserInfo o   where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
						FansUserInfo fansUserInfo =(FansUserInfo)fansUserInfoService.getObjectByParams(" where o.userOpenId='"+eventMessageInfo.getFromUserName()+"'");
						int fansGroupId=getFansGroupId(access_token,jo.getString("openid"),globalRetrunCodeList);//获取粉丝分组id
						//保存粉丝用户信息表并得到fansUserInfo
						if(fansUserInfo==null){
							fansUserInfo=saveFansUserInfo(jo,0,fansGroupId);
							//保存粉丝用户和公众号关联信息表
							if(fansUserInfo.getUserId()!=null){
								saveFansPublicno(eventMessageInfo,publicNoInfo,fansUserInfo);
							}
							//是否开启关注创建用户信息，默认不创建用户
							String isCreation = "false";
							isCreation = String.valueOf(ConfigUtils. getFileUrlConfigValue("isCreation"));
							if("true".equals(isCreation)){
								//检查用户是否为已关注用户
								int count = shopCustomerInfoService.getCount("where o.wxUserOpenId='" + fansUserInfo.getUserOpenId() + "'");
								//如果用户未关注过公众号，则新建用户
								if (count == 0) {
                                    String rootFolder = String.valueOf(ConfigUtils.getFileUrlConfigValue("fileUploadRoot"));
                                    String folderName = String.valueOf(ConfigUtils.getFileUrlConfigValue("shop")) + "/" + String.valueOf(ConfigUtils.getFileUrlConfigValue("image_customer"));
									String fileRule = String.valueOf(ConfigUtils.getFileUrlConfigValue("fileRule"));
                                    String phoneUrl = FileUploadUtil.uploadHttpImage(fansUserInfo.getHeadimgUrl(), rootFolder, folderName, fileRule);

                                    //创建用户对象
                                    customer = new Customer();
                                    customer.setLoginName(fansUserInfo.getUserOpenId());//设置用户登录名
                                    customer.setNickName(fansUserInfo.getNickName());//设置用户昵称
                                    customer.setPhotoUrl(phoneUrl);//设置复制后的微信头像
                                    
									customer = customerService.saveCustomer(customer, fansUserInfo.getUserOpenId(), fansUserInfo.getNickName(), 1);
								}
							}
							isNew = true;
							//给用户发送首次订阅自动回复消息
							expandEventMessageInfoService.sendMessageByOpenIdWithScene(access_token,customer.getCustomerId(),fansUserInfo, publicNoInfo, globalRetrunCodeList, 1, null, null);
						}else{
							fansUserInfo=saveFansUserInfo(jo,fansUserInfo.getUserId(),fansGroupId);
							//修改粉丝用户和公众号关联信息表关注状态
							if(Utils.objectIsNotEmpty(fansUserInfo)&&Utils.objectIsNotEmpty(fansUserInfo.getUserOpenId())){
								FansPublicno fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.toUserName='"+eventMessageInfo.getToUserName()+"' and o.userOpenId= '"+fansUserInfo.getUserOpenId()+"'");
								if(Utils.objectIsNotEmpty(fansPublicno)){
									fansPublicno.setSubscribeFlag(1);
									fansPublicnoService.saveOrUpdateObject(fansPublicno);
								}
							}
						}
						if(customer.getCustomerId()>0){
							//查看参数
							expandEventMessageInfoService.confirmEventSource(customer.getCustomerId(),isNew,access_token,fansUserInfo,publicNoInfo,globalRetrunCodeList,eventMessageInfo);
						}
					}
				}
			}
		}

	//取消关注修改粉丝用户信息表关注状态
	public void  saveCancelFollowFanUserInfo(String access_token,EventMessageInfo eventMessageInfo,PublicNoInfo  publicNoInfo){
		if(eventMessageInfo!=null){
			//得到粉丝用户数据
			String strJson = WXUserManager.getUserBasicInformation(access_token,eventMessageInfo.getFromUserName() ,"zh_CN");
			JSONObject jo = JSONObject.fromObject(strJson);
			//修改粉丝用户和公众号关联信息表关注状态
			FansPublicno fansPublicno=new FansPublicno();
			fansPublicno =(FansPublicno)fansPublicnoService.getObjectByParams(" where o.toUserName='"+eventMessageInfo.getToUserName()+"' and o.userOpenId= '"+jo.getString("openid")+"'");
			if(fansPublicno!=null){
				fansPublicno.setSubscribeFlag(0);
				fansPublicno=(FansPublicno)fansPublicnoService.saveOrUpdateObject(fansPublicno);
				FansUserInfo fansUserInfo=new FansUserInfo();

				//修改粉丝用户表数据
				fansUserInfo=(FansUserInfo)fansUserInfoService.getObjectByParams(" where o.userId="+fansPublicno.getUserId());
				if(fansUserInfo!=null){
					fansUserInfo.setSubscribe(Integer.parseInt(jo.getString("subscribe")));
					fansUserInfo=(FansUserInfo)fansUserInfoService.saveOrUpdateObject(fansUserInfo);
				}
			}
		}
	}

	//点击事件自动回复
	public void clickEvenReply(String access_token,EventMessageInfo eventMessageInfo,List<KeyBook> listKeyBook){
		String eventKey = eventMessageInfo.getEventKey();
		String indexKey = eventKey.substring(0,4);
		logger.info("自动回复indexKey："+indexKey);
		if("ywfs".equals(indexKey)){
			expandEventMessageInfoService.confirmClickEvent(access_token, eventMessageInfo, null, null, null);
		}else{
			//得到回复数据
			if(Utils.objectIsNotEmpty(access_token)&&Utils.objectIsNotEmpty(eventMessageInfo)&&Utils.objectIsNotEmpty(listKeyBook)&&listKeyBook.size()>0){
				for(KeyBook k:listKeyBook){
					if(k.getValue().equals(eventMessageInfo.getEventKey())){
						Map<String, Object> jsonManMap = new HashMap<String, Object>();
						jsonManMap.put("touser", eventMessageInfo.getFromUserName());
						jsonManMap.put("msgtype", "text");
						//定义子map
						Map<String, Object> jsonSonMap = new HashMap<String, Object>();
						jsonSonMap.put("content",k.getName());
						jsonManMap.put("text", jsonSonMap);
						// 格式化map
						JSONObject jo2 = JSONObject.fromObject(jsonManMap);
						String strJsonMap=jo2.toString();
						//		logger.info("strJsonMap="+strJsonMap);
						WXBasicUtil.sendMessage(access_token,strJsonMap);
					}
				}
			}
		}
	}

	public void setEventMessageInfoDao(
			IEventMessageInfoDao eventMessageInfoDao) {
		this.baseDao = this.eventMessageInfoDao = eventMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}
	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}

	public void setFansUserInfoService(IFansUserInfoService fansUserInfoService) {
		this.fansUserInfoService = fansUserInfoService;
	}

	public void setFansPublicnoService(IFansPublicnoService fansPublicnoService) {
		this.fansPublicnoService = fansPublicnoService;
	}

	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}

	public void setExpandEventMessageInfoService(
			IExpandEventMessageInfoService expandEventMessageInfoService) {
		this.expandEventMessageInfoService = expandEventMessageInfoService;
	}

	public void setShopCustomerInfoService(IShopCustomerInfoService shopCustomerInfoService) {
		this.shopCustomerInfoService = shopCustomerInfoService;
	}
}
