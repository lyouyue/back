package distribution.configure.service.imp;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import util.pojo.PageHelper;
import util.service.BaseService;
import distribution.configure.dao.IDisConfigureDao;
import distribution.configure.pojo.DisConfigure;
import distribution.configure.service.IDisConfigureService;
/**
 * 分销配置：前台Action的service实现类
 * @author 
 */
public class DisConfigureService extends BaseService<DisConfigure> implements IDisConfigureService {
	//@SuppressWarnings("unused")
	private IDisConfigureDao disConfigureDao;
	
	public DisConfigure getDisConfigure(){
		return (DisConfigure) disConfigureDao.get(" ORDER BY o.configureId");
	}
	
	@Override
	public PageHelper getPageHelper(PageHelper pageHelper,Map<String, Object> map) throws UnsupportedEncodingException {
		String where =" where 1=1 ";
		String sqlCont="select COUNT(o.configureId) from dis_configure  o ";
		int totalRecordCount =Integer.parseInt(disConfigureDao.getMaxDataSQL(sqlCont+where).toString());
		pageHelper.setPageInfo(pageHelper.getPageSize(), totalRecordCount, pageHelper.getCurrentPage());
		String sql="select o.* from dis_configure o "+where+ " ORDER BY o.configureId ";
		List<Map<String,Object>> configureList =this.findListMapPageBySql(sql, pageHelper);
		pageHelper.setObjectList(configureList);
		return pageHelper;
	}

	public void setDisConfigureDao(IDisConfigureDao disConfigureDao) {
		this.baseDao = this.disConfigureDao = disConfigureDao;
	}
}
