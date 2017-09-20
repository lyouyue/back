package util.other;

import basic.pojo.KeyBook;

import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletContext;

import java.util.List;
import java.util.Map;

/**
 * Created by Zhangdingfang on 2016/8/9 0009下午 6:45.
 * 获取basic_systemconfig表中配置属性
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ConfigUtils {

	/**
	 * 获取systemConfig.properties表中配置属性
	 */
	private static Map<String, Object> fileUrlConfig = (Map<String, Object>) ServletActionContext.getServletContext().getAttribute("fileUrlConfig");
	/**
	 * 获取basic_systemconfig表中配置属性
	 */
	private static Map<String, Object> systemConfig = (Map<String, Object>) ServletActionContext.getServletContext().getAttribute("fileUrlConfig");
	/**
	 * 获取basic_keybook表中配置属性
	 */
	private static Map<String,List> keyBook = (Map<String, List>) ServletActionContext.getServletContext().getAttribute("keybook");

    /**
     * 静态获得 指定 [systemConfig.properties] type 的 value
     * @param type
     * @return
     */
    public static Object getFileUrlConfigValue(String type) {
    	return fileUrlConfig.get(type);
    }
    
    /**
     * 静态获得 指定 [systemConfig.properties] type 的 value
     * @param type
     * @return
     */
    public static Object getFileUrlConfigValue(ServletContext servletContext, String type) {
    	return ((Map)servletContext.getAttribute("fileUrlConfig")).get(type);
    }
    /**
     * 静态获得 指定 [basic_systemconfig] type 的 value
     * @param type
     * @return
     */
    public static Object getSystemConfigValue(String type) {
        return systemConfig.get(type);
    }

    /**
     * 静态获得 指定 [basic_systemconfig] type 的 value
     * @param type
     * @return
     */
    public static Object getSystemConfigValue(ServletContext servletContext, String type) {
        return ((Map)servletContext.getAttribute("fileUrlConfig")).get(type);
    }

    /**
     * 静态获得 指定 [basic_keybook] type 的 集合
     * @param type
     * @return
     */
    public static List<KeyBook> getKeyBooks(String type) {
        return (List<KeyBook>) keyBook.get(type);
    }

    /**
     * @return 静态获得 配置属性
     */
	public static Map<String, Object> getFileUrlConfig() {
		return fileUrlConfig;
	}

	/**
	 * @return 静态获得 配置属性
	 */
	public static Map<String, Object> getSystemConfig() {
		return systemConfig;
	}

	/**
	 * @return 静态获得 配置属性
	 */
	public static Map<String, List> getKeyBook() {
		return keyBook;
	}
    
}
