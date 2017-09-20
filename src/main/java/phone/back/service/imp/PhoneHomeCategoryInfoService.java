package phone.back.service.imp;

import phone.back.dao.IPhoneHomeCategoryInfoDao;
import phone.back.pojo.PhoneHomeCategoryInfo;
import phone.back.service.IPhoneHomeCategoryInfoService;
import util.service.BaseService;

/**
 * 手机端分类信息service接口类
 * 
 *	2014-01-22
 */
public class PhoneHomeCategoryInfoService extends BaseService<PhoneHomeCategoryInfo> implements IPhoneHomeCategoryInfoService{
	@SuppressWarnings("unused")
	private IPhoneHomeCategoryInfoDao phoneHomeCategoryInfoDao;

	public void setPhoneHomeCategoryInfoDao(
			IPhoneHomeCategoryInfoDao phoneHomeCategoryInfoDao) {
		this.baseDao=this.phoneHomeCategoryInfoDao = phoneHomeCategoryInfoDao;
	}
}
