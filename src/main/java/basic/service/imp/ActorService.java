package basic.service.imp;
import java.io.IOException;

import util.other.Utils;
import util.service.BaseService;
import basic.dao.IActorDao;
import basic.pojo.Actor;
import basic.service.IActorPurviewService;
import basic.service.IActorService;
/**
 * 角色Service接口实现类
 * 
 *
 */
/**   
 * @作用：
 * @功能：
 * @作者: cyy
 * @日期：2016年10月28日 下午6:28:30 
 * @版本：V1.0   
 */
public class ActorService extends BaseService  <Actor> implements IActorService{
	private IActorDao actorDao;
	private IActorPurviewService actorPurviewService;
	private UsersActorService usersActorService;
	
	/**
	 * 删除角色
	 */
	public boolean deleteActor(String ids){
		boolean isSuccess = false;
		if(Utils.stringIsNotEmpty(ids)){
			//删除角色
			isSuccess = actorDao.deleteObjectById(ids);
			//删除角色-权限 
			isSuccess = actorPurviewService.deleteObjectsByIds("actorId", ids);
			//删除角色-用户
			isSuccess = usersActorService.deleteObjectsByIds("actorId", ids);
		}
		return isSuccess;
	}
	
	public void setActorDao(IActorDao actorDao) {
		this.baseDao =this.actorDao= actorDao;
	}

	public void setActorPurviewService(IActorPurviewService actorPurviewService) {
		this.actorPurviewService = actorPurviewService;
	}

	public void setUsersActorService(UsersActorService usersActorService) {
		this.usersActorService = usersActorService;
	}
	
}
