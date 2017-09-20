package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 文本消息信息表Service接口
 * @author Administrator
 * 2014-09-05
 */
public interface ITextMessageInfoService extends IBaseService<TextMessageInfo> {
	
	public void saveOrUpdataTextMessage (TextMessageInfo textMessageInfo);
	
	public String saveReplyMessage(String wxName,String sendMsgContent,TextMessageInfo textMessageInfo,PublicNoInfo publicNoInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList );
}
