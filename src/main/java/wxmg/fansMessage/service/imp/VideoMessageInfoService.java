package wxmg.fansMessage.service.imp;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WXUploadForMidea;
import wxmg.fansMessage.dao.IVideoMessageInfoDao;
import wxmg.fansMessage.pojo.ImageMessageInfo;
import wxmg.fansMessage.pojo.VideoMessageInfo;
import wxmg.fansMessage.service.IVideoMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
/**
 * 视频消息信息Service接口实现类
 * @author Administrator
 * 2014-09-10
 */
public class VideoMessageInfoService extends BaseService<VideoMessageInfo>
		implements IVideoMessageInfoService {
	@SuppressWarnings("unused")
	private IVideoMessageInfoDao videoMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存视频消息
	public void saveOrUpdateVideoMessageInfo(VideoMessageInfo videoMessageInfo,String access_token,String filepath){
		VideoMessageInfo vidmi=(VideoMessageInfo)videoMessageInfoDao.getObjectSome(null, " where o.msgId="+videoMessageInfo.getMsgId());
		if(vidmi!=null){
			videoMessageInfo.setVideoMessageInfoId(vidmi.getVideoMessageInfoId());
		}
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+videoMessageInfo.getToUserName()+"'");
		videoMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		videoMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		videoMessageInfo.setCollectFlag(0);
		videoMessageInfo.setReplyFlag(0);
		String messageFile = WXUploadForMidea.getMideaByMideaId(access_token, videoMessageInfo.getMediaId(),filepath);
		if(messageFile!=null&&!"".equals(messageFile)){
			videoMessageInfo.setVideoUrl(messageFile);
			videoMessageInfo.setCollectFlag(1);
		}
		videoMessageInfoDao.saveOrUpdateObject(videoMessageInfo);
	}
	
	//回复消息
	public String saveReplyVideoMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VideoMessageInfo videoMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList ){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", videoMessageInfo.getFromUserName());
//		jsonManMap.put("touser", "o5HwDjz_M7GOZmVLX1erqtU4LYBQ");//测试用
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
//		System.out.println("strJsonMap="+strJsonMap);
//		WXBasicUtil.sendMessage("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ", strJsonMap);//测试用
//		String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");//测试用
		String strJson=WXBasicUtil.sendMessage(access_token,strJsonMap);
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
			if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo2.setUserName(wxName);
			wXPublicNumberSendMsgInfo2.setFanUserName(videoMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)videoMessageInfo.getVideoMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝视频消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			videoMessageInfo = (VideoMessageInfo)videoMessageInfoDao.getObjectById(videoMessageInfo.getVideoMessageInfoId()+"");
			videoMessageInfo.setReplyFlag(1);
			videoMessageInfo.setReplyFlagTime(new Date());
			videoMessageInfoDao.saveOrUpdateObject(videoMessageInfo);
			return null;
		}else{
				return backMessage;
		}
	}
	
	public void setVideoMessageInfoDao(IVideoMessageInfoDao videoMessageInfoDao) {
		this.baseDao = this.videoMessageInfoDao = videoMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}
	
}
