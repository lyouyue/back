package wxmg.util.wx;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;

import util.other.Utils;
/**
 * 测试用户管理工具类
 */
public class TestUserManager {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	@Test
	//测试得到用户基本信息
	public  void testGetUserBasicInformation(){
		try {
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			//param appId、appSecret、openId、lang(zh_CN 简体，zh_TW 繁体，en 英语)
			String strJson = WXUserManager.getUserBasicInformation(access_token, "o5HwDj1bG3nl7RHBwXNjsqJubkmI","zh_CN");
//		    System.out.println(strJson);
			JSONObject jo = JSONObject.fromObject(strJson);
		    //展示所有的字段，根据需要把这里的字段保存到我们的数据库
//		    System.out.println("jo = "+jo);
//		    System.out.println("jo subscribe = "+jo.getString("subscribe"));
//		    System.out.println("jo openid = "+jo.getString("openid"));
//		    System.out.println("jo nickname = "+jo.getString("nickname"));
//		    System.out.println("jo sex = "+jo.getString("sex"));
//		    System.out.println("jo headimgurl = "+jo.getString("headimgurl"));
//		    System.out.println("jo openid = "+jo.getString("subscribe_time"));
//		    System.out.println("jo remark = "+jo.getString("remark"));
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//设置用户备注
	public  void testSetUserRemark(){
		try {
			/*json格式
			 {
				"openid":"oDF3iY9ffA-hqb2vVvbr7qxf6A0Q",
				"remark":"pangzi"
			}
			 */
			// 定义map
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			jsonMap.put("openid", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonMap.put("remark", "wenjianying");
			// 格式化map
			JSONObject jo = JSONObject.fromObject(jsonMap);
			String strJsonMap=jo.toString();
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXUserManager.setUserRemark(access_token,strJsonMap );
//			System.out.println("strJson = "+strJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	
	//测试获得用户列表
	@Test
	public void testGetUserList(){
		try {
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			//param appId、appSecret、openId、lang(zh_CN 简体，zh_TW 繁体，en 英语)
			String access_token="VY1DrNayK-OE_ZH_mJSNc_jAqcbIXPktKGtwqpC8Cpg_Lcahau_VGt3yYfIsCOVKADyvyqFE-YmRpvQIGvrFLPIMtSHNOn29o66_d0f47DQ";
			String strJson = WXUserManager.getUserList(access_token, "");
		    System.out.println(strJson);
			JSONObject jo = JSONObject.fromObject(strJson);
			//获得openid数组
			if(Utils.objectIsNotEmpty(jo.getString("data"))){
				String openStr=jo.getString("data").substring(jo.getString("data").indexOf("[")+1,jo.getString("data").indexOf("]") );
				System.out.println(openStr);
				String [] openIdArray=openStr.replaceAll("\"", "").split(",");
				System.out.println(openIdArray.length);
			}
		    //展示所有的字段，根据需要把这里的字段保存到我们的数据库
//		    System.out.println("jo = "+jo);
//		    System.out.println("jo subscribe = "+jo.getString("data"));
//		    System.out.println("jo openid = "+jo.getString("total"));
//		    System.out.println("jo nickname = "+jo.getString("count"));
//		    System.out.println("jo sex = "+jo.getString("next_openid"));
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
}
