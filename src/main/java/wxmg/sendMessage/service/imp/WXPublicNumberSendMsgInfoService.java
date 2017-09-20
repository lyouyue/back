package wxmg.sendMessage.service.imp;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import util.other.WxBase64;
import util.service.BaseService;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.sendMessage.dao.IWXPublicNumberSendMsgInfoDao;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
/**
 * 素材图片接口实现类
 *
 */
public class WXPublicNumberSendMsgInfoService  extends BaseService  <WXPublicNumberSendMsgInfo> implements IWXPublicNumberSendMsgInfoService{
	private IWXPublicNumberSendMsgInfoDao wXPublicNumberSendMsgInfoDao;
	
	//回复消息
	@SuppressWarnings("unchecked")
	public String saveReplyMessage(String wxName,String access_token, String sendMsgContent,TextMessageInfo textMessageInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,String remark,String type){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", textMessageInfo.getFromUserName());
		jsonManMap.put("msgtype", type);
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		if("text".equals(type)){
			jsonSonMap.put("content",sendMsgContent);
		}else if("image".equals(type)){
			jsonSonMap.put("media_id",sendMsgContent);
		}
		jsonManMap.put(type, jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
		if(access_token==null){
			access_token = WXBasicUtil.getAccessToken(publicNoInfo.getAppId(), publicNoInfo.getAppSecret());
		}
		String strJson= WXBasicUtil.sendMessage(access_token,strJsonMap);
		if(globalRetrunCodeList==null){
			globalRetrunCodeList = (List<GlobalRetrunCode>) ServletActionContext.getServletContext().getAttribute("globalRetrunCodeList");
		}
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo.setUserName(wxName);
			wXPublicNumberSendMsgInfo.setFanUserName(textMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo.setMessageInfoId((long)textMessageInfo.getTextMessageInfoId());
			wXPublicNumberSendMsgInfo.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo.setSendMsgContent(WxBase64.encode(sendMsgContent));
			wXPublicNumberSendMsgInfo.setSendMsgTypeEnumId(getMsgTypeEnumIdByType(type));
			wXPublicNumberSendMsgInfo.setRemark(null==remark?"粉丝文本消息回复":WxBase64.encode(remark));
			wXPublicNumberSendMsgInfo.setSendTime(new Date());
			wXPublicNumberSendMsgInfoDao.saveOrUpdateObject(wXPublicNumberSendMsgInfo);
			return null;
		}else{
			return backMessage;
		}
	}
			
	public int getMsgTypeEnumIdByType(String type){
		int enumId = 1;
		if("text".equals(type)){
			enumId = 1;
		}else if("image".equals(type)){
			enumId = 2;
		}else if("voice".equals(type)){
			enumId = 3;
		}else if("video".equals(type)){
			enumId = 4;
		}else if("news".equals(type)){
			enumId = 9;
		}
		return enumId;
	}

	public void setwXPublicNumberSendMsgInfoDao(IWXPublicNumberSendMsgInfoDao wXPublicNumberSendMsgInfoDao) {
		this.baseDao=this.wXPublicNumberSendMsgInfoDao = wXPublicNumberSendMsgInfoDao;
	}
}
