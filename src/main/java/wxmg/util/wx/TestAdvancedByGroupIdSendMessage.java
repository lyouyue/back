package wxmg.util.wx;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;

/**
 * 高级群发消息测试类,按照组（group_Id）发送
 * 
 * @author  
 * @param 
 */
public class TestAdvancedByGroupIdSendMessage {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	@Test
	//1按照group_Id进行高级群发(文本)消息
	public  void testSendTextMessageByGroupId(){
		try {
			/*
			json格式
		    {
			   "filter":{
			      "group_id":"0"
			   },
			   "text":{
			      "content":"CONTENT"
			   },
			    "msgtype":"text"
			}
				*/
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("filter",(new JSONObject()).accumulate("group_id", "1"));
			jSONObject.accumulate("text", (new JSONObject()).accumulate("content", "hellow 大家好"));
			jSONObject.accumulate("msgtype", "text");
			
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"byGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//2按照group_Id进行高级群发(图文)消息
	public  void testSendImageMessageByGroupId(){
		try {
			/*
			json格式
				{
				   "filter":{
				      "group_id":"2"
				   },
				   "mpnews":{
				      "media_id":"123dsdajkasd231jhksad"
				   },
				    "msgtype":"mpnews"
				}
			 */
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("filter",(new JSONObject()).accumulate("group_id", "0"));
			jSONObject.accumulate("mpnews", (new JSONObject()).accumulate("media_id", "HWtCJf4cFs104LgggkDn_9I5KWBDdpc4xsRKKyw9tLDiAjGLWrThjLqHUMJ2YzWh"));
			jSONObject.accumulate("msgtype", "mpnews");
			
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"byGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//3按照group_Id进行高级群发(语音)消息
	public  void testSendVoiceMessageByGroupId(){
		try {
			/*
			json格式
				{
				   "filter":{
				      "group_id":"2"
				   },
				   "voice":{
				      "media_id":"123dsdajkasd231jhksad"
				   },
				    "msgtype":"voice"
				}

			 */
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("filter",(new JSONObject()).accumulate("group_id", "0"));
			jSONObject.accumulate("voice", (new JSONObject()).accumulate("media_id", "lU9iEq_EADSQ7tyPlc8_Gdm2FTyhY6yasTWaB79upaoxlICA2QaLEjzE_1GU8IAp"));
			jSONObject.accumulate("msgtype", "voice");
			
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"byGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//4按照group_Id进行高级群发(图片)消息
	public  void testSendMpnewsMessageByGroupId(){
		try {
			/*
			json格式
				{
				   "filter":{
				      "group_id":"2"
				   },
				   "image":{
				      "media_id":"123dsdajkasd231jhksad"
				   },
				    "msgtype":"image"
				}

			 */
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("filter",(new JSONObject()).accumulate("group_id", "0"));
			jSONObject.accumulate("image", (new JSONObject()).accumulate("media_id", "HWtCJf4cFs104LgggkDn_9I5KWBDdpc4xsRKKyw9tLDiAjGLWrThjLqHUMJ2YzWh"));
			jSONObject.accumulate("msgtype", "image");
			
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"byGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//5按照group_Id进行高级群发(视频)消息
	public  void testSendVideoMessageByGroupId(){
		try {
			/*
			json格式
			{
			   "filter":{
			      "group_id":"2"
			   },
			   "mpvideo":{
			      "media_id":"IhdaAQXuvJtGzwwc0abfXnzeezfO0NgPK6AQYShD8RQYMTtfzbLdBIQkQziv2XJc",
			   },
			    "msgtype":"mpvideo"
			}

			 */
			JSONObject jSONObject = new JSONObject();
			jSONObject.accumulate("filter",(new JSONObject()).accumulate("group_id", "0"));
			jSONObject.accumulate("mpvideo", (new JSONObject()).accumulate("media_id", "hPE5bzKrb9G6ctJT7OSfKSWm9kNoJj9D7hMgqqQsBNppBMOBI-m7flzmI1XE14oT"));
			jSONObject.accumulate("msgtype", "mpvideo");
			
//			System.out.println("jSONObject ="+jSONObject.toString());
			String jSONObjectStr=jSONObject.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
			WXAdvancedMessage.sendAdvancedGroupMessage(access_token, jSONObjectStr,"byGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	 
}
