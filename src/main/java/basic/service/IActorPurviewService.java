package basic.service;
import util.service.IBaseService;
import basic.pojo.ActorPurview;
/**
 * 角色权限Service接口
 * @author LQS
 *
 */
public interface IActorPurviewService extends IBaseService <ActorPurview>{
	public boolean saveActorPurview (Integer [] purviewIds,String actorId,String[]  functionValues);
}
