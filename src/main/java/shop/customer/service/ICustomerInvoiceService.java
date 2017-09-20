package shop.customer.service;
import shop.customer.pojo.Customer;
import shop.customer.pojo.CustomerInvoice;
import util.service.IBaseService;

import javax.servlet.ServletContext;

/**
 * 客户发票信息Service接口
 * @author 张丁方
 *
 */
public interface ICustomerInvoiceService extends IBaseService <CustomerInvoice> {

	/**
	 * 保存用户使用的发票信息
	 * @param customerInvoice
	 * @return
     */
	public CustomerInvoice saveCustomerInvoice(CustomerInvoice customerInvoice) throws Exception;

	/**
	 * 根据用户id获得用户发票信息
	 * @param customerId
	 * @return
	 * @throws Exception
	 */
	public CustomerInvoice getCustomerInvoiceById(Integer customerId) throws Exception;
}
