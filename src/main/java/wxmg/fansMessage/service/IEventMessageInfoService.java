package wxmg.fansMessage.service;

import java.util.List;

import org.dom4j.Element;

import basic.pojo.KeyBook;
import util.service.IBaseService;
import wxmg.fansMessage.pojo.EventMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 事件消息信息Service接口   
 * @author Administrator   
 * 2014-09-05
 */
public interface IEventMessageInfoService extends IBaseService<EventMessageInfo> {
	public void saveOrUpdateEventMessageInfo(Element root,EventMessageInfo eventMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList,List<KeyBook> listKeyBook);
	public String saveReplyEvenMessage(String sendMsgContent,PublicNoInfo publicNoInfo,EventMessageInfo eventMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList);
}
