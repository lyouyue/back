package shop.customer.service.imp;

import java.math.BigDecimal;
import java.util.Date;

import org.apache.log4j.Logger;
import shop.customer.dao.ICustomerBankrollDao;
import shop.customer.dao.IRechargeDao;
import shop.customer.pojo.CustomerBankroll;
import shop.customer.pojo.FundDetail;
import shop.customer.pojo.Recharge;
import shop.customer.service.IFundDetailService;
import shop.customer.service.IRechargeService;
import util.other.SerialNumberUtil;
import util.other.Utils;
import util.service.BaseService;
/**
 * 充值记录Service接口实现类
 */
public class RechargeService extends BaseService<Recharge> implements IRechargeService {
	/**充值记录Dao接口**/
	private IRechargeDao rechargeDao;
	/**账户资金Dao**/
	private ICustomerBankrollDao customerBankrollDao;
	/**资金流水Service**/
	private IFundDetailService fundDetailService;
	//用户充值:后台普通充值
	public boolean saveRechargeMoney(String customerId,BigDecimal rechargeAmount){
		boolean flag1=false;
		Recharge recharge=new Recharge();
		recharge.setCustomerId(Integer.valueOf(customerId));
		recharge.setRechargeAmount(rechargeAmount);
		recharge.setRechargeCode(SerialNumberUtil.OrderSnNumber());
		recharge.setRechargeTime(new Date());
		recharge.setRechargeType(3);// 1:普通充值  2:用户中心普通充值 3:后台普通充值
		recharge.setState(1);// 0.未支付 1.已支付
		recharge = rechargeDao.saveOrUpdateObject(recharge);
		if(Utils.objectIsNotEmpty(recharge)){
			flag1=true;
			FundDetail fundDetail = new FundDetail();
			try {
				fundDetail.setCustomerId(Integer.parseInt(customerId));
				fundDetail.setOrdersNo("");
				fundDetail.setFundDetailsCode(recharge.getRechargeCode());
				fundDetail.setAmount(recharge.getRechargeAmount());
				fundDetail.setFundDetailsType(1);	//消费类型 1收入 2支出
				fundDetail.setTransactionTime(new Date());
				fundDetail.setSource(1);			//来源 充值
				fundDetailService.saveOrUpdateObject(fundDetail);
			} catch (Exception e) {
				logger.error("充值失败");
			}
		}
		return flag1;
	}

	public void setRechargeDao(IRechargeDao rechargeDao) {
		this.baseDao = this.rechargeDao = rechargeDao;
	}

	public void setCustomerBankrollDao(ICustomerBankrollDao customerBankrollDao) {
		this.customerBankrollDao = customerBankrollDao;
	}

	public void setFundDetailService(IFundDetailService fundDetailService) {
		this.fundDetailService = fundDetailService;
	}
}
