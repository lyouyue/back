package wxmg.fansMessage.service;

import java.util.List;
import java.util.Map;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.VoiceIdentifyMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 语音识别消息信息Service接口
 * @author Administrator
 * 2014-09-06
 */
public interface IVoiceIdentifyMessageInfoService extends IBaseService<VoiceIdentifyMessageInfo> {
	
	public void saveOrUpdateVoiceIdentifyMessageInfo ( Map<Object,Object> fileUrlConfig,String accessToken,VoiceIdentifyMessageInfo voiceIdentifyMessageInfo);
	public String saveReplyVoiceIdentifyMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VoiceIdentifyMessageInfo voiceIdentifyMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList );
}
