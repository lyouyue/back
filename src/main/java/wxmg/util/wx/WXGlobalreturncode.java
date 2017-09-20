package wxmg.util.wx;

import java.util.List;

import javax.servlet.ServletContext;

import net.sf.json.JSONObject;

import org.springframework.web.context.ServletContextAware;






import util.action.BaseAction;
//import net.sf.json.JSONArray;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;

public class WXGlobalreturncode extends BaseAction{
	private static final long serialVersionUID = -8988954502724648636L;
	public static  String getGlobalReturnCode(String stringJson,List<GlobalRetrunCode> globalRetrunCodeList) {
		
		JSONObject jo = JSONObject.fromObject(stringJson);
		if(jo.containsKey("created_at")){//上传多媒体
			return null;
		}else if(jo.containsKey("subscribe")){//得到个人详细信息
			return null;
		}else if(jo.containsKey("groups")){//查询分组
			return null;
		}else if(jo.containsKey("access_token")){//得到访问令牌
			return null;
		}else if(jo.containsKey("groupid")){//查询所在分组Id
			return null;
		}else if(jo.containsKey("next_openid")){//获得粉丝列表
			return null;
		}else if("0".equals(jo.getString("errcode"))){//发送客服消息;高级群发;修改分组;
			return null;
		}else{
			String back=backErrorMessage(jo, globalRetrunCodeList);
			return jo.getString("errcode")+back;
		}
	}
	
	//下载判断
	public static String uploadBack(String strJson,List<GlobalRetrunCode> globalRetrunCodeList){//下载上传多媒体
		JSONObject jo = JSONObject.fromObject(strJson);
		if(jo.containsKey("errcode")){
			String back=backErrorMessage(jo,globalRetrunCodeList);
			return jo.getString("errcode")+back;
		}else{
			return null;
		}
	}
	public static String backErrorMessage(JSONObject jo,List<GlobalRetrunCode> globalRetrunCodeList){
//		List<GlobalRetrunCode> globalRetrunCodeList = (List<GlobalRetrunCode>) servletContext.getAttribute("globalRetrunCodeList");
		for(GlobalRetrunCode globalRetrunCode:globalRetrunCodeList){
			if(globalRetrunCode.getReturncode().equals(jo.getString("errcode"))){
				//String s = JSONArray.fromObject(globalRetrunCode).toString();
				return globalRetrunCode.getDiscretion();
			}
		}
		return null;
	}
	
}
