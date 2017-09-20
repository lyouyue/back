package shop.customer.service.imp;

import org.springframework.web.context.ServletContextAware;

import shop.customer.dao.ICustomerBankrollDao;
import shop.customer.pojo.CustomerBankroll;
import shop.customer.service.ICustomerBankrollService;
import shop.customer.service.IFundDetailService;
import util.common.EnumUtils;
import util.other.*;
import util.service.BaseService;

import javax.servlet.ServletContext;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 账户资金Service接口实现类
 */
@SuppressWarnings("unchecked")
public class CustomerBankrollService extends BaseService<CustomerBankroll>
		implements ICustomerBankrollService, ServletContextAware {
	private ServletContext servletContext;
	/**
	 * 获得用户指定类型的总余额【仅用于查询总余额、余额总支出、余额总收入】
	 *
	 * @param customerId
	 * @param shopCustomerBalanceType 查询余额的类型
	 * @return 加密后的余额
	 */
	@Override
	public String getCustomerBalance(Integer customerId, String shopCustomerBalanceType) throws Exception {
		//对传入的参数进行解密
		shopCustomerBalanceType = AESUtils.decrypt(shopCustomerBalanceType);
		//获得要查询的余额类型
		EnumUtils.ShopCustomerBalanceType type = EnumUtils.getBalanceType(shopCustomerBalanceType);

		BigDecimal balance = BigDecimal.ZERO;
		//查询总余额
		if (type.equals(EnumUtils.ShopCustomerBalanceType.Balance)) {
			balance = customerBankrollDao.getCustomerBalanceByCustomerId(customerId);
		}
		//查询充值总金额
		else if (type.equals(EnumUtils.ShopCustomerBalanceType.BalanceRecharge)) {
			balance = customerBankrollDao.getBalanceRechargeByCustomerId(customerId);
		}
		//查询余额总支出
		else if (type.equals(EnumUtils.ShopCustomerBalanceType.BalanceExpenditure)) {
			balance = fundDetailService.getBalanceExpenditureByCustomerId(customerId);
		}
		//查询余额总收入
		else if (type.equals(EnumUtils.ShopCustomerBalanceType.BalanceIncome)) {
			balance = fundDetailService.getBalanceIncomeByCustomerId(customerId);
		}
		//对结果加密
		String result = AESUtils.encrypt(String.valueOf(balance));
		return result;
	}

	/**
	 * 根据用户id查询金币总余额
	 *
	 * @param customerId
	 * @return 加密后的余额
	 * @throws Exception
	 */
	@Override
	public String getBalanceCoinByCustomerId(Integer customerId) throws Exception {
		BigDecimal balanceCoin = customerBankrollDao.getBalanceCoinByCustomerId(customerId);
		//对结果加密
		String result = AESUtils.encrypt(String.valueOf(balanceCoin));
		return result;
	}

	/**
	 * 同步现金钱包，用户余额、充值总额
	 *
	 * @throws Exception
	 */
	@Override
	public void saveBankRollBySync() throws Exception {
		customerBankrollDao.saveBankRollBySync();
	}

	/**
	 * 同步现金钱包，用户总金币
	 *
	 * @throws Exception
	 */
	@Override
	public void saveBankRollMallCoinBySync() throws Exception {
		customerBankrollDao.saveBankRollMallCoinBySync();
	}

	/**
	 * 删除过期的已同步的财务记录
	 *
	 * @throws Exception
	 */
	@Override
	public void deleteExpiredFinanceSynced() throws Exception {
		/*获得过期时间*/
		Integer beforeSeconds = Integer.parseInt(String.valueOf(((Map<String, Object>)servletContext.getAttribute("fileUrlConfig")).get("financeSyncedBeforeSeconds")));
		//删除在...以前 现金钱包、金币流水已同步的记录(单位：秒)，默认7天（7*24*60*60）
		customerBankrollDao.deleteExpiredFinanceSynced(beforeSeconds);
	}

	/**账户资金Dao**/
	private ICustomerBankrollDao customerBankrollDao;
	private IFundDetailService fundDetailService;
	public void setCustomerBankrollDao(ICustomerBankrollDao customerBankrollDao) {
		this.baseDao = this.customerBankrollDao = customerBankrollDao;
	}

	public void setFundDetailService(IFundDetailService fundDetailService) {
		this.fundDetailService = fundDetailService;
	}

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
}
