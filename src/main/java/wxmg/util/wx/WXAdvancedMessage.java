package wxmg.util.wx;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
/**
 * 高级群发工具类
 */
public class WXAdvancedMessage {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	/**
	 * 高级群发工具类
	 * @author 
	 * @param urlType: upload 上传图文消息素材、uploadvideo:上传视频多媒体  byGroup 根据分组进行群发、byOpenId 根据OpenID列表群发、deleteMessage 删除群发
	 *
	 */
	public static String sendAdvancedGroupMessage(String access_token, String json,String urlType){
		//SSLSocketFactory.getSocketFactory().setHostnameVerifier(new AllowAllHostnameVerifier());
		String url="";
		//上传图文消息素材
		if("upload".equals(urlType)){
			url = "https://api.weixin.qq.com/cgi-bin/media/uploadnews?access_token="+access_token;
		}
		//上传视频多媒体
		else if("uploadvideo".equals(urlType)){
//			url = "https://file.api.weixin.qq.com/cgi-bin/media/uploadvideo?access_token="+access_token;
			url = "https://api.weixin.qq.com/cgi-bin/media/uploadvideo?access_token="+access_token;
		}
		//根据分组进行群发
		else if("byGroup".equals(urlType)){
			url = "https://api.weixin.qq.com/cgi-bin/message/mass/sendall?access_token="+access_token;
		}
		//根据OpenID列表群发:文本、图片、图文、语音、视频
		else if("byOpenId".equals(urlType)){
			url = "https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token="+access_token;
		}
		//删除群发
		else if("deleteMessage".equals(urlType)){
			url = "https://api.weixin.qq.com//cgi-bin/message/mass/delete?access_token="+access_token;
		}
//		System.out.println("url= "+url);
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			//json = new String(json.getBytes(), "iso8859-1");
			json = new String(json.getBytes("utf-8"), "iso8859-1");
			StringEntity stringEntity = new StringEntity(json);
			stringEntity.setContentEncoding("iso8859-1");
			stringEntity.setContentType("application/json; encoding=iso8859-1");
			post.setEntity(stringEntity);
			HttpResponse res = client.execute(post);
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();
				String strJson = EntityUtils.toString(entity, "utf-8");
//				System.out.println("strJson = "+strJson);
				return strJson;
			}
		}
		catch (Exception e)
		{
			throw new RuntimeException(e);
		}
		return null;
	}
	
	public static String sendAdvancedGroupMessage2(String access_token, String json,String urlType) {
		StringBuffer bufferRes = new StringBuffer();
		try {
			String tokenURL = "https://file.api.weixin.qq.com/cgi-bin/media/uploadvideo?access_token="+access_token;
//			System.out.println("tokenURL = "+tokenURL);
			URL realUrl = new URL(tokenURL);
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
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
//		System.out.println("bufferRes.toString() ="+bufferRes.toString());
		return bufferRes.toString();

	}
}
