package shop.customer.service.imp;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import shop.common.pojo.CoinRules;
import shop.customer.dao.IMallCoinDao;
import shop.customer.pojo.MallCoin;
import shop.customer.service.ICustomerBankrollService;
import shop.customer.service.IMallCoinService;
import util.common.EnumUtils;
import util.other.*;
import util.service.BaseService;
/**
 * 金币Service接口实现类
 * @author mf
 */
public class MallCoinService extends BaseService<MallCoin> implements
		IMallCoinService {
	/** 金币dao **/
	private IMallCoinDao mallCoinDao;
	private ICustomerBankrollService customerBankrollService;

	/**
	 * 获得用户指定类型的总金币【仅用于查询可用总金币、金币总支出、金币总收入】
	 *
	 * @param customerId
	 * @param shopCustomerBalanceType 查询金币的类型
	 * @return
	 */
	@Override
	public String getCustomerMallCoin(Integer customerId, String shopCustomerBalanceType) throws Exception {
		//对传入的参数进行解密
		shopCustomerBalanceType = AESUtils.decrypt(shopCustomerBalanceType);
		//获得要查询的余额类型
		EnumUtils.ShopCustomerBalanceType type = EnumUtils.getBalanceType(shopCustomerBalanceType);

		BigDecimal balance = BigDecimal.ZERO;
		//查询总金币
		if (type.equals(EnumUtils.ShopCustomerBalanceType.Balance.Balance)) {
			//调用mysql函数 getBalanceCoinByCustomerId 查询，直接返回加密后的结果
			return customerBankrollService.getBalanceCoinByCustomerId(customerId);
		}
		//查询金币总支出
		else if (type.equals(EnumUtils.ShopCustomerBalanceType.Balance.BalanceExpenditure)) {
			balance = mallCoinDao.getCoinExpenditureByCustomerId(customerId);
		}
		//查询金币总收入
		else if (type.equals(EnumUtils.ShopCustomerBalanceType.Balance.BalanceIncome)) {
			balance = mallCoinDao.getCoinIncomeByCustomerId(customerId);
		}
		//对结果加密
		String result = AESUtils.encrypt(String.valueOf(balance));
		return result;
	}

	/**
	 * 注册赠送金币
	 *
	 * @param id
	 *            用户ID
	 * @param keyBookMap
	 *            金币规则keyBookMap
	 */
	@SuppressWarnings("unchecked")
	public void saveRegisterVirtualCoin(Integer id,Map<String, Object> keyBookMap) {
		MallCoin v = new MallCoin();// 新建金币明细
		v.setCustomerId(id);// 插入客户ID
		v.setSerialNumber(SerialNumberUtil.VirtualCoinNumber());// 金币流水号
		v.setType(1);// 类型为1 代表收入
		v.setOrdersId(0);// 没有订单ID 所以填0
		v.setOrdersNo("");
		v.setTradeTime(new Date());// 时间
		v.setOperatorTime(new Date());
		v.setRemarks("注册所得");
		// 从金币数据字典中中获取注册应该赠送的金币数量
		List<CoinRules> crList = (List<CoinRules>)keyBookMap.get("coinRulesRegister");
		String value = crList.get(0).getValue();
		v.setTransactionNumber(new BigDecimal(value));// 赠送金币
		mallCoinDao.saveOrUpdateObject(v);
	}
	/**
	 * 推荐赠送金币
	 * @param id  推荐人ID
	 * @param keyBookMap 金币规则keyBookMap
	 */
	@SuppressWarnings("unchecked")
	public void saveRecommendVirtualCoin(String id,Map<String, Object> keyBookMap) {
		MallCoin v1 = (MallCoin) mallCoinDao.get(" where o.customerId = "+Integer.valueOf(id)+" order by o.tradeTime desc limit 0,1 ");//查询该id的用户剩余金币数量
		MallCoin v2 = new MallCoin();
		v2.setCustomerId(Integer.valueOf(id));
		v2.setType(1);//类型为1  代表收入
		v2.setSerialNumber(SerialNumberUtil.VirtualCoinNumber());
		v2.setTradeTime(new Date());
		v2.setOperatorTime(new Date());
		v2.setOrdersId(0);//没有订单ID  所以填0
		v2.setOrdersNo("");
		v2.setRemarks("推荐所得");
		List<CoinRules> crList = (List<CoinRules>) keyBookMap.get("coinRulesRecommend");
		String value = crList.get(0).getValue();
		v2.setTransactionNumber(new BigDecimal(value));//赠送金币
		mallCoinDao.saveOrUpdateObject(v2);
	}

	/**
	 * 根据用户id及订单号查询金币明细
	 *
	 * @param customerId
	 * @param ordersNo
	 * @return
	 */
	@Override
	public MallCoin getObjectByParam(Integer customerId, String ordersNo) {
		return mallCoinDao.getObjectByParam(customerId, ordersNo);
	}

	public void setMallCoinDao(IMallCoinDao mallCoinDao) {
		this.baseDao = this.mallCoinDao = mallCoinDao;
	}

	public void setCustomerBankrollService(ICustomerBankrollService customerBankrollService) {
		this.customerBankrollService = customerBankrollService;
	}
}