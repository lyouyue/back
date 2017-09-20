package wxmg.util.wx;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.junit.Test;

import wxmg.basicInfo.pojo.FansGroup;

/**
 * 测试组管理工具类
 */
public class TestWXGroupManager {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	@Test
	//查询所有分组
	public  void testSearchAllGroups(){
		try {
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXGroupManager.searchAllGroups(access_token);
//			System.out.println("strJson = "+strJson);
			JSONObject fromObject = JSONObject.fromObject(strJson);
			Object object = fromObject.get("groups");
			JSONArray fromObject2 = JSONArray.fromObject(object);
			//json数组转换成 对象的集合
			List<FansGroup> fansGroupList = new ArrayList<FansGroup>();
			for(Object obj:fromObject2){
				FansGroup fansGroup = new FansGroup();
				JSONObject fromObject3 = JSONObject.fromObject(obj);
				fansGroup.setId( Integer.parseInt(fromObject3.getString("id")));
				fansGroup.setName(fromObject3.getString("name"));
				fansGroup.setCount(Integer.parseInt(fromObject3.getString("count")));
				fansGroupList.add(fansGroup);
			}
//			System.out.println("fansGroupList = "+fansGroupList);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//创建分组
	public  void testCreateGroup(){
		try {
			/*
			 * {
				    "group": {
				        "id": 107, 
				        "name": "test"
				    }
				}
			 */
			 JSONObject jsonObject = new JSONObject();
			 jsonObject.accumulate("id", 102);
			 jsonObject.accumulate("name", "testGroup12");
			 JSONObject jsonObject2 = new JSONObject();
			 jsonObject2.accumulate("group", jsonObject);
			 JSONObject jsonObject3 = JSONObject.fromObject(jsonObject2);
//			 System.out.println("***********jsonObject3 ="+jsonObject3);
			 String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			 WXGroupManager.postSubmit(access_token, jsonObject3.toString(), "createGroup");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//查询用户所在分组
	public  void testSerachUserInGroup(){
		try {
			/*json格式
			 * {"openid":"od8XIjsmk6QdVTETa9jLtGWA6KBc"}
			 */
			JSONObject jsonObject = new JSONObject();
			jsonObject.accumulate("openid", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
//			System.out.println("***********jsonObject.toString() ="+jsonObject.toString());
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXGroupManager.postSubmit(access_token, jsonObject.toString(), "searchUserInGroup");
//			System.out.println("***********strJson="+strJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//修改分组名称
	public  void testUpdateGroupName(){
		try {
			/*json格式
			 * {"group":{"id":108,"name":"test2_modify2"}}
			 */
			JSONObject jsonObject = new JSONObject();
			jsonObject.accumulate("id", "112");
			jsonObject.accumulate("name", "aaabb中国");
			JSONObject jsonObject2 = new JSONObject();
			jsonObject2.accumulate("group", jsonObject);
//			System.out.println("***********jsonObject2.toString() ="+jsonObject2.toString());
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXGroupManager.postSubmit(access_token, jsonObject2.toString(), "updateGroupName");
//			System.out.println("***********strJson="+strJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//移动用户所在分组
	public  void testMoveUserGroup(){
		try {
			/*json格式
			 * {"openid":"oDF3iYx0ro3_7jD4HFRDfrjdCM58","to_groupid":108}
			 */
			JSONObject jsonObject = new JSONObject();
			jsonObject.accumulate("openid", "o5HwDj1bG3nl7RHBwXNjsqJubkmI");
			jsonObject.accumulate("to_groupid", "1");
//			System.out.println("***********jsonObject.toString() ="+jsonObject.toString());
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			String strJson = WXGroupManager.postSubmit(access_token, jsonObject.toString(), "moveUserGroup");
//			System.out.println("***********strJson="+strJson);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
}
