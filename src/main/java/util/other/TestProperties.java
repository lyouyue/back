package util.other;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
/**
 * 工具类 - 属性文件处理
 * 
 * */
@SuppressWarnings({ "unchecked", "rawtypes" })
public class TestProperties  {

	static{
		String filePath = System.getProperty("user.dir")+"/fileUrlConfig.properties";
		Properties ps = new Properties();
		try {
			InputStream	in = new BufferedInputStream(new FileInputStream(filePath));
			ps.load(in);
		} catch (FileNotFoundException fe) {
			//logger.error(fe);
		}catch (IOException e) {
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		Map fileUrlConfig = new HashMap();
		fileUrlConfig = ps;
		Set<Map.Entry<String,String>> set = fileUrlConfig.entrySet();
		Iterator it = set.iterator(); 
		while(it.hasNext()){
			Map.Entry<String,String> me = (Map.Entry<String,String>) it.next();
			String key = (String) me.getKey();
			String value = (String) me.getValue();
//			System.out.println("key is =  "+key+" , value is =  "+value);
		}
    }
	public TestProperties() {
	}
}
