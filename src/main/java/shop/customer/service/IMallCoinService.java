package shop.customer.service;
import java.util.Map;

import shop.customer.pojo.MallCoin;
import util.service.IBaseService;
/**
 * 金币Service接口
 * @author mf
 */
public interface IMallCoinService extends IBaseService <MallCoin> {
	/**
	 * 注册赠送金币
	 * @param id 用户ID
	 * @param keyBookMap  金币规则keyBookMap
	 */
	public void saveRegisterVirtualCoin(Integer id,Map<String,Object> keyBookMap);
	/**
	 * 推荐赠送金币
	 * @param id  推荐人ID
	 * @param keyBookMap 金币规则keyBookMap
	 */
	public void saveRecommendVirtualCoin(String id,Map<String, Object> keyBookMap);

	/**
	 * 根据用户id及订单号查询金币明细
	 * @param customerId
	 * @param ordersNo
	 * @return
	 */
	public MallCoin getObjectByParam(Integer customerId, String ordersNo);

	/**
	 * 获得用户指定类型的总金币【仅用于查询可用总金币、金币总支出、金币总收入】
	 * @param customerId
	 * @param shopCustomerBalanceType 查询金币的类型
	 * @return
	 */
	public String getCustomerMallCoin(Integer customerId, String shopCustomerBalanceType) throws Exception;
}
