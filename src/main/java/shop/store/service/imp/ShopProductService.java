package shop.store.service.imp;
import shop.store.dao.IShopCategoryDao;
import shop.store.dao.IShopProductDao;
import shop.store.pojo.ShopProduct;
import shop.store.service.IShopProductService;
import util.service.BaseService;
/**
 * ShopCategoryService - 店铺套餐Service接口实现类
 * @author 孟琦瑞
 */
@SuppressWarnings("unused")
public class ShopProductService extends BaseService  <ShopProduct> implements IShopProductService{
	private IShopProductDao shopProductDao;//店铺套餐Dao
	public void setShopProductDao(IShopProductDao shopProductDao) {
		this.baseDao = this.shopProductDao = shopProductDao;
	}
}
