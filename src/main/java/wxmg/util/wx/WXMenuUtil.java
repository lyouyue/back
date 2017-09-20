package wxmg.util.wx;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.tuckey.web.filters.urlrewrite.utils.Log;

public class WXMenuUtil {
	/**
	 * 日志
	 */
	public static Log logger = Log.getLog(WXMenuUtil.class);
	/**
	 * 创建微信自定义菜单
	 * @author 
	 * @return String
	 */
	public static String createWXMenu(String access_token,  String json){
		String url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + access_token;
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			json = new String(json.getBytes("utf-8"), "iso8859-1");
//			System.out.println("json="+json);
			StringEntity stringEntity = new StringEntity(json);
			stringEntity.setContentEncoding("iso8859-1");
			stringEntity.setContentType("application/json; encoding=iso8859-1");
			post.setEntity(stringEntity);
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();
				String stringJson = EntityUtils.toString(entity, "utf-8");
//				System.out.println("stringJson ="+stringJson);
				return stringJson;
			}
			
		}
		catch (Exception e)
		{
			throw new RuntimeException(e);
		}
		return null;
	}
	/**
	 * 创建微信自定义菜单
	 * @author LQS
	 * @return Map
	 */
	public static Map createMenu(String appId,String appSecret,String menuJsonInfo) {
		Map<String, String> jsonMap = new HashMap<String, String>();
		StringBuffer bufferRes = new StringBuffer();
		// 获取access_token
		String access_token = WXBasicUtil.getAccessToken(appId, appSecret);
		
		try {
			//menuInfo=new String(menuInfo.getBytes(),"UTF-8");
			URL createUrl = new URL("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + access_token);
			HttpURLConnection conn = (HttpURLConnection) createUrl.openConnection();
			// 连接超时
			conn.setConnectTimeout(25000);
			// 读取超时 --服务器响应比较慢，增大时间
			conn.setReadTimeout(25000);
			HttpURLConnection.setFollowRedirects(true);

			// 请求方式
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0");
			conn.setRequestProperty("Referer", "https://api.weixin.qq.com/");
			conn.connect();

			// 获取URLConnection对象对应的输出流
			OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream());
			// 发送请求参数
//			System.out.println("menuJsonInfo="+menuJsonInfo);
			out.write(menuJsonInfo);
			out.flush();
			out.close();

			InputStream in = conn.getInputStream();
			BufferedReader read = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String valueString = null;
			while ((valueString = read.readLine()) != null) {
				bufferRes.append(valueString);
			}
//			System.out.println(bufferRes.toString());
			in.close();
			if (conn != null) {
				conn.disconnect();
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		jsonMap = WXBasicUtil.parseJsonStringToMap(bufferRes.toString());
		return jsonMap;
	}
	
	/**
	 * 删除微信自定义菜单
	 * @author LQS
	 * @return Map
	 */

	public static Map<String, String> deleteMenu(String access_token) {
		/**
		 * { "access_token":
		 * "40uwe8TWe0clJFQDG5rslHZsWgTasuoK7dwkd3UQogWHhbXfez5ThhQ5C5kjshD6mBv8hsABlOi_BTcS5NmcYi0NjrHKqsLYc-4jAJOAU5ZPGhlOfyfcVr3THBWHuiSP4Rfhq0IdbQEiLc4Sc6Zt3g"
		 * , "expires_in":7200 }
		 */
		StringBuffer bufferRes = new StringBuffer();
		try {
			String deleteURL = "https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=" + access_token;
			URL realUrl = new URL(deleteURL);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
			// 连接超时
			conn.setConnectTimeout(25000);
			// 读取超时 --服务器响应比较慢，增大时间
			conn.setReadTimeout(25000);
			HttpURLConnection.setFollowRedirects(true);
			// 请求方式
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0");
			conn.setRequestProperty("Referer", "https://api.weixin.qq.com/");
			conn.connect();
			// 获取URLConnection对象对应的输出流
			InputStream in = conn.getInputStream();
			BufferedReader read = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String valueString = null;
			while ((valueString = read.readLine()) != null) {
				bufferRes.append(valueString);
			}
			in.close();
			if (conn != null) {
				conn.disconnect();
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		Map<String, String> jsonMap = WXBasicUtil.parseJsonStringToMap(bufferRes.toString());
		return jsonMap;
	}

	/**
	 * 获取微信自定义菜单
	 * @author LQS
	 * @return String
	 */
	public static String getMenu(String access_token) {
		/**
		 * { "access_token":
		 * "40uwe8TWe0clJFQDG5rslHZsWgTasuoK7dwkd3UQogWHhbXfez5ThhQ5C5kjshD6mBv8hsABlOi_BTcS5NmcYi0NjrHKqsLYc-4jAJOAU5ZPGhlOfyfcVr3THBWHuiSP4Rfhq0IdbQEiLc4Sc6Zt3g"
		 * , "expires_in":7200 }
		 */
		StringBuffer bufferRes = new StringBuffer();
		try {
			String getURL = "https://api.weixin.qq.com/cgi-bin/menu/get?access_token=" + access_token;
			URL realUrl = new URL(getURL);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
			// 连接超时
			conn.setConnectTimeout(25000);
			// 读取超时 --服务器响应比较慢，增大时间
			conn.setReadTimeout(25000);
			HttpURLConnection.setFollowRedirects(true);
			// 请求方式
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:21.0) Gecko/20100101 Firefox/21.0");
			conn.setRequestProperty("Referer", "https://api.weixin.qq.com/");
			conn.connect();
			// 获取URLConnection对象对应的输出流
			InputStream in = conn.getInputStream();
			BufferedReader read = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String valueString = null;
			while ((valueString = read.readLine()) != null) {
				bufferRes.append(valueString);
			}
			in.close();
			if (conn != null) {
				// 关闭连接
				conn.disconnect();
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return bufferRes.toString();
	}

}
