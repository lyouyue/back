package wxmg.fansMessage.service.imp;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.product.service.IProductInfoService;
import util.other.Utils;
import util.service.BaseService;
import wxmg.fansMessage.dao.IVoiceIdentifyMessageInfoDao;
import wxmg.fansMessage.pojo.VoiceIdentifyMessageInfo;
import wxmg.fansMessage.service.IVoiceIdentifyMessageInfoService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
import wxmg.sendMessage.pojo.WXPublicNumberSendMsgInfo;
import wxmg.sendMessage.service.IWXPublicNumberSendMsgInfoService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.util.wx.WXGlobalreturncode;
import wxmg.util.wx.WxArticle;
/**
 * 语音识别消息信息Service接口实现类
 * @author Administrator
 * 2014-09-10
 */
public class VoiceIdentifyMessageInfoService extends BaseService<VoiceIdentifyMessageInfo> implements
IVoiceIdentifyMessageInfoService {
	private IVoiceIdentifyMessageInfoDao voiceIdentifyMessageInfoDao;//语音识别消息表dao
	private IPublicNoInfoService publicNoInfoService;//公众号表
	private IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService;//公众号发送消息表Service
	private IProductInfoService productInfoService;//套餐表Service
	//保存语音识别消息
	public void saveOrUpdateVoiceIdentifyMessageInfo ( Map<Object,Object> fileUrlConfig,String accessToken,VoiceIdentifyMessageInfo voiceIdentifyMessageInfo){
		if(Utils.objectIsNotEmpty(voiceIdentifyMessageInfo)){
			VoiceIdentifyMessageInfo vimi=(VoiceIdentifyMessageInfo)voiceIdentifyMessageInfoDao.getObjectSome(null," where o.msgId="+voiceIdentifyMessageInfo.getMsgId());
			String title = voiceIdentifyMessageInfo.getRecognition();
			//过滤语音识别中标点符号
			title = title.replaceAll("[\\pP\\p{Punct}]", " ");
			title = title.trim();
			List<WxArticle> articleList=createArticleList(fileUrlConfig,title);//得到图文数据集合
			sendNewsMessage(voiceIdentifyMessageInfo,articleList,accessToken);//调用自动回复图文消息
			if(vimi!=null){//保存语音识别消息
				voiceIdentifyMessageInfo.setVoiceIdentifyMessageInfoId(vimi.getVoiceIdentifyMessageInfoId());
			}
			PublicNoInfo publicNoInfo=(PublicNoInfo)publicNoInfoService.getObjectSome(null," where o.toUserName= '"+voiceIdentifyMessageInfo.getToUserName()+"'");
			voiceIdentifyMessageInfo.setRecognition(title);
			voiceIdentifyMessageInfo.setPublicNumberId(publicNoInfo.getPublicNumberId());
			voiceIdentifyMessageInfo.setPublicNumberName(publicNoInfo.getWxName());
			voiceIdentifyMessageInfo.setCollectFlag(0);
			voiceIdentifyMessageInfo.setReplyFlag(0);
			voiceIdentifyMessageInfoDao.saveOrUpdateObject(voiceIdentifyMessageInfo);
		}
	}

//添加图文数据方法
private List<WxArticle> createArticleList(Map<Object,Object> fileUrlConfig,String title) {
	//获取查询结果10条
	List<Map<String,Object>> productInfoList=productInfoService.findListMapBySql("select productId,productFullName,productTypeId,productName,logoImg,describle from shop_productinfo where productName like '%"+title+"%' and isPutSale=2 and isPass=1 order by productId desc limit 10");
	List<WxArticle> articleList=new ArrayList<WxArticle>();//创建图文数据集合
	if(productInfoList!=null&&!"".equals(productInfoList)&&productInfoList.size()>0){
		int size=productInfoList.size();
		for(int i=0;i<size;i++){//循环放入图文集合中
			WxArticle wxArticle = new WxArticle();
			wxArticle.setTitle(productInfoList.get(i).get("productFullName").toString());
			//wxArticle.setDescription(productInfoList.get(i).get("describle").toString());
			wxArticle.setUrl(fileUrlConfig.get("phoneBasePath")+"/"+"phone/gotoProductInfo.action?productId="+productInfoList.get(i).get("productId"));
			wxArticle.setPicurl(fileUrlConfig.get("uploadFileVisitRoot")+productInfoList.get(i).get("logoImg").toString());
			articleList.add(wxArticle);
		}
	}
	return articleList;
}

//回复文本消息
public String saveReplyVoiceIdentifyMessage(String wxName,String sendMsgContent,PublicNoInfo publicNoInfo,VoiceIdentifyMessageInfo voiceIdentifyMessageInfo,String access_token,List<GlobalRetrunCode> globalRetrunCodeList ){
	Map<String, Object> jsonManMap = new HashMap<String, Object>();
	jsonManMap.put("touser", voiceIdentifyMessageInfo.getFromUserName());
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
		if(backMessage==null){//添加对象中的其他数据
		WXPublicNumberSendMsgInfo wXPublicNumberSendMsgInfo2 = new WXPublicNumberSendMsgInfo();
		wXPublicNumberSendMsgInfo2.setUserName(wxName);
		wXPublicNumberSendMsgInfo2.setFanUserName(voiceIdentifyMessageInfo.getFromUserName());
		wXPublicNumberSendMsgInfo2.setMessageInfoId((long)voiceIdentifyMessageInfo.getVoiceIdentifyMessageInfoId());
		wXPublicNumberSendMsgInfo2.setPublicNumberName(publicNoInfo.getWxName());
		wXPublicNumberSendMsgInfo2.setPublicNumberIdBigint((long)publicNoInfo.getPublicNumberId());
		wXPublicNumberSendMsgInfo2.setSendMsgContent(sendMsgContent);
		wXPublicNumberSendMsgInfo2.setSendMsgTypeEnumId(1);
		wXPublicNumberSendMsgInfo2.setRemark("粉丝语音识别消息回复");
		wXPublicNumberSendMsgInfo2.setSendTime(new Date());
		wXPublicNumberSendMsgInfoService.saveOrUpdateObject(wXPublicNumberSendMsgInfo2);
		voiceIdentifyMessageInfo = (VoiceIdentifyMessageInfo)voiceIdentifyMessageInfoDao.getObjectById(voiceIdentifyMessageInfo.getVoiceIdentifyMessageInfoId()+"");
		voiceIdentifyMessageInfo.setReplyFlag(1);
		voiceIdentifyMessageInfo.setReplyFlagTime(new Date());
		voiceIdentifyMessageInfoDao.saveOrUpdateObject(voiceIdentifyMessageInfo);
		return null;
	}else{
		return backMessage;
	}
}


//自动回复图文消息
public void sendNewsMessage(VoiceIdentifyMessageInfo voiceIdentifyMessageInfo ,List<WxArticle> articleList,String access_token){// voiceIdentifyMessageInfo粉丝用户发送的消息  articleLit为发送的数据不超过10条
//	System.out.println("回复图文消息--------"+voiceIdentifyMessageInfo.getFromUserName());
	try {
		//图文消息条数限制在10条以内，注意，如果图文数超过10，则将会无响应。
		if(Utils.collectionIsNotEmpty(articleList)&&articleList.size()<=10&&articleList.size()>0){
			//1定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			jsonSonMap.put("articles", articleList);
			//2定义主map
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", voiceIdentifyMessageInfo.getFromUserName());
			jsonManMap.put("msgtype", "news");
			jsonManMap.put("news", jsonSonMap);
			//3格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
			//System.out.println("********strJsonMap = "+strJsonMap);
			WXBasicUtil.sendMessage(access_token, strJsonMap);
		} else{
//			System.out.println("数据不能大于10条，请重新发送！此方法不能做判断处理返回，由开发人员再业务部分处理");
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", voiceIdentifyMessageInfo.getFromUserName());
			jsonManMap.put("msgtype", "text");
			//定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			String recognition = voiceIdentifyMessageInfo.getRecognition();
			//过滤语音识别中标点符号
			recognition = recognition.replaceAll("[\\pP\\p{Punct}]", " ");
			recognition = recognition.trim();
			jsonSonMap.put("content","没有找到关于“"+recognition+"”的套餐");
			jsonManMap.put("text", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
//			System.out.println("strJsonMap="+strJsonMap);
			WXBasicUtil.sendMessage(access_token,strJsonMap);
		}
			
	} catch (Exception e) {
		String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
	}

}

public void setVoiceIdentifyMessageInfoDao(IVoiceIdentifyMessageInfoDao voiceIdentifyMessageInfoDao) {
	this.baseDao=this.voiceIdentifyMessageInfoDao = voiceIdentifyMessageInfoDao;
}
public void setPublicNoInfoService(IPublicNoInfoService publicNoInfoService) {
	this.publicNoInfoService = publicNoInfoService;
}

public void setwXPublicNumberSendMsgInfoService(
	IWXPublicNumberSendMsgInfoService wXPublicNumberSendMsgInfoService) {
	this.wXPublicNumberSendMsgInfoService = wXPublicNumberSendMsgInfoService;
}

public void setProductInfoService(IProductInfoService productInfoService) {
	this.productInfoService = productInfoService;
}

}
