package shop.customer.service;

import java.math.BigDecimal;

import shop.customer.pojo.Recharge;
import util.service.IBaseService;
/**
 * 充值记录Service接口
 */
public interface IRechargeService extends IBaseService<Recharge> {
	public boolean saveRechargeMoney(String customerId,BigDecimal rechargeAmount);
}
