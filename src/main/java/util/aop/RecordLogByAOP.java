package util.aop;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;

public class RecordLogByAOP {
	private Logger logger = Logger.getLogger(this.getClass());
	public void recordLog(JoinPoint jp){
		int i = 1;
		String clazzName = jp.getTarget().getClass().getName();
		try {
			Class<?> clazz = Class.forName(clazzName);
			String methodName = jp.getSignature().getName();  
			Object[] args = jp.getArgs();
			StringBuffer sb = new StringBuffer();
			for (Object object : args) {
				sb.append("  ~~"+i+"、"+object);
				i++;
			}
			
			logger.info("className: "+clazzName+"    ####    methodName: "+methodName+"    ####    args:"+sb);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.info(e);
			
		}
		
	}
	
	public void recordLog_Exception(JoinPoint jp,Throwable e){
		String tryCatch_className = jp.getTarget().getClass().getName();
		try {
			Class<?> clazz = Class.forName(tryCatch_className);
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String tryCatch_methodName = jp.getSignature().getName();  
		StackTraceElement[] stackTrace = e.getStackTrace();
		int lineCount_log = 1;
		for (StackTraceElement stackTraceElement : stackTrace) {
			int e_lineNumber = stackTraceElement.getLineNumber();
			String e_className = stackTraceElement.getClassName();
			String e_methodName = stackTraceElement.getMethodName();
			logger.error("AOP:after-throwing   className: "+tryCatch_className+"    methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);
		}		
		
	}
}
