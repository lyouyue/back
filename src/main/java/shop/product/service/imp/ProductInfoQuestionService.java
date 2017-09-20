package shop.product.service.imp;
import shop.product.dao.IProductInfoQuestionDao;
import shop.product.pojo.ProductInfoQuestion;
import shop.product.service.IProductInfoQuestionService;
import util.service.BaseService;
/**
 * 品牌Service接口实现类
 * 
 *
 */
public class ProductInfoQuestionService extends BaseService  <ProductInfoQuestion> implements IProductInfoQuestionService{
	@SuppressWarnings("unused")
	private IProductInfoQuestionDao productInfoQuestionDao;
	public void setProductInfoQuestionDao(IProductInfoQuestionDao productInfoQuestionDao) {
		this.baseDao =this.productInfoQuestionDao= productInfoQuestionDao;
	}
}