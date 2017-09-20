package basic.service.imp;
import java.util.ArrayList;
import java.util.List;

import util.service.BaseService;
import basic.dao.IActorPurviewDao;
import basic.pojo.ActorPurview;
import basic.service.IActorPurviewService;
/**
 * 角色权限Service接口实现类
 * 
 *
 */
public class ActorPurviewService extends BaseService <ActorPurview> implements IActorPurviewService{
	private IActorPurviewDao actorPurviewDao;
	public void setActorPurviewDao(IActorPurviewDao actorPurviewDao) {
		this.baseDao = this.actorPurviewDao = actorPurviewDao;
	}
	
	public boolean saveActorPurview(Integer [] purviewIds,String actorId,String [] functionValues) {
		//去除数组中没有功能权限的值
		List <String> functionValuesList=new ArrayList<String>();
		for(String functionValue:functionValues){
			if(!"".equals(functionValue)){
				functionValuesList.add(functionValue);
			}
		}
		actorPurviewDao.deleteByParams(" where o.actorId="+actorId);//先删除原始的数据
		if(purviewIds!=null && purviewIds.length>0){
			for(int i=0;i<purviewIds.length;i++){
				if(actorId != null && purviewIds[i] != null){
					ActorPurview actorPurview = new ActorPurview();
					actorPurview.setActorId(Integer.parseInt(actorId));
					actorPurview.setPurviewId(purviewIds[i]);
					//找到对应的模块权限下的功能权限，对应的规则"purviewId_select,update,delete,add"
					if(functionValuesList!=null&&functionValuesList.size()>0){
						for(String functionValue:functionValuesList){
							String selectedPurviewId=functionValue.split("_")[0];
							String selectingPurviewId=purviewIds[i].toString();
							if(selectedPurviewId.equals(selectingPurviewId)){//判断权限ID是否相同
								actorPurview.setFunctions(functionValue);
								break;
							}
						}
					}
					actorPurviewDao.saveOrUpdateObject(actorPurview);
				}
			}
		}
		return true;
	}
}
