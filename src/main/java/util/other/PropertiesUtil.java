package util.other;

import java.util.Properties;

/**
 * 配置文件 *.properties 读取工具类
 * @author 张丁方 2016-7-28
 */
public abstract class PropertiesUtil {

    /**
     * xx.properties 专用读取函数
     * @param key 名
     * @return
     */
    public static String getValue(String key) {
    	String resource = "xx.properties";
        Properties p = new Properties();
        try {
            p.load(PropertiesUtil.class.getClassLoader().getResourceAsStream(resource));
            return p.getProperty(key);
        } catch (Exception e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
        return null;
    }

    /**
     * 自定义读取指定配置文件
     * @param key 名
     * @param config_file 指定文件 *.properties
     * @return
     */
    public static String getValue(String key, String config_file) {
        Properties p = new Properties();
        try {
            p.load(PropertiesUtil.class.getClassLoader().getResourceAsStream(config_file));
            return p.getProperty(key);
        } catch (Exception e) {
            //String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
        return null;
    }
}