package wxmg.globalReturnCode.service;

import util.service.IBaseService;
import wxmg.globalReturnCode.pojo.GlobalRetrunCode;
/**
 * 全局返回码Service接口   
 * @author Administrator   
 * 2014-09-05
 */
public interface IGlobalRetrunCodeService extends IBaseService<GlobalRetrunCode> {
	public void globalRetrunCodeInit();
}
