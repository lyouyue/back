package shop.store.service.imp;
import shop.store.dao.IShopProCateClassDao;
import shop.store.pojo.ShopProCateClass;
import shop.store.service.IShopProCateClassService;
import util.service.BaseService;
/**
 * ShopProCateClassService - 店铺内部套餐分类和套餐关系Service接口实现类
 */
public class ShopProCateClassService extends BaseService<ShopProCateClass> implements IShopProCateClassService{
	@SuppressWarnings("unused")
	private IShopProCateClassDao shopProCateClassDao;
	public void setShopProCateClassDao(IShopProCateClassDao shopProCateClassDao) {
		this.baseDao = this.shopProCateClassDao = shopProCateClassDao;
	}
}
