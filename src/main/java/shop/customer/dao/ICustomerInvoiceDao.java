package shop.customer.dao;
import shop.customer.pojo.Customer;
import shop.customer.pojo.CustomerInvoice;
import util.dao.IBaseDao;

/**
 * 客户发票信息Dao接口
 * @author 张丁方
 *
 */
public interface ICustomerInvoiceDao extends IBaseDao <CustomerInvoice>{

    /**
     * 根据传入参数 及值查出一条数据
     * @param customerId
     * @return
     */
    public CustomerInvoice getObjectByCustomerId(Integer customerId);
}
