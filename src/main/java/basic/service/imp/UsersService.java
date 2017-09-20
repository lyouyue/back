package basic.service.imp;
import util.other.Utils;
import util.service.BaseService;
import basic.dao.IUsersDao;
import basic.pojo.Users;
import basic.service.IUsersService;
/**
 * 后台管理员Service接口实现类
 * 
 *
 */
public class UsersService extends BaseService  <Users> implements IUsersService {
	private IUsersDao usersDao;
	private UsersActorService usersActorService;
	
	@Override
	public boolean deleteUsers(String ids) {
		boolean isSuccess = false;
		if(Utils.stringIsNotEmpty(ids)){
			//删除用户记录
			isSuccess = usersDao.deleteObjectById(ids);
			//删除用户-角色记录
			isSuccess = usersActorService.deleteObjectsByIds("usersId", ids);
		}
		return isSuccess;
	}
	
	
	public void setUsersDao(IUsersDao usersDao) {
		this.baseDao =this.usersDao= usersDao;
	}

	public void setUsersActorService(UsersActorService usersActorService) {
		this.usersActorService = usersActorService;
	}

	
}
