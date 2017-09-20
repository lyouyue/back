package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.VoiceMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 语音消息信息Service接口
 * @author Administrator
 * 2014-09-10
 */
public interface IVoiceMessageInfoService extends IBaseService<VoiceMessageInfo> {
	public void saveOrUpdataVoiceMessageInfo (VoiceMessageInfo voiceMessageInfo,String access_token,String filepath);
	public String saveReplyVoiceMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VoiceMessageInfo voiceMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList);
}
