package basic.service;

import java.util.List;

import basic.pojo.SystemConfig;
import util.service.IBaseService;
/**
 * 基础配置service接口
 * @author Administrator
 * 2014-08-19
 */
public interface ISystemConfigService extends IBaseService<SystemConfig> {
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
	public List distinctType(String column,String whereCondition);
	

}
