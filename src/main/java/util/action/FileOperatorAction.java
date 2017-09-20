package util.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import org.apache.log4j.Logger;
import util.upload.ImageFileUploadUtil;
/**
 * Action类 - 文件操作Action
 * 
 * */
@SuppressWarnings( { "serial" })
public class FileOperatorAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private File fileupload;
	private String fileuploadFileName; // 上传来的文件的名字
	private String fileUrl;
	private String fileUploadKey;
	private String categoryZipCode;
	private String code;
	/**
	 * asyncUploadFile 表示异步上传文件
	 */
	public void asyncUploadFile() {
		PrintWriter out;
		try {
			response.setHeader("Content-Type", "text/plain;charset=UTF-8");
			out = response.getWriter();
			String message = ImageFileUploadUtil.uploadImageFileNotShop(fileupload, fileuploadFileName, fileUrlConfig, fileUploadKey);
			out.print(message + "," + fileuploadFileName);
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	public String uploadImage() throws Exception {
		return "success";
	}
	public File getFileupload() {
		return fileupload;
	}
	public void setFileupload(File fileupload) {
		this.fileupload = fileupload;
	}
	public String getFileUrl() {
		return fileUrl;
	}
	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
	public String getFileuploadFileName() {
		return fileuploadFileName;
	}
	public void setFileuploadFileName(String fileuploadFileName) {
		this.fileuploadFileName = fileuploadFileName;
	}
	public String getFileUploadKey() {
		return fileUploadKey;
	}
	public void setFileUploadKey(String fileUploadKey) {
		this.fileUploadKey = fileUploadKey;
	}
	public String getCategoryZipCode() {
		return categoryZipCode;
	}
	public void setCategoryZipCode(String categoryZipCode) {
		this.categoryZipCode = categoryZipCode;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
}
