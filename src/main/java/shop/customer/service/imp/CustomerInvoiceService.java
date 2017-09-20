package shop.customer.service.imp;

import shop.customer.dao.ICustomerInvoiceDao;
import shop.customer.pojo.CustomerInvoice;
import shop.customer.service.ICustomerInvoiceService;
import util.other.Utils;
import util.service.BaseService;

import java.util.Date;

/**
 * 客户发票信息Service接口实现类
 *
 * @author 张丁方
 *
 */
public class CustomerInvoiceService extends BaseService<CustomerInvoice> implements ICustomerInvoiceService {
	// 引入需要的dao
	private ICustomerInvoiceDao customerInvoiceDao;
	/**
	 * 保存用户使用的发票信息
	 *
	 * @param customerInvoice 用户发票信息对象
	 * @return
	 */
	@Override
	public CustomerInvoice saveCustomerInvoice(CustomerInvoice customerInvoice) throws Exception{
		if (Utils.objectIsNotEmpty(customerInvoice)) {
			CustomerInvoice invoice = this.customerInvoiceDao.getObjectByCustomerId(customerInvoice.getCustomerId());
			if (Utils.objectIsEmpty(invoice)) {
				invoice = new CustomerInvoice();
				invoice.setCustomerId(customerInvoice.getCustomerId());
			}
			// 如果是普通发票，检查必备属性是否为空，并保存普通发票信息
			if (customerInvoice.getInvoiceType().equals(CustomerInvoice.InvoiceType.InvoiceTypeGeneral.getValue())) {
				if (Utils.objectIsEmpty(customerInvoice.getInvoiceTitle())) throw new Exception("发票抬头不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getInvoiceInfo())) throw new Exception("发票内容不可为空");

				invoice.setInvoiceTitle(customerInvoice.getInvoiceTitle());
				invoice.setInvoiceInfo(customerInvoice.getInvoiceInfo());
			}
			//检查增值税，并保存增值税发票信息
			else if (customerInvoice.getInvoiceType().equals(CustomerInvoice.InvoiceType.InvoiceTypeVAT.getValue())) {
				if (Utils.objectIsEmpty(customerInvoice.getCompanyName())) throw new Exception("单位名称不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getTaxpayerIdentificationCode())) throw new Exception("纳税人识别号不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getRegisteredAddress())) throw new Exception("注册地址不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getRegisterePhone())) throw new Exception("注册电话不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getDepositBank())) throw new Exception("开户行不可为空");
				if (Utils.objectIsEmpty(customerInvoice.getBankAccount())) throw new Exception("账号不可为空");
				invoice.setCompanyName(customerInvoice.getCompanyName());
				invoice.setTaxpayerIdentificationCode(customerInvoice.getTaxpayerIdentificationCode());
				invoice.setRegisteredAddress(customerInvoice.getRegisteredAddress());
				invoice.setRegisterePhone(customerInvoice.getRegisterePhone());
				invoice.setDepositBank(customerInvoice.getDepositBank());
				invoice.setBankAccount(customerInvoice.getBankAccount());
			}
			else return null;

			invoice.setInvoiceType(customerInvoice.getInvoiceType());
			invoice.setInvoiceStatue(0);

			Date nowDate = new Date();
			if (Utils.objectIsEmpty(invoice.getInvoiceId())) invoice.setCreateTime(nowDate);
			invoice.setUpdateTime(nowDate);

			return (CustomerInvoice) this.saveOrUpdateObject(invoice);
		}
		return null;
	}

	/**
	 * 根据用户id获得用户发票信息
	 *
	 * @param customerId
	 * @return
	 * @throws Exception
	 */
	@Override
	public CustomerInvoice getCustomerInvoiceById(Integer customerId) throws Exception {
		return customerInvoiceDao.getObjectByColumnId("customerId", String.valueOf(customerId));
	}

	public void setCustomerInvoiceDao(ICustomerInvoiceDao customerInvoiceDao) {
		this.baseDao = this.customerInvoiceDao = customerInvoiceDao;
	}
}