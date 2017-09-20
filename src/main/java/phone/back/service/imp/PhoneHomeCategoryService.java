package phone.back.service.imp;

import phone.back.dao.IPhoneHomeCategoryDao;
import phone.back.pojo.PhoneHomeCategory;
import phone.back.service.IPhoneHomeCategoryService;
import util.service.BaseService;

/**
 * 手机端分类service接口实现类
 * 
 *	2014-01-22
 */
public class PhoneHomeCategoryService extends BaseService<PhoneHomeCategory> implements IPhoneHomeCategoryService{
	@SuppressWarnings("unused")
	private IPhoneHomeCategoryDao phoneHomeCategoryDao;

	public void setPhoneHomeCategoryDao(IPhoneHomeCategoryDao phoneHomeCategoryDao) {
		this.baseDao=this.phoneHomeCategoryDao = phoneHomeCategoryDao;
	}
}
