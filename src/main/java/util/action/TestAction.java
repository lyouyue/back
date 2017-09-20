package util.action;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import util.other.Utils;

/**
 * @作用：测试Action
 * @功能：
 * @作者:
 * @日期：2016年3月23日 下午12:38:21 
 * @版本：V1.0   
 */
public class TestAction extends BaseAction {
	private static final long serialVersionUID = 2752911709036089235L;
	private String reqActionUrl;
	private String reqParameters;
	//响应数据
	private String responseValue;
	//响应码
	private Integer responseCode;
	/**
	 * @功能：跳转到测试页面
	 * @作者: 
	 * @参数： @return
	 * @返回值：String
	 * @日期: 2016年3月23日 下午12:39:35 
	 */
	public String gotoTestPage(){
		return SUCCESS;
	}
	/**请求外网地址
	 * @return
	 */
	public String gotoAction(){
		try {
			if(Utils.objectIsNotEmpty(reqActionUrl)){
				int index = reqActionUrl.indexOf("http://");
				String requestUrl=reqActionUrl;
				//如果不是以http://开头那么默认添加
				if(index!=0){
					requestUrl="http://"+requestUrl;
				}
				if(Utils.objectIsNotEmpty(reqParameters)){
					requestUrl = requestUrl+"?"+reqParameters;
				}
				responseValue = sendPost(requestUrl);
			}else{
				responseValue="请求地址为空";
			}
		} catch (IOException e) {
//			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return SUCCESS;
	}
	public String sendPost( String path)throws IOException {
		java.net.URL url = new java.net.URL(path);
		java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setConnectTimeout(5 * 1000);// 设置连接超时时间为5秒 
		conn.setReadTimeout(5 * 1000);// 设置读取超时时间为5秒 
		// 使用 URL 连接进行输出，则将 DoOutput标志设置为 true
		conn.setDoOutput(true);
		conn.setRequestProperty("Content-Type", "text/xml;charset=UTF-8");
		//conn.setRequestProperty("Content-Encoding","gzip");
		OutputStream outStream;
		String msg = "";// 保存调用http服务后的响应信息
		try {
			outStream = conn.getOutputStream();
			outStream.close();//关闭流
			responseCode =conn.getResponseCode();
			// 如果请求响应码是200，则表示成功
			if (conn.getResponseCode() == 200) {
				// HTTP服务端返回的编码是UTF-8,故必须设置为UTF-8,保持编码统一,否则会出现中文乱码
				BufferedReader in = new BufferedReader(new InputStreamReader(
						(InputStream) conn.getInputStream(), "UTF-8"));
				msg = in.readLine();
				in.close();
			}
			conn.disconnect();// 断开连接
		} catch (Exception e) {
			msg="请求地址有误！";
		}
		return msg;
	}
	public String getReqActionUrl() {
		return reqActionUrl;
	}
	public void setReqActionUrl(String reqActionUrl) {
		this.reqActionUrl = reqActionUrl;
	}
	public String getReqParameters() {
		return reqParameters;
	}
	public void setReqParameters(String reqParameters) {
		this.reqParameters = reqParameters;
	}
	public String getResponseValue() {
		return responseValue;
	}
	public void setResponseValue(String responseValue) {
		this.responseValue = responseValue;
	}
	public Integer getResponseCode() {
		return responseCode;
	}
	public void setResponseCode(Integer responseCode) {
		this.responseCode = responseCode;
	}
}
