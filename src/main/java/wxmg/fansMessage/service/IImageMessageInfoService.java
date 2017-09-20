package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.ImageMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 图片消息信息Service接口	
 * @author Administrator
 * 2014-09-05
 */
public interface IImageMessageInfoService extends IBaseService<ImageMessageInfo> {
	public void saveOrUpadteImageMessageInfo(ImageMessageInfo imageMessageInfo,String access_token,String filepath);
	public String saveReplyImageMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,ImageMessageInfo imageMessageInfo ,String access_token,List<GlobalRetrunCode> globalRetrunCodeList);
}
