package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.UrlMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 链接消息信息Service
 * @author Administrator
 * 2014-09-05
 */
public interface IUrlMessageInfoService extends IBaseService<UrlMessageInfo> {
	public void saveOrUpdataUrlMessageInfo(UrlMessageInfo urlMessageInfo);
	public String saveReplyUrlMessage(String sendMsgContent,PublicNoInfo publicNoInfo,UrlMessageInfo urlMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList);
}
