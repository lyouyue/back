package wxmg.util.wx;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

/**
 * 用户管理工具类
 */
public class WXUserManager {
	/**
	 * 得到用户基本信息
	 * @author 
	 * @param appId、appSecret、openId、lang(zh_CN 简体，zh_TW 繁体，en 英语)
	 *
	 */
	public static String getUserBasicInformation(String access_token,String openId,String lang){
		String url="https://api.weixin.qq.com/cgi-bin/user/info?access_token="+access_token+"&openid="+openId+"&lang="+lang;
//		System.out.println("url= "+url);
		DefaultHttpClient client = new DefaultHttpClient();
		HttpGet get = new HttpGet(url);
		try
		{
			HttpResponse res = client.execute(get);
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
	 * 设置用户备注
	 * @author 
	 * @param appId、appSecret、strJson(post提交字符串)
	 *
	 */
	public static String setUserRemark(String access_token,String json){
		String url="https://api.weixin.qq.com/cgi-bin/user/info/updateremark?access_token="+access_token;
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			json = new String(json.getBytes(), "iso8859-1");
			StringEntity stringEntity = new StringEntity(json);
			stringEntity.setContentEncoding("UTF-8");
			stringEntity.setContentType("application/json; encoding=utf-8");
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
	/**
	 * 获得公众号用户列表
	 *lyz
	 */
	public static String getUserList(String access_token,String nextOpenid){
		String url="https://api.weixin.qq.com/cgi-bin/user/get?access_token="+access_token+"&next_openid="+nextOpenid;
//		System.out.println("url= "+url);
		DefaultHttpClient client = new DefaultHttpClient();
		HttpGet get = new HttpGet(url);
		try
		{
			HttpResponse res = client.execute(get);
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
