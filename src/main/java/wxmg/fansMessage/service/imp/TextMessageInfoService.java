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
import wxmg.fansMessage.dao.ITextMessageInfoDao;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.fansMessage.service.ITextMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;

/**
 * 文本消息信息表Service接口实现类
 * @author Administrator
 * 2014-09-09
 */
public class TextMessageInfoService extends BaseService<TextMessageInfo> implements ITextMessageInfoService{
	@SuppressWarnings("unused")
	private ITextMessageInfoDao wxTextMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存文本消息
	public void saveOrUpdataTextMessage (TextMessageInfo textMessageInfo){
		TextMessageInfo tmi=(TextMessageInfo)wxTextMessageInfoDao.getObjectSome(null, " where o.msgId="+textMessageInfo.getMsgId());
		if(tmi!=null){
			textMessageInfo.setTextMessageInfoId(tmi.getTextMessageInfoId());
		}
		
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+textMessageInfo.getToUserName()+"'");
		textMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		textMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		textMessageInfo.setCollectFlag(0);
		textMessageInfo.setReplyFlag(0);
		wxTextMessageInfoDao.saveOrUpdateObject(textMessageInfo);
	}
	
	//回复消息
	public String saveReplyMessage(String wxName, String sendMsgContent,TextMessageInfo textMessageInfo,PublicNoInfo publicNoInfo ,String access_token,List<GlobalRetrunCode> globalRetrunCodeList ){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", textMessageInfo.getFromUserName());
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
		String strJson=WXBasicUtil.sendMessage(access_token,strJsonMap);
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo2.setUserName(Base64.encode(wxName, "UTF-8"));//保存粉丝用户名称
			wXPublicNumberSendMsgInfo2.setFanUserName(textMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)textMessageInfo.getTextMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝文本消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			textMessageInfo = (TextMessageInfo)wxTextMessageInfoDao.getObjectById(textMessageInfo.getTextMessageInfoId()+"");
			textMessageInfo.setReplyFlag(1);
			textMessageInfo.setReplyFlagTime(new Date());
			wxTextMessageInfoDao.saveOrUpdateObject(textMessageInfo);
			return null;
		}else{
			return backMessage;
		}
	}

	public void setWxTextMessageInfoDao(ITextMessageInfoDao wxTextMessageInfoDao) {
		this.baseDao = this.wxTextMessageInfoDao = wxTextMessageInfoDao;
	}

	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}

}
