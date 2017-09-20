package util.other;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

/**
 * Created by Administrator on 2016/8/3 0003上午 9:53.
 */
public class HttpRequestUtils {
	
    private static Logger logger = Logger.getLogger(HttpRequestUtils.class);

    /**
     * 向指定 URL 发送POST方法的请求
     *
     * @param url   发送请求的 URL
     * @param param 请求参数，请求参数应该是 name1=value1&name2=value2 的形式。
     * @return 所代表远程资源的响应结果
     */
    public static String sendPost(String url, String param) {
        List formparams = params2Map(param);
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost post = new HttpPost(url);
        String result = "";         //post结果
        RequestConfig config = RequestConfig.custom()
                .setConnectionRequestTimeout(10000)     //设置连接请求超时
                .setConnectTimeout(10000)               //设置连接超时
                .setSocketTimeout(10000)                //设置请求超时
                .build();
        CloseableHttpResponse response = null;
        try {
            post.setEntity(new UrlEncodedFormEntity(formparams, "UTF-8"));
            post.setConfig(config);
            response = httpClient.execute(post);
            HttpEntity entity = response.getEntity();
            result = EntityUtils.toString(entity);
            EntityUtils.consume(entity);
        } catch (ClientProtocolException e) {
            logger.error("post 请求异常 catch：ClientProtocolException = " + e);
        } catch (IOException e) {
            logger.error("post 请求异常 catch：IOException = " + e);
        } finally {
            closeResponse(response);
        }
        return result;
    }

    /**
     * 向指定 URL 发送 GET 方法的请求
     * @param url 发送请求的 URL
     * @return 所代表远程资源的响应结果
     */
    public static String sendGet(String url) {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpGet get = new HttpGet(url);
        String result = "";         //post结果
        RequestConfig config = RequestConfig.custom()   //自定义请求参数
                .setConnectionRequestTimeout(10000)     //设置连接请求超时
                .setConnectTimeout(10000)               //设置连接超时
                .setSocketTimeout(10000)                //设置请求超时
                .build();
        CloseableHttpResponse response = null;
        try {
            get.setConfig(config);
            response = httpClient.execute(get);
            HttpEntity entity = response.getEntity();
            result = EntityUtils.toString(entity);
            EntityUtils.consume(entity);
        } catch (ClientProtocolException e) {
            logger.error("get 请求异常 catch：ClientProtocolException = " + e);
        } catch (IOException e) {
            logger.error("get 请求异常 catch：IOException = " + e);
        } finally {
            closeResponse(response);
        }
        return result;
    }

    /**
     * &符号隔开的请求参数字符串，转Map
     *
     * @param param
     * @return
     */
    private static List params2Map(String param) {
        List formparams = new ArrayList();
        String[] paramAry = param.split("&");
        for (int i = 0; i < paramAry.length; i++) {
            String str = paramAry[i];
            String key = str.substring(0, str.indexOf("="));
            String value = str.substring(str.indexOf("=") + 1, str.length());
            formparams.add(new BasicNameValuePair(key, value));
        }
        return formparams;
    }

    /**
     * 关闭 http响应实例
     * @param response
     */
    public static void closeResponse(CloseableHttpResponse response) {
        try {
            if (Utils.objectIsNotEmpty(response)) {
                response.close();
            }
        } catch (IOException e) {
            logger.error("关闭 http响应 finally catch：IOException = " + e);
        }
    }
}