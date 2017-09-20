package basic.service.imp;

import java.util.List;

import util.service.BaseService;
import basic.dao.ISystemConfigDao;
import basic.pojo.SystemConfig;
import basic.service.ISystemConfigService;
/**
 * 基础配置
 * @author Administrator
 * 2014-08-19
 */
public class SystemConfigService extends BaseService<SystemConfig> implements
		ISystemConfigService {
	private ISystemConfigDao systemConfigDao;

	public void setSystemConfigDao(ISystemConfigDao systemConfigDao) {
		this.baseDao = this.systemConfigDao = systemConfigDao;
	}
	
	/**
	 * 基础设置根据列名去重
	 * 
	 * @param column  列名
	 * 
	 * @param whereCondition  查询条件
	 * 
	 * @return 返回List集合
	 */
	@SuppressWarnings({ "rawtypes" })
	public List distinctType(String column,String whereCondition){
		return systemConfigDao.findUnSame(column, whereCondition);
	}
	
}
