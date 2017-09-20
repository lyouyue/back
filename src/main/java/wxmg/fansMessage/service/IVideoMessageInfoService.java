package wxmg.fansMessage.service;

import java.util.List;

import util.service.IBaseService;
import wxmg.fansMessage.pojo.VideoMessageInfo;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 视频消息信息Service接口
 * @author Administrator
 * 2014-09-05
 */
public interface IVideoMessageInfoService extends IBaseService<VideoMessageInfo> {
	public void saveOrUpdateVideoMessageInfo(VideoMessageInfo videoMessageInfo,String access_token,String filepath);
	public String saveReplyVideoMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VideoMessageInfo videoMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList );
}
