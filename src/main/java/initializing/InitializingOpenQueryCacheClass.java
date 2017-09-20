package initializing;

import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.context.ServletContextAware;

import util.other.Utils;
import util.other.WebUtil;

/**
 * 初始化启用查询缓存的类
 * @author 
 *
 */
public class InitializingOpenQueryCacheClass implements InitializingBean , ServletContextAware {
	
	//servlet 上下文
	private ServletContext servletContext;
	//开启二级缓存的对象名称
	private String classSimpleName;
	
	/**
	 * 添加查询缓存的类
	 */
	public void afterPropertiesSet() throws Exception {
		//如果classSimpleName里不为空，并且包含“;”时，把字符串转化为list放入WebUtil中
		if(Utils.stringIsNotEmpty(classSimpleName)&&classSimpleName.contains(";")){
			WebUtil.setOpenQueryCacheClass(Arrays.asList(classSimpleName.split(";")));
		}else{
			WebUtil.setOpenQueryCacheClass(new ArrayList<String>());
		}
	}
	
	public void setClassSimpleName(String classSimpleName) {
		this.classSimpleName = classSimpleName;
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
}
