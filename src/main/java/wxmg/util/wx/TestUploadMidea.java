package wxmg.util.wx;

import java.io.File;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.junit.Test;

public class TestUploadMidea {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	//测试本地直接上传
	public  void testUpload(){
		try {
			File file = new File("D:/test1/1.jpg");
//			System.out.println("file = "+file);
			String fileName = file.toString();
			String fileSuffix = fileName.substring(fileName.lastIndexOf("."));
//			System.out.println("fileSuffix = "+fileSuffix);
			String realpath = new File("D:/test2/images").toString();
//			System.out.println("realpath = "+realpath);
			File savefile = new File(new File(realpath), "fileName"+fileSuffix);
			if(!savefile.getParentFile().exists()) {
				savefile.getParentFile().mkdirs();
				FileUtils.copyFile(file, savefile);
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//测试微信平台直接上传
	public  void testUploadForPost(){
		try {
			//测试上传图片
			//File file = new File("D:/test1中国/中国.jpg");
//			File file = new File("D:/test1/1.jpg");
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
//			//mediaId = strJson = {"type":"image","media_id":"yc3dMfXOCqrd-UjhGUEGqsZi5WXVp4ZzP-1Hnzp_rYtvF5JuTE0ULjhs-0NUFtw5","created_at":1411627437}
//			String mediaId = WXUploadForMidea.postSubmit(access_token,file, "image");
			//测试上传语音
//			File file = new File("D:/test1中国/中国.mp3");
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
//			WXUploadForMidea.postSubmit(access_token,file, "voice");
			//测试上传视频
			File file = new File("D:/test1中国/xiaojiao.mp4");
			//String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXUploadForMidea.postSubmit(access_token,file, "video");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	@Test
	//下载多媒体
	public  void testDownloadForPost(){
		try {
			//得到图片
			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
			WXUploadForMidea.getMideaByMideaId(access_token, "O_L6ruHHaQQrgbBP2lOs-25y7djtTd-tmNrRDCZtEph4TCLAnRrEssQFk0zlfsWI","D://");
			//得到语音(音频)
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
//			WXUploadForMidea.getMideaByMideaId(access_token, "k19atytNgDRuKtPYLiEX_OmLBL5UdGjKTuD-3SRSByzBLjoMFQq0bF_HF1ddeX2f","D://");
			//得到视频
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
//			WXUploadForMidea.getMideaByMideaId(access_token, "1VleOuFwBitgiLGg9zeAg9MtWvujYI9FgObtG2N3FWQEvFwxxXyJ82M-FHo20BUy","D://");
			
//			String access_token = WXBasicUtil.getAccessToken("wxbe2ca99a26aacc7c", "76d3d991c1be9a49087b8cb8ecf3df3f ");
//			WXUploadForMidea.getMideaByMideaId(access_token, "1VleOuFwBitgiLGg9zeAg9MtWvujYI9FgObtG2N3FWQEvFwxxXyJ82M-FHo20BUy","D://");
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
}
