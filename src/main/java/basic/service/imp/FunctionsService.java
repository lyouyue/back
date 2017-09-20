package basic.service.imp;
import java.util.List;

import util.other.Utils;
import util.service.BaseService;
import basic.dao.IFunctionsDao;
import basic.pojo.ActorPurview;
import basic.pojo.Functions;
import basic.service.IActorPurviewService;
import basic.service.IFunctionsService;
/**
 * 功能权限Service接口实现类
 * @author LQS
 *
 */
	public class FunctionsService extends BaseService  <Functions> implements IFunctionsService {
		private IFunctionsDao functionsDao;
		private IActorPurviewService actorPurviewService;
		/**
		 * 删除功能权限
		 */
		@Override
		public boolean deleteFunctions(String ids) {
			boolean isSuccess = false;
			if(Utils.stringIsNotEmpty(ids)){
				Functions functions = functionsDao.getObjectById(ids);
				if(Utils.objectIsNotEmpty(functions)&&Utils.objectIsNotEmpty(functions.getPurviewId())){
					//修改角色权限对象中的functionS字段
					String functionStr = functions.getPurviewId()+"_"+functions.getFunName()+"_"+functions.getFunValue();
					List<ActorPurview> actorPurviewList = actorPurviewService.findObjects(" where o.functions is not null and o.purviewId = "+functions.getPurviewId());
					if(Utils.collectionIsNotEmpty(actorPurviewList)){
						for(ActorPurview ap:actorPurviewList){
							if(Utils.objectIsNotEmpty(ap)&&Utils.objectIsNotEmpty(ap.getFunctions())){
								String[] functionStrArray = ap.getFunctions().split(",");
								String functionStr_new = "";
								for(int i=0;i<functionStrArray.length;i++){
									if(!functionStrArray[i].equals(functionStr)){
										functionStr_new += functionStrArray[i];
										functionStr_new += ",";
									}
								}
								if(Utils.objectIsNotEmpty(functionStr_new)){
									int lastIndex = functionStr_new.trim().lastIndexOf(",");
									int length = functionStr_new.trim().length();
									if((length-1)==lastIndex){//最后一个字符是逗号
										functionStr_new = functionStr_new.substring(0, lastIndex);
									}
								}
								ap.setFunctions(functionStr_new);
								actorPurviewService.saveOrUpdateObject(ap);
							}
						}
					}
					//删除功能权限
					isSuccess = functionsDao.deleteObjectById(ids);
				}
			}
			return isSuccess;
		}
		
		public void setFunctionsDao(IFunctionsDao functionsDao) {
			this.baseDao =this.functionsDao = functionsDao;
		}
		public void setActorPurviewService(IActorPurviewService actorPurviewService) {
			this.actorPurviewService = actorPurviewService;
		}
		
	}
