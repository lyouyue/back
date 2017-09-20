package shop.store.service.imp;

import shop.store.dao.ISelfSupportShopProCategoryDao;
import shop.store.pojo.ShopProCategory;
import shop.store.service.ISelfSupportShopProCategoryService;
import util.service.BaseService;

/**   
 * @作用：
 * @功能：
 * @作者: wyc
 * @日期：2016年5月17日 上午11:30:12 
 * @版本：V1.0   
 */
public class SelfSupportShopProCategoryService extends BaseService<ShopProCategory> implements ISelfSupportShopProCategoryService {
	
	@SuppressWarnings("unused")
	private ISelfSupportShopProCategoryDao selfSupportShopProCategoryDao;
	
	public void setSelfSupportShopProCategoryDao(
			ISelfSupportShopProCategoryDao selfSupportShopProCategoryDao) {
		this.baseDao=this.selfSupportShopProCategoryDao = selfSupportShopProCategoryDao;
	}
	
}
