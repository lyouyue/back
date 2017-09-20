package basic.service;
import util.service.IBaseService;
import basic.pojo.Functions;
/**
 * 功能权限Service接口
 * @author LQS
 *
 */
public interface IFunctionsService  extends IBaseService <Functions> {
	public boolean deleteFunctions(String ids);
}
