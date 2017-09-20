package shop.customer.service.imp;

import shop.customer.dao.IShopCustomerServiceDao;
import shop.customer.pojo.ShopCustomerService;
import shop.customer.service.ISelfSupportCustomerServiceService;
import util.service.BaseService;

/**   
 * @作用：自营店铺客服service
 * @功能：
 * @作者: wyc
 * @日期：2016年5月19日 下午2:43:17 
 * @版本：V1.0   
 */
public class SelfSupportCustomerServiceService extends BaseService<ShopCustomerService> implements ISelfSupportCustomerServiceService {
	
	@SuppressWarnings("unused")
	private IShopCustomerServiceDao shopCustomerServiceDao;
	public void setShopCustomerServiceDao(IShopCustomerServiceDao shopCustomerServiceDao) {
		this.baseDao = this.shopCustomerServiceDao = shopCustomerServiceDao;
	}
}
