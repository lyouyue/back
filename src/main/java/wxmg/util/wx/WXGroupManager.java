package wxmg.util.wx;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

/**
 * 组管理工具类
 */
public class WXGroupManager {

	/**
	 * 查询所有分组
	 * @author 
	 * @param  
	 *
	 */
	public static String  searchAllGroups(String access_token){
		String url="https://api.weixin.qq.com/cgi-bin/groups/get?access_token="+access_token;
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();
				String strJson = EntityUtils.toString(entity, "utf-8");
				return strJson;
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException(e);
		}
		return null;
	}
	/**
	 * 组管理post提交
	 * @author 
	 * @param  appId、appSecret、json、urlType(createGroup： 创建分组、searchUserInGroup:查询用户所在分组、updateGroupName:修改分组名、moveUserGroup:移动用户分组)
	 *
	 */
	public static String postSubmit(String access_token,String json,String urlType){
		String url="";
		if("createGroup".equals(urlType)){
			url="https://api.weixin.qq.com/cgi-bin/groups/create?access_token="+access_token;
		}else if("searchUserInGroup".equals(urlType)){
			url="https://api.weixin.qq.com/cgi-bin/groups/getid?access_token="+access_token;
		}else if("updateGroupName".equals(urlType)){
			url="https://api.weixin.qq.com/cgi-bin/groups/update?access_token="+access_token;
		}else if("moveUserGroup".equals(urlType)){
			url="https://api.weixin.qq.com/cgi-bin/groups/members/update?access_token="+access_token;
		} 
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			//json = new String(json.getBytes(), "iso8859-1");
			json = new String(json.getBytes("utf-8"), "iso8859-1");
			//System.out.println("****json ="+json);
			StringEntity stringEntity = new StringEntity(json);
			stringEntity.setContentEncoding("iso8859-1");
			stringEntity.setContentType("application/json; encoding=iso8859-1");
			post.setEntity(stringEntity);
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();
				String strJson = EntityUtils.toString(entity, "utf-8");
				return strJson;
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException(e);
		}
		return null;
	}
}
