package wxmg.sendMessage.service;


import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
/**公众号发送消息信息Service接口*/
public interface IWXPublicNumberSendMsgInfoService extends IBaseService<WXPublicNumberSendMsgInfo> {
	/**回复消息**/
	public String saveReplyMessage(String wxName,String access_token, String sendMsgContent,TextMessageInfo textMessageInfo,PublicNoInfo publicNoInfo,List<GlobalRetrunCode> globalRetrunCodeList,String remark,String type);
}
