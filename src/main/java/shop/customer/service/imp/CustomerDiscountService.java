package shop.customer.service.imp;
import shop.customer.dao.ICustomerDiscountDao;
import shop.customer.pojo.CustomerDiscount;
import shop.customer.service.ICustomerDiscountService;
import util.service.BaseService;
/**
 * 会员折扣Service接口实现
 * @author Wsy
 *
 */
public class CustomerDiscountService extends BaseService<CustomerDiscount> implements ICustomerDiscountService{
	@SuppressWarnings("unused")
	private ICustomerDiscountDao customerDiscountDao;
	public void setCustomerDiscountDao(ICustomerDiscountDao customerDiscountDao) {
		this.baseDao=this.customerDiscountDao = customerDiscountDao;
	}
}
