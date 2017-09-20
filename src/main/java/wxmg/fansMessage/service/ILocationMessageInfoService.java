package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.LocationMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 地理位置消息信息Service接口
 * @author Administrator
 * 2014-09-05
 */
public interface ILocationMessageInfoService extends IBaseService<LocationMessageInfo> {
	public void saveOrUpdataLocationMessageInfo(LocationMessageInfo locationMessageInfo);
	public String saveReplyLocationMessage(String sendMsgContent,PublicNoInfo publicNoInfo,LocationMessageInfo locationMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList);
}
