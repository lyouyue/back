package wxmg.fansMessage.service.imp;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.fansMessage.dao.ILocationMessageInfoDao;
import wxmg.fansMessage.pojo.LocationMessageInfo;
import wxmg.fansMessage.service.ILocationMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
/**
 * 地理位置消息信息Service接口实现类
 * @author Administrator
 * 2014-09-05
 */
public class LocationMessageInfoService extends BaseService<LocationMessageInfo> implements ILocationMessageInfoService{
	@SuppressWarnings("unused")
	private ILocationMessageInfoDao locationMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存位置消息
	public void saveOrUpdataLocationMessageInfo(LocationMessageInfo locationMessageInfo){
		LocationMessageInfo lcmesi=(LocationMessageInfo)locationMessageInfoDao.getObjectSome(null, "where o.msgId="+locationMessageInfo.getMsgId());
		if(lcmesi!=null){
			locationMessageInfo.setLocationMessageInfoId(lcmesi.getLocationMessageInfoId());
		}
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+locationMessageInfo.getToUserName()+"'");
		locationMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		locationMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		locationMessageInfo.setCollectFlag(0);
		locationMessageInfo.setReplyFlag(0);
		locationMessageInfoDao.saveOrUpdateObject(locationMessageInfo);
	}
	
	//回复消息
	public String saveReplyLocationMessage(String sendMsgContent,PublicNoInfo publicNoInfo,LocationMessageInfo locationMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", locationMessageInfo.getFromUserName());
//		jsonManMap.put("touser", "o5HwDjz_M7GOZmVLX1erqtU4LYBQ");//测试用
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
//		System.out.println("strJsonMap="+strJsonMap);
//		WXBasicUtil.sendMessage("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ", strJsonMap);
//		String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
		String strJson=WXBasicUtil.sendMessage(access_token,strJsonMap);//测试用
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo2.setFanUserName(locationMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)locationMessageInfo.getLocationMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝地理位置消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			locationMessageInfo = (LocationMessageInfo)locationMessageInfoDao.getObjectById(locationMessageInfo.getLocationMessageInfoId()+"");
			locationMessageInfo.setReplyFlag(1);
			locationMessageInfoDao.saveOrUpdateObject(locationMessageInfo);
			return null;
		}else{
			return backMessage;
		}
		
	}
	
	
	public void setLocationMessageInfoDao(
			ILocationMessageInfoDao locationMessageInfoDao) {
		this.baseDao=this.locationMessageInfoDao = locationMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}

	
}
