package shop.product.action;
import java.util.ArrayList;
import java.util.List;
import shop.product.pojo.ProductSpecificationValue;
import shop.product.service.IProductSpecificationValueService;
import util.action.BaseAction;
/**
 * ProductSpecificationValueAction - 套餐和规格值Action类
 */
@SuppressWarnings("serial")
public class ProductSpecificationValueAction extends BaseAction{
	@SuppressWarnings("unused")
	private IProductSpecificationValueService productSpecificationValueService;//套餐和规格值Servcie
	@SuppressWarnings("unused")
	private List<ProductSpecificationValue> productSpecificationValueList = new ArrayList<ProductSpecificationValue>();//套餐和规格值List
	@SuppressWarnings("unused")
	private ProductSpecificationValue productSpecificationValue;
	@SuppressWarnings("unused")
	private String productSpecificationValueId;
	@SuppressWarnings("unused")
	private String ids;

	public void setProductSpecificationValueService(IProductSpecificationValueService productSpecificationValueService) {
		this.productSpecificationValueService = productSpecificationValueService;
	}
}
