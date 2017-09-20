package shop.customer.dao.imp;
import shop.customer.dao.ICustomerDao;
import shop.customer.pojo.Customer;
import util.dao.BaseDao;
/**
 * 客户信息Dao接口实现类
 * 
 *
 */
public class CustomerDao extends BaseDao <Customer> implements ICustomerDao {
    /**
     * 更改用户类型
     *
     * @param customerId
     * @param type
     */
    @Override
    public boolean updateCustomerType(Integer customerId, Integer type) {
        return this.updateBySQL("update basic_customer set type = " + type + " where customerId = " + customerId);
    }
}
