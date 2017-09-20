package wxmg.util.wx;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;

/**
 * 高级群发消息测试类,按照组（openId）发送
 * 
 * @author  
 * @param 
 */
public class TestAdvancedByOpenIdSendMessage {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	@Test
	//上传图文消息素材,生成多媒体id
	public  void testUploadMpnews(){
		try {
			/*
			json格式
			{
			   "articles": [
					 {
                        "thumb_media_id":"qI6_Ze_6PtV7svjolgs-rN6stStuHIjs9_DidOHaj0Q-mwvBelOXCFZiq2OsIU-p",
                        "author":"xxx",
						 "title":"Happy Day",
						 "content_source_url":"www.qq.com",
						 "content":"content",
						 "digest":"digest",
                        "show_cover_pic":"1"
					 },
					 {
                        "thumb_media_id":"qI6_Ze_6PtV7svjolgs-rN6stStuHIjs9_DidOHaj0Q-mwvBelOXCFZiq2OsIU-p",
                        "author":"xxx",
						 "title":"Happy Day",
						 "content_source_url":"www.qq.com",
						 "content":"content",
						 "digest":"digest",
                        "show_cover_pic":"0"
					 }
			   ]
			}
            //生成的多媒体：
             {"type":"news","media_id":"As8Tmgcn6tb4EaL1aIumsTPNJ7LJ4qBHI3LmR7xhos__6MGchRUAfA25u_YNqK49","created_at":1410866961}
			*/
			//添加测试数据方法,实际数据由开发人员准备
			List<WXAdvancedArticle> articleList=createArticleList();
			//1定义子map
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			jsonMap.put("articles", articleList);
			//2格式化map
			JSONObject jo = JSONObject.fromObject(jsonMap);
//			System.out.println("jo ="+jo.toString());
			String strJsonMap=jo.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String returnStrJson = WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"upload");
//		    System.out.println("returnStrJson = "+returnStrJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//上传视频素材,生成多媒体id
	public  void testUploadVideo(){
		try {
			/*
			json格式
				{
				  "media_id": "CWX-FwthUxJrWm-6lynQTBfzWInj19oaZa5ckO7WqViX3Bi1Y2Xi1Lo8L9lodQzG",
				  "title": "TITLE",
				  "description": "Description"
					}
            //生成的多媒体：
             {
				  "type":"video",
				  "media_id":"IhdaAQXuvJtGzwwc0abfXnzeezfO0NgPK6AQYShD8RQYMTtfzbLdBIQkQziv2XJc",
				  "created_at":1398848981
				}
			 */
			//添加测试数据方法,实际数据由开发人员准备
			 JSONObject jsonObject = new JSONObject();
			 jsonObject.accumulate("media_id", "CWX-FwthUxJrWm-6lynQTBfzWInj19oaZa5ckO7WqViX3Bi1Y2Xi1Lo8L9lodQzG");
			 jsonObject.accumulate("title", "标题title");
			 jsonObject.accumulate("description", "description说明");
			 
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			String returnStrJson = WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jsonObject.toString(),"uploadvideo");
//			System.out.println("returnStrJson = "+returnStrJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//1按照openid进行高级群发(文本)消息
	public  void testSendTextMessageByOpenId(){
		try {
			/*
			json格式
			{
   				"touser": ["oR5Gjjl_eiZoUpGozMo7dbBJ362A", "oR5Gjjo5rXlMUocSEXKT7Q5RQ63Q" ], 
				"msgtype": "text", 
				"text": { "content": "hello from boxer"}
		    }
				*/
			JSONObject jo1 = new JSONObject();
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("touser", "a5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("msgtype", "text");
			JSONObject jo2 = new JSONObject();
			jo2.accumulate("content", "高级群发文本消息11");
			jo1.accumulate("text", jo2);
//			System.out.println("jo ="+jo1.toString());
			String strJsonMap=jo1.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"byOpenId");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//2按照openid进行高级群发(图片)消息
	public  void testSendImageMessageByOpenId(){
		try {
			/*
			json格式
				{
				   "touser":[
				    "OPENID1",
				    "OPENID2"
				   ],
				   "image":{
				      "media_id":"BTgN0opcW3Y5zV_ZebbsD3NFKRWf6cb7OPswPi9Q83fOJHK2P67dzxn11Cp7THat"
				   },
				    "msgtype":"image"
				}

			 */
			JSONObject jo1 = new JSONObject();
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			JSONObject jo2 = new JSONObject();
			//jo2.accumulate("media_id", "uZigYy1KW4NPNas_qtOzJuM3O4v0-yVPFgdEW1A4mtOITJU2nUU48n21K4vqmCFP");
			jo2.accumulate("media_id", "HWtCJf4cFs104LgggkDn_9I5KWBDdpc4xsRKKyw9tLDiAjGLWrThjLqHUMJ2YzWh");
			jo1.accumulate("image", jo2);
			jo1.accumulate("msgtype", "image");
//			System.out.println("jo ="+jo1.toString());
			String strJsonMap=jo1.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"byOpenId");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//3按照openid进行高级群发(语音)消息
	public  void testSendVoiceMessageByOpenId(){
		try {
			/*
			json格式
				{
				   "touser":[
				    "OPENID1",
				    "OPENID2"
				   ],
				   "voice":{
				      "media_id":"mLxl6paC7z2Tl-NJT64yzJve8T9c8u9K2x-Ai6Ujd4lIH9IBuF6-2r66mamn_gIT"
				   },
				    "msgtype":"voice"
				}

			 */
			JSONObject jo1 = new JSONObject();
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			JSONObject jo2 = new JSONObject();
			jo2.accumulate("media_id", "4xQj78sWjEvH3MA38K_M21P-LP_AeUUgDvGxQ38HEYVpmWyVAKhI-DBpSpCjMMVI");
			jo1.accumulate("voice", jo2);
			jo1.accumulate("msgtype", "voice");
//			System.out.println("jo ="+jo1.toString());
			String strJsonMap=jo1.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"byOpenId");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//4按照openid进行高级群发(图文)消息,本接口不稳定
	//注意先执行上面的方法testUploadMpnews()生成，第二次生成mideaId,才能用于群发
	public  void testSendMpnewsMessageByOpenId(){
		try {
			/*
			json格式
				{
				   "touser":[
				    "OPENID1",
				    "OPENID2"
				   ],
				   "mpnews":{
				      "media_id":"123dsdajkasd231jhksad"
				   },
				    "msgtype":"mpnews"
				}

			 */
			JSONObject jo1 = new JSONObject();
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			JSONObject jo2 = new JSONObject();
			jo2.accumulate("media_id", "8_n5OOCApyFtXUnnbO2113WUssIKH3OqkXcScwkv936d6h_jPAmx2kWF115-3Ug6");
			jo1.accumulate("mpnews", jo2);
			jo1.accumulate("msgtype", "mpnews");
//			System.out.println("jo ="+jo1.toString());
			String strJsonMap=jo1.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"byOpenId");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//5按照openid进行高级群发(视频)消息,接口不稳定
	//注意，先执行 上面的testUploadVideo()方法第二次获取mideaId 作为下面的参数适用
	public  void testSendVideoMessageByOpenId(){
		try {
			/*
			json格式
			{
			   "touser":[
			    "OPENID1",
			    "OPENID2"
			   ],
			   "video":{
			      "media_id":"123dsdajkasd231jhksad",
			      "title":"TITLE",
			      "description":"DESCRIPTION"
			   },
			    "msgtype":"video"
			}

			 */
			JSONObject jo1 = new JSONObject();
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jo1.accumulate("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			JSONObject jo2 = new JSONObject();
			jo2.accumulate("media_id", "IhdaAQXuvJtGzwwc0abfXnzeezfO0NgPK6AQYShD8RQYMTtfzbLdBIQkQziv2XJc");
			//jo2.accumulate("title", "高级群发视频标题");
			jo2.accumulate("title", "aaaaaaaaaaaaaa");
			//jo2.accumulate("description", "高级群发视频介绍");
			jo2.accumulate("description", "bbbbbbbbb");
			jo1.accumulate("video", jo2);
			jo1.accumulate("msgtype", "video");
//			System.out.println("jo ="+jo1.toString());
			String strJsonMap=jo1.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, strJsonMap,"byOpenId");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//删除群发
	public  void testDeleteMessageByMsgId(){
		try {
			/*
			json格式
				{
				   "msg_id":30124
				}
			 */
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("msg_id", "2348084016");
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"deleteMessage");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	//添加多媒体测试数据方法
		private List<WXAdvancedArticle> createArticleList() {
			List<WXAdvancedArticle> articleList=new ArrayList<WXAdvancedArticle>();
			for(int i=0;i<2;i++){
				WXAdvancedArticle wXAdvancedArticle = new WXAdvancedArticle();
                wXAdvancedArticle.setThumb_media_id("S6J5p6JgrwcCeqWUT3CILTwvzT4G7YLBTKAKUg8WTLDkjDp-_O23iX9GJROPimSA");
				wXAdvancedArticle.setAuthor("wjy");
				wXAdvancedArticle.setTitle("高级群发多媒体消息标题"+i);
				wXAdvancedArticle.setContent("高级群发多媒体消息内容"+i);
				wXAdvancedArticle.setContent_source_url("www.qq.com");
				wXAdvancedArticle.setDigest("高级群发多媒体消息描述"+i);
				//1为显示，0为不显示
				wXAdvancedArticle.setShow_cover_pic("1");
				articleList.add(wXAdvancedArticle);
			}
			return articleList;
		}
}
