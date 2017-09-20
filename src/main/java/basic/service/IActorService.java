package basic.service;
import util.service.IBaseService;
import basic.pojo.Actor;
/**
 * 角色Service接口
 * 
 *
 */
public interface IActorService  extends IBaseService <Actor> {
	public boolean deleteActor(String ids);
}
