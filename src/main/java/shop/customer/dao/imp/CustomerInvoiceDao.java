package shop.customer.dao.imp;
import shop.customer.dao.ICustomerDao;
import shop.customer.dao.ICustomerInvoiceDao;
import shop.customer.pojo.Customer;
import shop.customer.pojo.CustomerInvoice;
import util.dao.BaseDao;

/**
 * 客户发票信息Dao接口实现类
 * @author 张丁方
 *
 */
public class CustomerInvoiceDao extends BaseDao <CustomerInvoice> implements ICustomerInvoiceDao {
    /**
     * 根据传入参数 及值查出一条数据
     *
     * @param customerId
     * @return
     */
    @Override
    public CustomerInvoice getObjectByCustomerId(Integer customerId) {
        return this.get("where o.customerId=" + customerId);
    }
}
