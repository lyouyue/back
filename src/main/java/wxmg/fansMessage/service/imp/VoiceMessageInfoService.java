package wxmg.fansMessage.service.imp;

import it.sauronsoftware.base64.Base64;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



import net.sf.json.JSONObject;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WXUploadForMidea;
import wxmg.fansMessage.dao.IVoiceMessageInfoDao;
import wxmg.fansMessage.pojo.ImageMessageInfo;
import wxmg.fansMessage.pojo.VoiceMessageInfo;
import wxmg.fansMessage.service.IVoiceMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
/**
 * 语音消息信息Service接口实现类
 * @author Administrator
 * 2014-09-10
 */
public class VoiceMessageInfoService extends BaseService<VoiceMessageInfo>
		implements IVoiceMessageInfoService {
	@SuppressWarnings("unused")
	private IVoiceMessageInfoDao voiceMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存语音消息
	public void saveOrUpdataVoiceMessageInfo (VoiceMessageInfo voiceMessageInfo,String access_token,String filepath){
		VoiceMessageInfo vmi=(VoiceMessageInfo)voiceMessageInfoDao.getObjectSome(null," where o.msgId="+voiceMessageInfo.getMsgId());
		if(vmi!=null){
			voiceMessageInfo.setVoiceMessageInfoId(vmi.getVoiceMessageInfoId());
		}
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+voiceMessageInfo.getToUserName()+"'");
		voiceMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		voiceMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		voiceMessageInfo.setCollectFlag(0);
		voiceMessageInfo.setReplyFlag(0);
		String messageFile = WXUploadForMidea.getMideaByMideaId(access_token, voiceMessageInfo.getMediaId(), filepath);
		if(messageFile!=null&&!"".equals(messageFile)){
			voiceMessageInfo.setCollectFlag(1);
			voiceMessageInfo.setVoiceUrl(messageFile);
		}
		voiceMessageInfoDao.saveOrUpdateObject(voiceMessageInfo);
	}
	
	//回复消息
	public String saveReplyVoiceMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VoiceMessageInfo voiceMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", voiceMessageInfo.getFromUserName());
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
		String strJson =WXBasicUtil.sendMessage(access_token,strJsonMap);
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo2.setUserName(Base64.encode(wxName,"UTF-8"));
			wXPublicNumberSendMsgInfo2.setFanUserName(voiceMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)voiceMessageInfo.getVoiceMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝语音消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			voiceMessageInfo = (VoiceMessageInfo)voiceMessageInfoDao.getObjectById(voiceMessageInfo.getVoiceMessageInfoId()+"");
			voiceMessageInfo.setReplyFlag(1);
			voiceMessageInfo.setReplyFlagTime(new Date());
			voiceMessageInfoDao.saveOrUpdateObject(voiceMessageInfo);
			return null;
		}else{
			return backMessage;
		}
	}
	
	public void setVoiceMessageInfoDao(IVoiceMessageInfoDao voiceMessageInfoDao) {
		this.baseDao = this.voiceMessageInfoDao = voiceMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}

}
