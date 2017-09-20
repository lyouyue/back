package util.action;
import java.io.FileInputStream;
import java.io.InputStream;

import util.other.Utils;
/**
 * Action类 - 文件下载Action
 * 
 * */
public class DownLoadFileAction extends BaseAction {
	private static final long serialVersionUID = 3293386421681730095L;
	// 通用下载模块
	private String filename;
	private String downloadFileName;
	private InputStream downloadStream; // 这个输入流对应struts.xml中配置的那个downloadStream，两者必须一致
	private String downloadFileUrl; // 文件的相对路径
	public String downloadFile() throws Exception {
		if (!"".equals(downloadFileUrl) || downloadFileUrl !=null) {
			String downFileUrl = String.valueOf(getFileUrlConfig().get("fileUploadRoot"))+"/excel/"+downloadFileName;
			downloadStream = new FileInputStream(downFileUrl);
			if(Utils.objectIsNotEmpty(downloadStream)){
				return  "success";
			}else{
				this.addActionError("下载文件失败");
				return "error";
			}
		} else {
			this.addActionError("下载文件失败");
			return "error";
		}
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getDownloadFileName() {
		return downloadFileName;
	}
	public void setDownloadFileName(String downloadFileName) {
		this.downloadFileName = downloadFileName;
	}
	public InputStream getDownloadStream() {
		return downloadStream;
	}
	public void setDownloadStream(InputStream downloadStream) {
		this.downloadStream = downloadStream;
	}
	public String getDownloadFileUrl() {
		return downloadFileUrl;
	}
	public void setDownloadFileUrl(String downloadFileUrl) {
		this.downloadFileUrl = downloadFileUrl;
	}
}
