package wxmg.publicNo.service.imp;

import util.service.BaseService;
import wxmg.publicNo.dao.IPublicNumberRoleRelDao;
import wxmg.publicNo.pojo.PublicNumberRoleRel;
import wxmg.publicNo.service.IPublicNumberRoleRelService;
/**
 * 微信基本信息Service接口实现类
 * @author LQS
 *
 */
public class PublicNumberRoleRelService extends BaseService  <PublicNumberRoleRel> implements IPublicNumberRoleRelService {
	@SuppressWarnings("unused")
	private IPublicNumberRoleRelDao publicNumberRoleRelDao;

	public void setPublicNumberRoleRelDao(IPublicNumberRoleRelDao publicNumberRoleRelDao) {
		this.baseDao =  this.publicNumberRoleRelDao = publicNumberRoleRelDao;
	}

	
}
