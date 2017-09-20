package util.action;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;

import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import util.other.Utils;
import util.upload.ImageFileUploadUtil;
/**
 * Action类 - 上传文件Action
 * 
 * */
@SuppressWarnings("serial")
public class UploadAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	
	private File imagePath;//上传文件路径 
	private String imagePathFileName;//上传文件名称
	private String imageInfoPath;//获取配置文件systemConfig.properties中文件保存详细划分路径
	
	//上传文件校验出错，反馈信息
	public void returnUploadPath() throws IOException{
		//获取上传文件错误信息
		String acitonMessage = String.valueOf(session.getAttribute("acitonMessage"));
		//删除session中保存的错误信息
		session.removeAttribute("acitonMessage");
		JSONObject jo = new JSONObject();
		//回传错误信息到页面中
		jo.accumulate("photoUrl", "false_error3");
		jo.accumulate("photoUrlErrorMessage", acitonMessage);
		response.setContentType("text/html;charset=utf-8");
		response.setHeader("Cache-Control", "no-cache, must-revalidate");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	// 异步ajax 图片上传
	public void asyncUploadImage() {
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		try {
			PrintWriter out = response.getWriter();
			// 1图片上传
			if (Utils.objectIsNotEmpty(imagePath)) {
				if(!Utils.stringIsNotEmpty(imageInfoPath)){
					imageInfoPath = "image_temp";
				}
				String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), imageInfoPath);
				jo.accumulate("photoUrl", otherImg);
				jo.accumulate("uploadFileVisitRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
			} else {
				jo.accumulate("photoUrl", "false_error1");
			}
			out.println(jo.toString());
			out.flush();
			out.close();
		} catch (FileNotFoundException e) {
			jo.accumulate("photoUrl", "false_error2");
			try {
				PrintWriter pw = response.getWriter();
				pw.println(jo.toString());
				pw.flush();
				pw.close();
			} catch (IOException ioe) {
				logger.error(ioe);
			}
		} catch (Exception e) {
			jo.accumulate("photoUrl", "false_error");
			try {
				PrintWriter pw = response.getWriter();
				pw.println(jo.toString());
				pw.flush();
				pw.close();
			} catch (IOException ioe) {
				logger.error(ioe);
			}
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	
	//捕获上传文件校验信息
	public void validateAsyncUploadImage() throws IOException{
		String acitonMessage = "";//文件上传报错信息
		if(this.hasFieldErrors()){//判断是否有错误信息
			for(String acitonMessageTemp:this.getFieldErrors().get("imagePath")){//获取上传文件错误信息
				acitonMessage = acitonMessageTemp;
			}
		}else if(this.hasActionErrors()){//判断是否有错误信息
			for(String actionError:this.getActionErrors()){
				acitonMessage = actionError;
			}
			if(acitonMessage.startsWith("Request exceeded allowed size limit")){//如果超过struts.xml全局文件上传限制，则翻译为中文
				acitonMessage = "上传文件大小超过限制";
			}
		}
		session.setAttribute("acitonMessage", acitonMessage);//保存在session中传递
	}
	
	public File getImagePath() {
		return imagePath;
	}

	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}

	public String getImagePathFileName() {
		return imagePathFileName;
	}

	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}

	public String getImageInfoPath() {
		return imageInfoPath;
	}

	public void setImageInfoPath(String imageInfoPath) {
		this.imageInfoPath = imageInfoPath;
	}

}

