package shop.customer.dao;
import shop.customer.pojo.Customer;
import util.dao.IBaseDao;
/**
 * 客户信息Dao接口
 * 
 *
 */
public interface ICustomerDao extends IBaseDao <Customer>{
    /**
     * 更改用户类型
     * @param customerId
     * @param type
     */
    boolean updateCustomerType (Integer customerId, Integer type);
}
