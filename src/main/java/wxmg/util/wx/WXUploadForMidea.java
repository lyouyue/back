package wxmg.util.wx;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

/**
 * 上传多媒体文件工具类
 */
public class WXUploadForMidea {

	/**
	 * 上传多媒体文件
	 * @author 
	 * @param  appId,  appSecret, file：上传文件,  StrType(媒体文件类型，分别有图片（image）、语音（voice）、视频（video）和缩略图（thumb）)
	 *
	 */
	public static String postSubmit(String access_token,File file, String StrType){
//		System.out.println("access_token ="+access_token);
		String url="http://file.api.weixin.qq.com/cgi-bin/media/upload?access_token="+access_token+"&type="+StrType;
		DefaultHttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);
		try
		{
			 MultipartEntity multipartEntity = new MultipartEntity(); 
			 multipartEntity.addPart("filename",new FileBody(file));
			post.setEntity(multipartEntity);
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
	/**
	 * 下载多媒体,返回访问路径
	 * @author 
	 * @param  appId、appSecret、mideaId、filePath:图片存放路径
	 *
	 */
	public static String getMideaByMideaId(String access_token,String mideaId,String filePath){
//		System.out.println("access_token ="+access_token);
		String url="http://file.api.weixin.qq.com/cgi-bin/media/get?access_token="+access_token+"&media_id="+mideaId;
		DefaultHttpClient client = new DefaultHttpClient();
		//client.getParams().setParameter(CoreProtocolPNames.HTTP_CONTENT_CHARSET, "UTF-8"); 
		HttpGet get = new HttpGet(url);
		//post.addHeader("Content-Type", "text/html;charset=UTF-8");
		//post.getParams().setParameter(CoreProtocolPNames.HTTP_CONTENT_CHARSET, "UTF-8"); 
		//访问路径
		String accessPath="";
		try
		{
			
			HttpResponse res = client.execute(get);
			//System.out.println("res 编码="+res.getParams().getParameter(CoreProtocolPNames.HTTP_CONTENT_CHARSET)); 
			if (res.getStatusLine().getStatusCode() == HttpStatus.SC_OK)
			{
				HttpEntity entity = res.getEntity();
//				System.out.println("entity.getContentLength() = "+entity.getContentLength());
//				System.out.println("entity.getContentType() = "+entity.getContentType());
//				System.out.println(filePath);
				long contentLength = entity.getContentLength();
				String contentType = entity.getContentType().toString();
				InputStream inputStream = entity.getContent();
				if(contentLength>0){
					if(contentType.indexOf("image/jpeg")>0){
//						System.out.println("图片格式 ");
						accessPath=inputStreamToImage(inputStream,"image",filePath);
					}else if(contentType.indexOf("audio/amr")>0){
//						System.out.println("音频格式 ");
						accessPath=inputStreamToImage(inputStream,"voice",filePath);
						String newAccessPath=accessPath.substring(0,accessPath.lastIndexOf("."));
						ConvertMP3.changeToMp3(accessPath, newAccessPath+".mp3");
						accessPath=newAccessPath+".mp3";
					}else if(contentType.indexOf("audio/mp3")>0){
//						System.out.println("音频格式 ");
						accessPath=inputStreamToImage(inputStream,"voice1",filePath);
					}else if(contentType.indexOf("video/mpeg4")>0){
//						System.out.println("视频格式 ");
						accessPath=inputStreamToImage(inputStream,"video",filePath);
					}
				}
			}
		}
		catch (Exception e){
			throw new RuntimeException(e);
		}
		if(!"".equals(accessPath)){//截取出文件名及格式
			accessPath=accessPath.substring(accessPath.indexOf("weixin"), accessPath.length());
		}
//		System.out.println("accessPath = "+accessPath);
		return accessPath;
	}
	/**
	 * 将二进制流转换成对应的文件
	 * @author 
	 * @param in：文件流 、filePath:文件路径、 fileType:
                                图片（image）: 1M，支持JPG格式
			语音（voice）：2M，播放长度不超过60s，支持AMR\MP3格式
			视频（video）：10MB，支持MP4格式
			缩略图（thumb）：64KB，支持JPG格式
	 */
	public static String inputStreamToImage(InputStream in,String fileType,String filePath){    

		try { 
			File filep=new File(filePath);
			if(!filep.exists()){
				filep.mkdirs();
			}
			// 将字符串转换成二进制，用于显示对应的文件 
			File file=null;
			java.util.Random r=new java.util.Random();//生成随机数给文件命名
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String date = sdf.format(new Date());//生成当前时间字符串（用生成的随机数加生成的当前时间字符串来给文件命名）
			if("image".equals(fileType) || "thumb".equals(fileType)){
			  file=new File(filePath+"/"+Math.abs(r.nextInt())+date+".jpg");//可以是任何图片格式.jpg,.png等 
			}else if("voice".equals(fileType)){
				file=new File(filePath+"/"+Math.abs(r.nextInt())+date+".amr"); 
			}else if("voice1".equals(fileType)){
				file=new File(filePath+"/"+Math.abs(r.nextInt())+date+".mp3"); 
			}else if("video".equals(fileType)){
				file=new File(filePath+"/"+Math.abs(r.nextInt())+date+".mp4"); 
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
			return file.toString();
		} catch (Exception e) { 
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			return null;
		}  
    }	
}
