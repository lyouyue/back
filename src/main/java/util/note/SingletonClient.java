package util.note;
import java.util.Map;

import org.apache.struts2.ServletActionContext;

import cn.emay.sdk.client.api.Client;
public class SingletonClient{
	private static Client client=null;
	//获取密码
	private static String password;
	
	private SingletonClient(){
	}
	public synchronized static Client getClient(String softwareSerialNo,String key){
		if(client==null){
			try {
				client=new Client(softwareSerialNo,key);
			} catch (Exception e) {
				//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}
		return client;
	}
	@SuppressWarnings("unchecked")
	public synchronized static Client getClient(){
		Map<Object,Object> fileUrlConfig = (Map<Object,Object>)ServletActionContext.getServletContext().getAttribute("fileUrlConfig");
		if(client==null){
			try {
				client=new Client(String.valueOf(fileUrlConfig.get("YimeiSDK_softwareSerialNo")),String.valueOf(fileUrlConfig.get("YimeiSDK_key")));
			} catch (Exception e) {
				//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}
		return client;
	}
	public static String getPassword(){
		return password;
	}
	public static void main(String str[]){
		SingletonClient.getClient();
	}
}
