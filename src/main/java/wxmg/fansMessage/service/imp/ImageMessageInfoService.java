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
import wxmg.fansMessage.dao.IImageMessageInfoDao;
import wxmg.fansMessage.pojo.ImageMessageInfo;
import wxmg.fansMessage.pojo.TextMessageInfo;
import wxmg.fansMessage.service.IImageMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;

/**
 * 图片消息信息Service接口实现类
 * @author Administrator
 * 2014-09-05
 */
public class ImageMessageInfoService extends BaseService<ImageMessageInfo> implements IImageMessageInfoService{
	@SuppressWarnings("unused")
	private IImageMessageInfoDao imageMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存图片消息
	public void saveOrUpadteImageMessageInfo(ImageMessageInfo imageMessageInfo,String access_token,String filepath){
		ImageMessageInfo imgi=(ImageMessageInfo)imageMessageInfoDao.getObjectSome(null," where o.msgId="+imageMessageInfo.getMsgId());
		if(imgi!=null){
			imageMessageInfo.setPicMessageInfoId(imgi.getPicMessageInfoId());
		}
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome( null," where o.toUserName= '"+imageMessageInfo.getToUserName()+"'");
		imageMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		imageMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		imageMessageInfo.setCollectFlag(0);
		imageMessageInfo.setReplyFlag(0);
		String messageFile = WXUploadForMidea.getMideaByMideaId(access_token, imageMessageInfo.getMediaId(), filepath);
		if(messageFile!=null&&!"".equals(messageFile)){
			imageMessageInfo.setCollectFlag(1);
			imageMessageInfo.setPicUrl(messageFile);
		}
		imageMessageInfoDao.saveOrUpdateObject(imageMessageInfo);
	}
	
	
	//回复消息
	public String saveReplyImageMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,ImageMessageInfo imageMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList ){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", imageMessageInfo.getFromUserName());
		jsonManMap.put("msgtype", "text");
		//定义子map
		Map<String, Object> jsonSonMap = new HashMap<String, Object>();
		jsonSonMap.put("content",sendMsgContent);
		jsonManMap.put("text", jsonSonMap);
		// 格式化map
		JSONObject jo = JSONObject.fromObject(jsonManMap);
		String strJsonMap=jo.toString();
		String strJson=WXBasicUtil.sendMessage(access_token,strJsonMap);
		String backMessage=WXGlobalreturncode.getGlobalReturnCode(strJson,globalRetrunCodeList);//判断返回值是否为错误值为空则值为正确的
		if(backMessage==null){
			WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
			wXPublicNumberSendMsgInfo2.setUserName(wxName);
			wXPublicNumberSendMsgInfo2.setFanUserName(imageMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)imageMessageInfo.getPicMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝图片消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			imageMessageInfo = (ImageMessageInfo)imageMessageInfoDao.getObjectById(imageMessageInfo.getPicMessageInfoId()+"");
			imageMessageInfo.setReplyFlag(1);
			imageMessageInfo.setReplyFlagTime(new Date());
			imageMessageInfoDao.saveOrUpdateObject(imageMessageInfo);
			return null;
		}else{
			return backMessage;
		}
	}
	
	
	public void setImageMessageInfoDao(IImageMessageInfoDao imageMessageInfoDao) {
		this.baseDao = this.imageMessageInfoDao = imageMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}
	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}
	
	
}
