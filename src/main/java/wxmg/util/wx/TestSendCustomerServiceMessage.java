package wxmg.util.wx;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;

/**
 * 发送客服消息测试类及demo
 * 
 * @author  
 * @param 1发送文本消息text 2 发送图片消息image 3 发送语音消息voice 4 发送视频消息video 5 发送音乐消息music 6 发送图文消息news
 * 1执行：wxBasicUitl.java main方法获取access_token
 * TZxryDykThOQYnlTsQmXRK9PRPWU2IUxcIKr6oqzKH5m9h-6aabAT3YoddBOYR5V0t-x99W7raty8Fbhlv4AJQ
 * 2上传多媒体访问路径：
 * https://mp.weixin.qq.com/debug/cgi-bin/apiinfo?t=index&type=%E5%9F%BA%E7%A1%80%E6%94%AF%E6%8C%81&form=%E5%A4%9A%E5%AA%92%E4%BD%93%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0%E6%8E%A5%E5%8F%A3%20/media/upload
 */
public class TestSendCustomerServiceMessage {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	@Test
	//1发送文本消息text
	public  void testSendTextMessage(){
		try {
			/*
			String strJson = "{\"touser\" :\"o5HwDj1bG3nl7RHBwXNjsqJubkmI\",";
			strJson += "\"msgtype\":\"text\",";
			strJson += "\"text\":{";
			strJson += "\"content\":\"Hello World123 中国\"";
			strJson += "}}";
			strJson = new String(strJson.getBytes(), "utf-8");
//			System.out.println("strJson1="+strJson);
			WXBasicUtil.sendMessage("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ", strJson);
			//发送的json格式
			{
			    "touser":"OPENID",
			    "msgtype":"text",
			    "text":
			    {
			         "content":"Hello World"
			    }
			}
			*/
			//另一种处理方式,这个与接口的json串顺序不一样，但是不影响使用。
			// 定义主map
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", "o5HwDjz_M7GOZmVLX1erqtU4LYBQ");
			jsonManMap.put("msgtype", "text");
			//定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			jsonSonMap.put("content", "Hello World12中国1234");
			jsonManMap.put("text", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
//			System.out.println("strJsonMap="+strJsonMap);
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String jsonString = WXBasicUtil.sendMessage(access_token, strJsonMap);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//2发送图片消息image
	public  void testSendImageMessage(){
		try {
			// 定义主map
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonManMap.put("msgtype", "image");
			//定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			//三天后失效
			//jsonSonMap.put("media_id", "ZdVmlMTIRibFQEl791Y9CfgRDbbmGCwDNGZs79262EJa7N_O48gDbLgsz7qfQlIm");
			jsonSonMap.put("media_id", "5UNndtkNC9nB8f7lyovQcVfEReopSJ3lfipB2D_fOzAeJlmePJCJ0fmaZoUkAy8W");
			jsonManMap.put("image", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXBasicUtil.sendMessage(access_token, strJsonMap);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//3发送语音消息voice
	public  void testSendVoiceMessage(){
		try {
			// 定义主map
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonManMap.put("msgtype", "voice");
			//定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			jsonSonMap.put("media_id", "-GfTupytP6VLlbpxTDUsdcVsKrBUCtDLsdHiVptDUnkDWnA0OS_0gIOOZEosDnOr");//三天后失效
			jsonManMap.put("voice", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXBasicUtil.sendMessage(access_token, strJsonMap);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	// 4 发送视频消息video
	public  void testSendVoideoMessage(){
		try {
			/* json格式
			{
			    "touser": "o5HwDj1bG3nl7RHBwXNjsqJubkmI", 
			    "msgtype": "video", 
			    "video": {
			        "media_id": "TZxryDykThOQYnlTsQmXRK9PRPWU2IUxcIKr6oqzKH5m9h-6aabAT3YoddBOYR5V0t-x99W7raty8Fbhlv4AJQ", 
			        "thumb_media_id": "e1olugniIy2uKeSwvMh-qRMogQk4TtxSgTUdWvt-vRkFIBBdKZ7FugTO1aQgSRKX", 
			        "title": "标题", 
			        "description": "说明"
			    }
			}
			 {
				 "msgtype":"video",
				 "touser":"o5HwDj1bG3nl7RHBwXNjsqJubkmI",
				 "video":{
				          "title":"wodeshipin",
				          "thumb_media_id":"e1olugniIy2uKeSwvMh-qRMogQk4TtxSgTUdWvt-vRkFIBBdKZ7FugTO1aQgSRKX",
				          "description":"very good!!",
				          "media_id":"T8U0TAvFt_YIjW0DL6Bibc9cfQrwKXzYauzL4wMOepIpu2D5mKROV5xvuAmbpzfU"
				          }
			   }

			*/
			Map<String, Object> jsonManMap = new HashMap<String, Object>();// 定义主map
			jsonManMap.put("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonManMap.put("msgtype", "video");
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();//定义子map
			//三天后失效
			//jsonSonMap.put("media_id", "T8U0TAvFt_YIjW0DL6Bibc9cfQrwKXzYauzL4wMOepIpu2D5mKROV5xvuAmbpzfU");
			jsonSonMap.put("media_id", "jqT9oVo7gh4MLoBc0t5esvGVLGajrqQ23W0rf1689lugk0cocCHuZnksIBTsFamC");
			//注意这个媒体id必须是图片的，不能填写与上面一样的视频媒体id，可选
			jsonSonMap.put("thumb_media_id", "e1olugniIy2uKeSwvMh-qRMogQk4TtxSgTUdWvt-vRkFIBBdKZ7FugTO1aQgSRKX");
			//可选
			jsonSonMap.put("title", "客服消息视频");
			//可选
			jsonSonMap.put("description", "视频介绍");
			jsonManMap.put("video", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
//			System.out.println("strJsonMap = "+strJsonMap);
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXBasicUtil.sendMessage(access_token, strJsonMap);
			
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	// 5 发送音乐消息music,发送成功不能播放（测试窗口和本方法）
	public  void testSendMusicMessage(){
		try {
			/* 音乐 json格式
			{
			    "touser":"OPENID",
			    "msgtype":"music",
			    "music":
			    {
			      "title":"MUSIC_TITLE",
			      "description":"MUSIC_DESCRIPTION",
			      "musicurl":"MUSIC_URL",
			      "hqmusicurl":"HQ_MUSIC_URL",
			      "thumb_media_id":"THUMB_MEDIA_ID" 
			    }
			}
			*/
			// 定义主map
			Map<String, Object> jsonManMap = new HashMap<String, Object>();
			jsonManMap.put("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonManMap.put("msgtype", "music");
			//定义子map
			Map<String, Object> jsonSonMap = new HashMap<String, Object>();
			jsonSonMap.put("title", "小苹果");
			jsonSonMap.put("description", "筷子兄弟演唱");
			jsonSonMap.put("musicurl", "http://wxsj.shopjsp.com/xiaopinguo.mp3");
			jsonSonMap.put("hqmusicurl", "hqmusicurl");
			jsonSonMap.put("thumb_media_id", "e1olugniIy2uKeSwvMh-qRMogQk4TtxSgTUdWvt-vRkFIBBdKZ7FugTO1aQgSRKX");
			
			jsonManMap.put("music", jsonSonMap);
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonManMap);
			String strJsonMap=jo.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXBasicUtil.sendMessage(access_token, strJsonMap);
			
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	// 6 发送图文消息news
	public  void testSendNewsMessage(){
		/* 图文消息 json格式
		{
		    "touser":"OPENID",
		    "msgtype":"news",
		    "news":{
		        "articles": [
		         {
		             "title":"Happy Day",
		             "description":"Is Really A Happy Day",
		             "url":"URL",
		             "picurl":"PIC_URL"
		         },
		         {
		             "title":"Happy Day",
		             "description":"Is Really A Happy Day",
		             "url":"URL",
		             "picurl":"PIC_URL"
		         }
		         ]
		    }
		}

		*/
		try {
			//添加测试数据方法,实际数据由开发人员准备
			List<WxArticle> articleList=createArticleList();
			//图文消息条数限制在10条以内，注意，如果图文数超过10，则将会无响应。
			if(articleList!=null&&articleList.size()<10){
				//1定义子map
				Map<String, Object> jsonSonMap = new HashMap<String, Object>();
				jsonSonMap.put("articles", articleList);
				//2定义主map
				Map<String, Object> jsonManMap = new HashMap<String, Object>();
				jsonManMap.put("touser", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
				jsonManMap.put("msgtype", "news");
				jsonManMap.put("news", jsonSonMap);
				//3格式化map
				JSONObject jo = JSONObject.fromObject(jsonManMap);
				String strJsonMap=jo.toString();
//				System.out.println("********strJsonMap = "+strJsonMap);
				String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
				WXBasicUtil.sendMessage(access_token, strJsonMap);
			} else{
//				System.out.println("数据不能大于10条，请重新发送！此方法不能做判断处理返回，由开发人员再业务部分处理");
			}
				
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	//添加图文测试数据方法
	private List<WxArticle> createArticleList() {
		List<WxArticle> articleList=new ArrayList<WxArticle>();
		for(int i=0;i<3;i++){
			WxArticle wxArticle = new WxArticle();
			wxArticle.setTitle("Happy Day"+i);
			wxArticle.setDescription("Is Really A Happy Day"+i);
			wxArticle.setUrl("www.shopjsp.com");
			wxArticle.setPicurl("http://www.shopjsp.com/Public/upload/m_5257823e108f8.jpg");
			articleList.add(wxArticle);
		}
		return articleList;
	}
}
