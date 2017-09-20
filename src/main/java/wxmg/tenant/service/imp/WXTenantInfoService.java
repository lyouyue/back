package wxmg.tenant.service.imp;

import util.service.BaseService;
import wxmg.tenant.dao.IWXTenantInfoDao;
import wxmg.tenant.pojo.WXTenantInfo;
import wxmg.tenant.service.IWXTenantInfoService;

public class WXTenantInfoService extends BaseService<WXTenantInfo> implements  IWXTenantInfoService{
	private IWXTenantInfoDao wXTenantInfoDao;

	public void setwXTenantInfoDao(IWXTenantInfoDao wXTenantInfoDao) {
		this.baseDao=this.wXTenantInfoDao = wXTenantInfoDao;
	}
	
}
