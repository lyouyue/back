package wxmg.util.wx;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import util.other.Utils;

public class HttpDownloadImage {
	public static String  download(String photoUrl,String savePath) throws Exception {  
		InputStream in = null;
		try {
			String tokenURL = photoUrl;
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
			in = conn.getInputStream();
			String result = readInputStream(in,savePath);//得到图片的二进制数据  
			if (conn != null) {
				// 关闭连接
				conn.disconnect();
			}
			return result;
		} catch (Exception e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return null;
    }
	/** 
     * 从输入流中获取数据 
     * @param inStream 输入流 
     * @return 
     * @throws Exception 
     */  
    public static String readInputStream(InputStream inStream,String savePath) throws Exception{  
    	OutputStream outStream = null;
    	String fileName=null;
    	try{
    		// 输出的文件流  
            File sf=new File(savePath);  
            if(!sf.exists()){  
                sf.mkdirs();  
            }
            String newName=".png";
            String randomCode=Utils.getRandomCode();
    		//原始图片文件编译后的新名称
    		newName = randomCode + newName;
    		fileName = newName;
            outStream = new FileOutputStream(savePath+"/"+newName);
            byte[] buffer = new byte[1024];  
            int len = 0;  
            while( (len=inStream.read(buffer)) != -1 ){  
                outStream.write(buffer, 0, len);  
            }
    	}finally{
    		outStream.close();
            inStream.close();
    	}
        return fileName;  
    } 
}
