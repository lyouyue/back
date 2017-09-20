package wxmg.globalReturnCode.service.imp;

import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

import util.service.BaseService;
import wxmg.globalReturnCode.dao.IGlobalRetrunCodeDao;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
import wxmg.globalReturnCode.service.IGlobalRetrunCodeService;

/**
 * 全局返回码Service接口实现类   
 * @author Administrator
 * 2014-09-05
 */
public class GlobalRetrunCodeService extends BaseService<GlobalRetrunCode> implements IGlobalRetrunCodeService , ServletContextAware{
	private IGlobalRetrunCodeDao globalRetrunCodeDao;
	
	public void setGlobalRetrunCodeDao(IGlobalRetrunCodeDao globalRetrunCodeDao) {
		this.baseDao =  this.globalRetrunCodeDao = globalRetrunCodeDao;
	}
	//servlet 上下文
	private ServletContext servletContext;
	
	@SuppressWarnings("unchecked")
	public void globalRetrunCodeInit() {
		List<GlobalRetrunCode> globalRetrunCodeList = globalRetrunCodeDao.findObjects(null, null);
		servletContext.setAttribute("globalRetrunCodeList", globalRetrunCodeList);
	}

	public ServletContext getServletContext() {
		return servletContext;
	}

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	
}
