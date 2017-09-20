package distribution.configure.service;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import util.pojo.PageHelper;
import util.service.IBaseService;
import distribution.configure.pojo.DisConfigure;
/**
 * 分销配置：前台Action的service接口类
 * @author 
 */
public interface IDisConfigureService extends IBaseService <DisConfigure>{
	/**
	 * 获取分销配置
	 * @return
	 */
	public DisConfigure getDisConfigure();
	/**
	 * 获取分销配置列表
	 * @return
	 */
	public PageHelper getPageHelper(PageHelper pageHelper,Map<String,Object> map) throws UnsupportedEncodingException;

}
