package shop.product.service.imp;
import shop.product.dao.IBrandDao;
import shop.product.pojo.Brand;
import shop.product.service.IBrandService;
import util.service.BaseService;
/**
 * 品牌Service接口实现类
 * 
 *
 */
public class BrandService extends BaseService  <Brand> implements IBrandService{
	@SuppressWarnings("unused")
	private IBrandDao brandDao;
	public void setBrandDao(IBrandDao brandDao) {
		this.baseDao =this.brandDao= brandDao;
	}
}