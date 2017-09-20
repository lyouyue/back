package basic.service;
import util.service.IBaseService;
import basic.pojo.Users;
/**
 * 后台管理员Service接口
 * 
 *
 */
public interface IUsersService  extends IBaseService <Users> {
	public boolean deleteUsers(String ids);
}
