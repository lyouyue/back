package basic.service.imp;
/**
 * 权限Service接口实现类
 * 
 *
 */
import java.util.List;

import util.service.BaseService;
import basic.dao.IPurviewDao;
import basic.pojo.Purview;
import basic.service.IActorPurviewService;
import basic.service.IFunctionsService;
import basic.service.IPurviewService;
public class PurviewService extends BaseService  <Purview> implements IPurviewService {
	private IPurviewDao purviewDao;
	private IActorPurviewService actorPurviewService;
	private IFunctionsService functionsService;
	
	
	/**
	 * 根据父ID查询列表
	 * @param ID值
	 * @return 返回一个list集合
	 */
	public List<Purview> queryByParentId(String id) {
		return purviewDao.findObjects(" where 1=1 and o.parentId="+id+" order by o.sortCode");
	}
	/**
	 * 删除权限
	 * @param id 权限id
	 * @return boolean类型的 true 或 false
	 */
	public Boolean deletePurview(String id){
		boolean isSuccess = false;
		//获取当前权限对象
		Purview purview = purviewDao.getObjectById(id);
		//删除权限对象
		isSuccess = purviewDao.deleteObjectById(id);
		//删除角色—权限对象
		isSuccess =actorPurviewService.deleteObjectsByIds("purviewId", id);
		//删除功能权限对象
		isSuccess =functionsService.deleteObjectsByIds("purviewId", id);
		if(isSuccess){
			//删除成功，判断该obj的父obj是否改为叶子节点
			Purview pObj = (Purview) purviewDao.get(" where o.purviewId="+purview.getParentId());
			Integer count = purviewDao.getCount(" where o.parentId="+pObj.getPurviewId());
			if((count-1)==0){//count为数据库中的总条数 在这里减去要删除的对象
				pObj.setIsLeaf(1);
				purviewDao.saveOrUpdateObject(pObj);
			}
		}
		return isSuccess;
	}
	
	/**
	 * 添加和修改权限
	 * @param Purview 权限对象  oldParentId原始的父节点ID
	 * @return boolean类型的 true 或 false
	 */
	public Boolean saveOrUpdatePurview(Purview purview,String oldParentId){
		//修改操作
		if(purview.getPurviewId()!=null &&!"".equals(purview.getPurviewId())){
			if(Integer.parseInt(oldParentId)!=purview.getParentId()){//调整了原来的父节点
				Integer count=purviewDao.getCount(" where o.parentId="+oldParentId);
				if(count==1){//原来的父节点底下只有被调整的子节点，调整后肯定为叶子节点
					Purview oldParentPurview = (Purview)purviewDao.getObjectById(oldParentId.toString());
					oldParentPurview.setIsLeaf(1);
					purviewDao.saveOrUpdateObject(oldParentPurview);
				}
			}
		}else{
			purview.setIsLeaf(1);
		}
		Purview newParentPurview = (Purview)purviewDao.getObjectById(purview.getParentId().toString());
		newParentPurview.setIsLeaf(0);
		purviewDao.saveOrUpdateObject(newParentPurview);
		purview.setLevelCode(newParentPurview.getLevelCode()+1);
		purviewDao.saveOrUpdateObject(purview);
		if(purview.getPurviewId()!=null)return true;
		else return false;
	}
	
	public void setPurviewDao(IPurviewDao purviewDao) {
		this.baseDao = this.purviewDao = purviewDao;
	}
	
	public void setActorPurviewService(IActorPurviewService actorPurviewService) {
		this.actorPurviewService = actorPurviewService;
	}

	public void setFunctionsService(IFunctionsService functionsService) {
		this.functionsService = functionsService;
	}
}
