package wxmg.fansMessage.service.imp;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.fansMessage.dao.IUrlMessageInfoDao;
import wxmg.fansMessage.pojo.ImageMessageInfo;
import wxmg.fansMessage.pojo.UrlMessageInfo;
import wxmg.fansMessage.service.IUrlMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
/**
 * 链接消息信息Service实现类
 * @author Administrator
 * 2014-09-09
 */
public class UrlMessageInfoService extends BaseService<UrlMessageInfo> implements IUrlMessageInfoService{
	@SuppressWarnings("unused")
	private IUrlMessageInfoDao urlMessageInfoDao;
	private IPublicNoInfoService publicNoInfoService;
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;
	
	//保存链接消息
	public void saveOrUpdataUrlMessageInfo(UrlMessageInfo urlMessageInfo){
		UrlMessageInfo urlmi=(UrlMessageInfo)urlMessageInfoDao.getObjectSome(null, " where o.msgId="+urlMessageInfo.getMsgId());
		if(urlmi!=null){
			urlMessageInfo.setUrlMessageInfoId(urlmi.getUrlMessageInfoId());
		}
		PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+urlMessageInfo.getToUserName()+"'");
		urlMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
		urlMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
		urlMessageInfo.setCollectFlag(0);
		urlMessageInfo.setReplyFlag(0);
		urlMessageInfoDao.saveOrUpdateObject(urlMessageInfo);
	}
	
	//回复消息
	public String saveReplyUrlMessage(String sendMsgContent,PublicNoInfo publicNoInfo,UrlMessageInfo urlMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList){
		Map<String, Object> jsonManMap = new HashMap<String, Object>();
		jsonManMap.put("touser", urlMessageInfo.getFromUserName());
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
			wXPublicNumberSendMsgInfo2.setFanUserName(urlMessageInfo.getFromUserName());
			wXPublicNumberSendMsgInfo2.setMessageInfoId((long)urlMessageInfo.getUrlMessageInfoId());
			wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
			wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
			wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
			wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
			wXPublicNumberSendMsgInfo2.setRemark("粉丝链接消息回复");
			wXPublicNumberSendMsgInfo2.setSendTime(new Date());
			wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
			urlMessageInfo = (UrlMessageInfo)urlMessageInfoDao.getObjectById(urlMessageInfo.getUrlMessageInfoId()+"");
			urlMessageInfo.setReplyFlag(1);
			urlMessageInfoDao.saveOrUpdateObject(urlMessageInfo);
			return null;
		}else{
			return backMessage;
		}
	}
	
	public void setUrlMessageInfoDao(IUrlMessageInfoDao urlMessageInfoDao) {
		this.baseDao = this.urlMessageInfoDao = urlMessageInfoDao;
	}
	public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
		this.publicNoInfoService = publicNoInfoService;
	}

	public void setwXPublicNumberSendMsgInfoService(
			IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
		this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
	}
	
}
