package wxmg.util.wx;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.tuckey.web.filters.urlrewrite.utils.Log;

import util.action.BaseAction;

public class WXBasicUtil extends BaseAction {
	private static final long serialVersionUID = 714414761026365789L;
	/**
	 * 日志
	 */
	public static Log logger = Log.getLog(WXBasicUtil.class);
	/**
	 * 获取微信的二维码图片
	 * @author LQS
	 */
	public static void getQRCode(String access_token,Map<Object,Object> fileUrlConfig) {
		StringBuffer bufferRes = new StringBuffer();
		try {
			String qrCodeURL = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" + URLEncoder.encode(access_token);
			URL realUrl = new URL(qrCodeURL);
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
			/*
			 * BufferedReader read = new BufferedReader(new
			 * InputStreamReader(in,"UTF-8")); String valueString = null; while
			 * ((valueString=read.readLine())!=null){
			 * bufferRes.append(valueString); } in.close(); if (conn != null) {
			 * conn.disconnect(); }
			 */
			inputStreamToImage(in,fileUrlConfig);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}

	}

	/**
	 * 获取微信的凭据
	 * @author 
	 * @return String
	 */
	public static String getTicket(String access_token,String customerId,int ticketType) {
		Map<String, String> jsonMap = new HashMap<String, String>();
		StringBuffer bufferRes = new StringBuffer();
		// 获取access_token
		String postCode = null;
		switch (ticketType) {
		case 1://临时二维码
			postCode = "{\"expire_seconds\": 604800,\"action_name\": \"QR_SCENE\", \"action_info\": {\"scene\": {\"scene_id\": "+customerId+"}}}";
			break;
		case 2://永久二维码
			postCode = "{\"action_name\": \"QR_LIMIT_SCENE\", \"action_info\": {\"scene\": {\"scene_id\": "+customerId+"}}}";
			break;
		}
		try {
			String ticketURL = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" + access_token;
			URL realUrl = new URL(ticketURL);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
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
			out.write(postCode);
			out.flush();
			out.close();

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
		jsonMap = parseJsonStringToMap(bufferRes.toString());
		return jsonMap.get("ticket");
	}
	
	/**
	 * 将二进制流转换成图片，获取的微信的二维码图片
	 * @author LQS
	 * @return String
	 */
	public static void inputStreamToImage(InputStream in,Map<Object,Object> fileUrlConfig){    

		try { 
			// 将字符串转换成二进制，用于显示图片   
			// 将上面生成的图片格式字符串 imgStr，还原成图片显示   
			//byte[] imgByte = hex2byte(imgStr);   
			//InputStream in = new ByteArrayInputStream(imgByte); 
			File file=new File(fileUrlConfig.get("fileUploadRoot")+"/"+fileUrlConfig.get("wx")+"/"+fileUrlConfig.get("image_QRCode")+"/wx.jpg");//可以是任何图片格式.jpg,.png等 
			File file1=new File(fileUrlConfig.get("fileUploadRoot")+"/"+fileUrlConfig.get("wx")+"/"+fileUrlConfig.get("image_QRCode"));//可以是任何图片格式.jpg,.png等 
			if (!file1.exists()) {
				file1.mkdirs();
			}
			FileOutputStream fos=new FileOutputStream(file); 
			byte[] b = new byte[1024]; 
			int nRead = 0; 
			while ((nRead = in.read(b)) != -1) { 
				fos.write(b, 0, nRead); 
			} 
			fos.flush(); 
			fos.close(); 
			in.close(); 
		} catch (Exception e) { 
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);} 
		}  
    }	
	
	/**
	 * 获取微信的凭据
	 * @author LQS
	 * @return String
	 */
	public static String getTicket(String access_token) {
		Map<String, String> jsonMap = new HashMap<String, String>();
		StringBuffer bufferRes = new StringBuffer();
		// 获取access_token
		String postCode = "{\"action_name\": \"QR_LIMIT_SCENE\", \"action_info\": {\"scene\": {\"scene_id\": 123}}}";
		try {
			String ticketURL = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=" + access_token;
			URL realUrl = new URL(ticketURL);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
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
			out.write(postCode);
			out.flush();
			out.close();

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
		jsonMap = parseJsonStringToMap(bufferRes.toString());
		return jsonMap.get("ticket");
	}

	/**
	 * 获取微信的AccessToken
	 * @author LQS
	 * @return String 
	 */
	public final static String getAccessToken(String appId, String appSecret) {

		StringBuffer bufferRes = new StringBuffer();
		try {
			String tokenURL = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appId + "&secret=" + appSecret;
			URL realUrl = new URL(tokenURL);
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
		Map<String, String> accessTokenMap = parseJsonStringToMap(bufferRes.toString());
		String access_token = accessTokenMap.get("access_token");
		return access_token;
	}
	/**
	 * 获取微信授权的AccessToken
	 * @author LQS
	 * @return String 
	 */
	public final static Map<String, String> getOAuthAccessTokenMap(String appId, String appSecret,String code) {

		StringBuffer bufferRes = new StringBuffer();
		try {
			String tokenURL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+appId+"&secret="+appSecret+"&code="+code+"&grant_type=authorization_code";
			URL realUrl = new URL(tokenURL);
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
		Map<String, String> accessTokenMap = parseJsonStringToMap(bufferRes.toString());
		return accessTokenMap;
	}
	/**
	 * 将json字符串转换成map对象
	 * @author LQS
	 * @return Map
	 */
	public static Map<String, String> parseJsonStringToMap(String jsonString) {
		JSONArray arry = JSONArray.fromObject("[" + jsonString + "]");
		Map<String, String> jsonMap = new HashMap<String, String>();
		if(arry!=null){
			for (int i = 0; i < arry.size(); i++) {
				JSONObject jsonObject = arry.getJSONObject(i);
				for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
					String key = (String) iter.next();
					String value = jsonObject.get(key).toString();
					jsonMap.put(key, value);
				}
			}
		}
		return jsonMap;
	}
	/**
	 * 发送客服消息,注意图文消息：图文消息条数限制在10条以内，如果图文数超过10，则将会无响应
	 * @author 
	 * @param 1发送文本消息text 2 发送图片消息image 3 发送语音消息voice 4 发送视频消息video 5 发送音乐消息music 6 发送图文消息news
	 *
	 */
	public static String sendMessage(String access_token,  String json){
		String url = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=" + access_token;
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			//json = new String(json.getBytes(), "iso8859-1");
			json = new String(json.getBytes("utf-8"), "iso8859-1");
			StringEntity stringEntity = new StringEntity(json);
			stringEntity.setContentEncoding("iso8859-1");
			//stringEntity.setContentType("application/json");
			stringEntity.setContentType("application/json; encoding=iso8859-1");
			post.setEntity(stringEntity);
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();

				 String strJson = EntityUtils.toString(entity, "utf-8");
//				System.out.println(strJson);
				return strJson;


			}
		}
		catch (Exception e)
		{
			throw new RuntimeException(e);
		}
		return null;
	}
	
	public static void main(String[] args) {
		// String params =
		// "{\"button\":[{\"name\":\"我的账户\",\"sub_button\":[{\"type\":\"click\",\"name\":\"微商城\",\"key\":\"M1001\"},{\"type\":\"click\",\"name\":\"我的资产\",\"key\":\"M1002\"}]},{\"type\":\"click\",\"name\":\"我的资产\",\"key\":\"M2001\"},{\"type\":\"click\",\"name\":\"其它\",\"key\":\"M3001\"}]}";
		/*
		 * String json=
		 * "[{\"access_token\":\"40uwe8TWe0clJFQDG5rslHZsWgTasuoK7dwkd3UQogWHhbXfez5ThhQ5C5kjshD6mBv8hsABlOi_BTcS5NmcYi0NjrHKqsLYc-4jAJOAU5ZPGhlOfyfcVr3THBWHuiSP4Rfhq0IdbQEiLc4Sc6Zt3g\",\"expires_in\":7200}]"
		 * ; Map<String, String> map =parseAccessTokenJsonString(json);
		 * System.out.println("-------获取access_token的值-------");
		 * System.out.println(map.get("access_token"));
		 */
		// createMenu();
		/*
		 * String params="{\"errcode\":0,\"errmsg\":\"ok\"}"; Map
		 * map=parseJsonStringToMap(params); System.out.println(map);
		 */
		//createMenu();
		String access_token = getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f");
//		System.out.println("access_token = "+access_token);
	}

}
