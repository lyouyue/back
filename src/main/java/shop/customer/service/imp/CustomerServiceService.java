package shop.customer.service.imp;
import shop.customer.dao.ICustomerServiceDao;
import shop.customer.pojo.CusService;
import shop.customer.service.ICustomerServiceService;
import util.service.BaseService;
/**
 * 客户信息Service接口实现类
 * 
 * 
 * 
 */
public class CustomerServiceService extends BaseService<CusService> implements
		ICustomerServiceService {
	@SuppressWarnings("unused")
	private ICustomerServiceDao customerServiceDao;
	public void setCustomerServiceDao(ICustomerServiceDao customerServiceDao) {
		this.baseDao = this.customerServiceDao = customerServiceDao;
	}
}
