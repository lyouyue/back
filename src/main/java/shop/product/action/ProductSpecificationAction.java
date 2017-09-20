package shop.product.action;
import java.util.ArrayList;
import java.util.List;
import shop.product.pojo.ProductSpecification;
import shop.product.service.IProductSpecificationService;
import util.action.BaseAction;
/**
 * ProductSpecificationAction - 套餐和规格Action类
 */
@SuppressWarnings("serial")
public class ProductSpecificationAction extends BaseAction{
	@SuppressWarnings("unused")
	private IProductSpecificationService productSpecificationService;//套餐和规格Service
	@SuppressWarnings("unused")
	private List<ProductSpecification> productSpecificationList = new ArrayList<ProductSpecification>();//套餐和规格List
	@SuppressWarnings("unused")
	private String productSpecificationId;
	@SuppressWarnings("unused")
	private String ids;

	public void setProductSpecificationService(IProductSpecificationService productSpecificationService) {
		this.productSpecificationService = productSpecificationService;
	}
}
