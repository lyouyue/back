package util.service;

import shop.customer.service.ICustomerBankrollService;
import shop.customer.service.IMallCoinService;
import shop.order.dao.IOrdersDao;
import shop.store.dao.IShopSettlementDetailDao;
import shop.store.pojo.ShopSettlementDetail;
import util.action.BaseAction;
import util.other.Utils;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
* ################################
 * @作用：定时器
 * @功能：店铺自动申请结算
 * @作者: Zhang Dingfang
 * @日期：2016年8月7日
 * @版本：V1.0
 * ################################
 * 定时规则：每个月的15日启动定时器
 * 扫描规则：扫描现金钱包流水表[shop_fund_detailsync]，[shop_mall_coinsync]
 * 同步条件：
 * 			[shop_fund_detailsync.status=1] 只同步未同步的数据，同步后修改其状态为已同步
 * 扫描操作：修改[shop_customer_bankroll]表，用户最新的总余额、总充值余额、总金币
 * ################################
 */
@SuppressWarnings("rawtypes")
public class QuartzCustomerBankrollService {

	/**
	 * 同步现金钱包，用户余额、充值总额
	 *
	 * @throws Exception
	 */
	public void saveBankRollBySync() throws Exception{
		customerBankrollService.saveBankRollBySync();
	}

	/**
	 * 同步现金钱包，用户总金币
	 * @throws Exception
	 */
	public void saveBankRollMallCoinBySync() throws Exception{
		customerBankrollService.saveBankRollMallCoinBySync();
	}

	/**
	 * 删除过期的已同步的财务记录
	 * @throws Exception
	 */
	public void deleteExpiredFinanceSynced() throws Exception{
		customerBankrollService.deleteExpiredFinanceSynced();
	}

	/**订单结算申请service**/
	private ICustomerBankrollService customerBankrollService;

	public ICustomerBankrollService getCustomerBankrollService() {
		return customerBankrollService;
	}

	public void setCustomerBankrollService(ICustomerBankrollService customerBankrollService) {
		this.customerBankrollService = customerBankrollService;
	}
}
